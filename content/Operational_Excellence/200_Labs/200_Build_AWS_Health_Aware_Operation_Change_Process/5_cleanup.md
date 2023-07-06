---
title: "Teardown"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

In this section you will delete all resources related to the lab environment.

### Cleaning up the CloudFormation Resources

1. Click [this link](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1) to go to CloudFormation.

2. Select the **radio button** left to the Stack that's been created (e.g. health-stack-02 in this case), and click the **Delete** button.
![Section5 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section5_delete_cfn.png)

3. Click the **Delete stack** button in the pop-up window.
![Section5 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section5_delete_stack.png)

### Cleaning up the Systems Manager Resources

1. Go to [Change Manager Templates](https://us-east-1.console.aws.amazon.com/systems-manager/change-manager?region=us-east-1#/dashboard/templates), and click on the **wa-ssm-health-aware-lab-template** template.
![Section5 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section5_delete_the_template.png)

2. Click the **Actions** dropdown box, and click the **Delete template** button.
![Section5 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section5_continue_delete_template.png)

3. Input **DELETE** in the pop-up window, and click the **Delete** button.
![Section5 App Arch](/Operations/200_Build_AWS_Health_Aware_Operation_Change_Process/Images/section5_delete_popup.png)