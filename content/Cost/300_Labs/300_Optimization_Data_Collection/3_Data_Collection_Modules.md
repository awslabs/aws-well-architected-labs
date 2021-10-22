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

The Compute Optimizer Service only shows current point in time recommendations looking at the past 14 days of usage.
In this module, the data will be collected together so you will access to all accounts recommendations in one place. This can be accessed through the Management Account. You can use the saved Athena query as a view to query these results and track your recommendations.
This Data will be separated by type service and partitioned by year, month. 


* IAM Policy added to  **OptimizationManagementDataRoleStack**:  

              - PolicyName: "ComputeOptimizerPolicy"
                PolicyDocument:
                  Version: "2012-10-17"
                  Statement:
                  - Effect: "Allow"
                    Action: 
                      - "compute-optimizer:*"
                      - "EC2:DescribeInstances"
                      - "cloudwatch:GetMetricData"
                      - "autoscaling:DescribeAutoScalingGroups"
                      - "compute-optimizer:UpdateEnrollmentStatus"
                      - "compute-optimizer:GetAutoScalingGroupRecommendations"
                      - "compute-optimizer:GetEC2InstanceRecommendations"
                      - "compute-optimizer:GetEnrollmentStatus"
                      - "compute-optimizer:GetEC2RecommendationProjectedMetrics"
                      - "compute-optimizer:GetRecommendationSummaries"
                      - "organizations:ListAccounts"
                      - "organizations:DescribeOrganization"
                      - "organizations:DescribeAccount"
                      - "lambda:ListFunctions"
                      - "lambda:ListProvisionedConcurrencyConfigs"
                      - "EC2:DescribeVolumes" 
                      Resource: "*"    

* CloudFormation Stack added to **OptimizationDataCollectionStack** :  

        COCDataStack:
          Type: AWS::CloudFormation::Stack
          Properties:
            TemplateURL: "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/compute_optimizer.yaml"
            TimeoutInMinutes: 2
            Parameters:
              DestinationBucketARN: !GetAtt S3Bucket.Arn 
              DestinationBucket: !Ref S3Bucket
              GlueRoleARN: !GetAtt GlueRole.Arn
              RoleNameARN: !Sub "arn:aws:iam::${ManagementAccountID}:role/${ManagementAccountRole}"
              CodeBucket: !Ref CodeBucket
        AccountCollector:
          Type: AWS::CloudFormation::Stack
          Properties:
            TemplateURL: "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/get_accounts.yaml"
            TimeoutInMinutes: 2
            Parameters:
              RoleARN: !Sub "arn:aws:iam::${ManagementAccountID}:role/${ManagementAccountRole}"
              TaskQueuesUrl: !Sub "${COCDataStack.Outputs.SQSUrl}"

* Optional Parameters with current defaults:
DataStackMulti
    - DatabaseName: optimization_data
    - CodeKey:  Cost/Labs/300_Optimization_Data_Collection/coc.zip
    - CFDataName: ComputeOptimizer
    - Prefix: COC

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
This module will extract the data from AWS Organizations, such as account ID, account name, organization parent and specified tags. This data can be connected to your AWS Cost & Usage Report to enrich it or other modules in this lab. In Tags list all the tags from your Organization you would like to include **separated by a comma**.
It is not partitioned.
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


## Testing your deployment 

Once you have deployed your modules you will be able to test your Lambda function to get your first set of data in Amazon S3. 

1. The updated CloudFormation will have created a Nested stack. By clicking on your stack and selecting **Resources** find your lambda function and click the hyperlink.

2. To test your lambda function click **Test**
![Images/lambda_test_cf.png](/Cost/300_Organization_Data_CUR_Connection/Images/lambda_test_cf.png) 

3. Enter an **Event name** of **Test**, click **Create**:

![Images/Configure_Test.png](/Cost/300_Organization_Data_CUR_Connection/Images/Configure_Test.png)

4.	Click **Test**

5. The function will run, it will take a minute or two given the size of the Organizations files and processing required, then return success. Click **Details** and view the output. 

6. Go to the **Athena** service page

![Images/Athena.png](/Cost/300_Organization_Data_CUR_Connection/Images/Athena.png)

7. You will be able to see your data in the **Optimization_Data** Database

![Images/Optimization_Data_DB.png](/Cost/300_Optimization_Data_Collection/Images/Optimization_Data_DB.png)

8. If your module has a saved query you will be able to see it in the **Saved queries** section. 
![Images/Saved_queries.png](/Cost/300_Optimization_Data_Collection/Images/Saved_queries.png)


{{% notice tip %}}
If you would like to make your own modules then go to the next section to learn more on how they are made!
{{% /notice %}}


Now you have your data in AWS Athena you can use this to identify optimization opportunities using Athena Queries or Passing into Amazon QuickSight.


{{< prev_next_button link_prev_url="../2_deploy_additional_roles/" link_next_url="../4_create_custom_data_collection_module/" />}}
