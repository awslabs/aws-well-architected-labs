---
title: "CUDOS Dashboard"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2b. </b>"
---

## Authors
- Timur Tulyaganov, AWS Sr. Technical Account Manager
- Yuriy Prykhodko, AWS Sr. Technical Account Manager

{{% notice note %}}
If you used the automation scripts in the [previous step](/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/2a_cost_intelligence_dashboard/) you should already have the CUDOS Dashboard and can skip to the bottom of this page and click Next Step
{{% /notice %}}

## Deployment Options
There are 2 options to deploy the CUDOS Dashboard. If you are unsure what option to select, we recommend using the Manual deployment


### Option 1: Manual Deployment
This option is the manual deployment and will walk you through all steps required to create this dashboard without any automation. We recommend this option users new to Athena and QuickSight. 
{{%expand "Click here to continue with the  manual deployment" %}}

### Create Athena Views


**NOTE:** If you've deployed the Cost Intelligence Dashboard, you will only need to create the **customer_all** view, views 0-5 are the same as the Cost Intelligence Dashboard
    ------------ | -------------

The data source for the dashboard will be an Athena view of your existing Cost and Usage Report (CUR). The default dashboard assumes you have both Savings Plans and Reserved Instances, if not you will need to create the alternate views.

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
		

**NOTE:** Unless you already have Savings Plans and Reserved Instances both already adopted as your savings options, **recreate Athena Views** corresponding with your savings profile whenever you onboard a new savings option (like Savings Plans or Reserved Instances) **for the first time**.
    ------------ | -------------

3. Create the **account_map  view** by modifying the following code, and executing it in Athena:
	- [View0 - account_map](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/0_view0/)



4. Create the **Summary view** by modifying the following code, and executing it in Athena:
	- [View1 - Summary View](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/1_view1/)
	

5. Create the **EC2_Running_Cost view** by modifying the following code, and executing it in Athena:
	- [View2 - EC2_Running_Cost](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/2_view2/)

6. Create the **Compute savings plan eligible spend view** by modifying the following code, and executing it in Athena:
	- [View3 - compute savings plan eligible spend](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/3_view3/)	

7. Create the **s3 view** by modifying the following code, and executing it in Athena:
	- [View4 - s3](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/4_view4/)	

8. Create the **RI SP Mapping view** by modifying the following code, and executing it in Athena:
	- [View5 - RI SP Mapping](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/5_view5/)	

9. Create the **customer_all view** by modifying the following code, and executing it in Athena:
	- [View6 - customer_all](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/6_view6/)	



**NOTE:** The Athena Views are updated to reflect any additions in the cost and usage report. If you created your dashboard prior to June 1, 2021 you will want to update to the latest views.
    ------------ | -------------



### Create QuickSight Data Sets
#### Create Datasets

1. Go to the **QuickSight** service homepage inside your account. Be sure to select the correct region from the top right user menu or you will not see your expected tables

    ![qs_region](/Cost/200_Cloud_Intelligence/Images/cur/qs_region.png?classes=lab_picture_small)

1.	From the left hand menu, choose **Datasets**

    ![qs_dataset_sidebar](/Cost/200_Cloud_Intelligence/Images/cur/qs_dataset_sidebar.png?classes=lab_picture_small)
	
1.	Click **New dataset** displayed in the top right corner

    ![qs_dataset](/Cost/200_Cloud_Intelligence/Images/cur/qs_dataset.png?classes=lab_picture_small)

1.	Choose **Athena** as your Data Source

    ![qs_datasource](/Cost/200_Cloud_Intelligence/Images/cur/qs_datasource.png?classes=lab_picture_small)

1.	Enter a data source name of **Cost_Dashboard** and click **Create data source**

    ![qs_create_datasource](/Cost/200_Cloud_Intelligence/Images/cur/qs_create_datasource.png?classes=lab_picture_small)

1.	Select the database which holds the views you created (reference Athena if you’re unsure which one to select), and the **summary_view** table, then click **Edit/Preview data**

    ![qs_select_datasource](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_datasource.png?classes=lab_picture_small)

1.	Select **SPICE** to change your Query mode

    ![qs_dataset_summary](/Cost/200_Cloud_Intelligence/Images/cur/qs_dataset_summary.png?classes=lab_picture_small)
	
