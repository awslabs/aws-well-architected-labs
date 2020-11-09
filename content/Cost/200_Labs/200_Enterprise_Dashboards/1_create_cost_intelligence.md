---
title: "Create Cost Intelligence Dashboard"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

## Authors
- Alee Whitman, Commercial Architect (AWS)

### FAQ
The FAQ for this dashboard is [here.](/Cost/200_Enterprise_Dashboards/Cost_Intelligence_Dashboard_ReadMe.pdf)

### Request Template Access
Ensure you have requested access to the Cost Intelligence template [here.](http://d3ozd1vexgt67t.cloudfront.net/)

### Create Athena Views
The data source for the dashboard will be an Athena view of your existing Cost and Usage Report (CUR). The default dashboard assumes you have both Savings Plans and Reserved Instances, if not - you will need to create the alternate views.

1. Login via SSO in your Cost Optimization account, go into the **Athena** console:

2. Modify and run the following queries to confirm if you have Savings Plans, and Reserved Instances in your usage. If no lines are returned, you have no Savings Plans or Reserved Instances. Replace (database).(tablename) and run the following:

    Savings Plans:

        select * from (database).(tablename)
        where savings_plan_savings_plan_a_r_n not like ''
        limit 10

    Reserved Instances:

        select * from (database).(tablename)
        where reservation_reservation_a_r_n not like ''
        limit 10

3. Create the **Summary view** by modifying the following code, and executing it in Athena: 
    - [View1 - Summary]({{< ref "./Code/1_view1.md" >}})

4. Create the **EC2_Running_Cost view** by modifying the following code, and executing it in Athena:
    - [View2 - EC2_Running_Cost]({{< ref "./Code/2_view2.md" >}})

5. Create the **Compute savings plan eligible spend view** by modifying the following code, and executing it in Athena:
    - [View3 - compute savings plan eligible spend]({{< ref "./Code/3_view3.md" >}})

6. Create the **s3 view** by modifying the following code, and executing it in Athena:
    - [View4 - s3]({{< ref "./Code/4_view4.md" >}})

7. Create the **RI SP Mapping view** by modifying the following code, and executing it in Athena:
    - [View5 - RI SP Mapping]({{< ref "./Code/5_view5.md" >}})


{{% notice note %}}
The Athena Views are updated to reflect any additions in the cost and usage report. If you created your dashboard prior to October 26, 2020 you will want to update to the latest views.
{{% /notice %}}



### Create QuickSight Data Sets
We will now create the data sets in QuickSight from the Athena views.

1. Go to the **QuickSight** service homepage

2. Click **Manage data**:
![Images/quicksight_dataset_2.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_2.png)

3. Click **New dataset**
![Images/quicksight_dataset_3.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_3.png)

4. Click **Athena**
![Images/quicksight_dataset_4.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_4.png)

5. Enter a data source name of **Cost_Dashboard** and click **Create data source**:
![Images/quicksight_dataset_5.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_5.png)

6. Select the **costmaster** database, and the **summary_view** table, click **Edit/Preview data**:
![Images/quicksight_dataset_6.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_6.png)

7. Select **SPICE** to change your Query mode:
![Images/quicksight_dataset_7.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_7.png)

8. Hover over **payer_account_id**  to get the drop down arrow and click on it the then hover over **Change data type** then select **# Int**:
![Images/quicksight_dataset_8.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_8.png)

9. Repeat **step 8** for **linked_account_id** to change it to **Int**

10. Select **Save**:
![Images/quicksight_dataset_10.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_10.png)

11. Select the **summary_view** Data Set:
![Images/quicksight_dataset_11.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_11.png)

12. Click **Schedule refresh**:
![Images/quicksight_dataset_12.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_12.png)

13. Click **Create**:
![Images/quicksight_dataset_13.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_13.png)

14. Enter a schedule, it needs to be refreshed daily, and click **Create**:
![Images/quicksight_dataset_14.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_14.png)

15. Click **Cancel** to exit:
![Images/quicksight_dataset_15.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_15.png)

16. Click the **x** in the top corner:
![Images/quicksight_dataset_16.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_16.png)

17. Repeat **steps 3-16**, creating data sets with the remaining Athena views. The data source name will be **Cost_Dashboard**, and select the following views as the table:

 - s3_view
 - ec2_running_cost
 - compute_savings_plan_eligible_spend



18. Select **summary_view** Data Set:
![Images/quicksight_dataset_18.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_18.png)

19. Select **Edit data set**

20. Select **Add Data**:
![Images/quicksight_dataset_20.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_20.png)

21. Select your **ri_sp_mapping** view and click **Select**:
![Images/quicksight_dataset_21.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_21.png)

22. Select the **two circles** to open the Join configuration then select **Left** to change your join type:
![Images/quicksight_dataset_22.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_22.png)

23. Select **Add a new join clause** two times so you have **3** join clauses:
![Images/quicksight_dataset_23.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_23.png)

24. Create following **3 join clauses** then click **Apply**:
	- **ri_sp_arn** = **ri_sp_arn_mapping**
	- **payer_account_id** = **payer_account_id_mapping**
	- **billing_period** = **billing_period_mapping**
![Images/quicksight_dataset_24.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_24.png)

25. Change the **payer_account_id_mapping** field to **Int**:
![Images/quicksight_dataset_25.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_25.png)

26. Select **Save** 
![Images/quicksight_dataset_26.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dataset_26.png)

{{% notice tip %}}
You now have your data set setup ready to create a visualization.
{{% /notice %}}


### Create the Dashboard
We will now use the CLI to create the dashboard from the Cost Intelligence Dashboard template, then create an Analysis you can customize and modify in the next step.

1. Go to this page to request access to the template. Enter your AWS AccountID and click Submit: [Template Access](http://d3ozd1vexgt67t.cloudfront.net/)

2. Edit the following command, replacing **AccountID** and **region**, then using the CLI list the QuickSight datasets and copy the **Name** and **Arn** for the 4 datasets: **s3_view**, **ec2_running_cost**, **compute_savings_plan_eligible_spend**, **summary_view**:

        aws quicksight list-data-sets --aws-account-id (AccountID) --region (region)

  ![Images/quicksight_dashboard_2.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dashboard_2.png)

3. Get your users **Arn** by editing the following command, replacing **AccountID** and **region**, then using the CLI run the command:

        aws quicksight list-users --aws-account-id (AccountID) --namespace default --region (region)

 ![Images/quicksight_dashboard_3.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dashboard_3.png)

4. Create a local file **create-dashboard.json** with the text below, replace the values **(Account ID)** on line 2, **(User ARN)** one line 7, and each Dataset **(ARN)** on lines 25, 30, 35, 40:

        {
            "AwsAccountId": "(Account ID)",
            "DashboardId": "cost_intelligence_dashboard",
            "Name": "Cost Intelligence Dashboard",
            "Permissions": [
                {
                    "Principal": "(User ARN)",
                    "Actions": [
                            "quicksight:DescribeDashboard",
                            "quicksight:ListDashboardVersions",
                            "quicksight:UpdateDashboardPermissions",
                            "quicksight:QueryDashboard",
                            "quicksight:UpdateDashboard",
                            "quicksight:DeleteDashboard",
                            "quicksight:DescribeDashboardPermissions",
                            "quicksight:UpdateDashboardPublishedVersion"
                    ]
                }
            ],
            "SourceEntity": {
                "SourceTemplate": {
                    "DataSetReferences": [
                        {
                            "DataSetPlaceholder": "summary_view",
                            "DataSetArn": "(Summary Dataset ARN)"

                        },
						                        {
                            "DataSetPlaceholder": "ec2_running_cost",
                            "DataSetArn": "(ec2_running_cost Dataset ARN)"

                        },
						                        {
                            "DataSetPlaceholder": "compute_savings_plan_eligible_spend",
                            "DataSetArn": "(compute_savings_plan_eligible_spend Dataset ARN)"

                        },
						                        {
                            "DataSetPlaceholder": "s3_view",
                            "DataSetArn": "(s3_view Dataset ARN)"

                        }
                    ],
                            "Arn": "arn:aws:quicksight:us-east-1:869004330191:template/optics_cost_analysis"
                }
            },
            "VersionDescription": "1"
        }

5. To create the dashboard from the template, edit then run the following command, replacing **(region)** and you should receive a 202 response:

        aws quicksight create-dashboard --cli-input-json file://create-dashboard.json --region (region)

![Images/quicksight_dashboard_5.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dashboard_5.png)

6. After a few minutes the dashboard will become available in QuickSight under **All dashboard**, click on the **Dashboard name**:
![Images/quicksight_dashboard_6.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dashboard_6.png)

7. {{%expand "Click here - if you do not see your dashboard" %}}

Edit and run the following command:

        aws quicksight describe-dashboard --aws-account-id (YOUR ACCOUNT ID) --dashboard-id cost_intelligence_dashboard --region (region)

Correct the listed errors and run the **delete-dashboard** command followed by the original **create-dashboard** command:
		
        aws quicksight delete-dashboard --aws-account-id (YOUR ACCOUNT ID) --dashboard-id cost_intelligence_dashboard --region (region)

{{% /expand%}}



8. Click **Share**, click **Share dashboard**:, 
![Images/quicksight_dashboard_7.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dashboard_7.png)

9. Click **Manage dashboard access**:
![Images/quicksight_dashboard_8.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dashboard_8.png)

10. Add the required users, or share with all users, ensure you check **Save as** for each user, then click the **x** to close the window:
![Images/quicksight_dashboard_9.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dashboard_9.png)

11. Click **Save as**:
![Images/quicksight_dashboard_10.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dashboard_10.png)

12. Enter an **Analysis name** and click **Create**:
![Images/quicksight_dashboard_11.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dashboard_11.png)

{{% notice note %}}
Perform steps 11 and 12 above to create additional analyses for other teams, this will allow each team to have their own customizable analysis.
{{% /notice %}}

13. You will now have an analysis created from the template that you can edit and modify:
![Images/quicksight_dashboard_12.png](/Cost/200_Enterprise_Dashboards/Images/quicksight_dashboard_12.png)



{{% notice tip %}}
You have successfully created the analysis from a template. For a detailed description of the dashboard read the [FAQ](/Cost/200_Enterprise_Dashboards/Cost_Intelligence_Dashboard_ReadMe.pdf)
{{% /notice %}}

{{< prev_next_button link_prev_url="../" link_next_url="../2_modify_cost_intelligence/" />}}
