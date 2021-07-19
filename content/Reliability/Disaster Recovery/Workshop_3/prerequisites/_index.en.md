+++
title = "Pre-requisites"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++


We will launch the same CloudFormation template in both the Primary N. Virginia (us-east-1) and Secondary N. California (us-west-1) regions. Once the CloudFormation templates complete successfully, we will configure our static websites to host from Amazon S3 and connect CloudFormation provisioned to the API endpoints.

## Getting Started

Login to the [AWS Console](https://us-east-1.console.aws.amazon.com/console).

{{% notice note %}}
If you are using your own AWS account be aware that you will incur costs for the resources deployed in this workshop. Complete the cleanup steps at the end to minimize those costs.

If you are running this at a group event - please log in via Event Engine. Instructions are provided by the event host.
{{% /notice %}}