1.	Click **Add Data**

    ![qs_add_data](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_data.png?classes=lab_picture_small)
	
1.  Select **Data source**	
  
  ![qs_add_data_source](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_data_source.png?classes=lab_picture_small)
	
10. Choose your **Cost_Dashboard** view and click **Select**

    ![qs_select_data_source_add](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_data_source_add.png?classes=lab_picture_small)

1.  Select the **database** which holds the CUR views you created
	![qs_select_database_add](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_database_add.png?classes=lab_picture_small)
	
12.  Choose your **account_map** view and click **Select**
	![qs_add_account_map](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_account_map.png?classes=lab_picture_small)

13.	Click the two circles to open the **Join conﬁguration**, then select **Left** to change your join type

    ![qs_join_account_map_left](/Cost/200_Cloud_Intelligence/Images/cur/qs_join_account_map_left.png?classes=lab_picture_small)
	
1.	Configure the join clause to **linked_account_id = account_id**, then click **Apply**

    ![qs_join_account_map](/Cost/200_Cloud_Intelligence/Images/cur/qs_join_account_map.png?classes=lab_picture_small)
	
1.	Select **Save**

    ![qs_save_summary](/Cost/200_Cloud_Intelligence/Images/cur/qs_save_summary.png?classes=lab_picture_small)

1.	Select the **summary_view** dataset

    ![qs_select_summary](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_summary.png?classes=lab_picture_small)

1.	Click **Schedule refresh**

    ![qs_schedule_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_schedule_refresh.png?classes=lab_picture_small)

1.	Click **Create**

    ![qs_create_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_create_refresh.png?classes=lab_picture_small)

1.	Enter a daily schedule, in the appropriate time zone and click **Create**

    ![qs_daily_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_daily_refresh.png?classes=lab_picture_small)

1.	Click **Cancel** to exit

    ![qs_cancel_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_cancel_refresh.png?classes=lab_picture_small)

1.	Click **x** to exit

    ![qs_exit_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_exit_refresh.png?classes=lab_picture_small)

1.	Repeat **steps 3-21**, creating data sets with the remaining Athena views. You will reuse your existing **Cost_Dashboard** data source, and select the following views as the table:

 - s3_view
 - ec2_running_cost
 - compute_savings_plan_eligible_spend


	**NOTE:** Make sure to reuse the existing Athena data source by scrolling to the bottom of the Data source create/select page when creating a new Dataset instead of creating a new data source  
		------------ | -------------
			![qs_data_source_scroll](/Cost/200_Cloud_Intelligence/Images/cur/qs_data_source_scroll.png?classes=lab_picture_small)

	When this step is complete, your Datasets tab should have **4 new SPICE Datasets**
	
23.	Select the **summary_view** dataset

    ![qs_select_summary](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_summary.png?classes=lab_picture_small)

1.	Click **Edit Data Set**

    ![qs_edit_dataset](/Cost/200_Cloud_Intelligence/Images/cur/qs_edit_dataset.png?classes=lab_picture_small)

1.	Click **Add Data**

    ![qs_add_data_2](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_data_2.png?classes=lab_picture_small)

1. Select **Data source**	
    ![qs_add_data_source](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_data_source.png?classes=lab_picture_small)
	
1.	Choose your **Cost_Dashboard** view and click **Select**

    ![qs_select_data_source_add](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_data_source_add.png?classes=lab_picture_small)

1.  Select the **database** which holds the CUR views you created

   ![qs_select_database_add](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_database_add.png?classes=lab_picture_small)	
	
29.	Choose your **ri_sp_mapping view** and click **Select**

    ![qs_add_ri_sp](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_ri_sp.png?classes=lab_picture_small)

1.	Click the two circles to open the **Join conﬁguration**, then select **Left** to change your join type

    ![qs_ri_sp_left](/Cost/200_Cloud_Intelligence/Images/cur/qs_ri_sp_left.png?classes=lab_picture_small)

1.	Click **Add a new join clause** twice so you have 3 join clauses to configure in total. Configure the 3 join clauses as below, then click **Apply**
    * **ri_sp_arn = ri_sp_arn_mapping**
	* **payer_account_id = payer_account_id_mapping**
    * **billing_period = billing_period_mapping**

    ![qs_ri_sp_join](/Cost/200_Cloud_Intelligence/Images/cur/qs_ri_sp_join.png?classes=lab_picture_small)
	
