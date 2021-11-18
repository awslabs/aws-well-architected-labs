---
title: "Teardown"
date: 2020-11-18T11:16:09-04:00
chapter: false
pre: "<b>7. </b>"
weight: 7
---

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

You should skip this step. Your AWS account will be cleaned automatically

**If you are using your own AWS account**:

Please use these steps when you are done with the lab

#### Cleaning up the CloudFormation Stack
The following instructions will remove the resources that you have created in this lab.

1.  Sign in to the AWS Management Console and navigate to the AWS CloudFormation console - <https://console.aws.amazon.com/cloudformation/>
1.  Select the stack `Shuffle-sharding-lab`, and click on the **Resources** tab.
1.  Locate the resource with the logical ID `CanaryBucket`. Click on the URL next to it (in the **Physical ID** column).
1.  On the S3 console, empty the bucket of all objects.
1.  Return to the CloudFormation console and delete the `Shuffle-sharding-lab` stack.

{{< prev_next_button link_prev_url="../6_impact_of_failures_shuffle_sharding" link_next_url="../8_resources/" />}}
