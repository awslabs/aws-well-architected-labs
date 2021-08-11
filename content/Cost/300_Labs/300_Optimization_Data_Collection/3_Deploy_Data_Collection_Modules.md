---
title: "Deploy Data Collection Modules"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Data Modules 
For every module, there are three steps to complete:
1. Grant additional permissions to the IAM roles created by **OptimizationManagementDataRoleStack** or **OptimizationDataCollectionStack** so they can access the relevant data. 
   For our pre-made modules, it will specify which stack will need to be updated. 
1. Update **OptimizationDataCollectionStack** with the module to retrieve the data. 
1. Test the deployed Lambda function to confirm it is working as expected

{{% notice tip %}}
These modules templates are managed in AWS owned buckets. If you do not wish to have updates on them from AWS then please save a copy to a bucket in your account and use instead. 
{{% /notice %}}


{{%expand "Cost Explorer Rightsizing Recommendations" %}}

### Cost Explorer Rightsizing Recommendations
This solution will collect rightsizing recommendations from AWS Cost Explorer in your management account. You can use the saved Athena query as a view to query these results and track your recommendations. Find out more about the recommendations [here.](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/ce-rightsizing.html)
This Data will be partitioned by year, month, day. 


* IAM Policy to add to **OptimizationManagementDataRoleStack**:  
  [Link to Instructions](#how-to-update-iam-policies-in-optimizationmanagementdatarolestack)

        - PolicyName: "RightsizeReadOnlyPolicy"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                  - "ce:GetRightsizingRecommendation"
                Resource: "*"

* CloudFormation Stack to add to **OptimizationDataCollectionStack**  
  [Link to Instructions](#how-to-update-optimizationdatacollectionstack) 

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
This module is designed to loop through your AWS Organizations account and collect data that could be used to find optimization data. It has two components, firstly the AWS accounts collector which used the management role built before. This then passes the account id into an SQS queue which then is used as an event in the next component. This section assumes a role into the account the reads the data and places into an Amazon S3 bucket in the Cost Account.  See the **Utilise Data Section** for more information on how to use this data.
This Data will be partitioned by year, month. 

* Three different IAM Policies to add to **OptimizationDataRoleStack** CloudFormation StackSet depending on what you want to ingest:  
  [Link to Instructions](#how-to-update-iam-policies-in-optimizationdatarolestack)


  **Amazon Machine Images**
    
        - PolicyName: "ImageReadOnlyPolicy"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                  - "ec2:DescribeImages"
                Resource: "*"

  **Amazon Elastic Block Store (EBS)**

        - PolicyName: "VolumeReadOnlyPolicy"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                -  "ec2:DescribeVolumeStatus"
                -  "ec2:DescribeVolumes"
                Resource: "*"

  **Amazon EBS snapshots**

        - PolicyName: "SnapshotsReadOnlyPolicy"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                - "ec2:DescribeSnapshots"
                - "ec2:DescribeSnapshotAttribute"
                Resource: "*"
        

* CloudFormation to add to **OptimizationDataCollectionStack**:  
The services you can collect data are below. Use these in the *Prefix* and *CFDataName* parameters:
  - ami
  - ebs
  - snapshot
  - ta

[Link to Instructions](#how-to-update-optimizationdatacollectionstack)

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


* [Test your Lambda](#testing-your-deployment) 

{{% notice note %}}
The AccountCollector module is reusable and only needs to be added once but multiple queues can be added too TaskQueuesUrl
{{% /notice %}}

{{% /expand%}}


{{%expand "Trusted Advisor" %}}

###  Trusted Advisor
This module will retrieve all AWS Trusted Advisor recommendations from all your linked account. See the **Utilise Data Section** for more information on how to use this data.
This Data will be partitioned by year, month, day. 


* IAM Policy to add to **OptimizationDataRoleStack** CloudFormation StackSet:  
  [Link to Instructions](#how-to-update-iam-policies-in-optimizationdatarolestack)

     
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
          


* CloudFormation to add to **OptimizationDataCollectionStack**:  
  [Link to Instructions](#how-to-update-optimizationdatacollectionstack)

        TrustedAdvisor:
          Type: AWS::CloudFormation::Stack
          Properties:
                TemplateURL:  "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/lambda_data.yaml"
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

* [Test your Lambda](#testing-your-deployment) 

{{% notice note %}}
The AccountCollector module is reusable and only needs to be added once but multiple queues can be added too TaskQueuesUrl
{{% /notice %}}

{{% /expand%}}


{{%expand "Compute Optimizer Collector" %}}

## Compute Optimizer Collector

The Compute Optimizer Service only shows current point in time recommendations looking at the past 14 days of usage.
In this module, the data will be collected together so you will access to all accounts recommendations in one place. This can be accessed through the Management Account. You can use the saved Athena query as a view to query these results and track your recommendations.
This Data will be separated by type service and partitioned by year, month. 


* IAM Policy to add to *OptimizationManagementDataRoleStack*:  
  [Link to Instructions](#how-to-update-iam-policies-in-optimizationmanagementdatarolestack)


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

* CloudFormation to add to *OptimizationDataCollectionStack* :  
  [Link to Instructions](#how-to-update-optimizationdatacollectionstack)

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

* [Test your Lambda](#testing-your-deployment)                       
{{% notice note %}}
The AccountCollector module is reusable and only needs to be added once but multiple ques can be added too TaskQueuesUrl
{{% /notice %}}

{{% /expand%}}


{{%expand "ECS Chargeback Data" %}}

## ECS Chargeback

This will enable you too automated report to show costs associated with ECS Tasks leveraging EC2 instances within a Cluster. Instructions on how to use this data can be found [here.](https://github.com/aws-samples/ecs-chargeback-cloudformation) This Data will be partitioned by year, month, day. 


* IAM Policy to add to **OptimizationDataRoleStack** CloudFormation StackSet:  
  [Link to Instructions](#how-to-update-iam-policies-in-optimizationdatarolestack)


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

* CloudFormation to add to **OptimizationDataCollectionStack**:  
  [Link to Instructions](#how-to-update-optimizationdatacollectionstack)

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
* [Test your Lambda](#testing-your-deployment) 



{{% /expand%}}


{{%expand "RDS Utilization Data" %}}

## RDS Utilization
The module will collect RDS Cloudwatch metrics from your accounts. Using this data you can identify possible underutilized instances. You can use the saved Athena query as a view to query these results and track your recommendations.
This is partitioned by TBC. 

* IAM Policy to add to **OptimizationDataRoleStack** CloudFormation StackSet:  
  [Link to Instructions](#how-to-update-iam-policies-in-optimizationdatarolestack)


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

* CloudFormation to add to **OptimizationDataCollectionStack**:  
  [Link to Instructions](#how-to-update-optimizationdatacollectionstack)

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

* [Test your Lambda](#testing-your-deployment) 


{{% /expand%}}

## How to Update your CloudFormation

To add your selected modules from above please follow the steps specified in the module section. 

### How to Update OptimizationDataCollectionStack
1. Login via SSO in your Cost Optimization account and search for **CloudFormation**.
![Images/cloudformation.png](/Cost/300_Organization_Data_CUR_Connection/Images/cloudformation.png)

2. In your Cost Account under CloudFormation select your **OptimizationDataCollectionStack** 

3. Click **Update** 
![Images/Update_CF.png](/Cost/300_Optimization_Data_Collection/Images/Update_CF.png)

4. Choose **Edit template in designer** then click **View in Designer**
![Images/update_in_designer.png](/Cost/300_Optimization_Data_Collection/Images/update_in_designer.png) 

5. In the template box copy your module code and past at the bottom of the template. When using Designer we recommend deleting the first space of the first line of the module. This will help with formatting the code all in the same style. Then **Click** the upload button on the top left hand corner.  

![Images/designer_view.png](/Cost/300_Optimization_Data_Collection/Images/designer_view.png) 

6. This will take you back to the upload section. Click **Next** and follow the same process you did on the initial setup. 
![Images/Update_stack.png](/Cost/300_Optimization_Data_Collection/Images/Update_stack.png) 



### How to Update IAM Policies in OptimizationManagementDataRoleStack
The IAM Roles created in the previous section need to be updated with the relevant permissions.

Depending on the module, you will need to add the permissions to either the management role or the role created in the stack set. In the pre-made modules this will be specified.

These instructions are for updating the roles in **OptimizationManagementDataRoleStack**. This stack is
deployed in the management account.

1. Login via SSO in your Management account and search for **CloudFormation**
   ![Images/cloudformation.png](/Cost/300_Organization_Data_CUR_Connection/Images/cloudformation.png)

2. Select the **OptimizationManagementDataRoleStack** and click **Update**  
![Images/Update_man_role.png](/Cost/300_Optimization_Data_Collection/Images/Update_man_role.png)  
   
3. Select **Edit template in designer** then **View in Designer**  
![Images/Edit_template_man_role.png](/Cost/300_Optimization_Data_Collection/Images/Edit_template_man_role.png)  

4. Copy the IAM permission code from the module section above. In Designer in the template section paste the code at the bottom.
   Click the Upload button in the top corner.  
![Images/Update_man_role_design.png](/Cost/300_Optimization_Data_Collection/Images/Update_man_role_design.png)  

5. Click Next and keep everything to default till deployed




### How to Update IAM Policies in OptimizationDataRoleStack
The IAM Roles created in the previous section stack set need to be updated with the relevant permission.

Depending on the module, you will need to add the permissions to either the management role or the
role created in the stack set. In the pre-made modules this will be specified.

These instructions are for updating the roles in **OptimizationDataRoleStack**. This stack is
deployed in each of the linked accounts.

1. Copy the IAM permission code from the module section above. Using the file you downloaded in the **Role for Read Only Data Collector** step (called optimisation_read_only_role.yaml), paste the additional policy at the bottom and save. 

2. Login via SSO in your Management account and search for **CloudFormation**
   ![Images/cloudformation.png](/Cost/300_Organization_Data_CUR_Connection/Images/cloudformation.png)

3. Copy the IAM permission code from the module section above. In your local copy of the optimisation_read_only_role.yaml file add it to the bottom. 

4. In CloudFormation click on the hamburger icon on the side panel on the left hand side of the screen and select **StackSets**. 

5. Select the **OptimizationDataRoleStack**. Click Actions, Edit StackSet Details
![Images/Update_SS.png](/Cost/300_Optimization_Data_Collection/Images/Update_SS.png)  

6. Select **Replace current template**, **Upload a template file** then **Choose file** with you local copy of the optimisation_read_only_role.yaml file
![Images/Update_SS_File.png](/Cost/300_Optimization_Data_Collection/Images/Update_SS_File.png)  

7. Click Next and keep everything to default till deployed



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


Now you have your data in AWS Athena you can use this to identify optimization opportunities using Athena Queries or Passing into Amazon Quicksight.


{{< prev_next_button link_prev_url="../2_deploy_additional_roles/" link_next_url="../4_create_custom_data_collection_module/" />}}
