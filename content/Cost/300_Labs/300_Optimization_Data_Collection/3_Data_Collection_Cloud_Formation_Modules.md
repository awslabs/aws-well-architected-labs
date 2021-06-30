---
title: "Data Collection CloudFormation Modules"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

### Add Data Collector Modules
Now that you have deployed your template and your additional roles you can now start adding modules. Below there are pre made modules you can add to your template. Each set will have the resources and parameters you need along with policy requirements for the roles you made. 



1. Login via SSO in your Cost Optimization account and search for **Cloud Formation**.
![Images/cloudformation.png](/Cost/300_Organization_Data_CUR_Connection/Images/cloudformation.png)

2. In your Cost Account under CloudFormation select your **OptimizationDataCollectionStack** 

3. Click **Update** 
![Images/Update_CF.png](/Cost/300_Optimization_Data_Collection/Images/Update_CF.png)

4. Choose **Edit template in designer** then click **View in Designer**
![Images/update_in_designer.png](/Cost/300_Optimization_Data_Collection/Images/update_in_designer.png) 

5. In the template box copy your module code and past at the bottom of the template. Then **Click** the upload button on the top left hand corner. 
![Images/designer_view.png](/Cost/300_Optimization_Data_Collection/Images/designer_view.png) 


#### Pre-made modules

{{%expand "RightSize Recommendations" %}}

### RightSize Recommendations
This solution will collect rightsizing recommendations from AWS Cost Explorer in your management account and upload them to an Amazon S3 bucket. You can use the saved Athena query as a view to query these results and track your recommendations. Find out more [here.](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/ce-rightsizing.html)

* Main file module:

        RightsizeStack:
            Type: AWS::CloudFormation::Stack
            Properties:
                Parameters:
                    DestinationBucket: !Ref S3Bucket
                    DestinationBucketARN: !GetAtt S3Bucket.Arn 
                    RoleName: !Sub "arn:aws:iam::${ManagementAccountID}:role/${ManagementAccountRole}"
                TemplateURL: "https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/organization_rightsizing_lambda.yaml"
                TimeoutInMinutes: 5


* Add to Management Role Policy:

        -  "ce:GetRightsizingRecommendation"
{{% /expand%}}



{{%expand "Static Data Collector" %}}

### Static Data Collector
This module is designed to loop through your organizations account and collect data that could be used to find optimization data. It has two components, firstly the AWS accounts collector which used the management role built before. This then passes the account id into an SQS que which then is used as an event in the next component. This section assumes a role into the account the reads the data and places into an S3 bucket and is read into Athena by Glue.  

This relies on a role to be available in all accounts in your organization to read this information. The role will need the below access to get the data
NOTE: ONLY WORKS IN US-WEST-1 ATM

* Multi Account Policy needed to add to optimisation_read_only_role.yaml:


The available resources who's data can be collected are the following:
 * ami
    
        - PolicyName: "ImageReadOnlyPolicy"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                  - "ec2:DescribeImages"
                Resource: "*"

 * ebs

        
        - PolicyName: "VolumeReadOnlyPolicy"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                -  "ec2:DescribeVolumeStatus"
                -  "ec2:DescribeVolumes"
                Resource: "*"

 * snapshot

        - PolicyName: "SnapshotsReadOnlyPolicy"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                - "ec2:DescribeSnapshots"
                - "ec2:DescribeSnapshotAttribute"
                Resource: "*"
        


* ta
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
        


* CloudFormation to add:


        Parameters:
            MultiAccountRoleName:
            Type: String
            Description: Name of the IAM role deployed in all accounts which can retrieve AWS Data.
            Default: OPTICS-Assume-Role-Management-Account


        Resource:
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
            AccountCollector:
                Type: AWS::CloudFormation::Stack
                Properties:
                  TemplateURL: "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/get_accounts.yaml"
                  TimeoutInMinutes: 2
                  Parameters:
                      RoleARN: !Sub "arn:aws:iam::${ManagementAccountID}:role/${ManagementAccountRole}"
                      TaskQueuesUrl: !Sub "${DataStackMulti.Outputs.SQSUrl}"


