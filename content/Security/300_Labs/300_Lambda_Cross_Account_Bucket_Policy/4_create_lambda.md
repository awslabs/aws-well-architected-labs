---
title: "Create Lambda in account 1"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

1. Open the Lambda console <https://console.aws.amazon.com/lambda>
1. Click **Create a function**
1. Accept the default **Author from scratch**
1. Enter function name as _Lambda-List-S3_
1. Select **Python 3.7** runtime
1. Expand Permissions, click **Use an existing role**, then select the **Lambda-List-S3-Role**
1. Click **Create function**
1. Replace the example function code with the following
    * Replace **bucketname** with the S3 bucket name from account 2

          import json
          import boto3
          import os
          import uuid

          def lambda_handler(event, context):
              try:

                  # Create an S3 client
                  s3 = boto3.client('s3')

                  # Call S3 to list current buckets
                  objlist = s3.list_objects(
                                  Bucket='bucketname',
                                  MaxKeys = 10)

                  print (objlist['Contents'])
                  return str(objlist['Contents'])


              except Exception as e:
                  print(e)
                  raise e

1. Click **Save**.
1. Click **Test**, accept the default event template, enter an event name for the test, then click **Create**
1. Click **Test** again, and in a few seconds the function output should highlight green and you can expand the detail to see the response from the S3 API
