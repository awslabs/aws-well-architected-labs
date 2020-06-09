---
title: "Deploying the infrastructure"
menutitle: "Deploy"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

{{% notice warning %}}
The CloudFormation template that accompanies this lab requires the ability to create IAM Roles and IAM Instance Profiles.  If the account you are using does not have these capabilities, you will not be able to complete this lab.
{{% /notice %}}


1. Download the [time_test.yaml](/Performance/100_Clock_Source_Performance/Code/time_test.yaml) CloudFormation template to your machine.
1. This lab assumes you will be deploying to the default VPC within your AWS account.  If you wish to deploy to a different VPC, just select the subnet that corresponds to your VPC.

{{% common/CreateNewCloudFormationStack templatename="time_test.yaml" stackname="TimeTest" %}}
    * **Stack Name** – Whatever you want to call the stack for this test
    * **EC2InstanceSubnetId** – The subnet you wish to deploy the 2 EC2 instances into for testing.
    * **KVMNodeInstanceType** – What size KVM Node (which implies it is a Nitro instance) to use for the test
    * **KeyName** – SSH keyname to use for the test (in case you want to ssh into the box to run additional tests)
    * **LatestAmiId** – This will auto-populate with the latest version of the Amazon Linux AMI
    * **XenNodeInstanceType** – Which non-nitro Xen based node to use for the test
{{% /common/CreateNewCloudFormationStack %}}
