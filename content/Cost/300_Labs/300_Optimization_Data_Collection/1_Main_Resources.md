---
title: "Main Resources"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### Create Reusable Resource

The first step is to create a set of reusable resources that can be passed into the other modules. 


{{%expand "Click here to continue with the CloudFormation  Setup" %}}


1. **Download CloudFormation** by clicking [here](/Cost/300_Optimization_Data_Collection/Code/main.yaml). This will be the foundation of the rest of the lab and will will add to this to build out the modules.
  * You can right-click then choose **Save link as**; or you can right click and copy the link to use with `wget`
Or copy the below:

        AWSTemplateFormatVersion: '2010-09-09'
        Description: Main CF template that builds shared resources and other stacks
        Parameters:
        DestinationBucket:
            Type: String
            Description: Name of the S3 Bucket that needs to be created to hold information
            AllowedPattern: (?=^.{3,63}$)(?!^(\d+\.)+\d+$)(^(([a-z0-9]|[a-z0-9][a-z0-9\-]*[a-z0-9])\.)*([a-z0-9]|[a-z0-9][a-z0-9\-]*[a-z0-9])$)
            Default: optimizationdatacollectionbucket
        ManagementAccountRole: 
            Type: String
            Description: This will be the name of the IAM role that will be deployed in the management account which can retrieve AWS Org data. This is deployed in the next step
            Default: Lambda-Assume-Role-Management-Account
        ManagementAccountID: 
            Type: String
            Description: Your Management Account ID
        Resources:
        #Reusable Resources:
        S3Bucket:
            Type: 'AWS::S3::Bucket'
            Properties:
            BucketName:
            !Sub "${DestinationBucket}${AWS::AccountId}"
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


2. Login via SSO in your Cost Optimization account and search for **Cloud Formation**.
![Images/cloudformation.png](/Cost/300_Organization_Data_CUR_Connection/Images/cloudformation.png)

3. On the right side of the screen select **Create stack** and choose **With new resources (standard)**
![Images/create_stack.png](/Cost/300_Organization_Data_CUR_Connection/Images/create_stack.png)

4. Choose **Template is ready** and **Upload a template file** and upload the main.yaml file you downloaded from above. Click **Next**.
![Images/upload_template.png](/Cost/300_Organization_Data_CUR_Connection/Images/upload_template.png)

5. Call the stack **OptimizationDataCollectionStack** and fill in the parameters with the information described. The Role mentioned will be deployed in the next step. Click **Next** and **Next again**
![Images/Main_CF_Parameters.png](/Cost/300_Optimization_Data_Collection/Images/Main_CF_Parameters.png)

6. Tick the box **'I acknowledge that AWS CloudFormation might create IAM resources with custom names.'** and click **Create stack**.
![Images/Tick_Box.png](/Cost/300_Optimization_Data_Collection/Images/Tick_Box.png)

7. Wait till your CloudFormation has status as **CREATE_COMPLETE**.
![Images/Main_CF_Deployed.png](/Cost/300_Optimization_Data_Collection/Images/Main_CF_Deployed.png)
   
{{% notice note %}}
You have successfully setup the main CloudFormation specific steps. You can deploy through the CLI using the below command or through the [console](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/GettingStarted.html) aws cloudformation crate-stack --stack-name OptimizationDataCollectionStack --template-body file://main.yaml --capabilities CAPABILITY_NAMED_IAM --parameters file://parameter.json
{{% /notice %}}


{{% /expand%}}


{{< prev_next_button link_prev_url="../" link_next_url="../2_Management_Account/" />}}