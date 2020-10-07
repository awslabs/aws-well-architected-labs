---
title: "Tear down this lab"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

The following instructions will remove the resources that you have created in this lab.

If you deployed the CloudFormation stacks as part of the prerequisites for this lab, then delete these stacks to remove all the AWS resources. If you need help with how to delete CloudFormation stacks then follow these instructions to tear down those resources:
* [Delete the WebApp resources]({{< ref "/Security/200_Labs/200_Automated_Deployment_of_EC2_Web_Application/2_cleanup" >}})
* Wait for this stack deletion to complete
* [Delete the VPC resources]({{< ref "/Security/200_Labs/200_Automated_Deployment_of_VPC/2_cleanup" >}})


Otherwise, there were no additional new resources added as part of this lab.

***

## References & useful resources

[AWS CloudFormation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)  
[Amazon EC2 User Guide for Linux Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)

{{< prev_next_button link_prev_url="../3_failure_injection/" title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment, you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with [REL 12  How do you test reliability?](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}