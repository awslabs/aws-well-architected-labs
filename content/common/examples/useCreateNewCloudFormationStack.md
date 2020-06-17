---
title: "example implementations for CreateNewCloudFormationStack"
date: 2020-04-24T11:16:08-04:00
hidden: true
disableToc: true
---

<!--
Shows example usage for Shortcode at layouts/shortcodes/common/CreateNewCloudFormationStack.md

https://wellarchitectedlabs.com/common/examples/usecreatenewcloudformationstack/
-->

1. [Case 1 - all parameters left as default ](#case1)
1. [Case 2 - provides directions to update or view one or more parameters](#case2)

## Case 1 - all parameters left as default {#case1}

<!-- The slash at the end (before the percent) is VERY IMPORTANT. If you do not include this, then everything following this is considered part of the 'Inner' variable-->

{{% common/CreateNewCloudFormationStack stackname="CloudFormationLab" templatename="staticwebapp.yaml" /%}}


## Case 2 - provides directions to update or view one or more parameters {#case2}

<!-- This makes use of the 'Inner' variable -->

{{% common/CreateNewCloudFormationStack stackname="WebApp1-VPC" templatename="vpc-alb-app-db.yaml" %}}
    * **EC2InstanceSubnetId** – The subnet you wish to deploy the 2 EC2 instances into for testing.
    * Set the **numberOfAZ** parameter to `3`
    * Leave other parameters as their default values unless you are experimenting.
{{% /common/CreateNewCloudFormationStack %}}

