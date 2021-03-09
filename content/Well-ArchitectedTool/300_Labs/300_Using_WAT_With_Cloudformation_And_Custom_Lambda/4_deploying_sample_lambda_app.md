---
title: "Deploying Sample Lambda application along with Well-Architected review"
menutitle: "Deploy Sample Application"
date: 2020-03-08T11:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

{{% notice warning %}}
The CloudFormation template that accompanies this lab requires the ability to create IAM Roles and AWS Lambda functions.  If the account you are using does not have these capabilities, you will not be able to complete this lab.
{{% /notice %}}


## Deploy Sample Application CloudFormation Template

1. Download the [SampleLambdaAPIGWDeploy.yaml](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Code/CFN/SampleLambdaAPIGWDeploy.yaml) CloudFormation template to your machine.


{{% common/CreateNewCloudFormationStack templatename="SampleLambdaAPIGWDeploy.yaml" stackname="WALabDemoApp" %}}
    * **None of these parameters need to be changed, but are available if you wish to try different settings**
    * **Stack name** – Use **WALabDemoApp** (case sensitive)

    * **CreateWALambdaFunctionName** -
    * **UpdateWAQLambdaFunctionName** -
    * **LambdaFunctionsBucket** – S3 Bucket name that holds the [WAToolCFNAPILambda.zip](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Code/WAToolCFNAPILambda.zip) file
    * **WAToolCFNAPIKey** - The filename for the Lambda file, [WAToolCFNAPILambda.zip](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Code/WAToolCFNAPILambda.zip)

{{% /common/CreateNewCloudFormationStack %}}

{{% notice warning %}}
This template will take between **2-5 minutes** to fully deploy using a t3.large. A smaller instance size may take longer.
{{% /notice %}}
