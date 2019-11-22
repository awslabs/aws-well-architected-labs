# Level 300: Automated Athena CUR Query and E-mail Delivery
https://wellarchitectedlabs.com 

## Introduction
This hands-on lab will guide you through deploying an automatic CUR query & E-mail delivery solution using Athena, Lambda, SES and CloudWatch. The Lambda function is triggered by a CloudWatch event, it then runs saved queries in Athena against your CUR file. The queries are grouped into a single report file (xlsx format), and sends report via SES. This solution provides automated reporting to your organization, to both consumers of cloud and financial teams.

![Images/architecture.png](Images/architecture.png)

## Goals
- Provide automated financial reports across your organization


## Prerequisites
- CUR is enabled and delivered into S3, with Athena integration. Recommend to complete [200_4_Cost_and_Usage_Analysis](../../Cost_Fundamentals/200_4_Cost_and_Usage_Analysis/README.md)
- If your account is in the SES sandbox(default), verify your email addresses in SES to assure you can send or receive emails via verified mail addresses: https://docs.aws.amazon.com/ses/latest/DeveloperGuide/verify-email-addresses.html


## Permissions required
- Create IAM policies and roles
- Write and read to/from S3 Buckets 
- Create and modify Lambda functions
- Create, save and execute Athena queries
- Verify e-mail address, send mail in SES


## Costs
- Variable, dependent on the amount of data scanned and report frequency
- Approximately <$5 a month for small to medium accounts


## Time to complete
- The lab should take approximately 15 minutes to complete


<BR>

[![Start the lab](../../../common/images/startthelab.png)](Lab_Guide.md)

<BR>
<BR>

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
