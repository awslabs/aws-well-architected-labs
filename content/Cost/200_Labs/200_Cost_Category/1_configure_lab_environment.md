---
title: "Configure Lab Environment"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
## Overview
Any Company (a fictitious Enterprise organization) is running various projects on the AWS cloud in the us-east-1 region, which are owned by various departments within the organization for their respective teams. For example, the **Digital** department has implemented two critical 2-tier web applications **Project1** and **Project2** for two different teams called **Alpha** and **Beta** under two different cost centres **CostCenter-1111** and **CostCenter-2222** respectively.
  ![Section1 Architecture](/Cost/200_Cost_Category/Images/section1/Architecture.png)

The CFO is highly concerned about the entire cost of cloud resources that are generated as part of the digital department and has asked the head of the digital department to share a consolidated cost report exclusive to the digital department, including cost for each service that Alpha and Beta teams are using for their respective projects. A consolidated cost report will provide a centralized view of usage and costs, enable accurate chargeback, and allow for better forecasting. 

The lab uses two CloudFormation templates for **Project1** and **Project2**, and
will teach you the techniques to apply tags for cost categorization and
further use cost categories for expenditure awareness.

### Get the CloudFormation Template and Deploy it.
You can get both the CloudFormation templates used in this lab here - [Project1](/Cost/200_Cost_Category/Code/Project1cfm.yml "Section2 CFTemplate1") and [Project2](/Cost/200_Cost_Category/Code/Project2cfm.yml "Section2 CFTemplate2").

#### Console:
If you need detailed instructions on how to deploy a **CloudFormation stack** from within the console, please follow this
[guide.](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html)

1. Log into the **Cost Optimization Member Account** created in [AWS Account Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}}).

2. Open the CloudFormation console at
    [https://console.aws.amazon.com/cloudformation](https://console.aws.amazon.com/cloudformation/)
    and click **Create stack** button. 
 ![Section1 CFStack](/Cost/200_Cost_Category/Images/section1/createStackLandingPage.png)

3. Select the stack template which you downloaded earlier, and click
    **Choose file** to upload **Project1cfm.yaml** and click **Next**.
 ![Section1 Upload_CFStack](/Cost/200_Cost_Category/Images/section1/createStackTeamAlpha.png)

4. For the **Stack name** use any stack name of your choice and click
    **Next**. For this case, We have used **Alpha-Team-Resources** as a Stack
    name.
 ![Section1 StackName](/Cost/200_Cost_Category/Images/section1/specifyStackDetailsTeamAlpha.png)

5. Keep **Configure stack options** as default. Scroll down to the bottom of the page and click **Next**.
 ![Section1 StackOptions](/Cost/200_Cost_Category/Images/section1/configureStackOptionsTeamAlpha.png)

6. Scroll down to the bottom of the **Review Alpha-Team-Resources**
    page and acknowledge the IAM resources creation by selecting the check box. After reviewing, click on **Submit** to run the stack. It
    may take 15 minutes to complete the baseline deployment.
 ![Section1 IAM](/Cost/200_Cost_Category/Images/section1/acknowledgeResourcesTeamAlpha.png)

7. Now go to your newly created stack and go to the **Resources**
    section of the CloudFormation stack to find all the resources for
    team **Alpha**.
 ![Section1 StackResourcesAlpha](/Cost/200_Cost_Category/Images/section1/resourcesTeamAlpha.png)

8. Follow the same procedure step by step and select
    **Project2cfm.yaml** in step 3 to create resources for team Beta. We have used **Beta-Team-Resources** as a stack name in step 4.
 ![Section1 StackResourcesBeta](/Cost/200_Cost_Category/Images/section1/resourcesTeamBeta.png)


### Congratulations!

You have completed this section of the lab. In this section you
successfully deployed two AWS CloudFormation templates of the lab and
confirmed the relevant resources were created using the AWS Console.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../" link_next_url="../2_apply_tags/" />}}
