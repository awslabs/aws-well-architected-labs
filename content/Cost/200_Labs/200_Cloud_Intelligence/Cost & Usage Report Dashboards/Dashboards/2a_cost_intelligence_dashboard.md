---
title: "Cost Intelligence Dashboard"
date: 2021-05-26T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2a. </b>"
---

## Authors
- Alee Whitman, Sr. Commercial Architect (AWS OPTICS)

## Contributors 
- Arun Santhosh, Specialist SA (Amazon QuickSight)
- Kareem Syed-Mohammed, Senior Product Manager - Technical (Amazon QuickSight)
- Aaron Edell, Global Head of Business and GTM - EC2 Insights
- Timur Tulyaganov, AWS Sr. Technical Account Manager
- Yuriy Prykhodko, AWS Sr. Technical Account Manager

{{< rawhtml >}}
<video width="600" height="450" controls>
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Cost/Videos/DashboardCostIntelligence.mp4" type="video/mp4">
  Your browser doesn't support video, or if you're on GitHub head to https://wellarchitectedlabs.com to watch the video.
</video>
{{< /rawhtml >}}


## Deployment Options
There are 3 options to deploy the Cost Intelligence Dashboard. If you are unsure what option to select, we recommend using the Manual deployment

### Option 1: Manual Deployment
This option is the manual deployment and will walk you through all steps required to create this dashboard without any automation. We recommend this option users new to Athena and QuickSight. 
{{%expand "Click here to continue with the manual deployment" %}}

### Create Athena Views

**NOTE:** If you've deployed the CUDOS Dashboard, you will not need to create any new Athena views. All 5 views are the same as the CUDOS Dashboard
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
    "DashboardId": "cost_intelligence_dashboard",
    "Name": "Cost Intelligence Dashboard",
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

                 }
             ],
                     "Arn": "arn:aws:quicksight:us-east-1:869004330191:template/cost-intelligence-dashboard"
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
    \<DataSetId> | Replace with Dataset ID's from the data sets you created in the Preparing Quicksight section **NOTE:** There are 4 unique Dataset IDs

5. Run the import
```
aws quicksight create-dashboard --cli-input-json file://import.json --region <Region> --dashboard-id cost_intelligence_dashboard
```

6. Check the status of your deployment
```
aws quicksight describe-dashboard --dashboard-id cost_intelligence_dashboard --region <Region> --aws-account-id <Account_ID>
```

If you encounter no errors, open **QuickSight** from the AWS Console, and navigate to **Dashboards**. You should now see **Cost Intelligence Dashboard** available. This dashboard can be shared with other users, but is otherwise ready for viewing and customizing.

If something goes wrong in the dashboard creation step, correct the issue then delete the failed deployment before re-deploying

```
aws quicksight delete-dashboard --dashboard-id cost_intelligence_dashboard --region <Region> --aws-account-id <Account_ID>
```

**NOTE:** You have successfully created the Cost Intelligence Dashboard. For a detailed description of the dashboard read the [FAQ](/Cost/200_Cloud_Intelligence/Cost_Intelligence_Dashboard_ReadMe.pdf)
    ------------ | -------------
	
### Saving and Sharing your Dashboard in QuickSight
Now that you have your dashboard created you can share your dashboard with users or customize your own version of this dashboard
	
- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)	
	

{{% /expand%}}

