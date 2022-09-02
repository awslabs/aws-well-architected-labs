---
title: "Additional Dashboards"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Introduction
In addition to the two foundational Cloud Intelligence Dashboards CUR Dashboards, Cost Intelligence Dashboard and CUDOS, we have service and specific use case dashboards that help you dive deeper and gain additional insights.

### Data Transfer Dashboard

The Data Transfer Dashboard is an interactive, customizable and accessible QuickSight dashboard to help customers gain insights into their data transfer. It will analyze any data transfer that incurs a cost such as outbound internet and regional data transfer from all services.

This dashboard contains data transfer breakdowns with the following visuals:
 - Amount and cost by service and region
 - Between regions
 - Internet data transfer, AWS Global Accelerator usage details for estimation
 - Regional Data transfer
 - CloudFront cost and usage analysis

## Authors
- Chaitanya Shah, Sr. Technical Account Manager 

{{%expand "Click here to continue with the  Data Transfer Dashboard deployment" %}}

![Images/quicksight_dashboard_dt_new_analysis.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt_new_analysis.png)

### FAQ
The FAQ for this dashboard is [here.](/Cost/200_Enterprise_Dashboards/Cost_Intelligence_Dashboard_ReadMe.pdf)


### Introduction

The Data Transfer Dashboard is an interactive, customizable and accessible QuickSight dashboard to help customers gain insights into their data transfer. It will analyze any data transfer that incurs a cost such as outbound internet and regional data transfer from all services.

This dashboard contains data transfer breakdowns with the following visuals:
 - Amount and cost by service and region
 - Between regions
 - Internet data transfer 
 - Regional Data transfer

### Request Template Access
Ensure you have requested access to the Cost Intelligence template [here.](http://d3ozd1vexgt67t.cloudfront.net/)

### Create Athena Views
The data source for the dashboard will be an Athena view of your existing Cost and Usage Report (CUR). 

1. Login via SSO in your Cost Optimization account, go into the **Athena** console:

2. Create the **Data Transfer view** by modifying the following code, and executing it in Athena or using aws cli: 
    - [Data Transfer View](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/code/7_view7/)


**NOTE** The Athena Views are updated to reflect any additions in the cost and usage report. If you created your dashboard prior to July 26, 2020 you will want to update to the latest views.
    ------------ | -------------



### Create QuickSight Data Sets
We will now create the data sets in QuickSight from the Athena views.

1. Go to the **QuickSight** service homepage

2. Click on the **Datasets** and then click on **New dataset**
![Images/quicksight_dashboard_dt-2.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt-2.png)

3. Click **Athena**
![Images/quicksight_dashboard_dt-3.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt-3.png)

4. Enter a data source name of **DataTransfer_Cost_Dashboard** and click **Create data source**:
![Images/quicksight_dashboard_dt-4.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt-4.png)

5. Select the **costmaster** database, and the **data_transfer_view** table, click **Edit/Preview data**:
![Images/quicksight_dashboard_dt-5.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt-5.png)

**NOTE:**If you have large data for data transfer in CUR, we do NOT recommend using SPICE when setting up your data set in QuickSight, you can quickly use up the 10GB/user allocation and start to incur additional charges. Please use your judgment before enabling it.
    ------------ | -------------

6. Select **SPICE** to change your Query mode:
![Images/quicksight_dataset_6.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt-6.png)

7. Click on **region**  to get the drop down arrow and click on it, then hover over **Change data type** then select **# String**

8. Select **Save & Publish** and then Click on **Cancel**:
![Images/quicksight_dashboard_dt-8.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt-8.png)

9. Select the **data_transfer_view** Data Set:
![Images/quicksight_dashboard_dt-9.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt-9.png)

10. Click **Schedule refresh**:
![Images/quicksight_dashboard_dt-10.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt-10.png)

11. Click **Create**:
![Images/quicksight_dataset_13.png)](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dataset_13.png)

12. Enter a schedule, it needs to be refreshed daily, and click **Create**:
![Images/quicksight_dashboard_dt-12.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt-11.png)

13. Click **Cancel** to exit:
![Images/quicksight_dashboard_dt-12.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt-12.png)

14. Click the **x** in the top corner:
![Images/qquicksight_dashboard_dt-13.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt-13.png)

{{% notice tip %}}
You now have your data set setup ready to create a visualization.
{{% /notice %}}


### Create the Dashboard
We will now use the CLI to create the dashboard from the Data Transfer Cost and Usage Analysis Dashboard template, then create an Analysis you can customize and modify in the next step.

