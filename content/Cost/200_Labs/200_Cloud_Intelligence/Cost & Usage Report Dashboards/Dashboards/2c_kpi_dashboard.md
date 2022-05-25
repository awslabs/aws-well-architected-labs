---
title: "KPI Dashboard"
date: 2022-01-16T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>2c. </b>"
---

## Authors
- Alee Whitman, Sr. Commercial Architect (AWS OPTICS)

## Contributors 
- Aaron Edell, Global Head of Business and GTM - Customer Cloud Intelligence
- Alex Head, OPTICS Manager 
- Georgios Rozakis, AWS Technical Account Manager
- Oleksandr Moskalenko, Sr. AWS Technical Account Manager
- Timur Tulyaganov, AWS Principal Technical Account Manager
- Yash Bindlish, AWS Technical Account Manager
- Yuriy Prykhodko, AWS Sr. Technical Account Manager

## KPI Dashboard 
The KPI and Modernization Dashboard helps your organization combine DevOps and IT infrastructure with Finance and the C-Suite to grow more efficiently and effectively on AWS. This dashboard lets you set and track modernization and optimization goals such as percent OnDemand, Spot adoption, and Graviton usage. By enabling every line of business to create and track usage goals, and your cloud center of excellence to make recommendations organization-wide, you can grow more efficiently and innovate more quickly on AWS. 

- [Explore a sample KPI Dashboard](https://d1s0yx3p3y3rah.cloudfront.net/anonymous-embed?dashboard=kpi) 

![kpi_sample](/Cost/200_Cloud_Intelligence/Images/kpi/kpi_sample.png?classes=lab_picture_small)

## Prerequisites
KPI dashboard can be only be installed if following products are in billing history (CUR)
- RDS
- Elasticache
If you do not have these products you can install and then delete instances of each product after 1 hour.

	
## Deployment Options
There are 3 options to deploy the KPI Dashboard. Bookmark the [KPI Dashboard Changelog](https://github.com/aws-samples/aws-cudos-framework-deployment/blob/main/changes/CHANGELOG-kpi.md) for the latest version and updates. 

### Option 1: Manual Deployment (1 hour)
This option is the manual deployment and will walk you through all steps required to create this dashboard without any automation. We recommend this option to users who are new to Athena and QuickSight. 
{{%expand "Click here to continue with the manual deployment" %}}

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


### Option 2: Command Line Interface Deployment (15 mins)
The CID command line tool is an optional way to create the Cloud Intelligence Dashboards. The command line tool will allow you to complete the deployments in less than half the time as the standard manual setup.

{{%expand "Click here to continue with the Automation Scripts Deployment" %}}

- Navigate to the [Cloud Intelligence Dashboards automation repo](https://github.com/aws-samples/aws-cudos-framework-deployment/) and follow the instructions to run the command line tool. You will have the option of deploying the KPI dashboard from the list of supported dashboards. 

Once complete, visit the [account mapping page](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/0_view0/) and follow the steps there to get your account names into the dashboard. 
{{% /expand%}}


### Option 3: CloudFormation Deployment (30 mins)
This section is **optional** and automates the creation of the KPI Dashboard using **CloudFormation templates**. The CloudFormation templates allows you to complete the lab in less than half the time as the standard setup. You will require permissions to modify CloudFormation templates and create an IAM role. **If you do not have the required permissions use the Manual Deployment**. 

{{%expand "Click here to continue with the CloudFormation Deployment" %}}

**NOTE:** An IAM role will be created when you create the CloudFormation stack. Please review the CloudFormation template with your security team and switch to the manual setup if required
    ------------ | -------------

### Create the KPI Dashboard using a CloudFormation Template

1. Login via SSO in your Cost Optimization account

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

### Saving and Sharing your Dashboard in QuickSight
Now that you have your dashboard created you can share your dashboard with users or customize your own version of this dashboard
	
- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)	

{{% /expand%}}

### Saving and Sharing your Dashboard in QuickSight
Now that you have your dashboard created you can share your dashboard with users or customize your own version of this dashboard.
	
- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)
	


### Update Dashboard Template - Optional

{{%expand "Click here to update your dashboard with the latest version" %}}

If you are tracking our [Changelog](https://github.com/aws-samples/aws-cudos-framework-deployment/blob/main/changes/CHANGELOG-kpi.md), you already know that we are always improving the Cloud Intelligence Dashboards.

#### Option 1: Command Line Tool
Visit the [GitHub repository](https://github.com/aws-samples/aws-cudos-framework-deployment/) to download and install the CID Command Line Tool and follow the instructions for running the `update` command. 

#### Option 2: Manual Update

To pull the latest version of the dashboard from the public template please use the following steps.

1. Create a **kpi_update.json** file by removing permissions section from the **kpi_import.json** file. Sample for KPI Dashboard **kpi_update.json** file below:
```json
{
    "AwsAccountId": "<Account_ID>",
    "DashboardId": "kpi_dashboard",
    "Name": "KPI Dashboard",
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
            "DataSetArn": "arn:aws:quicksight:<region>:<Account_ID>:dataset/<DatasetID>"
          },
          {
            "DataSetPlaceholder": "summary_view",
            "DataSetArn": "arn:aws:quicksight:<region>:<Account_ID>:dataset/<DatasetID>"
          },
          {
            "DataSetPlaceholder": "kpi_instance_all",
            "DataSetArn": "arn:aws:quicksight:<region>:<Account_ID>:dataset/<DatasetID>"
          },
          {
            "DataSetPlaceholder": "kpi_s3_storage_all",
            "DataSetArn": "arn:aws:quicksight:<region>:<Account_ID>:dataset/<DatasetID>"
          },
          {
            "DataSetPlaceholder": "kpi_ebs_storage_all",
            "DataSetArn": "arn:aws:quicksight:<region>:<Account_ID>:dataset/<DatasetID>"
          },		  
          {
            "DataSetPlaceholder": "kpi_ebs_snap",
            "DataSetArn": "arn:aws:quicksight:<region>:<Account_ID>:dataset/<DatasetID>"
          }
        ],
        "Arn": "arn:aws:quicksight:us-east-1:223485597511:template/kpi_dashboard"
          }
      }
}
```

2. If needed update the **kpi_update.json** to match your details by replacing the following placeholders:

    Placeholder | Replace with
    ------------ | -------------
    \<Account_ID> | AWS Account ID where the dashboard will be deployed
    \<Region> | [Region Code](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html#concepts-available-regions) where the dashboard will be deployed (Example eu-west-1)
    \<DatasetID> | Replace with Dataset ID's from the datasets you created in the Preparing QuickSight section **NOTE:** There are 6 unique Dataset IDs


3. Pull the latest published version of the dashboard template. Example for KPI Dashboard below:
```
aws quicksight update-dashboard --cli-input-json file://kpi_update.json --region <region>
```

4. Query the version number of the published dashboard. Example for KPI Dashboard below:
```
aws quicksight list-dashboard-versions --region <region> --aws-account-id <Account_ID> --dashboard-id kpi_dashboard 
```

5. Apply the latest pulled changes to the deployed dashboard with this CLI command. Example for KPI Dashboard below:
```
aws quicksight update-dashboard-published-version --region <region> --aws-account-id <Account_ID> --dashboard-id kpi_dashboard --version-number <version>
```
**NOTE:** The update commands were successfully tested in AWS CloudShell (recommended)
    ------------ | -------------

{{% /expand%}}
