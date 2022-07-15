---
title: "Data Collection Modules and Testing Deployment"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Data Collection Modules 

{{% notice tip %}}
These modules templates are managed in AWS owned buckets. If you do not wish to have updates on them from AWS then please save a copy to a bucket in your account and use instead. 
{{% /notice %}}

Below are the modules we have available in this lab. You can read more about them by expanding the sections. You have selected your chosen modules in the Deploy Main Resources section so no action is needed. 

{{%expand "Cost Explorer Rightsizing Recommendations" %}}

### Cost Explorer Rightsizing Recommendations
This module will collect rightsizing recommendations from AWS Cost Explorer in your management account. You can use the saved Athena query as a view to query these results and track your recommendations. Find out more about the recommendations [here.](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/ce-rightsizing.html)
This Data will be partitioned by year, month, day. 


* IAM Policy deployed with **OptimizationManagementDataRoleStack**:  

        - PolicyName: "RightsizeReadOnlyPolicy"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                  - "ce:GetRightsizingRecommendation"
                Resource: "*"

* CloudFormation Stack deployed with **OptimizationDataCollectionStack**  

        RightsizeStack:
          Type: AWS::CloudFormation::Stack
          Properties:
            Parameters:
                DestinationBucket: !Ref S3Bucket
                DestinationBucketARN: !GetAtt S3Bucket.Arn 
                RoleName: !Sub "arn:aws:iam::${ManagementAccountID}:role/${ManagementAccountRole}"
            TemplateURL: "https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/organization_rightsizing_lambda.yaml"
            TimeoutInMinutes: 5
