---
title: "Modify Cost Intelligence Dashboard"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

{{% notice note %}}
This **Lab has moved** under the Level 200 Cloud Intelligence Dashboards.[**Click this link to navigate to the updated Lab**]({{< ref "/Cost/200_Labs/200_Cloud_Intelligence" >}})
{{% /notice %}}


{{%expand " " %}}
## Authors
- Alee Whitman, Commercial Architect (AWS)


### Add Account Mapping Data
This section is **optional** and shows how you can add your **Business Unit or Enterprise Account mapping data** to your dashboard using Account Id as the identifier.

This example will show you how to replace the AccountID, with a name that is meaningful to your organization.

1. Create an account mapping file locally, you can use the sample here as a starting point:
[mapping_document.csv](/Cost/200_Enterprise_Dashboards/mapping_document.csv)

2. In **QuickSIght**, select the **summary_view** Data Set

3. Select **Edit data set**

4. Select **Add Data**:
![Images/quicksight_mapping_3.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_mapping_3.png)

5. Select **upload a file**
![Images/quicksight_mapping_4.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_mapping_4.png)

6. Navigate to your mapping data file and click **Open**

7. Confirm the mappings are correct, click **Next**:
![Images/quicksight_mapping_6.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_mapping_6.png)

8. Select the **two circles** to open the Join configuration then select **Left** to change your join type:
![Images/quicksight_mapping_7.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_mapping_7.png)

9. Create following **join clause** then click **Apply**:
	- **linked_account_id** = **(Your linked Account Id field name)**
![Images/quicksight_mapping_8.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_mapping_8.png)

10. Scroll down in the field list, and confirm the new fields have the correct data types. The **Account ID** must be **String**:

11. Select **Save**

12. Repeat **steps 2-11**, creating mapping joins for your remaining QuickSight data sets:

	- s3_view
	- ec2_running_cost
    - compute_savings_plan_eligible_spend


{{% notice note %}}
You now have new fields that can be used on the visuals - we will now use them
{{% /notice %}}


13. Go to the **Cost Intelligence Analysis**

14. Edit the calculated field **Account**:
![Images/quicksight_mapping_11.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_mapping_11.png)

15. Change the formula from **{linked_account_id}** to **{Account Name}**
![Images/quicksight_mapping_12.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_mapping_12.png)

16. You can now select a visual, select the **Account** field, and you will see the account names in your visuals, instead of the Account number:
![Images/quicksight_mapping_13.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_mapping_13.png)


{{% notice tip %}}
You now have successfully utilized mapping data on your dashboard
{{% /notice %}}
 


### Customize your Summary View Cost value
This section is **optional** and shows how you can customize the analysis from using **Amortized Cost** to using **Unblended/Invoiced Cost**.

1. From the QuickSight Analysis dashboard, click on the **Cost Intelligence Analysis**
![Images/quicksight_cost_1.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_cost_1.png)

2. Edit the calculated field **Cost**:
![Images/quicksight_cost_3.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_cost_3.png)

3. Change the formula from **{Cost_Amortized}** to **{Cost_Unblended}**:
![Images/quicksight_cost_4.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_cost_4.png)

4. If you have usage with upfront charges - such as partial or full upfront Savings Plans or Reserved Instances, you will notice changes in the cost values of your dashboards.

{{% notice tip %}}
You have successfully updated your Cost value and customized the Summary View.
{{% /notice %}}

{{< prev_next_button link_prev_url="../1_create_cost_intelligence/" link_next_url="../3_create_data_transfer_cost_analysis/" />}}
{{% /expand%}}