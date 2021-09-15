+++
title = "Pre-requisites"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++


We will launch the same CloudFormation template in both the Primary N. Virginia (us-east-1) and Secondary N. California (us-west-1) regions. After the CloudFormation templates finish executing, we will configure Amazon S3 to host our static websites and utilize the Amazon RDS MySQL cluster.

## Getting Started

Login to the [AWS Console](https://us-east-1.console.aws.amazon.com/console).

{{% notice note %}}
If you are using a personal AWS account, be aware that you will incur costs for the resources deployed in this workshop. Complete the cleanup steps at the end to minimize those costs.

If you are running this at a group event - please log in via Event Engine. The event host will provide the Instructions.
{{% /notice %}}

{{< prev_next_button link_prev_url="../" link_next_url="./primary-region/" />}}
