---
title: "Create Automation Resources"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

### Setup an AWS Lambda function to retrieve AWS Organizations information

Create the On-Demand AWS Lambda function to get the AWS Organizations information, and extract the required parts from it then write to our bucket in Amazon S3. 

1.	Return to your Sub account for the rest of this lab. Go to the **Lambda** service page :

![Images/Lambda.png](/Cost/300_Organization_Data_CUR_Connection/Images/Lambda.png)

2.	Click **Create function**:

![Images/Create_Function.png](/Cost/300_Organization_Data_CUR_Connection/Images/Create_Function.png)

3.	Enter the following details:
    1.	Select: **Author from scratch**
    2.	Function name: **Lambda_Org_Data**
    3.	Runtime: **Python** (Latest)
    4.	Open **Change default execution role**
    5.  Execution Role: **Use an existing role**
    6.	Role name: **LambdaOrgRole**

4.	Click **Create function**

![Images/Create_Function_Name.png](/Cost/300_Organization_Data_CUR_Connection/Images/Create_Function_Name.png)

5.	Copy and paste the following code into the **Function code** section and change (account id) to your **Management Account ID** on line 30 and (Region) to the **Region** on line 82 you are deploying in:

    <details>
    <summary> Click here to see the function code</summary>
        
        #!/usr/bin/env python3

        #Gets org data, grouped by ous and tags from managment accounts in json
        #Author Stephanie Gooch 2020

        import argparse
        import boto3
        from botocore.exceptions import ClientError
        from botocore.client import Config
        import os
        import datetime
        import json

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
            
        def lambda_handler(event, context):

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
                "organizations", region_name="us-east-1", #Using the Organizations client to get the data. This MUST be us-east-1 regardless of region you have the Lamda in
                aws_access_key_id=ACCESS_KEY,
                aws_secret_access_key=SECRET_KEY,
                aws_session_token=SESSION_TOKEN,
            )

            root_id    = client.list_roots()['Roots'][0]['Id']
            ou_id_list = get_ou_ids(root_id, client)
            
            with open('/tmp/ou-org.json', 'w') as f: # Saving in the temporay folder in the lambda
                for ou in ou_id_list.keys():
                    account_data(f, ou, ou_id_list[ou][0], client)
            s3_upload('ou-org')

            with open('/tmp/acc-org.json', 'w') as f: # Saving in the temporay folder in the lambda
                account_data(f, root_id, root_id, client)
            s3_upload('acc-org')

        def account_data(f, parent, parent_name, client):
            tags_check = os.environ["TAGS"]
            account_id_list = get_acc_ids(parent, client)
            for account_id in account_id_list:
                response = client.describe_account(AccountId=account_id)
                account  = response["Account"]          
                if tags_check != '':
                    tags_list = list_tags(client, account["Id"]) #gets the lists of tags for this account
                    
                    for tag in os.environ.get("TAGS").split(","): #looking at tags in the enviroment variables split by a space
                        for org_tag in tags_list:
                            if tag == org_tag['Key']: #if the tag found on the account is the same as the current one in the environent varibles, add it to the data
                                value = org_tag['Value']
                                kv = {tag : value}
                                account.update(kv)
                account.update({'Parent' : parent_name})        
                data = json.dumps(account, default = myconverter) #converts datetime to be able to placed in json

                f.write(data)
                f.write('\n')

        def s3_upload(file_name):
            bucket = os.environ["BUCKET_NAME"] #Using environment variables below the Lambda will use your S3 bucket
            try:
                s3 = boto3.client('s3', '(Region)',
                                config=Config(s3={'addressing_style': 'path'}))
                s3.upload_file(
                    f'/tmp/{file_name}.json', bucket, f"organisation-data/{file_name}.json") #uploading the file with the data to s3
                print(f"{file_name}org data in s3")
            except Exception as e:
                print(e)



        def get_ou_ids(parent_id, client):
            full_result = {}
            
            paginator = client.get_paginator('list_organizational_units_for_parent')
            iterator  = paginator.paginate(
                ParentId=parent_id

            )

            for page in iterator:
                for ou in page['OrganizationalUnits']:
                    print(ou['Name'])
                    full_result[ou['Id']]=[]
                    full_result[ou['Id']].append(ou['Name'])


            return full_result

        def get_acc_ids(parent_id,  client):
            full_result = []
            
            paginator = client.get_paginator('list_accounts_for_parent')
            iterator  = paginator.paginate(
                ParentId=parent_id
            )

            for page in iterator:
                for acc in page['Accounts']:
                    print(acc['Id'])
                    full_result.append(acc['Id'])


            return full_result


    </details>

