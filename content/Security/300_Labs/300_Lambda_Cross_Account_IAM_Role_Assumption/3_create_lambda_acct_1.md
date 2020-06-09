---
title: "Create Lambda in account 1"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---
1. Open the Lambda console.
2. Click Create a function.
3. Accept the default Author from scratch.
4. Enter function name as Lambda-Assume-Roles.
5. Select Python 3.6 runtime.
6. Expand Permissions, click Use an existing role, then select the Lambda-Assume-Roles role.
7. Click Create function.
8. Replace the example function code with the following, replacing the **RoleArn** with the one from account 2 you created previously.

        import json
        import boto3
        import os
        import uuid

        def lambda_handler(event, context):
            try:
                client = boto3.client('sts')
                response = client.assume_role(RoleArn='arn:aws:iam::account2:role/LambdaS3ListBuckets',RoleSessionName="{}-s3".format(str(uuid.uuid4())[:5]))
                session = boto3.Session(aws_access_key_id=response['Credentials']['AccessKeyId'],aws_secret_access_key=response['Credentials']['SecretAccessKey'],aws_session_token=response['Credentials']['SessionToken'])

                s3 = session.client('s3')
                s3list = s3.list_buckets()
                print (s3list)
                return str(s3list['Buckets'])

            except Exception as e:
                print(e)
                raise e

9. Click Save.
10. Click Test, accept the default event template, enter event name of test, then click Create.
11. Click Test again, and in a few seconds the function output should highlight green and you can expand the detail to see the response from the S3 API.

How could the example policies be improved?
