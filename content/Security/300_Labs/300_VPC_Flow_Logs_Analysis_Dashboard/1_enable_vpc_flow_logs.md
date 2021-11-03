---
title: "Enable VPC Flow Logs"
#menutitle: "Lab #1"
date: 2021-09-18T06:00:00-00:00
chapter: false
weight: 1
pre: "<b>1. </b>"
hidden: false
---

{{% notice note %}}
**Central AWS Account:** AWS account which you want to designate for storing VPC Flow Logs centrally. This account will also contain Athena DB, table and QuickSight Dashboard.\
 \
**Additional Accounts:** These are other accoutns that you own and has VPCs that you wish to enable Flow Logs and have an ability to push it to Central AWS Account's S3 bucket.\
 \
**QuickSight:** To manage VPC Flow Logs and QuickSight dashboard in central account please make sure you create resources for the central account in the region supported by QuickSight. Refer to this [link](https://docs.aws.amazon.com/quicksight/latest/user/regions.html) to see supported regions.
{{% /notice %}}

### Enable VPC Flow Logs
We assume that you already have VPC and existing resources running in your account. If you wish to crete VPC please refer to [documentation](https://docs.aws.amazon.com/directoryservice/latest/admin-guide/gsg_create_vpc.html) and for other reseource like Subnet, EC2 etc. refer to appropriate service documentation [here](https://docs.aws.amazon.com/index.html). 

QuickSight dashboard provided in this lab requires all the fields mentioned in the [Introduction section](/security/300_labs/300_vpc_flow_logs_analysis_dashboard/#introduction) are required. If you already have enabled VPC Flow logs with those fields (with CSV format, Hive partition enabled and delivered to S3) then you can skip this section and proceed to "**Create Athena resources, Lambda function and CloudWatch rule**" section to continue. If you do not have VPC flow logs enabled or existing VPC Flow logs does not have all the required fields then this section will help you in enabling vpc flow logs for existing VPC(s) in your account. Repeate all the steps from this section for each VPC in case you want to enable VPC Flow logs in respective account to visualize them in QuickSight dashboard under central account.

1. Login to your central AWS account.

2. Run CloudFormation stack to enable VPC Flow Logs.

<!-- https://cf-templates-wa-lab.s3.amazonaws.com/vpc-flow-logs-custom.yaml -->

<!-- {{%expand "Click here - if you wish to launch CloudFormation directly" %}}
Click [Here](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/new?templateURL=https://d36ux702kcm75i.cloudfront.net/vpc-flow-logs-custom.yaml&stackName=EnableVPCFlowLog) to launch CloudFormation template in your account to enable VPC Flow logs. Then click on **Next**

![Images/quicksight_dashboard_dt-2.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-01.png)
{{% /expand%}}
OR
{{%expand "Click here - if you wish to manually download the CloudFormation template and run it" %}} -->
<!-- {{% /expand%}} -->
- Download CloudFormation Template:
    - [vpc-flow-logs-custom.yaml](https://d36ux702kcm75i.cloudfront.net/vpc-flow-logs-custom.yaml) 
        - This cloudformation template enables VPC Flow Logs in the account you run it. You will need to run it per VPC.

    - From AWS Console navigate to CloudFormation. Then click on **Create stack**
    ![Images/quicksight_dashboard_dt-8.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-08.png)

    - Create stack page:
      1. In **Create stack** page **Specify template** select **Upload a template** file. 
      2. Then **Choose File** and upload the template vpc-flow-logs-custom.yaml (you have downloaded previously)
      3. **Click Next**
    ![Images/quicksight_dashboard_dt-9.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-09.png)

3. Provide name for the stack e.g. "vpc-flow-logs-stack" and values for the stack parameters and then click **Next**

    - **TrafficType** (ACCEPT, REJECT, ALL): Type of traffic you wish to record
        - ACCEPT — The recorded traffic was permitted by the security groups and network ACLs.
        - REJECT — The recorded traffic was not permitted by the security groups or network ACLs.
        - ALL -  The recorded traffic that was permitted (ACCEPT) and was not permitted (REJECT) by the security groups or network ACLs.

    - **VpcFlowLogsBucketName (Optional)**: S3 bucket name where VPC flow logs will be stored. 

        - If you specify the bucket name then it is assumed that the bucket already exists. If you want to centralize the storage of the logs create the bucket before and specify the bucket name here. 

        - If you leave it blank CloudFormation template will create a bucket for you.

        **If you are enabling VPC Flow Logs in additional account then please make sure to modify S3 bucket's policy from the central account to grant access to additional account and provide the name of the central bucket to this parameter.**
{{% notice note %}}
**VpcFlowLogsBucketName** - This buket will be used to gather vpc flow logs for all of your vpcs from one or more accounts. So please make sure this is the central account where you want your VPC flow logs to be collected and QuickSight dashboard to be hosted.
{{% /notice%}}
    - **VpcFlowLogsFilePrefix (Optional)**: VPC Flow [logfile prefix](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs-s3.html#flow-logs-s3-path) in S3 bucket. See bold text in below example

        **e.g.** bucket_name/<span style="color: #f92672">**vpc-flow-logs**</span>/AWSLogs/aws_account_id/vpcflowlogs/region/year/month/day/

    - **VpcId**: You can find the VPC ID in [console](https://console.aws.amazon.com/vpc/home?region=us-east-1#vpcs:) 

    ![Images/quicksight_dashboard_dt-2.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-02.png)

4. In **Configure stack options** page, add below tags and click on **Next**
    - Name=VPCFlowLogs-CFN
    - Purpose=WALabVPCFlowLogs

![Images/quicksight_dashboard_dt-3.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-03.png)

5. On Review screen verify the inputs you have provided

![Images/quicksight_dashboard_dt-4.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-04.png)

6. Last click on **Create stack**
![Images/quicksight_dashboard_dt-5.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-05.png)

7. As shown below you will see progress of the stack creation under **Events** tab. Please wait for the stack to complete the execution. Once complete it will show the status **CREATE_COMPLETE** in green then proceed to the next step.
![Images/quicksight_dashboard_dt-6.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-06.png)

8. To verify, navigate to VPC service, click on vpc link and then click on **Flow Logs** tab at the bottom part of the screen. You will see a line with flow logs you just created now.
![Images/quicksight_dashboard_dt-7.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-07.png)

### Delete older VPC Flow Logs from S3 bucket (Optional)

We recommend you to create a life cycle policy to delete logs older than 90 days or lesser as per your requirement to save cost. All the steps from this section are required to execute one time in central account.

- {{%expand "Click here to see the steps to Delete older VPC Flow Logs from S3 bucket" %}}

1. Login to central AWS account if you are not already in that acccount.
2. Navigate to S3 service from console
3. Click on S3 bucket where you stored VPC Flow Logs and click on **Management** link.
![Images/qs-vpcfl-s3-0.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-s3-0.png)
4. Click on **Create lifecycle rule**
![Images/qs-vpcfl-s3-1.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-s3-1.png)
5. Enter name for the rule e.g. **90_DAY_DELETE**. You can edit the number of days based on your requirement.
    - Check **"This rule applies to all objects in the bucket"**
    - Check **"I acknowledge that this rule will apply to all the objects in the bucket."**
    - Under **"Lifecycle rule actions"** check
        - Expire current versions of objects
        - Delete expired delete markers or incomplete multipart uploads
    ![Images/qs-vpcfl-s3-2.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-s3-2.png)
6. Enter 90 days for **"Number of days after object creation"** and 90 days for **"Number of days after object becomes previous versions"** and click on **Create rule**

    *NOTE: You can change the number of days based on your requirement.*
![Images/qs-vpcfl-s3-3.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-s3-3.png)
7. Once you create the rule, it will appear on **Lifecycle Configuration Page**
![Images/qs-vpcfl-s3-4.png](/Security/300_VPC_Flow_Logs_Analysis_Dashboard/images/qs-vpcfl-s3-4.png)
{{%/expand%}}


### Enable VPC Flow Logs in additional accounts and store it in central bucket (Optional)

- {{%expand "Click here to see the steps to enable VPC Flow logs in additional accounts" %}}

##### Before you proceed to enable VPC Flow Logs in additional account, you need to grant permission to access S3 bucket(from central account) for target account’s VPC to push logs. Repeate all the steps from this section for each Account/VPC.


Please follow below steps to edit S3 bucket policy in central account:
1. Navigate to S3 service in the central account where you have S3 bucket and QuickSight Dashboard for VPC Flow Logs created in first step.
2. Click on the vpc flow logs bucket you created earlier and then navigate to permissions tab.
3. Scroll down to the bucket policy. You will see existing policy like below.
4. Click on Edit. In the policy json find resource attribute. Add another line under resource to grant permission to store flow logs from another account you wish to. 
    
            e.g. "arn:aws:s3:::wa-lab-vpc-flow-logs/vpc-flow-logs/AWSLogs/<New account number>/*"
    
    Note: Above is an example only. Please change it according to your bucket name, prefix and New account number with actual target account number. If Resource attribute of the policy is not an array, then you need to add any additional account in array format (as a comma separated list surrounded in square brackets)
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

        **Note: Navigate to S3 service and click on S3 bucket you have created to store VPC Flow Logs, to see the date and region information as shown in example image below. If you do not see any content then you may need to wait until log records are written to the bucket based on 1 or 10 minutes granularity**

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


<!-- {{< prev_next_button link_prev_url="../4_distribute_dashboards/"  title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST3 - "How do you monitor usage and cost?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-expenditure-and-usage-awareness.html)
{{< /prev_next_button >}} -->


{{< prev_next_button link_prev_url="../" link_next_url="../2_create_athena_lambda_cloudwatch_rule/" />}}
