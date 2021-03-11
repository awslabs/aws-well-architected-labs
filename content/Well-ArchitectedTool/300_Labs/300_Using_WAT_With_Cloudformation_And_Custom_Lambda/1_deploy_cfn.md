---
title: "Deploying the infrastructure"
menutitle: "Deploy Infrastructure"
date: 2020-03-08T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

{{% notice warning %}}
The CloudFormation template that accompanies this lab requires the ability to create IAM Roles and AWS Lambda functions.  If the account you are using does not have these capabilities, you will not be able to complete this lab.
{{% /notice %}}


## Deploy CloudFormation Template

1. Download the [DeployWACustomLambda.yaml](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Code/CFN/DeployWACustomLambda.yaml) CloudFormation template to your machine.
1. For this lab, you will need to use **us-east-2**  


{{% common/CreateNewCloudFormationStack templatename="DeployWACustomLambda.yaml" stackname="WALambdaHelpers" SAMDeploy="TRUE"%}}
    * **None of these parameters need to be changed, but are available if you wish to try different settings**
    * **CreateWALambdaFunctionName** - The name for the new CreateWA lambda function.
    * **UpdateWAQLambdaFunctionName** - The name for the new UpdateWA lambda function.
    * **LambdaFunctionsBucket** – S3 Bucket name that holds the [WAToolCFNAPILambda.zip](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Code/WAToolCFNAPILambda.zip) file
    * **WAToolCFNAPIKey** - The filename for the Lambda file, [WAToolCFNAPILambda.zip](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Code/WAToolCFNAPILambda.zip)

{{% /common/CreateNewCloudFormationStack %}}

{{% notice warning %}}
This template will take between **1-5 minutes** to fully deploy.
{{% /notice %}}

{{< prev_next_button link_prev_url="../" link_next_url="../2_explore_lambda_code/" />}}
