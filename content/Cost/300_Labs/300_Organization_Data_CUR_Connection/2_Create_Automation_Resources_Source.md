---
title: "Create Automation Resources"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

### Setup Organisation Lambda Function

Create the On-Demand Lambda function to get the organisation information, and extract the required parts from it then write to our folder in S3. 

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

5.	Copy and paste the following code into the **Function code** section and change (account id) to your **Managment Account ID**:

    <details>
    <summary> Click here to see the function code</summary>
        
        #!/usr/bin/env python3
    
        import argparse
        import boto3
        from botocore.exceptions import ClientError
        from botocore.client import Config
        import os
        
        def list_accounts():
            bucket = os.environ["BUCKET_NAME"] #Using enviroment varibles below the lambda will use your S3 bucket

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
            with open('/tmp/org.csv', 'w') as f: # Saving in the temporay folder in the lambda

                for response in response_iterator: # extracts the needed info
                    for account in response["Accounts"]:
                        aid = account["Id"]
                        name = account["Name"]
                        time = account["JoinedTimestamp"]
                        status = account["Status"]
                        line = "%s, %s, %s, %s\n" % (aid, name, time, status)
                        f.write(line)
            print("respose gathered")

            try:
                s3 = boto3.client('s3', 'eu-west-1',
                                config=Config(s3={'addressing_style': 'path'}))
                s3.upload_file(
                    '/tmp/org.csv', bucket, "organisation-data/org.csv") #uploading the file with the data to s3
                print("org data in s3")
            except Exception as e:
                print(e)

        def lambda_handler(event, context):
            list_accounts()


    </details>

6.	Edit **Basic settings** below:
    -	Memory: **512MB**
    -	Timeout: **2min**
    -	Click **save**


![Images/Lambda_Edit_Settings.png](/Cost/300_Organization_Data_CUR_Connection/Images/Lambda_Edit_Settings.png)

7.	Scroll down to **Environment variable** and click **Edit**

![Images/Manage_Env_Vars.png](/Cost/300_Organization_Data_CUR_Connection/Images/Manage_Env_Vars.png)

8.	Add environment variable:
    - In **Key** paste ‘BUCKET_NAME’ 
    - In **Value** paste your bucket name. 
 
    Click **Save**

![Images/Env_Bucket_Name.png](/Cost/300_Organization_Data_CUR_Connection/Images/Env_Bucket_Name.png)

9.	Scroll to the **function code**  and click **Deploy**. Then Click **Test**.

![Images/Deploy_Function.png](/Cost/300_Organization_Data_CUR_Connection/Images/Deploy_Function.png)

10.	Enter an **Event name** of **Test**, click **Create**:

![Images/Configure_Test.png](/Cost/300_Organization_Data_CUR_Connection/Images/Configure_Test.png)

11.	Click **Test**

12.	The function will run, it will take a minute or two given the size of the organisation files and processing required, then return success. Click **Details** and verify there is headroom in the configured resources and duration to allow any increases in organisation file size over time:

![Images/Lambda_Success.png](/Cost/300_Organization_Data_CUR_Connection/Images/Lambda_Success.png)

13.	Go to your S3 bucket and into the organisation-data folder and you should see a file of non-zero size is in it:

![Images/Org_in_S3.png](/Cost/300_Organization_Data_CUR_Connection/Images/Org_in_S3.png)


### CloudWatch Events Setup

We will setup a CloudWatch Event to periodically run the Lambda functions, this will update the organisation and include any newly created accounts.

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