### Optional 2: Automation Scripts Deployment
The [Cloud Intelligence Dashboards automation repo](https://github.com/aws-samples/aws-cudos-framework-deployment) is an optional way to create the Cloud Intelligence Dashboards using a collection of setup automation scripts. The supplied scripts allow you to complete the workshops in less than half the time as the standard manual setup.

{{%expand "Click here to continue with the Automation Scripts Deployment" %}}

- Navigate to the [CID section of the Cloud Intelligence Dashboards automation repo](https://github.com/aws-samples/aws-cudos-framework-deployment/tree/main/cudos)  
{{% /expand%}}


### Option 3: CloudFormation Deployment
This section is **optional** and automates the creation of the Cost Intelligence Dashboard using a **CloudFormation template**. The CloudFormation template allows you to complete the lab in less than half the time as the standard setup. You will require permissions to modify CloudFormation templates, create an IAM role, create an S3 Bucket, and create an Athena Database. **If you do not have the required permissions use the Manual Deployment**. 

{{%expand "Click here to continue with the CloudFormation Deployment" %}}

**NOTE:** An IAM role and a new Athena Datasource will be created when you create the CloudFormation stack. Please review the CloudFormation template with your security team and switch to the manual setup if required
    ------------ | -------------

### Create the Cost Intelligence Dashboard using a CloudFormation Template

1. Login via SSO in your Cost Optimization account

2. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https%3A%2F%2Fee-assets-prod-us-east-1.s3.amazonaws.com%2Fmodules%2F8cf0b70c5c7a489ebe4e957c2f32bb67%2Fv2%2FQuickSightCurReportAutomation.yml)
	
![Images/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_2.png)

3. Enter a **Stack name** for your template such as **Cost-Intelligence-Dashboard-QuickSight**
![Images/cf_dash_3.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_3.png)

4. Review **1stReadMe** parameter to confirm prerequisites before specifying the other parameters
![Images/cf_dash_4.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_4.png)

5. Validate your Athena primary workgroup has an output location 
	- Open a new tab or window and navigate to the **Athena** console
	- Select **Workgroup: primary**
![Images/cf_dash_athena_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_2.png)
	- Click the bubble next to **primary** and then select view **detail**
![Images/cf_dash_athena_3.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_3.png)
	- Confirm your **Query result location** is configured with an S3 bucket path. 
		- If configured, **continue to step 6**. 
		- If not configured, continue to setting up by clicking **Edit workgroup**
![Images/cf_dash_athena_4.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_4.png)
	- Add the **S3 bucket path** you have selected for your Query result location and click save
![Images/cf_dash_athena_5.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_5.png)

6. Update your **BucketFolderPath** with the S3 path where your **year partitions of CUR data** are stored
![Images/cf_dash_6.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_6.png)
To validate the correct path for your year partitions of the CUR data follow the tasks below:
	- Open a new tab or window and navigate to the **S3** console
	- Select the S3 Bucket your CUR is located in
![Images/cf_dash_s3_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_s3_2.png)	
	- Navigate your folders until you find the folder with the **year partitions of the CUR**
![Images/cf_dash_s3_3.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_s3_3.png)	
		- Tip: Your yearly partitions folder is located in the folder with your .yml file, monthly folders, and status report
	- Add the identified BucketFolderPath to the CloudFormation parameter making sure to **not add trailing /**  (eg - BucketName/FolderName/.../FolderName)	
		- Tip: copy and paste the **S3 URI** then **remove the leading 's3://' and the ending '/'**

7. Update your **QuickSightUser** with your **QuickSight username** 
![Images/cf_dash_7.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_7.png)
To validate your QuickSight complete the tasks below:
	- Open a new tab or window and navigate to the **QuickSight** console
	- Click on the **profile icon** in the top right side of the navigation bar, then select **Manage QuickSight**
![Images/cf_dash_qs_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_qs_2.png)
	- Locate your username in the **manage users** section 
![Images/cf_dash_qs_3.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_qs_3.png)

8. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page

9. Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png)

10. You will see the stack will start in **CREATE_IN_PROGRESS**
![Images/cf_dash_10.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_10.png)

**NOTE:** This step can take 5-15mins
    ------------ | -------------

11. Once complete, the stack will show **CREATE_COMPLETE**
![Images/cf_dash_11.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_11.png)

12. Navigate to **Dashboards** page in your QuickSight console, click on your **Dashboard name**
![Images/cf_dash_12.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_12.png)

### Creating your Account Mapping

1. Navigate to **Athena** in the AWS console:

1. Create the **account_map view** by modifying the following code, and executing it in Athena:
	- [View0 - account_map](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/0_view0/)

1. Go to the **QuickSight** service homepage inside your account. Be sure to select the correct region from the top right user menu or you will not see your expected tables

    ![qs_region](/Cost/200_Cloud_Intelligence/Images/cur/qs_region.png?classes=lab_picture_small)
	
1.	From the left hand menu, choose **Datasets**

    ![qs_dataset_sidebar](/Cost/200_Cloud_Intelligence/Images/cur/qs_dataset_sidebar.png?classes=lab_picture_small)
	
1.	Select the **summary_view** dataset

    ![qs_select_summary](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_summary.png?classes=lab_picture_small)

1.	Click **Edit Data Set**

    ![qs_edit_dataset](/Cost/200_Cloud_Intelligence/Images/cur/qs_edit_dataset.png?classes=lab_picture_small)

1.	Click **Add Data**

    ![qs_add_data](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_data.png?classes=lab_picture_small)

1.	Choose your **account_map** view and click **Select**

    ![qs_add_account_map](/Cost/200_Cloud_Intelligence/Images/cur/qs_add_account_map.png?classes=lab_picture_small)

1.	Click the two circles to open the **Join conﬁguration**, then select **Left** to change your join type

    ![qs_join_account_map_left](/Cost/200_Cloud_Intelligence/Images/cur/qs_join_account_map_left.png?classes=lab_picture_small)
	
1.	Configure the join clause to **linked_account_id = account_id**, then click **Apply**

    ![qs_join_account_map](/Cost/200_Cloud_Intelligence/Images/cur/qs_join_account_map.png?classes=lab_picture_small)
	
1.	Select **Save**

    ![qs_save_summary](/Cost/200_Cloud_Intelligence/Images/cur/qs_save_summary.png?classes=lab_picture_small)
	
1.	Repeat **steps 3-11**, for the remaining 3 data sets. 
 - s3_view
 - ec2_running_cost
 - compute_savings_plan_eligible_spend

**NOTE:** You have successfully created the Cost Intelligence Dashboard. For a detailed description of the dashboard read the [FAQ](/Cost/200_Cloud_Intelligence/Cost_Intelligence_Dashboard_ReadMe.pdf)
    ------------ | -------------

### Saving and Sharing your Dashboard in QuickSight
Now that you have your dashboard created you can share your dashboard with users or customize your own version of this dashboard
	
- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)	


{{% /expand%}}


{{< prev_next_button link_prev_url="../1_prerequistes/" link_next_url="../2b_cudos_dashboard/" />}}
