---
title: "Tear down this lab"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---
When a CloudFormation stack is deleted, CloudFormation will automatically delete
the resources that it created.

{{% common/EventEngineVsOwnAccountCleanup %}}

### Remove AWS CloudFormation provisioned resources

You will now delete **CloudFormationLab** CloudFormation stack.

#### How to delete an AWS CloudFormation stack

{{% common/DeleteCloudFormationStack %}}

---

## References & useful resources

* [What is AWS CloudFormation?](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)
* CloudFormation [AWS Resource and Property Types Reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html)
