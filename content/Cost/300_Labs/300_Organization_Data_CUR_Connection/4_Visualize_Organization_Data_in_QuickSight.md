---
title: "Visualize Organization Data in QuickSight"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

### Join your AWS Organizations data with the AWS Cost & Usage Report in Amazon Quicksight


In Amazon Quicksight we will add to the existing AWS Cost & Usage Report from the Cost Visualization lab. Please make sure you have completed the 100 AWS Account Setup [QuickSight]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup/6_QuickSight" >}}) part of the lab as this will allow QuickSight to have access to your S3 bucket that starts with 'cost'.

1. Log on to the console via SSO, go to the **QuickSight** service, Enter your email address and click **Continue**:

![Images/QuickSight_email.png](/Cost/200_5_Cost_Visualization/Images/QuickSight_email.png)

2. Click **Manage data** in the top right:

![Images/AWSQuicksight13.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight13.png)

3. In your data set click on the Cost & Usage dataset you have already created. Select **Edit Data Set**

![Images/Edit_Data_Set.png](/Cost/300_Organization_Data_CUR_Connection/Images/Edit_Data_Set.png)

4. On the **Top Left** of the screen click **Add Data**

![Images/Add_Data.png](/Cost/300_Organization_Data_CUR_Connection/Images/Add_Data.png)

5. In the pop up select your **organisation_data** and click **Select**

![Images/Org_Data.png](/Cost/300_Organization_Data_CUR_Connection/Images/Org_Data.png)

6. Now your data has been added we can setup the join. Click on the two circles connecting the two data sets. Below you will see two down downs where we can select the joins.

![Images/Inital_Join.png](/Cost/300_Organization_Data_CUR_Connection/Images/Inital_Join.png)

7. The left box should be your Cost and Usage Report. Under that select the drop down bock and choose **line_item_usage_account_id**. In the right box under the Organizations_data select **account_number**. On the right select **Full Join**. Then click **Apply**.

![Images/Joins.png](/Cost/300_Organization_Data_CUR_Connection/Images/Joins.png)

8. You can save this as a new data set by changing the name at the top to **Cost_and_Usage_Data_with_Org**. You then click on **Save**.

![Images/Save_and_Visulize.png](/Cost/300_Organization_Data_CUR_Connection/Images/Save_and_Visulize.png)

9. Let's setup a Schedule refresh for the data. Click on the QuickSight Icon in the top left to bring you back to the home page. Then click on Datasets on the left and find your dataset you just created. Click on the name then select **Schedule refresh** the click **Create**.

![Images/ScheduleRefresh.png](/Cost/300_Organization_Data_CUR_Connection/Images/ScheduleRefresh.png)

10. Choose **your Time zone** and select **Weekly**. Selecting the Starting day as tomorrow so you match the 7 days set in the Amazon CloudWatch Event. Click **Create** and then the Exit button.

![Images/Timezone.png](/Cost/300_Organization_Data_CUR_Connection/Images/Timezone.png)

11. Click on your dataset again and click **Create analysis**.
![Images/Create_Analysis.png](/Cost/300_Organization_Data_CUR_Connection/Images/Create_Analysis.png)

12. Now you will be taken to a new dashboard. On the left you can see some of the column names we have added such as account_name. 

13. On the top of the screen click on **Field wells** and pull in the following:
- Drag in **account_name** into Y axis 
- **line_item_unblended_cost** into Value (ensure the Aggregate is Sum).

The visual below will show you your spend by account name. 

![Images/Dashboard.png](/Cost/300_Organization_Data_CUR_Connection/Images/Dashboard.png)



{{% notice tip %}}
Congratulations - QuickSight is now setup for your users to see the account names and other details in your dashboards.
{{% /notice %}}


{{< prev_next_button link_prev_url="../3_utilize_organization_data_source/" link_next_url="../5_join_cost_intelligence_dashboard/" />}}