{{% notice note %}}
The AccountCollector module is reusable and only needs to be added once but multiple ques can be added too TaskQueuesUrl
{{% /notice %}}

{{% /expand%}}


{{%expand "Compute Optimizer Collector" %}}

## Compute Optimizer Collector

The Compute Optimizer Service **Currently this data only lasts** and does not show historical information. In this module the data will be collected and placed into S3 and read by athena so you can view the recommendations over time and have access to all accounts recommendations in one place. This can be accessed through the Management Account. 

* CloudFormation to add:

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
                AccountCollector:
                    Type: AWS::CloudFormation::Stack
                    Properties:
                      TemplateURL: "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/get_accounts.yaml"
                      TimeoutInMinutes: 2
                      Parameters:
                          RoleARN: !Sub "arn:aws:iam::${ManagementAccountID}:role/${ManagementAccountRole}"
                          TaskQueuesUrl: !Sub "${COCDataStack.Outputs.SQSUrl}"
                        

* Add to Management Role Policy:

                - PolicyName: !Sub "Compute Optimizer Policy"
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

{{% notice note %}}
The AccountCollector module is reusable and only needs to be added once but multiple ques can be added too TaskQueuesUrl
{{% /notice %}}
{{% /expand%}}


{{%expand "ECS Chargeback Data" %}}

## ECS Chargeback

* CloudFormation to add:

                ECSStack:
                    Type: AWS::CloudFormation::Stack
                    Properties:
                      TemplateURL: "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/ecs_data.yaml"
                      TimeoutInMinutes: 2
                      Parameters:
                          DestinationBucket: !Ref S3Bucket
                          GlueRoleArn: !GetAtt GlueRole.Arn 
                          MultiAccountRoleName: !Ref MultiAccountRoleName
                AccountCollector:
                    Type: AWS::CloudFormation::Stack
                    Properties:
                      TemplateURL: "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/get_accounts.yaml"
                      TimeoutInMinutes: 2
                      Parameters:
                          RoleARN: !Sub "arn:aws:iam::${ManagementAccountID}:role/${ManagementAccountRole}"
                          TaskQueuesUrl: !Sub "${ECSStack.Outputs.SQSUrl}"

* Multi Account Policy needed to add to optimisation_read_only_role.yaml:

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

{{% /expand%}}

6. This will take you back to the upload section. Click **Next** and follow the same process you did on the initial setup. 
![Images/Update_stack.png](/Cost/300_Optimization_Data_Collection/Images/Update_stack.png) 



### Update Role

1. To add the IAM Policy rule to the IAM Roles created in section 2, then go to your management account.

2. In either your Management.yaml or optimisation_read_only_role.yaml files (depending on the module) copy the permissions and to the Management-Account-permissions section under actions e.g.

        - PolicyName: "Example policy"
          PolicyDocument:
            Version: "2012-10-17"
            Statement:
              - Effect: "Allow"
                Action:
                  - <required actions>
                Resource: "*"




3. In the console follow the same process as above to update your cloudformation stack.



## Testing Lambdas 

Once you have deployed your modules you will be able to test your Lambda function to get your first set of data in Amazon S3. 

1. The updated CloudFormation will crated a Nested stack. By clicking on your stack and selecting **Resources** find your lambda function and click the hyperlink.

2. To test your lambda function click **Test**
![Images/lambda_test_cf.png](/Cost/300_Organization_Data_CUR_Connection/Images/lambda_test_cf.png) 

3. Enter an **Event name** of **Test**, click **Create**:

![Images/Configure_Test.png](/Cost/300_Organization_Data_CUR_Connection/Images/Configure_Test.png)

4.	Click **Test**

5.	The function will run, it will take a minute or two given the size of the Organizations files and processing required, then return success. Click **Details** and view the output. 

6. By going to athena you will be able to see your data in the **Optimization_Data** Database


{{% notice tip %}}
If you would like to make your own modules then go to the next section to learn more on how they are made!
{{% /notice %}}


## Tips
* If you are using a resource from another module and passing it in then ...



{{< prev_next_button link_prev_url="../2_Additional_Roles/" link_next_url="../4_Custom_Data_Collection_Module/" />}}
