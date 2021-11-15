---
title: "Teardown"
date: 2021-07-26T11:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---


To perform a teardown for this lab, perform the following steps:


1. Delete **QuickSight dashboard, Athena dataset**
    1. Go to the AWS CloudFormation console: <https://console.aws.amazon.com/cloudformation>
    2. Select the CloudFormation stack you crated with template **vpc_flowlogs_quicksight_template.yaml** to delete and click **Delete**
    3. In the confirmation dialog, click **Delete stack**
    4. The **Status** changes to _DELETE_IN_PROGRESS_
    5. Click the refresh button to update and status will ultimately progress to _DELETE_COMPLETE_
    6. When complete, the stack will no longer be displayed. To see deleted stacks use the drop down next to the Filter text box.
    6. To see progress during stack deletion
        * Click the stack name
        * Select the Events column
        * Refresh to see new events

2. Delete **Athena DB, Table, View, Lambda Function and Cloudwatchwatch rule**
    1. Go to the AWS CloudFormation console: <https://console.aws.amazon.com/cloudformation>
    2. Select the CloudFormation stack you crated with template **vpc_athena_db_table_view_lambda.yaml** to delete and click **Delete**
    3. In the confirmation dialog, click **Delete stack**
    4. The **Status** changes to _DELETE_IN_PROGRESS_
    5. Click the refresh button to update and status will ultimately progress to _DELETE_COMPLETE_
    6. When complete, the stack will no longer be displayed. To see deleted stacks use the drop down next to the Filter text box.
    6. To see progress during stack deletion
        * Click the stack name
        * Select the Events column
        * Refresh to see new events

4. Delete **VPC Flow Logs from VPC** (Please login to the AWS account where you have executed cloudformation template to create VPC Flow Logs)
    1. Go to the AWS CloudFormation console: <https://console.aws.amazon.com/cloudformation>
    2. Select the CloudFormation stack you crated with template **vpc-flow-logs-custom.yaml** to delete and click **Delete**
    3. In the confirmation dialog, click **Delete stack**
    4. The **Status** changes to _DELETE_IN_PROGRESS_
    5. Click the refresh button to update and status will ultimately progress to _DELETE_COMPLETE_
    6. When complete, the stack will no longer be displayed. To see deleted stacks use the drop down next to the Filter text box.
    6. To see progress during stack deletion
        * Click the stack name
        * Select the Events column
        * Refresh to see new events

5. Delete **S3 bucket** you created for storing VPC Flow Logs.
		

{{< prev_next_button link_prev_url="../2_create_lambda_and_cloudwatch_rule/" title="Congratulations!" final_step="true" />}}


