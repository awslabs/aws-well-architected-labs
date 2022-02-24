---
title: "Create Athena resources, Lambda function and CloudWatch rule"
menutitle: "Create Athena Resources"
date: 2021-09-18T06:00:00-00:00
chapter: false
weight: 2
pre: "<b>2. </b>"
hidden: false
---

Now that you have enabled VPC Flow Logs, which will help you understand how your applications are communicating over your VPC network with log records containing the Instance ID, Source and Destination IP addresses, Subnet ID, VPC ID and the type and volume of traffic to list a few. While the raw VPC Flow Logs by themselves provide detailed information about every single network traffic flow, you still need to filter and aggregate them to derive the necessary insights e.g Dropped traffic, Top Source and destination IPs etc. This is where you need an analytical tool such as Athena to query the raw VPC Flow Logs and get you to the required insights and a QuickSight dashaboard which is built on top of Athena table/view.

**_All the steps from this section are required to execute one time in central account._**

1. Login to your central AWS account.

2. Run CloudFormation stack to create Athena Database, Table, Lambda function and Cloudwatch rule.

 - Download CloudFormation Template:
    - **CSV file format**: [vpc_athena_db_table_view_lambda.yaml](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/code/vpc_athena_db_table_view_lambda.yaml) 
    
      **OR**
    
    - **Parquet file format**: [vpc_athena_db_table_view_lambda_parquet.yaml](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/code/vpc_athena_db_table_view_lambda_parquet.yaml)


    This cloudformation template creates
    - **Athena DataBase, an external table, VPC Flow Logs View:** To query and fetch data from S3 bucket for VPC Flow Logs.
    - **Lambda function:** To create partitions in external Athena table for log records stored every day in S3 bucket.
    - **Cloudwatch rule:** Invokes lambda function at daily frequency.

- From AWS Console navigate to CloudFormation. Then click on **Create stack**
![Images/quicksight_dashboard_dt-8.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-08.png)

- Create stack page:
  1. In **Specify template** section, select **Upload a template** file. 
  2. Then **Choose File** and upload the template **_vpc_athena_db_table_view_lambda.yaml_** (you have downloaded previously)
  3. Then **Click Next**
      
    ![Images/quicksight_dashboard_dt-9.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-09.png)

3. In **Specify stack details** page provide values to below parameters:
   1. Provide unique stack name e.g. **VPCFlowLogsAthenaLambdaStack-01**\
     (Please read the description of each parameter carefully)
   2. **AthenaQueryResultBucketArn:** The ARN of the Amazon S3 bucket to which Athena query results are stored. e.g. 'arn:aws:s3:::aws-athena-query-results-us-east-1-XXXXXXXXXXXXXX'
   3. **AthenaResultsOutputLocation:** URI path of the Amazon S3 bucket where Athena query results are stored.
   4. **HiveCompatibleS3prefix:** [documentation](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-s3.html) Adds prefixes of partition keys in s3 object key (Hive-compatible S3 prefix)
        
        Note: Please select true for Parquet

   5. **S3BucketRegion:** Region of the S3 bucket created in the central account. e.g. _us-east-1_
   6. **VpcFlowLogsAthenaDatabaseName:** Only provide existing database name if it has a table with all the required fields mentioned in the [Introduction section](/security/300_labs/300_vpc_flow_logs_analysis_dashboard/#introduction) otherwise leave it empty so that this template will create new DB.
   7. **VpcFlowLogsAthenaTableName:** Only provide existing table name if it has all the required fields mentioned in the [Introduction section](/security/300_labs/300_vpc_flow_logs_analysis_dashboard/#introduction) otherwise leave it empty so that this template will create new table.
   8. **VpcFlowLogsBucketName:** Name of the Amazon S3 bucket where vpc flow logs are stored. e.g. _my-vpc-flow-logs-bucket_
   9. **VpcFlowLogsFilePrefix:** The log file prefix in Amazon S3 bucket that comes right after s3 bucket name e.g. _vpc-flow-logs_
   10. **VpcFlowLogsS3BucketLocation:** Please provide complete path **without log file name**, as shown below

   e.g.

   For CSV - **_s3://my-vpc-flow-logs-bucket/vpc-flow-logs/AWSLogs/0123456789/vpcflowlogs/us-east-1/2021/11/01/_**
   
   For Parquet - **_s3://my-vpc-flow-logs-bucket/vpc-flow-logs-enh-parquet/AWSLogs/_**

- Click **Next**

![Images/quicksight_dashboard_dt-10.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-10.png)
4. Add tags **Name=VPCFlowLogs-Lambda-Stack** and **Purpose=WALabVPCFlowLogs**. Keep rest of the selections to **default** values. Click **Next**
![Images/quicksight_dashboard_dt-11.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-11.png)
5. Review the Stack and click on **I acknowledge that AWS CloudFormation might create IAM resources.** checkbox, Click on **Create Stack**
![Images/quicksight_dashboard_dt-12.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-12.png)
6. You will see the progress of the stack creation under **Events** tab as below. Please wait for the stack to complete the execution. Once complete it will show the status **CREATE_COMPLETE** in green then proceed to the next step. 
![Images/quicksight_dashboard_dt-13.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-13.png) 

7. To verify the result navigate to Athena from AWS Console and run below sql query:

        SELECT * FROM vpc_flow_logs_custom_integration limit 10;
        
   Athena View for CSV: 

        SELECT * FROM vpc_flow_logs_view limit 10;

   Athena Views for Parquet:

        SELECT * FROM vpc_flow_logs_summary_view limit 10;

        SELECT * FROM vpc_flow_logs_daily_view limit 10;

        SELECT * FROM vpc_flow_logs_enhanced_view limit 10;


Example screen shot:
![Images/quicksight_dashboard_dt-15.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-15-1.png) 


{{< prev_next_button link_prev_url="../1_enable_vpc_flow_logs/" link_next_url="../3_create_vpc_flow_logs_analysis" >}}