1.	Click **Save**

    ![qs_ri_sp_save](/Cost/200_Cloud_Intelligence/Images/cur/qs_ri_sp_save.png?classes=lab_picture_small)

1.	Click **New dataset** displayed in the top right corner of QuickSight

    ![qs_dataset](/Cost/200_Cloud_Intelligence/Images/cur/qs_dataset.png?classes=lab_picture_small)

1.	Select your existing **Cost_Dashboard** as your Data Source
   
   ![qs_datasource_dup](/Cost/200_Cloud_Intelligence/Images/cur/qs_datasource_dup.png?classes=lab_picture_small)
   
29.	Select **Create dataset**

   ![qs_create_customer_all](/Cost/200_Cloud_Intelligence/Images/cur/qs_create_customer_all.png?classes=lab_picture_small)

30.	Select the database which holds your **customer_all** view and select that view then click **Edit/Preview data**

   ![qs_customer_all_view](/Cost/200_Cloud_Intelligence/Images/cur/qs_customer_all_view.png?classes=lab_picture_small)

31.	Keep the Query mode as **Direct query**

    ![qs_direct_query](/Cost/200_Cloud_Intelligence/Images/cur/qs_direct_query.png?classes=lab_picture_small)

32.	Repeat steps 8-15, but configure this join clause in step 14:
    **line_item_usage_account_id** = **account_id**

    ![qs_customer_all_map](/Cost/200_Cloud_Intelligence/Images/cur/qs_customer_all_map.png?classes=lab_picture_small)
	

**NOTE:** This completes the QuickSight Data Preparation section. Next up is the Import process to generate the QuickSight Dashboard.
    ------------ | -------------

### Import Dashboard Template
We will now use the CLI to create the dashboard from the CUDOS Dashboard template.

1. Edit and Run `list-users` and make a note of your **User ARN**:
```
aws quicksight list-users --aws-account-id <Account_ID> --namespace default --region <Region>
```

2. Edit and Run `list-data-sets` and make a note of the **Name** and **Arn** for the **5 Datasets ARNs**:
```
aws quicksight list-data-sets --aws-account-id <Account_ID> --region <Region>
```

3. Create an **import.json** file using the below sample
```
{
    "AwsAccountId": "<Account_ID>",
    "DashboardId": "cudos",
    "Name": "CUDOS",
    "Permissions": [
         {
                "Principal": "<User ARN>",
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
"DashboardPublishOptions": {
"AdHocFilteringOption": {
"AvailabilityStatus": "DISABLED"
}
},
    "SourceEntity": {
        "SourceTemplate": {
            "DataSetReferences": [
                {
                    "DataSetPlaceholder": "summary_view",
                    "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"

                },
                                         {
                    "DataSetPlaceholder": "ec2_running_cost",
                    "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"

                },
                                         {
                     "DataSetPlaceholder": "compute_savings_plan_eligible_spend",
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"

                 },
                                         {
                     "DataSetPlaceholder": "s3_view",
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"

                 },
                              {
                 "DataSetPlaceholder": "customer_all",
                 "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"
             }
             ],
                     "Arn": "arn:aws:quicksight:us-east-1:223485597511:template/cudos_dashboard_v3"
         }
     },
     "VersionDescription": "1"
}
```

4. Update the **import.json** to match your details by replacing the following placeholders:

    Placeholder | Replace with
    ------------ | -------------
    \<Account_ID> | AWS Account ID where the dashboard will be deployed
    \<Region> | [Region Code](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) where the dashboard will be deployed (Example eu-west-1)
    \<User ARN> | ARN of your user
    \<DataSetId> | Replace with Dataset ID's from the data sets you created in the Preparing Quicksight section **NOTE:** There are 5 unique Dataset IDs

5. Run the import
```
aws quicksight create-dashboard --cli-input-json file://import.json --region <Region> --dashboard-id cudos
```

6. Check the status of your deployment
```
aws quicksight describe-dashboard --dashboard-id cudos --region <Region> --aws-account-id <Account_ID>
```

If you encounter no errors, open **QuickSight** from the AWS Console, and navigate to **Dashboards**. You should now see **CUDOS** available. This dashboard can be shared with other users, but is otherwise ready for viewing and customizing.

