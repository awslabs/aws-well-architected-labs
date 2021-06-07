---
title: "Join with the Enterprise Cost Intelligence Dashboard"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

### Join with the Enterprise Cost Intelligence Dashboard


This section is **optional** and shows how you can add your AWS Organization Data to your **Enterprise Dashboards** - [200_Enterprise_Dashboards]({{< ref "/Cost/200_Labs/200_Enterprise_Dashboards" >}}).

This example will show you how to map your Enterprise Dashboard linked_account_id to your Organizations account_number to add account information that is meaningful to your organization.
This is to replace this step: https://wellarchitectedlabs.com/cost/200_labs/200_enterprise_dashboards/2_modify_cost_intelligence/. 

1. Go to the **Amazon QuickSight** service homepage

2. In **QuickSight**, select the **summary_view** Data Set

3. Select **Edit data set**

4. Select **Add data**:
![Images/dashboard_mapping_3.png](/Cost/300_Organization_Data_CUR_Connection/Images/dashboard_mapping_3.png)

5. Select your Amazon Athena **organization_data** table and click **Select**
![Images/Org_Data.png](/Cost/300_Organization_Data_CUR_Connection/Images/Org_Data.png)

6. Select the **two circles** to open the join configuration then select **Left** to change your join type:
![Images/dashboard_mapping_6.png](/Cost/300_Organization_Data_CUR_Connection/Images/dashboard_mapping_6.png)

7. Create following **join clause** :
	- **linked_account_id** = **id**
Click **Apply**

![Images/dashboard_mapping_7.png](/Cost/300_Organization_Data_CUR_Connection/Images/dashboard_mapping_7.png)

8. Scroll down in the field list, and confirm the **Account ID** must be **Int**:
![Images/dashboard_mapping_8.png](/Cost/300_Organization_Data_CUR_Connection/Images/dashboard_mapping_8.png)

9. Select **Save**

10. Repeat **steps 2-9**, creating mapping joins for your remaining QuickSight data sets:

	- s3_view
	- ec2_running_cost
    - compute_savings_plan_eligible_spend

{{% notice tip %}}
You now have new fields that can be used on the visuals in the Cost Intelligence Dashboard - we will now use them
{{% /notice %}}

11. Go to the **Cost Intelligence Analysis**

12. Edit the calculated field **Account**:
![Images/dashboard_mapping_12.png](/Cost/300_Organization_Data_CUR_Connection/Images/dashboard_mapping_12.png)

13. Change the formula from **toString({linked_account_id})** to **{name}**
![Images/dashboard_mapping_13.png](/Cost/300_Organization_Data_CUR_Connection/Images/dashboard_mapping_13.png)

14. You can now select a visual, select the **Account** field, and you will see the account names in your visuals, instead of the Account number:
![Images/dashboard_mapping_14.png](/Cost/300_Organization_Data_CUR_Connection/Images/dashboard_mapping_14.png)


{{% notice tip %}}
You now have successfully utilized Organization mapping data on your Cost Intelligence Dashboard
{{% /notice %}}


{{< prev_next_button link_prev_url="../4_visualize_organization_data_in_quicksight/" link_next_url="../6_teardown/" />}}

