---
title: "Teardown"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

## Overview

It is recommended to delete all the resources those are not in use
anymore to save the cost

### Delete resources created by cloudformation template

#### Console:

1. Log in as the Cost Optimization team (admin credentials), created in AWS Account Setup

2. In the navigation pane, choose **CloudFormation**
    ![Section6 CloudFormation](/Cost/200_Cost_Category/Images/section6/cloudFormation.png)

3. Select **alpha-team-resources** and under choose **delete(**Note :
    this will delete all the resources created as part cloudformation
    and will take up to 15 mins)
    ![Section6 DeleteAlphaTeamResources](/Cost/200_Cost_Category/Images/section6/deleteAlphaTeamResources.png)

4. Click on Delete stack.
    ![Section6 DeleteAlphaTeamStack](/Cost/200_Cost_Category/Images/section6/deleteAlphaTeamStack.png)

5. Similarly select **beta-team-resources** and under **action** choose **delete**.

6. Confirm there are no io1 unattached EBS volumes, go to the **EC2 dashboard**,
   click on **Elastic Block Store**, click **Volumes**.

### Delete cost category

#### Console:

1. Sign in to the AWS Management Console using management admin account
    credentials and open the AWS Billing console at
    [https://console.aws.amazon.com/billing/](https://console.aws.amazon.com/billing/)

2. In the navigation pane, choose **AWS Cost Categories**.

3. Choose **cost by department** and delete the category.

4. Similarly choose **cost by team** and delete the category.

### Deactivate user defined tags

#### Console:

1. Sign in to the AWS Management Console using management account admin
    credentials and open the AWS Billing console at
    [https://console.aws.amazon.com/billing/](https://console.aws.amazon.com/billing/)

2. In the navigation pane, choose **Cost allocation tags**.

3. Under **User-defined cost allocation tags** select "CostCentre",
    "Department", "ProjectName" and "TeamName" to activate the tags.

4. Choose **Deactivate**.


{{< prev_next_button link_prev_url="../5_visualize_in_cost_explorer/"  title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST7 - "How do you use pricing models to reduce cost?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-cost-effective-resources.html)
{{< /prev_next_button >}}