If something goes wrong in the dashboard creation step, correct the issue then delete the failed deployment before re-deploying

```
aws quicksight delete-dashboard --dashboard-id cudos --region <Region> --aws-account-id <Account_ID>
```

### Saving and Sharing your Dashboard in QuickSight
Now that you have your dashboard created you can share your dashboard with users or customize your own version of this dashboard
	
- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)
	
	
{{% /expand%}}


### Optional 2: Automation Scripts Deployment
The [Cloud Intelligence Dashboards automation repo](https://github.com/aws-samples/aws-cudos-framework-deployment) is an optional way to create the Cloud Intelligence Dashboards using a collection of setup automation scripts. The supplied scripts allow you to complete the workshops in less than half the time as the standard manual setup.

{{%expand "Click here to continue with the Automation Scripts Deployment" %}}

- Navigate to the [CUDOS section of the Cloud Intelligence Dashboards automation repo](https://github.com/aws-samples/aws-cudos-framework-deployment/tree/main/cudos)  
{{% /expand%}}

### Update Dashboard Template - Optional

{{%expand "Click here to update your dashboard with the latest version" %}}

If you are tracking our [Changelog](https://github.com/aws-samples/aws-cudos-framework-deployment/blob/main/cudos/CHANGELOG.md), you already know that we continue improving Cloud Intelligence Dashboards.

To pull the latest version of the dashboard from the public template please use the following steps.

1. Create an **update.json** file by removing permissions section from the **import.json** file. Sample for CUDOS Dashboard **update.json** file below:
```json
{
    "AwsAccountId": "<Account_ID>",
    "DashboardId": "cudos",
    "Name": "CUDOS",
    "DashboardPublishOptions": {
      "AdHocFilteringOption": {
        "AvailabilityStatus": "DISABLED"
      }
    },
    "SourceEntity": {
      "SourceTemplate": {
        "DataSetReferences": [
          {
            "DataSetPlaceholder": "summary_view",
            "DataSetArn": "arn:aws:quicksight:<region>:<Account_ID>:dataset/<DatasetID>"
          },
          {
            "DataSetPlaceholder": "ec2_running_cost",
            "DataSetArn": "arn:aws:quicksight:<region>:<Account_ID>:dataset/<DatasetID>"
          },
          {
            "DataSetPlaceholder": "compute_savings_plan_eligible_spend",
            "DataSetArn": "arn:aws:quicksight:<region>:<Account_ID>:dataset/<DatasetID>"
          },
          {
            "DataSetPlaceholder": "s3_view",
            "DataSetArn": "arn:aws:quicksight:<region>:<Account_ID>:dataset/<DatasetID>"
          },
          {
            "DataSetPlaceholder": "customer_all",
            "DataSetArn": "arn:aws:quicksight:<region>:<Account_ID>:dataset/<DatasetID>"
          }
        ],
        "Arn": "arn:aws:quicksight:us-east-1:223485597511:template/cudos_dashboard_v3"
          }
      }
}
```

2. If needed update the **update.json** to match your details by replacing the following placeholders:

    Placeholder | Replace with
    ------------ | -------------
    \<Account_ID> | AWS Account ID where the dashboard will be deployed
    \<Region> | [Region Code](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) where the dashboard will be deployed (Example eu-west-1)
    \<DatasetID> | Replace with Dataset ID's from the datasets you created in the Preparing Quicksight section **NOTE:** There are 5 unique Dataset IDs


3. Pull the latest published version of the dashboard template. Example for CUDOS Dashboard below:
```
aws quicksight update-dashboard --cli-input-json file://update.json --region <region>
```

4. Query the version number of the published dashboard. Example for CUDOS Dashboard below:
```
aws quicksight list-dashboard-versions --region <region> --aws-account-id <Account_ID> --dashboard-id cudos --query 'sort_by(DashboardVersionSummaryList, &VersionNumber)[-1].VersionNumber'
```

5. Apply the latest pulled changes to the deployed dashboard with this CLI command. Example for CUDOS Dashboard below:
```
aws quicksight update-dashboard-published-version --region <region> --aws-account-id <Account_ID> --dashboard-id cudos --version-number <version>
```

{{% /expand%}}

{{< prev_next_button link_prev_url="../2a_cost_intelligence_dashboard" link_next_url="../2c_additional_dashboards" />}}
