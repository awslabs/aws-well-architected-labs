---
title: "Teardown"
date: 2021-08-31T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

The following instructions will remove the resources that you have created in this lab.

#### Cleaning up the CloudFormation Stack

1.  Sign in to the AWS Management Console and navigate to the AWS CloudFormation console - <https://console.aws.amazon.com/cloudformation/>
1.  Select the stack `WA-risk-management`, and delete the stack.

#### Cleaning up Lambda functions

1. Sign in to the AWS Management Console and navigate to the AWS CloudFormation console - <https://console.aws.amazon.com/lambda/>
1. Select the `wa-risk-tracking` function, click on **Actions** and **Delete**.
1. Select the `wa-update-workload` function, click on **Actions** and **Delete**.

#### Cleaning up OpsItems

Depending on the number of workloads defined and documented in the AWS WA Tool and the number of best practices missing in each workload, the walkthrough of the solution in this lab could potentially create a large number of OpsItems. You can set the status of the OpsItems to **Resolved** manually from the console, or you can use [this Python script](/watool/200_Manage_Workload_Risks_with_OpsCenter/Code/clear_OpsItems.py) that uses Boto3 to set the status of all OpsItems with the source of **Well-Architected** to **Resolved**.

To use the cleanup script, make sure you have Python 3 and the [AWS SDK for Python (Boto3)](https://aws.amazon.com/sdk-for-python/) installed. The environment must also be [configured with AWS credentials](https://boto3.amazonaws.com/v1/documentation/api/latest/guide/credentials.html) to make API calls to Systems Manager. The script requires one argument - the AWS Region used to walk through this lab.

```
python3 clear_OpsItems.py us-east-1
```

**NOTE:** In the command above, replace **us-east-1** with the AWS Region you used for this lab.

### Thank you for using this lab.
