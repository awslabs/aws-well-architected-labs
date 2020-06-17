---
title: "Tear down this lab"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---
{{% common/EventEngineVsOwnAccountCleanup %}}

#### How to delete an AWS CloudFormation stack

If you are already familiar with how to delete an AWS CloudFormation stack, then skip to the next section: **Delete workshop CloudFormation stacks**

{{% common/DeleteCloudFormationStack %}}

#### Delete workshop CloudFormation stacks

1. First delete the **CloudFormationLab** CloudFormation stack
1. Wait for the **CloudFormationLab** CloudFormation stack to complete (it will no longer be shown on the list of actice stacks)
1. Then delete the **WebApp1-VPC** CloudFormation stack

---

## References & useful resources

AWS CloudFormation
* [What is AWS CloudFormation?](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)
* CloudFormation [AWS Resource and Property Types Reference](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-template-resource-type-ref.html)

AWS Resources that enable reliable architectures:
* [What Is Amazon EC2 Auto Scaling?](https://docs.aws.amazon.com/autoscaling/ec2/userguide/what-is-amazon-ec2-auto-scaling.html)
* Elastic Load Balancing: [What Is an Application Load Balancer?](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)
* Availability Zones: AWS [Global Infrastructure](https://aws.amazon.com/about-aws/global-infrastructure/)