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
    * **LambdaStackName** - Name of the Role Stack to reference outputs. This should be the same as the stack you deployed in the second step.
    * **WAWorkloadType** - Example list of Workload types that could be used in your environment. For this lab we only allow these values:
      * APIGWLambda
      * EC2WebApp
      * EKSWebApp
      * ECSWebApp
    * **WAWorkloadDescription** - Description for WA Workload field
    * **WAWorkloadOwner** - Who owns the WA workload
    * **WAEnvironment** - The environment in which your workload runs. You must select either PRODUCTION or PREPRODUCTION
    * **APIGWName** - Name for the API Gateway
    * **apiGatewayStageName** - The stage name for the API Gateway
    * **APIGWHTTPMethod** - The method type for the deployed API
    * **SampleLambdaFunctionName** - The name for the sample lambda function  

{{% /common/CreateNewCloudFormationStack %}}

{{% notice warning %}}
This template will take between **2-5 minutes** to fully deploy.
{{% /notice %}}

## Review CloudFormation Outputs from stack creation
Once deployed, you can click on the Outputs tab and find the various outputs from the Cloudformation. The WAWorkloadId is the WorkloadId from the Well-Architected Tool.

![CFNOutputs](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Images/4/CFNOutputs1.png?classes=lab_picture_auto)

The link next to apiGatewayInvokeURL will show you the sample Lambda function responding via Amazon API Gateway. If you click on the link, it will show your IP address as reported by API Gateway headers as well as a link to the Well-Architected labs website.

![CFNOutputs](/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Images/4/CFNOutputs2.png?classes=lab_picture_auto)
