---
title: "Deploying the infrastructure"
menutitle: "Deploy Infrastructure"
date: 2020-11-19T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
tags:
 - Windows Server
 - Windows
 - EC2
 - CloudWatch
 - CloudWatch Dashboard
---

{{% notice warning %}}
The CloudFormation template that accompanies this lab requires the ability to create IAM Roles and IAM Instance Profiles.  If the account you are using does not have these capabilities, you will not be able to complete this lab.
{{% /notice %}}


## Deploy VPC
{{% common/Create_VPC_Stack stackname="PerfLab-VPC" %}}

1. When the stack status is _CREATE_COMPLETE_, you can continue to the next step.

{{< prev_next_button link_prev_url="../" link_next_url="../2_deploy_instance/" />}}
