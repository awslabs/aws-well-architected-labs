---
title: "Deploying an instance"
menutitle: "Deploy Instance"
date: 2020-11-19T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
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


<!-- ## Create EC2 KeyPair -->
<!-- Make sure they have a EC2 KeyPair first, then run the CFN -->
<!-- {{% common/CreateEC2KeyPair keypairname="wapetestlab" region="us-west-2" fileformat="pem" %}} -->

## Deploy CloudFormation Template

1. Download the [WindowsMachineDeploy.yaml](/Performance/100_Monitoring_Windows_EC2_CloudWatch/Code/WindowsMachineDeploy.yaml) CloudFormation template to your machine.


{{% common/CreateNewCloudFormationStack templatename="WindowsMachineDeploy.yaml" stackname="WindowsMachineDeploy" %}}
    * **Stack name** – Use **WindowsMachineDeploy** (case sensitive)

    * **VPCImportName** - The subnet you wish to deploy the EC2 instance into for testing. For this lab, we use a default VPC subnet within the account.
    * **InstanceAMI** – This will auto-populate with the latest version of the Windows 2019 Base AMI
    * **InstanceType** - Instance Type, defaults to t3.large but can use any size supported by Windows in the region you have chosen
    <!-- * **KeyPair** – keyname to use for the test (in case you want to RDP into the box to run additional tests). Select the one you created above or another one if you had a pre-existing keypair from the drop-down. -->
    * **MetricAggregationInterval** - How often should the Windows CloudWatch Agent send data into CloudWatch. No need to change this.
    * **MetricCollectionInterval** - How often should the CloudWatch Agent collect information from the Operating System. No need to change this.
    * **PrimaryNodeLabel** - The additional label assigned to the EC2 instance to use for searching within CloudWatch Explorer
    <!-- * **RDPLocation**  - The IP range of that can connect to this Windows EC2 Instance -->

{{% /common/CreateNewCloudFormationStack %}}

{{% notice warning %}}
This template will take between **10-15 minutes** to fully deploy using a t3.large. A smaller instance size may take longer.
{{% /notice %}}

{{< prev_next_button link_prev_url="../1_deploy_vpc/" link_next_url="../3_creating_cloudwatch_dashboard/" />}}
