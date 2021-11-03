---
title: "Create Athena resources, Lambda function and CloudWatch rule"
menutitle: "Create Athena Resources"
date: 2021-09-18T06:00:00-00:00
chapter: false
weight: 2
pre: "<b>2. </b>"
hidden: false
---

<!-- ### Create the Athena DataBase, external table, View, Lambda function and Cloudwatch rule to add partitions daily to Athena table -->
<!-- 2. Modify CloudFormation template you have just downloaded as below. 
   - Under VPCAthenaPartitionsFunction→Code section where python code starts:
     - Replace `<vpc-flow-logs-bucket>` with bucket name of vpc flow logs.
     - Replace `vpc-flow-logs` with prefix that you have provided while executing CloudFormation template earlier.
     - Set python variable **s3_ouput** to S3 url where Athena query results are stored. If you are setting it for first time refer documentation [here](https://docs.aws.amazon.com/athena/latest/ug/querying.html) 
     - Replace `<Athena DB>` with Athena DB name where external table was created in step 1 from **Create external Athena table** section
     - Replace `vpc_flow_logs_custom` with Athena external table that was created in step 1 from **Create external Athena table** section
    
            #Parameters for S3 log location and Athena table (Fill this carefully)
            s3_buckcet_flow_log = '<vpc-flow-logs-bucket>' # '<s3 bucket name where flow logs will be stored>'
            s3_account_prefix = 'vpc-flow-logs/AWSLogs/' # '<prefix for VPC flow logs that comes after bucket name>' e.g. 'vpc-flow-logs'
            s3_ouput = '<S3 bucket URL where Athena query results are stored>'
            # e.g. 's3://aws-athena-query-results-us-east-1-<account number>'
            database = '<Athena DB>'
            table_name = 'vpc_flow_logs_custom' # '<Athena table name for VPC flow logs>' -->

Now that you have enabled VPC Flow Logs, which will help you understand how your applications are communicating over your VPC network with log records containing the Instance ID, Source and Destination IP addresses, Subnet ID, VPC ID and the type and volume of traffic to list a few. While the raw VPC Flow Logs by themselves provide detailed information about every single network traffic flow, you still need to filter and aggregate them to derive the necessary insights e.g Dropped traffic, Top Source and destination IPs etc. This is where you need an analytical tool such as Athena to query the raw VPC Flow Logs and get you to the required insights and a QuickSight dashaboard which is built on top of Athena table/view.

**_All the steps from this section are required to execute one time in central account._**

1. Login to your central AWS account.

2. Run CloudFormation stack to create Athena Database, Table, Lambda function and Cloudwatch rule.
<!-- {{%expand "Click here - if you wish to launch CloudFormation directly" %}}
Click [Here](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?templateURL=https://d36ux702kcm75i.cloudfront.net/vpc_athena_db_table_view_lambda.yaml&stackName=VPCFlowLogsAthenaLambdaStack-01) to launch CloudFormation template in your account to enable VPC Flow logs. Then click on **Next**
![Images/qs-vpcfl-athena-01.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-athena-01.png)
{{% /expand%}}
OR
{{%expand "Click here - if you wish to manually download the CloudFormation template and run it" %}} 
{{% /expand%}}-->

 - Download CloudFormation Template:
 [vpc_athena_db_table_view_lambda.yaml](https://d36ux702kcm75i.cloudfront.net/vpc_athena_db_table_view_lambda.yaml)

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
    <!-- If you have downloaded template earlier, navigate to CloudFormation. 
    - In **Create stack** menu select standard option.  -->
      
    ![Images/quicksight_dashboard_dt-9.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-09.png)

<!-- 2. From AWS Console switch to primary region and navigate to CloudFormation. Then click on **Create stack**
![Images/quicksight_dashboard_dt-8.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-08.png)

4. In **Create stack** page Under **Specify template** select **Upload a template file**. Choose File and upload the template you just modified. Click **Next**
![Images/quicksight_dashboard_dt-9.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-09.png) -->
3. In **Specify stack details** page provide values to below parameters:
   1. Provide unique stack name e.g. **VPCFlowLogsAthenaLambdaStack-01**\
     (Please read the description of each parameter carefully)
   2. **AthenaQueryResultBucketArn:** The ARN of the Amazon S3 bucket to which Athena query results are stored. e.g. 'arn:aws:s3:::aws-athena-query-results-us-east-1-XXXXXXXXXXXXXX'
   3. **AthenaResultsOutputLocation:** URI path of the Amazon S3 bucket where Athena query results are stored.
   4. **HiveCompatibleS3prefix:** [documentation](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-s3.html) Adds prefixes of partition keys in s3 object key (Hive-compatible S3 prefix)\
        (Note: Please select false, since only this option is supported for now)
   5. **S3BucketRegion:** Region of the S3 bucket created in the central account. e.g. _us-east-1_
   6. **VpcFlowLogsAthenaDatabaseName:** Only provide existing database name if it has a table with all the required fields mentioned in the [Introduction section](/security/300_labs/300_vpc_flow_logs_analysis_dashboard/#introduction) otherwise leave it empty so that this template will create new DB.
   7. **VpcFlowLogsAthenaTableName:** Only provide existing table name if it has all the required fields mentioned in the [Introduction section](/security/300_labs/300_vpc_flow_logs_analysis_dashboard/#introduction) otherwise leave it empty so that this template will create new table.
   8. **VpcFlowLogsBucketName:** Name of the Amazon S3 bucket where vpc flow logs are stored. e.g. _my-vpc-flow-logs-bucket_
   9. **VpcFlowLogsFilePrefix:** The log file prefix in Amazon S3 bucket that comes right after s3 bucket name e.g. _vpc-flow-logs_
   10. **VpcFlowLogsS3BucketLocation:** Please provide complete path **without log file name**, as shown below

   e.g. **_s3://my-vpc-flow-logs-bucket/vpc-flow-logs/AWSLogs/0123456789/vpcflowlogs/us-east-1/2021/11/01/_**

- Click **Next**

![Images/quicksight_dashboard_dt-10.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-10.png)
4. Add tags **Name=VPCFlowLogs-Lambda-Stack** and **Purpose=WALabVPCFlowLogs**. Keep rest of the selections to **default** vaules. Click **Next**
![Images/quicksight_dashboard_dt-11.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-11.png)
5. Review the Stack and click on **I acknowledge that AWS CloudFormation might create IAM resources.** checkbox, Click on **Create Stack**
![Images/quicksight_dashboard_dt-12.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-12.png)
6. You will see the progress of the stack creation under **Events** tab as below. Please wait for the stack to complete the execution. Once complete it will show the status **CREATE_COMPLETE** in green then proceed to the next step. 
![Images/quicksight_dashboard_dt-13.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-13.png) 
<!-- 9. Navigate to Lambda Service and click on newly created lambda. 
![Images/quicksight_dashboard_dt-14.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-14.png) 
10. Test lambda function
{{% notice note %}}
If you are running Test first time, you can use Hello-World template to define the test without any changes to the context.
{{% /notice %}} -->
7. To verify the result navigate to Athena from AWS Console and run below sql query:

        SELECT * FROM vpc_flow_logs_custom_integration limit 10;
        
   Athena View: 

        SELECT * FROM vpc_flow_logs_view limit 10;


Example screen shot:
![Images/quicksight_dashboard_dt-15.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-15-1.png) 


{{< prev_next_button link_prev_url="../1_enable_vpc_flow_logs/" link_next_url="../3_create_vpc_flow_logs_analysis" >}}