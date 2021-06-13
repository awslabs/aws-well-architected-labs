---
title: "Data Collection CloudFormation Modules"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

### How to add
Now that you have you main file you can now start adding modules. The below is an example of adding the the module we made earlier. Further down there are pre made modules you can add in as well. 



1. Open your main file and in the **Resource** section copy and past stacks from below.

2. In your Cost Account under CloudFormation select your **OptimizationDataCollectionStack** and click update stack. 

3. Choose **Template is ready** and **Upload a template file** and upload the updated main.yaml file. Click **Next** and continue through to deployment.

4. If needed add the IAM Policy needed to the Management Role crated in section 2 buy adding a new policy section to the Management CloudFormation. 



## Pre-made modules


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


* Management Policy needed:

        -  "ce:GetRightsizingRecommendation"
{{% /expand%}}



{{%expand "Static Data Collector " %}}
    Parameters:
        MultiAccountRoleName:
        Type: String
        Description: Name of the IAM role deployed in all accounts which can retrieve AWS Data.
    Resource:
        DataStack:
            Type: AWS::CloudFormation::Stack
            Properties:
                TemplateURL:  "https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/300_Optimization_Data_Collection/lambda_data.yaml"
                TimeoutInMinutes: 2
                Parameters:
                    DestinationBucket: !Ref S3Bucket
                    DestinationBucketARN: !GetAtt S3Bucket.Arn 
                    Prefix: "ami"
                    DatabaseName: "Data"
                    CFDataName: "AMI"
                    GlueRoleARN: !GetAtt GlueRole.Arn
                    MultiAccountRoleName: !Ref MultiAccountRoleName

* Multi Account Policy needed:

        -  ""

{{% /expand%}}

{{% notice tip %}}
You have now created your lambda modules you may need access to your Management account to get this information. In the next step we will create this role
{{% /notice %}}


## Tips
* If you are using a resource from another module and passing it in then ...



{{< prev_next_button link_prev_url="../3_Data_Collection_Template/" link_next_url="../5_teardown/" />}}
