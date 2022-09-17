---
title: "CID CUDOS and the KPI Dashboards"
date: 2021-08-30T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---
The Cost Intelligence Dashboard (CID), CUDOS, and the KPI dashboard are all strongly recommended to be deployed together. These three dashboards are based on the Cost & Usage report and will help you address a wide range of FinOps use cases. The following steps will help you deploy all three dashboards into your account. If you just want to deploy one or two of these dashboards instead, please review the manual deployment section.

## Express Deployment (15 minutes)
The following is the **recommended method** for deploying the CUR-based Cloud Intelligence Dashboards (CID, CUDOS, and KPI). For the CloudFormation method or the manual method, please see options 2 or 3.

If you run into error, please [visit our FAQ](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/faq/) to see if we can provide a quick answer. 

{{%expand "Click here to continue" %}}

1. Open up a terminal application with permissions to run API requests against your AWS account. We recommend [CloudShell](https://console.aws.amazon.com/cloudshell).

2. We will be following the steps outlined in the [Cloud Intelligence Dashboards automation GitHub repo.](https://github.com/aws-samples/aws-cudos-framework-deployment/) For more information on the CLI tool, please visit the repo. 

3. In your Terminal type the following and hit return. This will make sure you have the latest pip package installed.

```bash
python3 -m ensurepip --upgrade
```

4. In your Terminal type the following and hit return. This will download and install the CID CLI tool.

```bash
pip3 install --upgrade cid-cmd
```

5. In your Terminal, type the following and hit return. You are now starting the process of deploying the dashboards. 

```bash
cid-cmd deploy
```

6. Select the CUDOS dashboard first. 

    ![cmd1](/Cost/200_Cloud_Intelligence/Images/cmd1.png?classes=lab_picture_verysmall)

7. The CLI may prompt you to select a QuickSight data source (use the data source you used for any previous CID delpoyments), an Athena workgroup (select primary if unsure), or an Athena database (select the one created by your Glue crawler for your CUR).

8. You will also be prompted to select the method you would like to use to get account names into the Cloud Intelligence Dashboards. It is recommended you choose "Retreive AWS Organizations account" if you use AWS Organizations. This will pull your account names as they are today. To setup automation to add new account names after deployment, follow [this lab.](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/) If you don't have AWS Organizations or you get an error when you select this option, select Dummy Account Mapping instead. For help on other ways of adding your account names, visit [this page dedicated to account mapping.](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/0_view0/)

9. Once complete, you should see a message with a link to your newly deployed dashboard.

    ![cmd2](/Cost/200_Cloud_Intelligence/Images/cmd1.png?classes=lab_picture_verysmall)

10. Run cid-cmd deploy again and select the Cloud Intelligence Dashboards. Once that is completed, run it one more time and select the KPI dashboard. Note that the KPI dashboard will use more SPICE capacity than the CID and CUDOS dashboards so please make sure you've [purchased enough](https://docs.aws.amazon.com/quicksight/latest/user/managing-spice-capacity.html). 

11.	Visit QuickSight and go to Datasets. Select the **summary_view** dataset

    ![qs_select_summary](/Cost/200_Cloud_Intelligence/Images/cur/qs_select_summary.png?classes=lab_picture_small)

12.	Click **Schedule refresh**

    ![qs_schedule_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_schedule_refresh.png?classes=lab_picture_small)

13.	Click **Create**

    ![qs_create_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_create_refresh.png?classes=lab_picture_small)

14.	Enter a daily schedule, in the appropriate time zone and click **Create**

    ![qs_daily_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_daily_refresh.png?classes=lab_picture_small)

15.	Click **Cancel** to exit

    ![qs_cancel_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_cancel_refresh.png?classes=lab_picture_small)

16.	Click **x** to exit

    ![qs_exit_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_exit_refresh.png?classes=lab_picture_small)

17.	Repeat these steps with all other SPICE datasets (including the KPI datasets). No refresh is required for customer_all.

18. [Share or edit your dashboard.](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight/) 

{{% /expand%}}

### Option 2: CloudFormation Deployment (30 Mins)
This section is **optional** and automates the creation of the Cost Intelligence Dashboard and CUDOS Dashboard using **CloudFormation templates**. If you choose this method to also deploy the KPI Dashboard, it will not reuse the same resources. Therefor it is recommended to use the CLI tool method above for the KPI dashboard after using this method to deploy the CID and CUDOS. The CloudFormation templates allows you to complete the lab in less than half the time as the manual setup. You will require permissions to modify CloudFormation templates and create an IAM role. **If you do not have the required permissions use the Manual Deployment**. 

{{%expand "Click here to continue with the CloudFormation Deployment for CID and CUDOS" %}}

**NOTE:** An IAM role will be created when you create the CloudFormation stack. Please review the CloudFormation template with your security team and switch to the manual setup if required
    ------------ | -------------

### Create the Cost Intelligence Dashboard using a CloudFormation Template

1. Login via SSO in your Cost Optimization account

2. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/cid_cudos.yaml)
	
![Images/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_2.png?classes=lab_picture_small)

3. Enter a **Stack name** for your template such as **Cost-Intelligence-Dashboard-QuickSight**
![Images/cf_dash_3.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_3.png?classes=lab_picture_small)

4. Review **1stReadMe** parameter to confirm prerequisites before specifying the other parameters
![Images/cf_dash_4.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_4.png?classes=lab_picture_small)

5. Update your **AthenaQueryResultsBucket** with the Athena results location where your CUR table is
![Images/cf_dash_4_1.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_4_1.png?classes=lab_picture_small)
To validate your Athena primary workgroup has an output location by  
	- Open a new tab or window and navigate to the **Athena** console
	- Select **Workgroup: primary**
![Images/cf_dash_athena_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_2.png?classes=lab_picture_small)
	- Click the bubble next to **primary** and then select view **detail**
![Images/cf_dash_athena_3.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_3.png?classes=lab_picture_small)
	- Confirm your **Query result location** is configured with an S3 bucket path. 
		- If configured, add the location to the **AthenaQueryResultsBucket** in your CloudFormation Template.
		- If not configured, continue to setting up by clicking **Edit workgroup**
![Images/cf_dash_athena_4.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_4.png?classes=lab_picture_small)
	- Add the **S3 bucket path** you have selected for your Query result location and click save
![Images/cf_dash_athena_5.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_5.png?classes=lab_picture_small)
	- Add the location to the **AthenaQueryResultsBucket** in your CloudFormation Template. 


6. Update your **BucketFolderPath** with the S3 path where your **year partitions of CUR data** are stored
![Images/cf_dash_6.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_6.png?classes=lab_picture_small)
To validate the correct path for your year partitions of the CUR data follow the tasks below:
	- Open a new tab or window and navigate to the **S3** console
	- Select the S3 Bucket your CUR is located in
![Images/cf_dash_s3_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_s3_2.png?classes=lab_picture_small)	
	- Navigate your folders until you find the folder with the **year partitions of the CUR**
![Images/cf_dash_s3_3.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_s3_3.png?classes=lab_picture_small)	
		- Tip: Your yearly partitions folder is located in the folder with your .yml file, monthly folders, and status report
	- Add the identified BucketFolderPath to the CloudFormation parameter making sure to **not add trailing /**  (eg - BucketName/FolderName/.../FolderName)	
		- Tip: copy and paste the **S3 URI** then **remove the leading 's3://' and the ending '/'**

7. Update your **CURDatabaseName** and **CURTableName** with the name of the CUR Athena Database and Table
![Images/cf_dash_6_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_6_2.png?classes=lab_picture_small)
To validate the Athena Database and Table of the CUR data follow the tasks below:
	- Open a new tab or window and navigate to the **Glue** console
	- Select the Athena Table your CUR is located in
![Images/cf_dash_glue_1.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_glue_1.png?classes=lab_picture_small)	
	- Find your Database **CURDatabaseName** and Table **CURTableName** 
![Images/cf_dash_glue_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_glue_2.png?classes=lab_picture_small)
	- Add the identified CURDatabaseName and CURTableName to the CloudFormation parameter

8. Update your **QuickSightUser** with your **QuickSight username** 
![Images/cf_dash_7.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_7.png?classes=lab_picture_small)
To validate your QuickSight complete the tasks below:
	- Open a new tab or window and navigate to the **QuickSight** console
	- Find your username in the top right navigation bar
![Images/cf_dash_qs_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_qs_2.png?classes=lab_picture_small)
	- Add the identified username to the CloudFormation parameter
	
8. Update your **QuicksightIdentityRegion** with your **QuickSight region** 
![Images/cf_dash_8.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_8.png?classes=lab_picture_small)

	- **Optional** add a **Suffix** if you want to create multiple instances of the same account. 

9. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page

10. Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

11. You will see the stack will start in **CREATE_IN_PROGRESS** 
![Images/cf_dash_10.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_10.png?classes=lab_picture_small)

**NOTE:** This step can take 5-15mins
    ------------ | -------------

12. Once complete, the stack will show **CREATE_COMPLETE**
![Images/cf_dash_11.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_11.png?classes=lab_picture_small)

13. Navigate to **Dashboards** page in your QuickSight console, click on your **Cost Intelligence Dashboard name** or your **CUDOS Dashboard name**
![Images/cf_dash_12.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_12.png?classes=lab_picture_small)

14. Set up scheduled SPICE refresh for SPICE Datasets manually or click the **Launch Spice Refresh CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**

	- [Launch Spice Refresh CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/spice_refresh.yaml)
	

**NOTE:** You have successfully created the Cost Intelligence Dashboard. For a detailed description of the dashboard read the [FAQ](/Cost/200_Cloud_Intelligence/Cost_Intelligence_Dashboard_ReadMe.pdf)
    ------------ | -------------

{{% /expand%}}

{{%expand "Click here to continue with the CloudFormation Deployment for the KPI Dashboard" %}}

**NOTE:** An IAM role will be created when you create the CloudFormation stack. Please review the CloudFormation template with your security team and switch to the manual setup if required
    ------------ | -------------

### Create the KPI Dashboard using a CloudFormation Template

Note: This will only work if you **have not** deployed CID and CUDOS using the CloudFormation template above. 

1. Login in to your Cost Optimization account

2. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/kpi.cfn.yml)
	
![Images/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_2.png?classes=lab_picture_small)

3. Enter a **Stack name** for your template such as **KPI-Dashboard-QuickSight**
![Images/cf_dash_3.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_3.png?classes=lab_picture_small)

4. Review **1stReadMe** parameter to confirm prerequisites before specifying the other parameters
![Images/cf_dash_4.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_4.png?classes=lab_picture_small)

5. Update your **AthenaQueryResultsBucket** with the Athena results location where your CUR table is
![Images/cf_dash_4_1.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_4_1.png?classes=lab_picture_small)
To validate your Athena primary workgroup has an output location by  
	- Open a new tab or window and navigate to the **Athena** console
	- Select **Workgroup: primary**
![Images/cf_dash_athena_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_2.png?classes=lab_picture_small)
	- Click the bubble next to **primary** and then select view **detail**
![Images/cf_dash_athena_3.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_3.png?classes=lab_picture_small)
	- Confirm your **Query result location** is configured with an S3 bucket path. 
		- If configured, add the location to the **AthenaQueryResultsBucket** in your CloudFormation Template.
		- If not configured, continue to setting up by clicking **Edit workgroup**
![Images/cf_dash_athena_4.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_4.png?classes=lab_picture_small)
	- Add the **S3 bucket path** you have selected for your Query result location and click save
![Images/cf_dash_athena_5.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_5.png?classes=lab_picture_small)
	- Add the location to the **AthenaQueryResultsBucket** in your CloudFormation Template. 


6. Update your **BucketFolderPath** with the S3 path where your **year partitions of CUR data** are stored
![Images/cf_dash_6.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_6.png?classes=lab_picture_small)
To validate the correct path for your year partitions of the CUR data follow the tasks below:
	- Open a new tab or window and navigate to the **S3** console
	- Select the S3 Bucket your CUR is located in
![Images/cf_dash_s3_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_s3_2.png?classes=lab_picture_small)	
	- Navigate your folders until you find the folder with the **year partitions of the CUR**
![Images/cf_dash_s3_3.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_s3_3.png?classes=lab_picture_small)	
		- Tip: Your yearly partitions folder is located in the folder with your .yml file, monthly folders, and status report
	- Add the identified BucketFolderPath to the CloudFormation parameter making sure to **not add trailing /**  (eg - BucketName/FolderName/.../FolderName)	
		- Tip: copy and paste the **S3 URI** then **remove the leading 's3://' and the ending '/'**

7. Update your **CURDatabaseName** and **CURTableName** with the name of the CUR Athena Database and Table
![Images/cf_dash_6_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_6_2.png?classes=lab_picture_small)
To validate the Athena Database and Table of the CUR data follow the tasks below:
	- Open a new tab or window and navigate to the **Glue** console
	- Select the Athena Table your CUR is located in
![Images/cf_dash_glue_1.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_glue_1.png?classes=lab_picture_small)	
	- Find your Database **CURDatabaseName** and Table **CURTableName** 
![Images/cf_dash_glue_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_glue_2.png?classes=lab_picture_small)
	- Add the identified CURDatabaseName and CURTableName to the CloudFormation parameter

8. Update your **QuickSightUser** with your **QuickSight username** 
![Images/cf_dash_7.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_7.png?classes=lab_picture_small)
To validate your QuickSight complete the tasks below:
	- Open a new tab or window and navigate to the **QuickSight** console
	- Find your username in the top right navigation bar
![Images/cf_dash_qs_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_qs_2.png?classes=lab_picture_small)
	- Add the identified username to the CloudFormation parameter
	
8. Update your **QuicksightIdentityRegion** with your **QuickSight region** 
![Images/cf_dash_8.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_8.png?classes=lab_picture_small)

	- **Optional** add a **Suffix** if you want to create multiple instances of the same account. 

9. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page

10. Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_9.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

11. You will see the stack will start in **CREATE_IN_PROGRESS** 
![Images/cf_dash_10.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_10.png?classes=lab_picture_small)

**NOTE:** This step can take 5-15mins
    ------------ | -------------

12. Once complete, the stack will show **CREATE_COMPLETE**
![Images/cf_dash_11.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_11.png?classes=lab_picture_small)

13. Navigate to **Dashboards** page in your QuickSight console, click on your **KPI Dashboard name** 
![Images/cf_dash_12.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_12.png?classes=lab_picture_small)


**NOTE:** You have successfully created the KPI Dashboard.
    ------------ | -------------

{{% /expand%}}

### Option 3: Manual Deployment (1 hour)
This option is the manual deployment and will walk you through all steps required to create this dashboard without any automation. We recommend this option users new to Athena and QuickSight.

{{%expand "Click here to continue with the manual deployment for the CID" %}}

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

3. Create an **cid_import.json** file using the below sample
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
                    "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                },
                                         {
                     "DataSetPlaceholder": "compute_savings_plan_eligible_spend",
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                 },
                                         {
                     "DataSetPlaceholder": "s3_view",
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                 }
             ],
                     "Arn": "arn:aws:quicksight:us-east-1:223485597511:template/Cost_Intelligence_Dashboard"
         }
     },
     "VersionDescription": "1"
}
```

4. Update the **cid_import.json** to match your details by replacing the following placeholders:

    Placeholder | Replace with
    ------------ | -------------
    \<Account_ID> | AWS Account ID where the dashboard will be deployed
    \<Region> | [Region Code](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) where the dashboard will be deployed (Example eu-west-1)
    \<User ARN> | ARN of your user
    \<DataSetId> | Replace with Dataset ID's from the data sets you created in the Preparing Quicksight section **NOTE:** There are 4 unique Dataset IDs

5. Run the import
```
aws quicksight create-dashboard --cli-input-json file://cid_import.json --region <Region> --dashboard-id cost_intelligence_dashboard
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

{{% /expand%}}

{{%expand "Click here to continue with the  manual deployment of CUDOS" %}}

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
                    "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                },
                                         {
                    "DataSetPlaceholder": "ec2_running_cost",
                    "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                },
                                         {
                     "DataSetPlaceholder": "compute_savings_plan_eligible_spend",
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                 },
                                         {
                     "DataSetPlaceholder": "s3_view",
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"

                 },
                              {
                 "DataSetPlaceholder": "customer_all",
                 "DataSetArn": "arn:aws:quicksight:<Region>:<Account_ID>:dataset/<DatasetID>"
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
	
{{% /expand%}}

{{%expand "Click here to continue with the manual deployment of the KPI Dashboard" %}}

### Create Athena Views

**NOTE:** This dashboard uses the account_map and summary_view as shown in the CID/CUDOS dashboards. If you have not created these dashboards, you will need to create one or both of the dashboards prior to creating the KPI Dashboard 
    ------------ | -------------

The data source for the dashboard will be an Athena view of your existing Cost and Usage Report (CUR). The default dashboard assumes you have both Savings Plans and Reserved Instances. If you do not have both, follow the instructions within each view below to adjust the query accordingly. 

1. Login via SSO in your Cost Optimization account, go into the **Athena** console:


2. Create the **KPI Instance Mapping view** by modifying the following code, and executing it in Athena:
	- [KPI Instance Mapping](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/kpi_instance_mapping_view/)

3. Create the **KPI Instance All view** by modifying the following code, and executing it in Athena:
	- [KPI Instance All](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/kpi_instance_all_view/)

4. Create the **KPI S3 Storage All view** by modifying the following code, and executing it in Athena:
	- [KPI S3 Storage All](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/kpi_s3_storage_all_view/)	

5. Create the **KPI EBS Storage All view** by modifying the following code, and executing it in Athena:
	- [KPI EBS Storage All](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/kpi_ebs_storage_all_view/)

6. Create the **KPI EBS Snap view** by modifying the following code, and executing it in Athena:
	- [KPI EBS Snap](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/kpi_ebs_snap_view/)	

7. Create the **KPI Tracker view** by modifying the following code, and executing it in Athena:
	- [KPI Tracker](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/kpi_tracker_view/)	



**NOTE:** The Athena Views are updated to reflect any additions in the cost and usage report. If you created your dashboard prior to January 18, 2022 you will want to update to the latest views above.
    ------------ | -------------



### Create QuickSight Data Sets

#### Create Datasets

1. Go to the **QuickSight** service homepage inside your account. Be sure to select the correct region from the top right user menu or you will not see your expected tables

    ![qs_region](/Cost/200_Cloud_Intelligence/Images/cur/qs_region.png?classes=lab_picture_small)

2.	From the left hand menu, choose **Datasets**

    ![qs_dataset_sidebar](/Cost/200_Cloud_Intelligence/Images/cur/qs_dataset_sidebar.png?classes=lab_picture_small)
	
3.	Click **New dataset** displayed in the top right corner

    ![qs_dataset](/Cost/200_Cloud_Intelligence/Images/cur/qs_dataset.png?classes=lab_picture_small)
	
    
4.	Select your existing **data source** you created for your CID and/or CUDOS dashboard 

**NOTE:** Your existing data sources are at the bottom of the page 
    ------------ | -------------
	
![qs_data_source_scroll](/Cost/200_Cloud_Intelligence/Images/cur/qs_data_source_scroll.png?classes=lab_picture_small)


5.	Select the database which holds the views you created (reference Athena if you’re unsure which one to select), and select the **kpi_tracker** view then click **Edit/Preview data**

    ![qs_select_datasource](/Cost/200_Cloud_Intelligence/Images/kpi/qs_select_kpi_datasource.png?classes=lab_picture_small)

6.	Select **SPICE** to change your Query mode

    ![qs_dataset_summary](/Cost/200_Cloud_Intelligence/Images/kpi/qs_dataset_kpi.png?classes=lab_picture_small)
	
7.	Select **Save & Publish**

    ![qs_save_summary](/Cost/200_Cloud_Intelligence/Images/kpi/qs_save_kpi.png?classes=lab_picture_small)

8.	Select **Cancel**

    ![qs_save_summary](/Cost/200_Cloud_Intelligence/Images/kpi/qs_cancel_kpi.png?classes=lab_picture_small)	

9.	Select the **kpi_tracker** dataset

    ![qs_select_summary](/Cost/200_Cloud_Intelligence/Images/kpi/qs_select_kpi.png?classes=lab_picture_small)

10.	Click **Schedule refresh**

    ![qs_schedule_refresh](/Cost/200_Cloud_Intelligence/Images/kpi/qs_schedule_refresh.png?classes=lab_picture_small)

11.	Click **Create**

    ![qs_create_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_create_refresh.png?classes=lab_picture_small)

12.	Enter a daily schedule, in the appropriate time zone and click **Create**

    ![qs_daily_refresh](/Cost/200_Cloud_Intelligence/Images/kpi/qs_daily_refresh.png?classes=lab_picture_small)

13.	Click **Cancel** to exit

    ![qs_cancel_refresh](/Cost/200_Cloud_Intelligence/Images/cur/qs_cancel_refresh.png?classes=lab_picture_small)

14.	Click **x** to exit

    ![qs_exit_refresh](/Cost/200_Cloud_Intelligence/Images/kpi/qs_exit_refresh.png?classes=lab_picture_small)

15.	Repeat **steps 3-14**, creating data sets with the remaining Athena views. You will reuse your existing **Cost_Dashboard** data source, and select the following views as the table:

 - kpi_instance_all
 - kpi_s3_storage_all
 - kpi_ebs_storage_all
 - kpi_ebs_snap_view


	**NOTE:** Make sure to reuse the existing Athena data source by scrolling to the bottom of the Data source create/select page when creating a new Dataset instead of creating a new data source  
		------------ | -------------
			![qs_data_source_scroll](/Cost/200_Cloud_Intelligence/Images/cur/qs_data_source_scroll.png?classes=lab_picture_small)

	When this step is complete, your Datasets tab should have **5 new SPICE Datasets** as well as your **existing summary_view dataset** and any existing datasets 
	

**NOTE:** This completes the QuickSight Data Preparation section. Next up is the Import process to generate the QuickSight Dashboard.
    ------------ | -------------

### Import Dashboard Template
We will now use the AWS CLI to create the dashboard from the KPI Dashboard template.

1. Edit and Run `list-users` and make a note of your **User ARN**:
```
aws quicksight list-users --aws-account-id <Account_ID> --namespace default --region <Region>
```

2. Edit and Run `list-data-sets` and make a note of the **Name** and **Arn** for the **5 Datasets ARNs**:
```
aws quicksight list-data-sets --aws-account-id <Account_ID> --region <Region>
```

3. Create an **kpi_import.json** file using the below sample
```
{
    "AwsAccountId": "<Account_ID>",
    "DashboardId": "kpi_dashboard",
    "Name": "KPI Dashboard",
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
                     "DataSetPlaceholder": "kpi_tracker", 
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"
                 },
                {
                    "DataSetPlaceholder": "summary_view", 
                    "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"
                 },
                 {
                     "DataSetPlaceholder": "kpi_instance_all", 
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"
                 },
                 {
                     "DataSetPlaceholder": "kpi_s3_storage_all", 
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"
                 },				 
                 {
                     "DataSetPlaceholder": "kpi_ebs_storage_all", 
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"
                 },
                 {
                     "DataSetPlaceholder": "kpi_ebs_snap", 
                     "DataSetArn": "arn:aws:quicksight:<Region>:<Account ID>:dataset/<DatasetID>"
                 }				 						 			 				 
             ],
                     "Arn": "arn:aws:quicksight:us-east-1:223485597511:template/kpi_dashboard"
         }
     },
     "VersionDescription": "1"
}
```

4. Update the **kpi_import.json** to match your details by replacing the following placeholders:

    Placeholder | Replace with
    ------------ | -------------
    \<Account_ID> | AWS Account ID where the dashboard will be deployed
    \<Region> | [Region Code](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) where the dashboard will be deployed (Example eu-west-1)
    \<User ARN> | ARN of your user
    \<DataSetId> | Replace with Dataset ID's from the data sets you created in the Preparing Quicksight section **NOTE:** There are 6 unique Dataset IDs

5. Run the import
```
aws quicksight create-dashboard --cli-input-json file://kpi_import.json --region <Region> --dashboard-id kpi_dashboard
```

6. Check the status of your deployment
```
aws quicksight describe-dashboard --dashboard-id kpi_dashboard --region <Region> --aws-account-id <Account_ID>
```

If you encounter no errors, open **QuickSight** from the AWS Console, and navigate to **Dashboards**. You should now see **KPI Dashboard** available. This dashboard can be shared with other users, but is otherwise ready for viewing and customizing.

If something goes wrong in the dashboard creation step, correct the issue then delete the failed deployment before re-deploying

```
aws quicksight delete-dashboard --dashboard-id kpi_dashboard --region <Region> --aws-account-id <Account_ID>
```
{{% /expand%}}


### Saving and Sharing your Dashboard in QuickSight
Now that you have your dashboard created you can share your dashboard with users or customize your own version of this dashboard.
	
- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)
	
### Add your Account Names to your Dashboard
Learn how to replace the Accound IDs with the Account Names for each of your linked accounts in AWS Organizations by following these steps. 

- [Steps for adding account names](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/0_view0/)

### Update Dashboard Template - Optional

{{%expand "Click here to update your dashboard with the latest version" %}}

If you are tracking our [Changelog](https://github.com/aws-samples/aws-cudos-framework-deployment/blob/main/changes/CHANGELOG-kpi.md), you already know that we are always improving the Cloud Intelligence Dashboards.

To pull the latest version of the dashboard from the public template please use the following steps.

#### Option 1: Command Line Tool

1. In your Terminal application write the following command and press enter. 

```bash
cid-cmd update
```

1. Choose the dashboard you wish to update and press enter.  

#### Option 2: Manual Update

1. Create a **cid_update.json** file by removing permissions section from the **cid_import.json** file. Sample for Cost Intelligence Dashboard **cid_update.json** file below:
```json
{
    "AwsAccountId": "<Account_ID>",
    "DashboardId": "cost_intelligence_dashboard",
    "Name": "Cost Intelligence Dashboard",
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
          }
        ],
        "Arn": "arn:aws:quicksight:us-east-1:223485597511:template/Cost_Intelligence_Dashboard"
          }
      }
}
```

2. If needed update the **cid_update.json** to match your details by replacing the following placeholders:

    Placeholder | Replace with
    ------------ | -------------
    \<Account_ID> | AWS Account ID where the dashboard will be deployed
    \<Region> | [Region Code](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) where the dashboard will be deployed (Example eu-west-1)
    \<DatasetID> | Replace with Dataset ID's from the datasets you created in the Preparing Quicksight section **NOTE:** There are 4 unique Dataset IDs


3. Pull the latest published version of the dashboard template. Example for CID Dashboard below:
```
aws quicksight update-dashboard --cli-input-json file://cid_update.json --region <region>
```

4. Query the version number of the published dashboard. Example for CID Dashboard below:
```
aws quicksight list-dashboard-versions --region <region> --aws-account-id <Account_ID> --dashboard-id cost_intelligence_dashboard
```

5. Apply the latest pulled changes to the deployed dashboard with this CLI command. Example for CID Dashboard below:
```
aws quicksight update-dashboard-published-version --region <region> --aws-account-id <Account_ID> --dashboard-id cost_intelligence_dashboard --version-number <version>
```
**NOTE:** The update commands were successfully tested in AWS CloudShell (recommended)
    ------------ | -------------
	
{{% /expand%}}

### Next Steps ###
- Visit our [customizations lab](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/customizations/) to learn some ways to customize your dashboards. 
- Having trouble? Visit [our FAQ](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/faq/). 

{{< prev_next_button link_prev_url="../1_prerequistes/" link_next_url="../3_additional_dashboards/" />}}
