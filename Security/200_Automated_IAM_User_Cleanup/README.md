# Level 200: Automated IAM User Cleanup

## Introduction
This hands-on lab will guide you through the steps to deploy a AWS Lambda function with [AWS Serverless Application Model (SAM)](https://aws.amazon.com/serverless/sam/) to provide regular insights on IAM User/s and AWS Access Key usage within your account.
You will use the [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-reference.html#serverless-sam-cli) to package your deployment. 
Skills learned will help you secure your AWS account in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Goals:
* Identify orphaned IAM Users and AWS Access Keys
* Take action to automatically remove IAM Users and AWS Access Keys no longer needed
* Reduce identity sprawl

## Prerequisites:
* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.  
NOTE: You will be billed for any applicable AWS resources used if you complete this lab.
* Select region with support for AWS Lambda from the list: [AWS Regions and Endpoints](https://docs.aws.amazon.com/general/latest/gr/rande.html).

* [AWS Serverless Application Model (SAM)](https://aws.amazon.com/serverless/sam/)  installed and configured. 
The AWS Serverless Application Model (SAM) is an open-source framework for building serverless applications. 
It provides shorthand syntax to express functions, APIs, databases, and event source mappings. 
With just a few lines per resource, you can define the application you want and model it using YAML. 
During deployment, SAM transforms and expands the SAM syntax into AWS CloudFormation syntax, enabling you to build serverless applications faster.
<BR>

## [Start the Lab!](Lab_Guide.md)


<BR>
<BR>

***

## License
Licensed under the Apache 2.0 and MITnoAttr License. 

Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