* [Test your Lambda](#testing-your-deployment) 
{{% /expand%}}


{{%expand "Inventory Collector" %}}

### Inventory Collector
This module is designed to loop through your AWS Organizations account and collect data that could be used to find optimization data. It has two components, firstly the AWS accounts collector which used the management role built before. This then passes the account id into an SQS queue which then is used as an event in the next component. This section assumes a role into the account the reads the data and places into an Amazon S3 bucket in the Cost Account.  See the **Utilize Data Section** for more information on how to use this data.
This Data will be partitioned by year, month. 

* IAM Policy deployed with **OptimizationDataRoleStack** CloudFormation StackSet depending on what you want to ingest:  

        - PolicyName: "InventoryCollectorPolicy"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                  - "ec2:DescribeImages"
                  -  "ec2:DescribeVolumeStatus"
                  -  "ec2:DescribeVolumes"
                  - "ec2:DescribeSnapshots"
                  - "ec2:DescribeSnapshotAttribute"
                    Resource: "*"

* CloudFormation Stack deployed with **OptimizationDataCollectionStack**:  
The services you can collect data are below. Use these in the *Prefix* and *CFDataName* parameters:
  - ami
  - ebs
  - snapshot
  - ta
        DataStackMulti:
          Type: AWS::CloudFormation::Stack
          Properties:
            TemplateURL:  "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/lambda_data.yaml"
            TimeoutInMinutes: 2
            Parameters:
              DestinationBucket: !Ref S3Bucket
              DestinationBucketARN: !GetAtt S3Bucket.Arn 
              Prefix: "ami" # example 
              CFDataName: "AMI" # example 
              GlueRoleARN: !GetAtt GlueRole.Arn
              MultiAccountRoleName: !Ref MultiAccountRoleName
              CodeBucket: !Ref CodeBucket
        AccountCollector:
          Type: AWS::CloudFormation::Stack
          Properties:
            TemplateURL: "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/get_accounts.yaml"
            TimeoutInMinutes: 2
            Parameters:
              RoleARN: !Sub "arn:aws:iam::${ManagementAccountID}:role/${ManagementAccountRole}"
              TaskQueuesUrl: !Sub "${DataStackMulti.Outputs.SQSUrl}"

* Optional Parameters with current defaults:
DataStackMulti
    - DatabaseName: optimization_data
    - CodeKey:  Cost/Labs/300_Optimization_Data_Collection/fof.zip

AccountCollector
    - Suffix: ''
    - Schedule: rate(14 days)

* [Test your Lambda](#testing-your-deployment) 

{{% notice note %}}
The AccountCollector module is reusable and only needs to be added once but multiple queues can be added too TaskQueuesUrl
{{% /notice %}}

{{% /expand%}}


{{%expand "Trusted Advisor" %}}

###  Trusted Advisor
This module will retrieve all AWS Trusted Advisor recommendations from all your linked account. See the **Utilize Data Section** for more information on how to use this data.
This Data will be partitioned by year, month, day. 

Once this module is deployed and TA data is collected you can visualize it with [TAO Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/). To deploy [TAO Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/) please follow either [automated](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/dashboards/3_auto_deployment/) or [manual](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/dashboards/4_manual-deployment-prepare/) deployment steps and specify organizational data collection bucket created in this lab as a source.

* IAM Policy added **OptimizationDataRoleStack** CloudFormation StackSet:  
     
          - PolicyName: "TAPolicy"
            PolicyDocument:
              Version: "2012-10-17"
              Statement:
                - Effect: "Allow"
                  Action:
                  - "trustedadvisor:*"
                  - "support:DescribeTrustedAdvisorChecks"
                  - "support:DescribeTrustedAdvisorCheckResult"
                  Resource: "*"
          


* CloudFormation Stack added to **OptimizationDataCollectionStack**:  

        TrustedAdvisor:
          Type: AWS::CloudFormation::Stack
          Properties:
                TemplateURL:  "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/trusted_advisor.yaml"
                TimeoutInMinutes: 2
                Parameters:
                  DestinationBucket: !Ref S3Bucket
                  DestinationBucketARN: !GetAtt S3Bucket.Arn 
                  Prefix: "ta"
                  CFDataName: "TA"
                  GlueRoleARN: !GetAtt GlueRole.Arn
                  MultiAccountRoleName: !Ref MultiAccountRoleName
                  CodeBucket: !Ref CodeBucket
        AccountCollector:
          Type: AWS::CloudFormation::Stack
          Properties:
                TemplateURL: "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/get_accounts.yaml"
                TimeoutInMinutes: 2
                Parameters:
                  RoleARN: !Sub "arn:aws:iam::${ManagementAccountID}:role/${ManagementAccountRole}"
                  TaskQueuesUrl: !Sub "${TrustedAdvisor.Outputs.SQSUrl}"

* Optional Parameters with current defaults:
DataStackMulti
    - DatabaseName: optimization_data
    - CodeKey:  Cost/Labs/300_Optimization_Data_Collection/ta.zip
    - CFDataName: Trusted_Advisor
    - Prefix: ta

AccountCollector
    - Suffix: ''
    - Schedule: rate(14 days)

* [Test your Lambda](#testing-your-deployment) 

{{% notice note %}}
The AccountCollector module is reusable and only needs to be added once but multiple queues can be added too TaskQueuesUrl
{{% /notice %}}

{{% /expand%}}


{{%expand "Compute Optimizer Collector" %}}

## Compute Optimizer

The Compute Optimizer Service by default only shows current point in time recommendations looking at the past 14 days of usage. In this module, the data will be collected together so you will access to all accounts and regions recommendations in one place. This can be accessed through the Management Account. You can use the saved Athena queries as a view to query these results and track your recommendations. Also we recommend to install [Compute Optimizer Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/#comute-optimizer-dashboard) for visualizing. 

Compute Optimizer Data will be separated by type service and partitioned by year, month. 
Please make sure you enable Compute Optimizer following this [guide.](https://docs.aws.amazon.com/organizations/latest/userguide/services-that-can-integrate-compute-optimizer.html)

Compute Optimizer is regional service and the Compute Optimizer Collector will deploy one bucket for each region. The user must specify **DeployRegions** - a comma separated list of regions with EC2, EBS, ASG and Lambda workloads. If blank, the current region will be used.

![Images/Arc_compute_optimizer_data_collection.png](/Cost/300_Optimization_Data_Collection/Images/Arc_compute_optimizer_data_collection.png) 


* IAM Policy added to  **OptimizationManagementDataRoleStack**:  

        - PolicyName: "ComputeOptimizer-ExportLambdaFunctionRecommendations"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                  - "compute-optimizer:ExportLambdaFunctionRecommendations"
                  - "compute-optimizer:GetLambdaFunctionRecommendations"
                  - "lambda:ListFunctions"
                  - "lambda:ListProvisionedConcurrencyConfigs"
                Resource: "*"
        - PolicyName: "ComputeOptimizer-ExportAutoScalingGroupRecommendations"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                  - "compute-optimizer:ExportAutoScalingGroupRecommendations"
                  - "compute-optimizer:GetAutoScalingGroupRecommendations"
                  - "autoscaling:DescribeAutoScalingGroups"
                Resource: "*"
        - PolicyName: "ComputeOptimizer-ExportEBSVolumeRecommendations"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                  - "compute-optimizer:ExportEBSVolumeRecommendations"
                  - "compute-optimizer:GetEBSVolumeRecommendations"
                  - "EC2:DescribeVolumes"
                Resource: "*"
        - PolicyName: "ComputeOptimizer-ExportEC2InstanceRecommendations"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                  - "compute-optimizer:ExportEC2InstanceRecommendations"
                  - "compute-optimizer:GetEC2InstanceRecommendations"
                  - "EC2:DescribeInstances"
                Resource: "*"


* CloudFormation Stack added to **OptimizationDataCollectionStack** :  

        ComputeOptimizerModule:
          Type: AWS::CloudFormation::Stack
          Condition: DeployComputeOptimizerModule
          Properties:
            TemplateURL: "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/compute_optimizer.yaml"
            Parameters:
              DestinationBucketARN: !GetAtt S3Bucket.Arn 
              DestinationBucket: !Ref S3Bucket
              GlueRoleARN: !GetAtt GlueRole.Arn
              RoleNameARN: !Sub "arn:aws:iam::${ManagementAccountID}:role/${RolePrefix}${ManagementAccountRole}"
              S3CrawlerQue: !GetAtt S3CrawlerQue.Arn
              RolePrefix: !Ref RolePrefix
              BucketPrefix:  !Ref DestinationBucket
              DeployRegions:
                Fn::If:
                  - ComputeOptimizerRegionsIsEmpty
                  - !Sub "${AWS::Region}"
                  - !Join [ ",", !Ref ComputeOptimizerRegions ]

* Optional Parameters with current defaults:
DataStackMulti
    - DatabaseName: optimization_data
    - CFDataName: ComputeOptimizer

AccountCollector
    - Suffix: ''
    - Schedule: rate(14 days)

* [Test your Lambda](#testing-your-deployment)                       
{{% notice note %}}
The AccountCollector module is reusable and only needs to be added once but multiple ques can be added too TaskQueuesUrl
{{% /notice %}}

{{% /expand%}}


{{%expand "ECS Chargeback Data" %}}

## ECS Chargeback

This module will enable you too automated report to show costs associated with ECS Tasks leveraging EC2 instances within a Cluster. Instructions on how to use this data can be found [here.](https://github.com/aws-samples/ecs-chargeback-cloudformation) This Data will be partitioned by year, month, day. 

### Pre-Requisites  

* Completion of  Well-Architected Lab: [100_1_aws_account_setup](https://wellarchitectedlabs.com/cost/100_labs/100_1_aws_account_setup/) or similar setup of the Cost and Usage Report (CUR) with resource Id enabled
* A CUR file has been established for the existing Management/Payer account within the Billing Console
* The ECS Cluster leveraging EC2 instances for compute resides in a Linked Account connected to the Management Account through the "Consolidated Billing" option within the Billing Console
* AWS generated tag is active in Cost Allocation Tags **aws:ecs:serviceName**  this will appear in the CUR as resource_tags_aws_ecs_service_Name
* User-defined Cost Allocation Tags **Name** is active
* You will need an S3 bucket in your Analytics account to upload source files into
* Your Tasks **MUST** have the Name of the Service as a tag **Name**. This is best done with [Tag propagation](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-using-tags.html) on service **creation**, see below:

![Images/Example_output.png](/Cost/300_Optimization_Data_Collection/Images/Example_output.png)
	- Note: If you cannot re-create your task using this the see the [source/tag.py](https://github.com/aws-samples/ecs-chargeback-cloudformation/blob/main/source/tag.py)


* IAM Policy added to **OptimizationDataRoleStack** CloudFormation StackSet:  

              - PolicyName: "ECSReadAccess"
                PolicyDocument:
                    Version: "2012-10-17"
                    Statement:
                    - Effect: "Allow"
                    Action: 
                        - "ecs:ListAttributes"
                        - "ecs:DescribeTaskSets"
                        - "ecs:DescribeTaskDefinition"
                        - "ecs:DescribeClusters"
                        - "ecs:ListServices"
                        - "ecs:ListAccountSettings"
                        - "ecs:DescribeCapacityProviders"
                        - "ecs:ListTagsForResource"
                        - "ecs:ListTasks"
                        - "ecs:ListTaskDefinitionFamilies"
                        - "ecs:DescribeServices"
                        - "ecs:ListContainerInstances"
                        - "ecs:DescribeContainerInstances"
                        - "ecs:DescribeTasks"
                        - "ecs:ListTaskDefinitions"
                        - "ecs:ListClusters"
                    Resource: "*"

* CloudFormation Stack added to **OptimizationDataCollectionStack**:  

        ECSStack:
          Type: AWS::CloudFormation::Stack
          Properties:
            TemplateURL: "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/ecs_data.yaml"
            TimeoutInMinutes: 2
            Parameters:
              DestinationBucket: !Ref S3Bucket
              GlueRoleArn: !GetAtt GlueRole.Arn 
              MultiAccountRoleName: !Ref MultiAccountRoleName
              CodeBucket: !Ref CodeBucket
        AccountCollector:
          Type: AWS::CloudFormation::Stack
          Properties:
            TemplateURL: "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/get_accounts.yaml"
            TimeoutInMinutes: 2
            Parameters:
              RoleARN: !Sub "arn:aws:iam::${ManagementAccountID}:role/${ManagementAccountRole}"
              TaskQueuesUrl: !Sub "${ECSStack.Outputs.SQSUrl}"

* Optional Parameters with current defaults:
DataStackMulti
    - DatabaseName: optimization_data
    - CodeKey:  Cost/Labs/300_Optimization_Data_Collection/ecs.zip
    - CFDataName: ecs-services-clusters
    - CURTable: managementcur

AccountCollector
    - Suffix: ''
    - Schedule: rate(14 days)


* [Test your Lambda](#testing-your-deployment) 



{{% /expand%}}


{{%expand "RDS Utilization Data" %}}

## RDS Utilization
The module will collect RDS CloudWatch metrics from your accounts. Using this data you can identify possible underutilized instances. You can use the saved Athena query as a view to query these results and track your recommendations.
This is partitioned by TBC. 

* IAM Policy added to **OptimizationDataRoleStack** CloudFormation StackSet:  

                  - PolicyName: "RDSUtilReadOnlyPolicy"
                    PolicyDocument:
                      Version: "2012-10-17"
                      Statement:
                          - Effect: "Allow"
                            Action:
                            - "rds:DescribeDBProxyTargetGroups"
                            - "rds:DescribeDBInstanceAutomatedBackups"
                            - "rds:DescribeDBEngineVersions"
                            - "rds:DescribeDBSubnetGroups"
                            - "rds:DescribeGlobalClusters"
                            - "rds:DescribeExportTasks"
                            - "rds:DescribePendingMaintenanceActions"
                            - "rds:DescribeEngineDefaultParameters"
                            - "rds:DescribeDBParameterGroups"
                            - "rds:DescribeDBClusterBacktracks"
                            - "rds:DescribeCustomAvailabilityZones"
                            - "rds:DescribeReservedDBInstancesOfferings"
                            - "rds:DescribeDBProxyTargets"
                            - "rds:DownloadDBLogFilePortion"
                            - "rds:DescribeDBInstances"
                            - "rds:DescribeSourceRegions"
                            - "rds:DescribeEngineDefaultClusterParameters"
                            - "rds:DescribeInstallationMedia"
                            - "rds:DescribeDBProxies"
                            - "rds:DescribeDBParameters"
                            - "rds:DescribeEventCategories"
                            - "rds:DescribeDBProxyEndpoints"
                            - "rds:DescribeEvents"
                            - "rds:DescribeDBClusterSnapshotAttributes"
                            - "rds:DescribeDBClusterParameters"
                            - "rds:DescribeEventSubscriptions"
                            - "rds:DescribeDBSnapshots"
                            - "rds:DescribeDBLogFiles"
                            - "rds:DescribeDBSecurityGroups"
                            - "rds:DescribeDBSnapshotAttributes"
                            - "rds:DescribeReservedDBInstances"
                            - "rds:ListTagsForResource"
                            - "rds:DescribeValidDBInstanceModifications"
                            - "rds:DescribeDBClusterSnapshots"
                            - "rds:DescribeOrderableDBInstanceOptions"
                            - "rds:DescribeOptionGroupOptions"
                            - "rds:DescribeDBClusterEndpoints"
                            - "rds:DescribeCertificates"
                            - "rds:DescribeDBClusters"
                            - "rds:DescribeAccountAttributes"
                            - "rds:DescribeOptionGroups"
                            - "rds:DescribeDBClusterParameterGroups"
                            - "ec2:DescribeRegions"
                            Resource: "*"

* CloudFormation Stack added to **OptimizationDataCollectionStack**:  

        RDSMetricsStack:
          Type: AWS::CloudFormation::Stack
          Properties:
            TemplateURL: "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/rds_util_template.yaml"
            TimeoutInMinutes: 2
            Parameters:
              DestinationBucket: !Ref S3Bucket
              DestinationBucketARN: !GetAtt S3Bucket.Arn 
              GlueRoleArn: !GetAtt GlueRole.Arn 
              MultiAccountRoleName: !Ref MultiAccountRoleName

* Optional Parameters with current defaults:
DataStackMulti
    - DatabaseName: optimization_data
    - CFDataName: RDSMETRICS
    - DAYS: 1


* [Test your Lambda](#testing-your-deployment) 


{{% /expand%}}


{{%expand "AWS Organization Data Export" %}}

## AWS Organization Data
This module will extract the data from AWS Organizations, such as account ID, account name, organization parent and all tags. This data can be connected to your AWS Cost & Usage Report to enrich it or other modules in this lab. It is not partitioned. 

* CloudFormation added to **OptimizationDataCollectionStack**:  

          OrganizationData:
            Type: AWS::CloudFormation::Stack
            Properties:
              TemplateURL:  "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/organization_data.yaml"
              TimeoutInMinutes: 2
              Parameters:
                DestinationBucket: !Ref S3Bucket
                GlueRoleARN: !GetAtt GlueRole.Arn
                ManagementAccountRole: !Sub "arn:aws:iam::${ManagementAccountID}:role/${ManagementAccountRole}"
                Tags: "Env"

* Optional Parameters:
    - Suffix: ''
    - Schedule: rate(14 days)

* [Test your Lambda](#testing-your-deployment) 
{{% /expand%}}

{{%expand "AWS Budgets Export" %}}
## AWS Budgets

AWS Budgets allows you to set custom budgets to track your cost and usage from the simplest to the most complex use cases. This module will export the data from all budgets so you can group together reports and combine with dashboards. This Data will be separated by type service and partitioned by year, month. This also has a saved query to create a view. 

            BudgetsModule:
                Type: AWS::CloudFormation::Stack
                Condition: DeployBudgetsModule
                Properties:
                  Parameters:
                      DestinationBucket: !Ref S3Bucket
                      DestinationBucketARN: !GetAtt S3Bucket.Arn 
                      ManagementAccountID: !Ref ManagementAccountID
                      RoleName: !Sub "arn:aws:iam::${ManagementAccountID}:role/${ManagementAccountRole}"
                  TemplateURL: "https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/Budgets.yaml"

* [Test your Lambda](#testing-your-deployment) 
{{% /expand%}}
## Testing your deployment 

Once you have deployed your modules you will be able to test your Lambda function to get your first set of data in Amazon S3. 

1. Depending on the module which you would like to test the following Lambda functions should be triggered:
- **Inventory Collector** module -> **AWS-Organization-Account-Collector** Lambda function
- **Trusted Advisor** module -> **AWS-Organization-Account-Collector** Lambda function
- **ECS Chargeback Data** module -> **AWS-Organization-Account-Collector** Lambda function
- **RDS Utilization Data module** module -> **AWS-Organization-Account-Collector** Lambda function
- **AWS Budgets Export module** module -> **AWS-Organization-Account-Collector** Lambda function
- **Cost Explorer Rightsizing Recommendations** module -> **aws-cost-explorer-rightsizing-recommendations-function** Lambda function
- **Compute Optimizer Collector** module -> **ComputeOptimizer-Trigger-Export** Lambda function
- **AWS Organization Data Export** module -> **Lambda_Organization_Data_Collector** Lambda function


2. To test your Lambda function open respective Lambda in AWS Console and click **Test**
![Images/lambda_test_cf.png](/Cost/300_Optimization_Data_Collection/Images/lambda_test_cf.png) 

3. Enter an **Event name** of **Test**, click **Create**:

![Images/Configure_Test.png](/Cost/300_Organization_Data_CUR_Connection/Images/Configure_Test.png)

4.	Click **Test**

5. The function will run, it will take a minute or two given the size of the Organizations files and processing required, then return success. Click **Details** and view the output. 

For **Compute Optimizer Collector** module processing can take up to 30 mins (15 mins for Compute Optimizer to produce exports requested by lambda, and then another 15 mins for the replication from region buckets to the main bucket)

6. Go to the **Athena** service page

![Images/Athena.png](/Cost/300_Organization_Data_CUR_Connection/Images/Athena.png)

7. You will be able to see your data in the **optimization_data** Database

![Images/Optimization_Data_DB.png](/Cost/300_Optimization_Data_Collection/Images/Optimization_Data_DB.png)

8. If your module has a saved query you will be able to see it in the **Saved queries** section. 
![Images/Saved_queries.png](/Cost/300_Optimization_Data_Collection/Images/Saved_queries.png)
Otherwise you can query each table directly by clicking on **Preview Table** button
![Images/athena_query_table.png](/Cost/300_Optimization_Data_Collection/Images/athena_query_table.png)




If you have just deployed all resources into your Management Account please see below.
{{%expand "Deployed just into Management Account" %}}

In some cases we have seen customers who have deployed all CloudFormation into just their Management Account have role access issues. If you have this issue then please do the below, if not please ignore.

To fix this, all you have to do is remove/comment out the assume role parts of the Lambda code. This will be on different lines in each lambda function. 

![Images/assume-role-comment.png](/Cost/300_Optimization_Data_Collection/Images/assume-role-comment.png)

Once this is done you can redeploy.

{{% /expand%}}

{{% notice tip %}}
If you would like to make your own modules then go to the next section to learn more on how they are made!
{{% /notice %}}


Now you have your data in AWS Athena you can use this to identify optimization opportunities using Athena Queries or visualizing data in Amazon QuickSight.


{{< prev_next_button link_prev_url="../2_deploy_additional_roles/" link_next_url="../4_utilize_data/" />}}
