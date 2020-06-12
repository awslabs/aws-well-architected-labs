---
title: "Configure Deployed Resources using Parameters"
menutitle: "Use Parameters"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

In this task, you will gain experience changing CloudFormation stack parameters and updating your CloudFormation stack

* Your objective is to deploy additional resources used by the VPC to enable connection to the internet

### 2.1 Update Parameters

1. Go to the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation) (if not already there)
1. Click on **Stacks**
1. Click on the **CloudFormationLab** stack
1. Click **Update**
1. Leave **Use current template** selected. You have not yet changed the template
1. Click **Next**
1. On the **Specify stack details** screen you now have the opportunity to change the **Parameters**
    * Change **PublicEnabledParam** to `true`
1. Click **Next**
1. Click **Next** again, until you arrive at the **Review CloudFormationLab** screen
    1. Scroll down to **Change set preview** and note several resources are being added
    1. At the bottom of the page, select **I acknowledge that AWS CloudFormation might create IAM resources with custom names**
    1. Click **Create stack**
1. When stack **status** is _CREATE_COMPLETE_ for your update (about one minute) then continue

## 2.2 Understanding the deployment

* You did not change any contents of the the CloudFormation Template
* Changing only one parameter, you re-deployed the stack which resulted in additional resources deployed

1. Go to the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation) (if not already there)
1. Click the **Resources** tab for the **CloudFormationLab** stack.
      * The listing now shows the VPC as before, plus additional resources required to enable us to deploy resources into the VPC that have access to the internet
      * Click through on several of the **Physical ID** links and explore these resources

The current deployment is now represented by this architecture diagram:
![SimpleVpcPlusPublic](/Reliability/200_Deploy_and_Update_CloudFormation/Images/SimpleVpcPlusPublic.png)