1. If you have not requested access, go to this we page to request access to the template: [Template Access](http://d3ozd1vexgt67t.cloudfront.net/)

2. Edit the following command, replacing **AccountID** with your account ID, and **region** with the region you are working in, then using the CLI list the QuickSight datasets and copy the **Name** and **Arn** for the dataset: **data_transfer_view**:

        aws quicksight list-data-sets --aws-account-id (AccountID) --region (region)
    &nbsp;

        {
            "Arn": "arn:aws:quicksight:us-east-1:<your account id>:dataset/fc0cf1eb-173b-4aca-93b6-f58784637732",
            "DataSetId": "fc0cf1eb-173b-4aca-93b6-f58784637732",
            "Name": "data_transfer_view",
            "CreatedTime": "2020-08-09T23:06:41.666000-04:00",
            "LastUpdatedTime": "2020-08-11T23:15:35.438000-04:00",
            "ImportMode": "SPICE"
        }

  <!-- ![Images/quicksight_dashboard_2.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_2.png) -->

3. Get your users **Arn** by editing the following command, replacing **AccountID** with your account ID, and **region** with the region you are working in, then using the CLI run the command:

        aws quicksight list-users --aws-account-id (AccountID) --namespace default --region (region)
    
    &nbsp;

        {
                "Arn": "arn:aws:quicksight:us-east-1:<your account id>:user/default/<your user>",
                "UserName": "<your user>",
                "Email": "<your user email>",
                "Role": "ADMIN",
                "Active": true,
                "PrincipalId": "<principal id>"
        }

 <!-- ![Images/quicksight_dashboard_3.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_3.png) -->

4. Create a local file **create-data-transfer-dashboard.json** with the text below, replace the values **(Account ID)** with your account ID on line 2 and line 25, **(User ARN)** with your user ARN on line 7, and **(DataTransfer view Dataset ID)** with your dataset ARN on line 25:

        {
            "AwsAccountId": "(Account ID)",
            "DashboardId": "data_transfer_cost_analysis_dashboard_enhanced",
            "Name": "DataTransfer Cost Analysis Dashboard Enhanced",
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
                            "DataSetPlaceholder": "data_transfer_view",
                            "DataSetArn": "arn:aws:quicksight:us-east-1:(Account ID):dataset/(DataTransfer view Dataset ID)"

                        }
                    ],
                            "Arn": "arn:aws:quicksight:us-east-1:869004330191:template/data-transfer-aga-est-cost-analysis-template-enhanced-v1"
                }
            },
            "VersionDescription": "1"
        }

5. To create the dashboard from the template, edit then run the following command, replacing **(region)** with the region you are working in, and you should receive a 202 response:

        aws quicksight create-dashboard --cli-input-json file://create-data-transfer-dashboard.json --region (region)
    - Response:
![Images/quicksight_dashboard_dt_resp.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt_resp.png)

6. After a few minutes the dashboard will become available in QuickSight under **All dashboard**, click on the **Dashboard name**:
![Images/quicksight_dashboard_dt-14.png](/Cost/200_Cloud_Intelligence/Images/cid/quicksight_dashboard_dt-14.png)

7. Follow step 7 if you do not see your dashboard

Edit and run the following command:

        aws quicksight describe-dashboard --aws-account-id (Account ID) --dashboard-id data_transfer_cost_analysis_dashboard --region (region)

Correct the listed errors and run the **delete-dashboard** command followed by the original **create-dashboard** command:
		
        aws quicksight delete-dashboard --aws-account-id (Account ID) --dashboard-id data_transfer_cost_analysis_dashboard --region (region)




**NOTE:** You have successfully created the analysis from a template. For a detailed description of the dashboard read the [FAQ](/Cost/200_Enterprise_Dashboards/Cost_Intelligence_Dashboard_ReadMe.pdf)
    ------------ | -------------


### Saving and Sharing your Dashboard in QuickSight
Now that you have your dashboard created you can share your dashboard with users or customize your own version of this dashboard
	
- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)	

{{% /expand%}}

### Trends Dashboard

The Trends Dashboard provides Financial and Technology organizational leaders access to proactive trends, signals, insights and anomalies to understand and analyze their AWS cloud usage.

{{%expand "Click here to continue with the Trends Dashboard deployment" %}}
- [Click to navigate Trends Dashboard workshop](https://cudos.workshop.aws/workshop-trends.html)

**NOTE:** The Trends Dashboard is provided as an AWS Workshop and not an official Well-Architected lab due to the differences in the data sets and attribute names. All dashboards should be validated before use. 
    ------------ | -------------

 {{% /expand%}}

{{< prev_next_button link_prev_url="../2_deploy_dashboards"  link_next_url="https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/">}}
