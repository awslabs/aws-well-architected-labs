Below is the code for the lambda function.

You will need to modify the following variable:

 - **athena_output**: This is where Athena puts output data, this is typically the master/payer Account ID, which is the default folder for Athena output queries
 - **bucketname**: This is the output bucket for the Athena queries

You will need to modify the following arrays, the order is important - the first folder in the subfolder array, will be given the permissions of the first element of the S3ObjectPolicies array.

 - **subfolders**: This contains the list of folders that the queries write to 
 - **S3ObjectPolicies**: This contains the S3 Object permissions ACL that will be written to objects in the corresponding folder. You will need to add the owners details (master/payer account) and the grantee (sub account) details.


```
import boto3
import json
import datetime
import time
# Get the current date, so you know which months folder you're working on
now = datetime.datetime.now()
    
# Variables to construct the s3 folder name
# YES! you can do multiple subfolders if you have multiple queries to run, 1 subfolder per query
currentmonth = '/year_1=' + str(now.year) + '/month_1=' + str(now.month) + '/'
bucketname = '(output bucket)'

#List of Subfolders & ACLs to apply to objects in them
#There MUST be a 1:1 between subfolders & policies
subfolders = ['<folder1>']

# Arrays to hold the Athena delete & create queries that we need to run
delete_query_strings = []
create_query_strings = []
# Athena output folder
athena_output = 's3://aws-athena-query-results-us-east-1-<account ID>/'
# Main loop
def lambda_handler(event, context):
    # Clear the current months S3 folder
    s3_clear_folders() 
    
    # Get the athena queries to run
    get_athena_queries()
    # Make sure to delete any existing temp tables, so no wobbly's are thrown
    run_delete_athena_queries()
    
    # Create the athena tables, which will actually output data to S3 folders
    run_create_athena_queries()
    # Delete the array in case of another Lambda invocation
    create_query_strings.clear()
    # You could make another call to delete the tables, however you need to make sure
    # the creates are finished, which may take some time, consuming time($) in Lambda
    # run_delete_athena_queries()
    # Delete the array in case of another Lambda invocation
    delete_query_strings.clear()
    return {
        'statusCode': 200,
        'body': json.dumps('Finished!')
    }
# Clear the S3 folders for the current month
def s3_clear_folders():
    # Get S3 client/object
    client = boto3.client('s3')
    # For each subfolder - in case you have multilpe subfolders, i.e. multilpe accounts/business units to split data out to
    for subfolder in subfolders:
        # List all objects in the current months bucket    
        response = client.list_objects_v2(
            Bucket=bucketname,
            Prefix=subfolder + currentmonth
        )
    
        # Get how many objects there are to delete, if any
        keys = response['KeyCount']
    
        # Only try to delete if there's objects
        if (keys > 0):
            # Get the ojbects from the response
            s3objects = response['Contents']
        
            # For each object, we're going to delete it
            # cycle through the list of objects
            for s3object in s3objects:
                
                # Get the object key
                objectkey = s3object['Key']
            
                # Delete the object
                response = client.delete_object(
                    Bucket=bucketname,
                    Key=objectkey
                )
# Get the Athena saved queries to run
# They need to be labelled 'create_linked' or 'delete_linked'
def get_athena_queries():
    # Get Athena client/object
    client = boto3.client('athena')
    # Get all the saved queries in Athena
    response = client.list_named_queries()
    # Get the named query IDs from the response
    named_query_IDs = response['NamedQueryIds']
    # Go through all the query ID, to find the delete & create queries we need to run
    for query_ID in named_query_IDs: 
        # Get all the details of a named query using its ID
        named_query = client.get_named_query(
            NamedQueryId=query_ID
        )
        
        # Get the query string & query name of the query
        querystring = named_query['NamedQuery']['QueryString']
        queryname = named_query['NamedQuery']['Name']
        
        # If its a create query, add it to the list of create queries
        # We also replace the '/subfolder' string in the query with the folder structure for the current month
        if 'create_linked_' in queryname:
            # Get a unique ID for the temp table
            tableID = queryname.split('_')[2]
            # String replacements to make the tablename unique, and work with the current months data
            new_query1 = querystring.replace('/subfolder', currentmonth)
            new_query2 = new_query1.replace('temp_table', 'temp_'+tableID)
            
            # Add the create query string to the array
            create_query_strings.append(new_query2)
            
        # If its a delete query, add it to the list of delete queries to execute later
        if 'delete_linked_' in queryname:
            # Get a unique ID for the temp table
            tableID = queryname.split('_')[2]
            
            # String replacements to make the tablename unique, and work with the current months data
            new_query1 = querystring.replace('temp_table', 'temp_'+tableID)
            
            # Add the delete query string to the array
            delete_query_strings.append(new_query1)
# Run the delete Athena queries to remove any temp tables
def run_delete_athena_queries():
    # Get Athena client/object
    client = boto3.client('athena')
    
    # Go through each of the delete query strings in the list
    for delete_query_string in delete_query_strings:
        # Execute the query string
        executionID = client.start_query_execution(
            QueryString=delete_query_string,
            ResultConfiguration={
                'OutputLocation': athena_output,
                'EncryptionConfiguration': {
                    'EncryptionOption': 'SSE_S3',
                }
            }
        )
        # Get the state of the delete execution
        response = client.get_query_execution(
            QueryExecutionId=executionID['QueryExecutionId']
        )['QueryExecution']['Status']['State']
        # A busy wait to make sure its finished before moving on
        # Tables must not exist before creation
        # If the function runs for a long time ($) you should implement step functions or a cost effective wait
        # This is a low "cost of complexity" solution
        while 'RUNNING' in response:
            # Busy wait to make sure it finishes 
            time.sleep(1)
            # Get the current state of the query
            response = client.get_query_execution(
            QueryExecutionId=executionID['QueryExecutionId']
            )['QueryExecution']['Status']['State']
# Run the Athena queries to create the table & populate the S3 data
def run_create_athena_queries():  
    
    # Get Athena client/object
    client = boto3.client('athena')
    
    # Go through each of the create query strings in the list
    for create_query_string in create_query_strings:
        
        # Execute the query string
        executionID = client.start_query_execution(
            QueryString=create_query_string,
            ResultConfiguration={
                'OutputLocation': athena_output,
                'EncryptionConfiguration': {
                    'EncryptionOption': 'SSE_S3',
                }
            }
        )
        
```