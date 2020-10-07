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

{{< prev_next_button link_prev_url="../5_add_ec2/" title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment, you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with [REL 8  How do you implement change?](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-change-management.html)
{{< /prev_next_button >}}