If you wish to deploy in the managment account here is the [link to Code](/Cost/300_Organization_Data_CUR_Connection/Code/org_data_ou_man_tags.py)


6.	Under Configuration -> General Configuration edit **Basic settings** below:
    -	Memory: **512MB**
    -	Timeout: **2min**
    -	Click **Save**


![Images/Lambda_Edit_Settings.png](/Cost/300_Organization_Data_CUR_Connection/Images/Lambda_Edit_Settings.png)

7.	Scroll down to **Environment variable** and click **Edit**

![Images/Manage_Env_Vars.png](/Cost/300_Organization_Data_CUR_Connection/Images/Manage_Env_Vars.png)

8.	Add S3 Bucket environment variable:
    - In **Key** paste ‘BUCKET_NAME’ 
    - In **Value** paste your S3 Bucket name where the Organizations data should be saved

9. If you wish to pull **tags** from your accounts as well, **Add environment variable** and add the below. If you don't skip this:
    - In **Key** paste TAGS
    - In **Value** paste list of tags from your Organisation you would like to include **separated by a comma**
    
Click **Save**

![Images/Env_Tags.png](/Cost/300_Organization_Data_CUR_Connection/Images/Env_Tags.png)

10.	Scroll to the **function code**  and click **Deploy**. Then Click **Test**.

![Images/Deploy_Function.png](/Cost/300_Organization_Data_CUR_Connection/Images/Deploy_Function.png)

11.	Enter an **Event name** of **Test**, click **Create**:

![Images/Configure_Test.png](/Cost/300_Organization_Data_CUR_Connection/Images/Configure_Test.png)

12.	Click **Test**

13.	The function will run, it will take a minute or two given the size of the Organizations files and processing required, then return success. Click **Details** and verify there is headroom in the configured resources and duration to allow any increases in Organizations file size over time:

![Images/Lambda_Success.png](/Cost/300_Organization_Data_CUR_Connection/Images/Lambda_Success.png)

14.	Go to your S3 bucket and into the organisation-data folder and you should see a file of non-zero size is in it:

![Images/Org_in_S3.png](/Cost/300_Organization_Data_CUR_Connection/Images/Org_in_S3.png)


### Amazon CloudWatch Events Setup

We will setup a Amazon CloudWatch Event to periodically run the Lambda functions, this will update the Organizations and include any newly created accounts.

1.	Go to the CloudWatch service page:

![Images/CloudWatch.png](/Cost/300_Organization_Data_CUR_Connection/Images/CloudWatch.png)

2.	Click on **Events**, then click **Rules**:

![Images/CloudWaCW_Events_and_Rules.png](/Cost/300_Organization_Data_CUR_Connection/Images/CW_Events_and_Rules.png)

3.	Click **Create rule**

![Images/CW_Create_Rule.png](/Cost/300_Organization_Data_CUR_Connection/Images/CW_Create_Rule.png)

4.	For the Event Source
    - Select **Schedule** and set the required period
    - Select **7 days**
    - Add the **Lambda_Org_Data** Lambda function

    Click **Configure details**

![Images/CW_Schedule.png](/Cost/300_Organization_Data_CUR_Connection/Images/CW_Schedule.png)

5.	Add the name Lambda_Org_Data, optionally add a description and click **Create rule**:

![Images/CW_Rule_Detail.png](/Cost/300_Organization_Data_CUR_Connection/Images/CW_Rule_Detail.png)


{{% notice tip %}}
You have now created your lambda function  to gather your organization data and place it into the S3 Bucket we made earlier. Using Cloudwatch this will now run every 7 days updating  the data. 
{{% /notice %}}


{{< prev_next_button link_prev_url="../1_create_static_resources_source/" link_next_url="../3_utilize_organization_data_source/" />}}
