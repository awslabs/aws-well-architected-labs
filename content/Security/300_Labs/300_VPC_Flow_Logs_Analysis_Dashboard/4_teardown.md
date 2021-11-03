---
title: "Teardown"
date: 2021-07-26T11:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---


To perform a teardown for this lab, perform the following steps:


1. Navigate to CloudFormation in Central account to remove QuickSight dashboard, Athena dataset
    - Go into CloudFormation
    - Select the stack you crated with template **vpc_flowlogs_quicksight_template.yaml**
    - Click the **Delete** button to delete the stack.

2. Remove Athena DB, Table, View, Lambda Function and Cloudwatchwatch rule
    - Go into CloudFormation
    - Select the stack you crated with template **vpc_athena_db_table_view_lambda.yaml**
    - Click the **Delete** button to delete the stack.

4. Remove VPC Flow Logs from VPC (Please login to the AWS account where you have executed cloudformation template to create VPC Flow Logs)
    - Go into CloudFormation
    - Select the stack you crated with template **vpc-flow-logs-custom.yaml**
    - Click the **Delete** button to delete the stack.

5. Remove S3 bucket you created for storing VPC Flow Logs.
		

{{< prev_next_button link_prev_url="../2_create_lambda_and_cloudwatch_rule/" title="Congratulations!" final_step="true" />}}


