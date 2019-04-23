# Quest: Loft - Introduction to Security

## About this Guide
This quest is the guide for an [AWS Loft](https://aws.amazon.com/start-ups/loft/) Well-Architected Security introduction workshop. You can check your local loft schedule for upcoming Well-Architected events, or you can also run it on your own! The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Prerequisites:
* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.  
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).

***

## Step 1 - New AWS Account Setup and Securing Root User 

### Walkthrough
This hands-on lab will guide you through the introductory steps to configure a new AWS account and secure the root user.
[AWS Account and Root User](../100_AWS_Account_and_Root_User)  
### Further Considerations
* Federate Identity Using SAML: [Leveraging a SAML provider](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_enable-console-saml.html)
* Separate production, non-production and different workloads using different AWS accounts: [AWS Multiple Account Billing Strategy](https://aws.amazon.com/answers/account-management/aws-multi-account-billing-strategy/)

## Step 2 - Basic Identity and Access Management User, Group, Role
This hands-on lab will guide you through the introductory steps to configure AWS Identity and Access Management (IAM).  
You will use the AWS Management Console to guide you through how to configure your first IAM user, group and role for administrative access.
### Walkthrough
[Basic Identity and Access Management User, Group, Role](../100_Basic_Identity_and_Access_Management_User_Group_Role)  

## Step 3 -  CloudFront with WAF Protection
This hands-on lab will guide you through the steps to protect a workload from network based attacks using Amazon CloudFront and AWS Web Application Firewall (WAF).
You will use the AWS Management Console and AWS CloudFormation to guide you through how to deploy CloudFront with WAF integration to apply defense in depth methods.  
As CloudFront takes some time to update configuration in all edge locations, consider starting step 4 while its deploying.
### Walkthrough
[CloudFront with WAF Protection](../200_CloudFront_with_WAF_Protection)  

## Step 4 - Automated Deployment of Detective Controls
This hands-on lab will guide you through how to use AWS CloudFormation to automatically configure detective controls including AWS CloudTrail and Amazon GuardDuty.
You will use the AWS Management Console and AWS CloudFormation to guide you through how to automate the configuration of AWS CloudTrail.  
### Walkthrough
Only complete step 2, GuardDuty from: [Automated Deployment of Detective Controls](../200_Automated_Deployment_of_Detective_Controls)  

***

## License
Licensed under the Apache 2.0 and MITnoAttr License. 

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
