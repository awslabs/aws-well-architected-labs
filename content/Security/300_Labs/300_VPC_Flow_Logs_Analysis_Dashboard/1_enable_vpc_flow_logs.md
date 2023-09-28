---
title: "Enable VPC Flow Logs"
date: 2021-09-18T06:00:00-00:00
chapter: false
weight: 1
pre: "<b>1. </b>"
hidden: false
---

{{% notice note %}}
**Central AWS Account:** AWS account which you want to designate for storing VPC Flow Logs centrally. This account will also contain Athena DB, table and QuickSight Dashboard.\
 \
**Additional Accounts:** These are other accounts that you own and has VPCs that you wish to enable Flow Logs and have an ability to push it to Central AWS Account's S3 bucket.\
 \
**QuickSight:** To manage VPC Flow Logs and QuickSight dashboard in central account please make sure you create resources for the central account in the region supported by QuickSight. Refer to this [link](https://docs.aws.amazon.com/quicksight/latest/user/regions.html) to see supported regions.
{{% /notice %}}

### VPC
If you already have VPC and other resources running your AWS account continue with next section "Enable VPC Flow Logs" otherwise click on below link to deploy VPC and a toy webapp into your account.
{{%expand "Click here for instructions how to deploy a VPC to your AWS account:" %}}
{{% common/Create_VPC_Stack stackname="WebApp1-VPC" %}}

Wait until the VPC CloudFormation stack status is CREATE_COMPLETE, then continue. This will take about four minutes.

* Download the CloudFormation template: [_staticwebapp.yaml_](/Reliability/Common/Code/CloudFormation/staticwebapp.yaml)
  * You can right-click then choose **Save link as**; or you can right click and copy the link to use with `wget`

{{% common/CreateNewCloudFormationStack stackname="CloudFormationLab" templatename="staticwebapp.yaml" /%}}

{{% /expand%}}

### Enable VPC Flow Logs

