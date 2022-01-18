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
- Cristian Popa, AWS Sr. Technical Account Manager
- Oleksandr Moskalenko, Sr. AWS Technical Account Manager
- Timur Tulyaganov, AWS Principal Technical Account Manager
- Yash Bindlish, AWS Technical Account Manager
- Yuriy Prykhodko, AWS Sr. Technical Account Manager

## KPI Dashboard 
The KPI and Modernization Dashboard helps your organization combine DevOps and IT infrastructure with Finance and the C-Suite to grow more efficiently and effectively on AWS. This dashboard lets you set and track modernization and optimization goals such as percent On Demand, Spot adoption, and Graviton usage. By enabling every line of business to create and track usage goals, and your cloud center of excellence to make recommendations organization-wide, you can grow more efficiently and innovate more quickly on AWS. 

Example of KPI Dashboard:

![kpi_sample](/Cost/200_Cloud_Intelligence/Images/kpi/kpi_sample.png?classes=lab_picture_small)
	

### Option 1: Manual Deployment
This option is the manual deployment and will walk you through all steps required to create this dashboard without any automation. We recommend this option to users who are new to Athena and QuickSight. 
{{%expand "Click here to continue with the manual deployment" %}}

### Optional 2: Command Line Tool Deployment
Coming Soon.

### Option 3: CloudFormation Deployment
Coming Soon.

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

### Saving and Sharing your Dashboard in QuickSight
Now that you have your dashboard created you can share your dashboard with users or customize your own version of this dashboard
	
- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)
	
	
{{% /expand%}}



### Update Dashboard Template - Optional

{{%expand "Click here to update your dashboard with the latest version" %}}

If you are tracking our [Changelog](https://github.com/aws-samples/aws-cudos-framework-deployment/blob/main/changes/CHANGELOG-kpi.md), you already know that we are always improving the Cloud Intelligence Dashboards.

To pull the latest version of the dashboard from the public template please use the following steps.

1. Create an **update.json** file by removing permissions section from the **kpi_import.json** file. Sample for KPI Dashboard **kpi_update.json** file below:
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
    \<DatasetID> | Replace with Dataset ID's from the datasets you created in the Preparing Quicksight section **NOTE:** There are 6 unique Dataset IDs


3. Pull the latest published version of the dashboard template. Example for KPI Dashboard below:
```
aws quicksight update-dashboard --cli-input-json file://kpi_update.json --region <region>
```

4. Query the version number of the published dashboard. Example for KPI Dashboard below:
```
aws quicksight list-dashboard-versions --region <region> --aws-account-id <Account_ID> --dashboard-id kpi_dashboard --query 'sort_by(DashboardVersionSummaryList, &VersionNumber)[-1].VersionNumber'
```

5. Apply the latest pulled changes to the deployed dashboard with this CLI command. Example for KPI Dashboard below:
```
aws quicksight update-dashboard-published-version --region <region> --aws-account-id <Account_ID> --dashboard-id kpi_dashboard --version-number <version>
```

{{% /expand%}}

{{< prev_next_button link_prev_url="../2b_cudos_dashboard" link_next_url="../3_additional_dashboards" />}}
