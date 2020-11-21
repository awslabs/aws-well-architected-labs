---
title: "Deploying the infrastructure"
menutitle: "Deploy"
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

## Create EC2 KeyPair
<!-- Make sure they have a EC2 KeyPair first, then run the CFN -->
1. Login to your AWS Console
{{% common/CreateEC2KeyPair keypairname="wapetestlab" region="us-west-2" fileformat="pem" %}}

## Deploy CloudFormation Template

1. Download the [WindowsMachineDeploy.yaml](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Code/WindowsMachineDeploy.yaml) CloudFormation template to your machine.
1. This lab assumes you will be deploying to the default VPC within your AWS account.  If you wish to deploy to a different VPC, just select the subnet that corresponds to your VPC. {{% notice warning %}}
If you have modified the default VPC or are using a VPC you have created, ensure that the subnet you are deploying the EC2 instances into can communicate with the internet and with AWS Systems Manager. One method for this is to [Create a VPC endpoint for SSM](https://docs.aws.amazon.com/systems-manager/latest/userguide/setup-create-vpc.html)
{{% /notice %}}


{{% common/CreateNewCloudFormationStack templatename="WindowsMachineDeploy.yaml" stackname="WindowsMachineDeploy" %}}
    * **Stack Name** – Whatever you want to call the stack. For this test we used WindowsMachineDeploy

    * **DeploySubnet** - The subnet you wish to deploy the EC2 instance into for testing. For this lab, we use a default VPC subnet within the account.
    * **DeployVPC** - The VPC you wish to deploy the EC2 instance into for testing. For this lab, we use the default VPC within the account.
    * **InstanceAMI** – This will auto-populate with the latest version of the Windows 2019 Base AMI
    * **InstanceType** - Instance Type, defaults to t3.large but can use any size supported by Windows in the region you have chosen
    * **KeyPair** – keyname to use for the test (in case you want to RDP into the box to run additional tests). Select the one you created above or another one if you had a pre-existing keypair from the drop-down.
    * **MetricAggregationInterval** - How often should the Windows CloudWatch Agent send data into CloudWatch. No need to change this.
    * **MetricCollectionInterval** - How often should the CloudWatch Agent collect information from the Operating System. No need to change this.
    * **PrimaryNodeLabel** - The additional label assigned to the EC2 instance to use for searching within CloudWatch Explorer
    * **RDPLocation**  - The IP range of that can connect to this Windows EC2 Instance

{{% /common/CreateNewCloudFormationStack %}}

{{% notice warning %}}
This template will take between **10-15 minutes** to fully deploy using a t3.large. A smaller instance size may take longer.
{{% /notice %}}

{{< prev_next_button link_prev_url="../" link_next_url="../2_creating_cloudwatch_dashboard/" />}}