QuickSight dashboard provided in this lab requires all the fields mentioned in the [Introduction section](/security/300_labs/300_vpc_flow_logs_analysis_dashboard/#introduction) are required. If you already have enabled VPC Flow logs with those fields (with parquet format, Hive partition enabled and delivered to S3) then you can skip this section and proceed to ["**Create Athena resources, Lambda function and CloudWatch rule**"](../2_create_athena_lambda_cloudwatch_rule/) section to continue. If you do not have VPC flow logs enabled or existing VPC Flow logs does not have all the required fields then this section will help you in enabling vpc flow logs for existing VPC(s) in your account. Repeat all the steps from this section for each VPC in case you want to enable VPC Flow logs in respective account to visualize them in QuickSight dashboard under central account.

#### Parquet file format

Use aws cli or AWS CloudShell to run below command. This command will create Flow Log in parquet file format with hive-compatible s3 prefixes

1. Navigate to CloudShell from AWS Console from the account where your VPC is located.
    Note: Please make sure you have correct region selected.
2. Replace `<VPC ID>` with VPC id from your account. You can find the VPC ID in [console](https://console.aws.amazon.com/vpc/home?region=us-east-1#vpcs:) 
3. Replace `<S3 ARN>` with S3 buckets arn from central account. Please specify subfolder in case you are storing logs under it. 
    
    e.g. `arn:aws:s3:::my-flow-log-bucket/my-custom-flow-logs/`

        aws ec2 create-flow-logs \
        --resource-type VPC \
        --resource-ids <VPC ID> \
        --traffic-type ALL \
        --log-destination-type s3 \
        --log-destination <S3 ARN> \
        --destination-options FileFormat=parquet,HiveCompatiblePartitions=True,PerHourPartition=false \
        --log-format '${account-id} ${action} ${az-id} ${bytes} ${dstaddr} ${dstport} ${end} ${flow-direction} ${instance-id} ${interface-id} ${log-status} ${packets} ${pkt-dst-aws-service} ${pkt-dstaddr} ${pkt-src-aws-service} ${pkt-srcaddr} ${protocol} ${region} ${srcaddr} ${srcport} ${start} ${sublocation-id} ${sublocation-type} ${subnet-id} ${tcp-flags} ${traffic-path} ${type} ${version} ${vpc-id}'
4. Once you finish replacing ID, ARN paste the command in CloudShell and run it. You will see below result with FlowLogIds, if it is successful.
![Images/quicksight_dashboard_dt-8.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-33.png)

- To verify, navigate to VPC service, click on vpc link and then click on **Flow Logs** tab at the bottom part of the screen. You will see a line with flow logs you just created now.
![Images/quicksight_dashboard_dt-7.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-07.png)

### Delete older VPC Flow Logs from S3 bucket (Optional)

We recommend you to create a life cycle policy to delete logs older than 90 days or lesser as per your requirement to save cost. All the steps from this section are required to execute one time in central account.

- {{%expand "Click here to see the steps to Delete older VPC Flow Logs from S3 bucket" %}}

1. Login to central AWS account if you are not already in that account.
2. Navigate to S3 service from console
3. Click on S3 bucket where you stored VPC Flow Logs and click on **Management** link.
![Images/qs-vpcfl-s3-0.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-s3-0.png)
4. Click on **Create lifecycle rule**
![Images/qs-vpcfl-s3-1.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-s3-1.png)
5. Enter name for the rule e.g., **90_DAY_DELETE**. You can edit the number of days based on your requirement.
    - Check **"This rule applies to all objects in the bucket"**
    - Check **"I acknowledge that this rule will apply to all the objects in the bucket."**
    - Under **"Lifecycle rule actions"** check
        - Expire current versions of objects
        - Permanently delete noncurrent versions of objects
    ![Images/qs-vpcfl-s3-2.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-s3-2.png)
6. Enter 90 days for **"Number of days after object creation"** and 90 days for **"Number of days after object becomes previous versions"** and click on **Create rule**

    *NOTE: You can change the number of days based on your requirement.*
![Images/qs-vpcfl-s3-3.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-s3-3.png)
7. Once you create the rule, it will appear on **Lifecycle Configuration Page**
![Images/qs-vpcfl-s3-4.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-s3-4.png)
{{%/expand%}}


### Enable VPC Flow Logs in additional accounts and store it in central bucket (Optional)

- {{%expand "Click here to see the steps to enable VPC Flow logs in additional accounts" %}}

##### Before you proceed to enable VPC Flow Logs in additional account, you need to grant permission to access S3 bucket(from central account) for target account’s VPC to push logs. Repeat all the steps from this section for each Account/VPC.


Please follow below steps to edit S3 bucket policy in central account:
1. Navigate to S3 service in the central account where you have S3 bucket and QuickSight Dashboard for VPC Flow Logs created in first step.
2. Click on the vpc flow logs bucket you created earlier and then navigate to permissions tab.
3. Scroll down to the bucket policy. You will see existing policy like below.
4. Click on Edit. In the policy json find resource attribute. Add another line under resource to grant permission to store flow logs from another account you wish to. 
    
            e.g., "arn:aws:s3:::wa-lab-vpc-flow-logs/vpc-flow-logs/AWSLogs/<New account number>/*"
    
    Note: Above is an example only. Please change it according to your bucket name, prefix and `<New account number>` with actual target account number. If Resource attribute of the policy is not an array, then you need to add any additional account in array format (as a comma separated list surrounded in square brackets)
5. Click on Save.
6. Log out from central account.
7. Repeat steps 1 thru 9 from section “**Enable VPC Flow Logs**” to enable logs in new account for desired VPC.
8. Log out from the additional account once you successfully enable flow logs for another VPC.
9. Log in to the central account.
10. Manually add first partition to the external table for the vpc in the new account:
    
    Follow below instructions (1 thru 4) to make necessary changes in the code:

            ALTER TABLE vpc_flow_logs_custom_integration ADD
            PARTITION (`aws-account-id`='<your new account number>', `aws-service`='vpcflowlogs', `aws-region`='<your region>', year='yyyy', month='mm', day='dd')
            LOCATION 's3://<VPC-Flow-Logs-Bucket-Name>/<VPC-Flow-Logs-Prefix>/AWSLogs/<your new account number>/vpcflowlogs/<your region>/yyyy/mm/dd';
    
    
    1. Replace `<your new account number>` with your new account number at 2 places
    2. Replace the `yyyy`,`mm`,`dd` with date for the log file at 2 places. Look into S3 bucket for files created under specific date

        **Note: Navigate to S3 service and click on S3 bucket you have created to store VPC Flow Logs, to see the date and region information as shown in example image below. If you do not see any content then you may need to wait until log records are written to the bucket based on 1- or 10-minutes granularity**

        ![images/qs-vpcfl-partitions.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-partitions.png)
        
    3. Replace `<your region>` with respective region in S3 bucket for vpc flow logs at 2 places
    4. In LOCATION Replace complete S3 url with appropriate path where your VPC logs are stored
        - `<VPC-Flow-Logs-Bucket-Name>` with bucket name where logs are stored
        - `<VPC-Flow-Logs-Prefix>` with Flow Logs prefix you have used while enabling logs. If you have not provided any prefix at the time of enabling it you can remove it from above path.

        Example below:
                
                ALTER TABLE vpc_flow_logs_custom_integration ADD
                PARTITION (`aws-account-id`='0123456789', `aws-service`='vpcflowlogs', `aws-region`='us-east-1', year='2021', month='10', day='27')
                LOCATION 's3://my-central-vpc-flow-logs/vpc-flow-logs/AWSLogs/0123456789/vpcflowlogs/us-east-1/2021/10/27';

        
{{% notice note %}}
Repeat above steps 1 thru 10 if you wish to enable VPC Flow Logs for VPCs in each secondary account.
{{% /notice %}}

{{% /expand%}}

{{< prev_next_button link_prev_url="../" link_next_url="../2_create_athena_lambda_cloudwatch_rule/" />}}
