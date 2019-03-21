# Level 100: CloudFront with S3 Bucket Origin

## Introduction
This hands-on lab will guide you through the steps to host static web content in an [Amazon S3 bucket](https://aws.amazon.com/s3/), protected and accelerated by [Amazon CloudFront](https://aws.amazon.com/cloudfront). Skills learned will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).  

![s3-cloudfront-diagram](Images/s3-cloudfront-diagram.png)

## Goals:
* Protecting S3 bucket from direct public access
* Improving access time with caching


## Prerequisites:
* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.  
NOTE: You will be billed for any applicable AWS resources used if you complete this lab.

## Overview
* **[Lab Guide.md](Lab%20Guide.md) the guide for this lab**
* [/Images](Images/) referenced by this lab

## Permissions required
* IAM User with *AdministratorAccess* AWS managed policy

***

## License
Licensed under the Apache 2.0 and MITnoAttr License. 

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
