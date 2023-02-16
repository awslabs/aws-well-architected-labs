---
title: "Apply Tags using Tag Editor"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---
## Overview

Tags are key and value pairs that act as metadata for organizing your AWS resources. With most AWS resources, you can add tags when you create the resource, whether it's an Amazon EC2 instance, an Amazon RDS, or other resources. However, you can also add or edit or delete tags to multiple supported resources at once using AWS Tag Editor. You can also search for the resources you want to add tag and then manage tags in your search results.

For AWS tagging best practices, please follow the below link :

<https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html>

For our lab we will use **CostCentre**, **ProjectName** and **TeamName** tag keys for the resources created for Project1 and Project2.


#### Console:

1. Login as the Cost Optimization team (admin account) created in [AWS Account Setup.]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}}) Search for **tag editor** in AWS console and select **Resource Groups & Tag Editor** from Services. In the navigation pane on the left, choose **Tag Editor** under Tagging.
 ![Section2 ResourceGroupEditor](/Cost/200_Cost_Category/Images/section2/resourceGroupTagEditorService.png)

2. Choose the AWS Regions in which you have deployed the resources. By
    default, your current region is used. Use **us-east-1** for the current
    lab. Choose **All supported resource types** in the **Resource types** section. Choose **Tag Key** as **"Department"** and **tag value** as
    **"Digital"** in **Tags** section. Then click on **Search resources** button.
 ![Section2 TagEditor](/Cost/200_Cost_Category/Images/section2/tagEditorFindResources.png)

3. In the **Resource search results** enter **project1** in **filter resources** search box and select all the resources . Then click on **Manage tags of selected resources**.
 ![Section2 ResourceProject1](/Cost/200_Cost_Category/Images/section2/resourceSearchResultProject1.png)

4. In the **Edit tags of all selected resources**, add the below tags and click on **Review and apply tag changes**.

   Note: Keep the **prepopulated** tag as is since we have deployed the resources
    through cloud formation template and AWS creates managed tags as
    part of the resource creation.

- Enter the tag **Key: TeamName | Value: Alpha**
- Enter the tag **Key: CostCentre | Value: 1111**
- Enter the tag **Key: ProjectName | Value: Project1**

 ![Section2 ManageTagsProject1](/Cost/200_Cost_Category/Images/section2/manageTagsProject1.png)

5.  Repeat step-1 & step-2, from the **Resource search results** enter **project2** in **filter resources** search box and select all the resources. Then click on **Manage tags of selected resources**

 ![Section2 ResourceProject2](/Cost/200_Cost_Category/Images/section2/resourceSearchResultProject2.png)

6.  In the **Edit tags of all selected resources** add the below tags and click on **Review and apply tag changes**:

- Enter the tag **Key: TeamName | Value: Beta**
- Enter the tag **Key: CostCentre | Value: 2222**
- Enter the tag **Key: ProjectName | Value: Project2**

 ![Section2 ManageTagsProject2](/Cost/200_Cost_Category/Images/section2/manageTagsProject2.png)

7. You will be able to see the resources corresponding to the
    particular tag and region, which means if you filter out by tag **Key:TeamName** and **Value: Alpha** you will be able to see all the resources
    for **team Alpha**.  ![Section2 ValidateTags](/Cost/200_Cost_Category/Images/section2/validateTagsTeamAlpha.png)
   
   Similarly, if you filter out by tag **Key: TeamName** and **Value: Beta**, you will be able to see resources corresponding to the applied tag value.



   

### Congratulations!

You have completed this section of the lab. In this section you
successfully tagged multiple resources at once using AWS Tag Editor
service.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../1_configure_lab_environment/" link_next_url="../3_configure_cost_allocation_tags/" />}}
