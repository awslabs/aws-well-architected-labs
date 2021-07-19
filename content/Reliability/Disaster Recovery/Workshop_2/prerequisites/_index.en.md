+++
title = "Pre-requisites"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++

We will be launching the same CloudFormation template in two separate regions - N. Virginia (us-east-1) and N. California (us-west-1). These regions will represent our Primary Region (us-east-1) and our Secondary Region (us-west-2). Once the CloudFormation templates complete successfully, we will configure our static websites hosted in S3 to connect to the API endpoints created from running the CloudFormation template.

## Getting Started

Login to your [**AWS Console**](https://us-east-1.console.aws.amazon.com/console)

{{% notice note %}}
If you are using your own AWS account be aware that you will incur costs for the resources deployed in this workshop. Complete the cleanup steps at the end to minimize those costs.

If you are running this at a group event - please log in via Event Engine. Instructions are provided by the event host.
{{% /notice %}}
