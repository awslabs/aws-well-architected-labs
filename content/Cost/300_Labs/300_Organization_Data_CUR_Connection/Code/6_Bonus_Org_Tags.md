---
title: "Bonus Organization Tags"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 6
pre: "<b>6. </b>"
---


### Update the Amazon Lambda Function to retrieve AWS Organizations tags

To get the Organizations tags, we need to update the Lambda function to pull this information too. We will be swapping from csv to json as this will allow us to have flexibility with Amazon Athena as different accounts might have different tags. 

1.	Go to the **Lambda** service page:

![Images/Lambda.png](/Cost/300_Organization_Data_CUR_Connection/Images/Lambda.png)

2. Search for the function **Lambda_Org_Data** and click on the name

![Images/Edit_Lambda.png](/Cost/300_Organization_Data_CUR_Connection/Images/Edit_Lambda.png)

3. Scroll down to the **Function Code** section and replace the code with the one below, change (account id) to your **Management Account ID** and (Region) to the **Region** you are deploying in:

    <details>
    <summary> Click here to see the function code</summary>
		
       #!/usr/bin/env python3
        
       #Lambda Function Code - Lambda_Org_Data
       import boto3
       from botocore.exceptions import ClientError
       from botocore.client import Config
       import os
       import json
       import datetime

       def myconverter(o):
         if isinstance(o, datetime.datetime):
            return o.__str__()
      
       def list_tags(client, resource_id):
          tags = []
          paginator = client.get_paginator("list_tags_for_resource")
          response_iterator = paginator.paginate(ResourceId=resource_id)
          for response in response_iterator:
             tags.extend(response['Tags'])
          return tags

       def list_accounts():
          bucket = os.environ["BUCKET_NAME"] #Using enviroment varibles below the lambda will use your S3 bucket
          tags_check = os.environ["TAGS"]

          sts_connection = boto3.client('sts')
          acct_b = sts_connection.assume_role(
                RoleArn="arn:aws:iam::(account id):role/OrganizationLambdaAccessRole",
                RoleSessionName="cross_acct_lambda"
          )
                
          ACCESS_KEY = acct_b['Credentials']['AccessKeyId']
          SECRET_KEY = acct_b['Credentials']['SecretAccessKey']
          SESSION_TOKEN = acct_b['Credentials']['SessionToken']

          # create service client using the assumed role credentials
          client = boto3.client(
                "organizations", region_name="us-east-1", #Using the Organization client to get the data. This MUST be us-east-1 regardless of region you have the lamda in
                aws_access_key_id=ACCESS_KEY,
                aws_secret_access_key=SECRET_KEY,
                aws_session_token=SESSION_TOKEN,
          )
          paginator = client.get_paginator("list_accounts") #Paginator for a large list of accounts
          response_iterator = paginator.paginate()
          with open('/tmp/org.json', 'w') as f: # Saving in the temporay folder in the lambda

                for response in response_iterator: # extracts the needed info
                   for account in response["Accounts"]:
                      aid = account["Id"]                
                      if tags_check != '':
                            tags_list = list_tags(client, aid) #gets the lists of tags for this account
                            
                            for tag in os.environ.get("TAGS").split(","): #looking at tags in the enviroment variables split by a space
                               for org_tag in tags_list:
                                  if tag == org_tag['Key']: #if the tag found on the account is the same as the current one in the environent varibles, add it to the data
                                        value = org_tag['Value']
                                        kv = {tag : value}
                                        account.update(kv)
                               
                      data = json.dumps(account, default = myconverter) #converts datetime to be able to placed in json

                      f.write(data)
                      f.write('\n')
          print("respose gathered")

          try:
                s3 = boto3.client('s3', '(Region)',
                               config=Config(s3={'addressing_style': 'path'}))
                s3.upload_file(
                   '/tmp/org.json', bucket, "organisation-data/org.json") #uploading the file with the data to s3
                print("org data in s3")
          except Exception as e:
                print(e)

       def lambda_handler(event, context):
          list_accounts()
            
	</details>

If you wish to deploy in the managment account here is the [link to Code](/Cost/300_Organization_Data_CUR_Connection/Code/org_data_man_tags.py)


4. Scroll down to **Environment variables** and click **Edit**

5. Click Add Environment variables. In the new empty box write **TAGS** under key and a list of tags from your Organisation you would like to include **separated by a comma**. Click **Save**.

![Images/Env_Tags.png](/Cost/300_Organization_Data_CUR_Connection/Images/Env_Tags.png)

6. Scroll to Function code section and Click **Deploy**.

7. You can now test the function by clicking **Test** at the top. 


{{% notice info %}}
If you tested the csv version then you need to go to your S3 but and delete the **csv file** that is there as you will now be using json.
{{% /notice %}}

### Update the Organizations Data Table
In this section we will update the Organization table in Athena to include the tags specified above.
1.	Go to the **Athena** service page

![Images/Athena.png](/Cost/300_Organization_Data_CUR_Connection/Images/Athena.png)

2.	We are going to update the table we created earlier with the tags your chose in the Lambda section. Copy and paste the below query replacing:

* Change **(bucket-name)** with your chosen bucket name from before
* Add the Tags name as they appear in the Organizations  page into the query in replace of the **(Tag1)**  that you chose in your lambda function etc
* Remove the **...**
* Click **Run Query**

		CREATE EXTERNAL TABLE IF NOT EXISTS managementcur.organisation_data (
         `Id` string,
         `Arn` string,
         `Email` string,
         `Name` string,
         `Status` string,
         `JoinedMethod` string,
         `JoinedTimestamp` string,
         `(Tag1)` string,
         `(Tag2)` string, 
         ...
			) 
			ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
			WITH SERDEPROPERTIES (
					'serialization.format' = '1' ) 
		  LOCATION 's3://(bucket-name)/organisation-data/' 
		  TBLPROPERTIES ('has_encrypted_data'='false');

![Images/Update_Athena_Tags.png](/Cost/300_Organization_Data_CUR_Connection/Images/Update_Athena_Tags.png)

3. There will now be additional columns with your tags in them.


{{% notice tip %}}
If you wish to add more tags at a later date you must repeat Step 4 from the lambda section, adding the tags to the list of Environment variables and replacing the Athena table with the tags appended. 
{{% /notice %}}


{{< prev_next_button link_prev_url="../5_join_cost_intelligence_dashboard/" link_next_url="../7_teardown/" />}}


