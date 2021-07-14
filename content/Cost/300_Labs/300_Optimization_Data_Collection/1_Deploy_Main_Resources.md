---
title: "Deploy core infrastructure for data retrieval"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### Create Reusable Resource

The first step is to create a set of reusable resources that can be passed into the other modules. 


1.  Click [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3-us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/Optimization_Data_Collector.yaml) if you are deploying to your linked account (recommended)

Or if you wish to keep this on your local machine please copy the below and deploy how you would normally:

        AWSTemplateFormatVersion: '2010-09-09'
        Description: Main CF template that builds shared resources and other stacks
        Parameters:
            DestinationBucket:
                Type: String
                Description: Name of the S3 Bucket that needs to be created to hold information
                AllowedPattern: (?=^.{3,63}$)(?!^(\d+\.)+\d+$)(^(([a-z0-9]|[a-z0-9][a-z0-9\-]*[a-z0-9])\.)*([a-z0-9]|[a-z0-9][a-z0-9\-]*[a-z0-9])$)
                Default: costoptimizationdatacollectionbucket
            ManagementAccountRole: 
                Type: String
                Description: This will be the name of the IAM role that will be deployed in the management account which can retrieve AWS Org data. This is deployed in the next step
                Default: Lambda-Assume-Role-Management-Account
            ManagementAccountID: 
                Type: String
                Description: Your Management Account ID
            MultiAccountRoleName:
                Type: String
                Description: This will be the name of the IAM role that will be deployed from the management account to linked accounts as a read only role
                Default: "Optimization-data-Multi-Account-Role"
            CodeBucket:
                Type: String
                Description: An AWS owned S3 Bucket that exists and holds code for the modules. Please choose from the list below depending on your region. The Default is in Oregon
                AllowedValues:
                - aws-well-architected-labs-ireland
                - aws-well-architected-labs
                - aws-well-architected-labs-ohio
                - aws-well-architected-labs-virginia
        Outputs:
            S3Bucket:
                Description: Name of S3 Bucket which will store the AWS Cost Explorer Rightsizing recommendations
                Value:
                Ref: S3Bucket
            S3BucketARN:
                Description: ARN of S3 Bucket which will store the AWS Cost Explorer Rightsizing recommendations
                Value:
                Fn::GetAtt:
                    - S3Bucket
                    - Arn 
        #Reusable Resources:
        Resources:
            S3Bucket:
                Type: 'AWS::S3::Bucket'
                Properties:
                BucketName:
                    !Sub "${DestinationBucket}${AWS::AccountId}"
                VersioningConfiguration:
                    Status: Enabled
                BucketEncryption:
                    ServerSideEncryptionConfiguration:
                    - ServerSideEncryptionByDefault:
                        SSEAlgorithm: AES256
            GlueRole:
                Type: AWS::IAM::Role
                Properties:
                RoleName: AWS-OPTICS-Glue-Crawler
                AssumeRolePolicyDocument:
                    Statement:
                    - Action:
                        - sts:AssumeRole
                        Effect: Allow
                        Principal:
                        Service:
                            - glue.amazonaws.com
                    Version: 2012-10-17
                ManagedPolicyArns:
                    - arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole
                Path: /
                Policies:
                    - PolicyName: "Put-S3"
                    PolicyDocument:
                        Version: "2012-10-17"
                        Statement:
                        - Effect: "Allow"
                            Action:
                            - "s3:PutObject"
                            - "s3:GetObject"
                            Resource: !Join
                                    - ''
                                    - - !GetAtt S3Bucket.Arn 
                                        - '*'
{{% notice note %}}
For the CodeBucket Parameter, if deploying in Oregon leave as CodeBucket: aws-well-architected-labs
{{% /notice %}}

2. Click **Next**.
![Images/upload_templates3.png](/Cost/300_Optimization_Data_Collection/Images/upload_templates3.png)

3. Call the stack **OptimizationDataCollectionStack** and fill in the parameters with the information described. The Role mentioned will be deployed in the next step. Click **Next** and **Next again**
![Images/Main_CF_Parameters.png](/Cost/300_Optimization_Data_Collection/Images/Main_CF_Parameters.png)

4. Tick the box **'I acknowledge that AWS CloudFormation might create IAM resources with custom names.'** and click **Create stack**.
![Images/Tick_Box.png](/Cost/300_Optimization_Data_Collection/Images/Tick_Box.png)

5. Wait till your CloudFormation has status as **CREATE_COMPLETE**.
![Images/Main_CF_Deployed.png](/Cost/300_Optimization_Data_Collection/Images/Main_CF_Deployed.png)
   
{{% notice note %}}
We will edit this template in designer in the AWS Console. If you wish to keep a version locally then download and manage how you would normally. 
{{% /notice %}}


{{< prev_next_button link_prev_url="../" link_next_url="../2_Additional_Roles/" />}}