---
title: "Setup QuickSight Dashboard"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

We will now setup the QuickSight dashboard to visualize your usage by cost, and setup the analysis to provide Savings Plan recommendations.

1. Go to the QuickSight service:
![Images/home_quicksight.png](/Cost/200_Pricing_Model_Analysis/Images/home_quicksight.png)

2. Click on **Manage data**:
![Images/quicksight_managedata.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_managedata.png)

3. Click on **New data set**:
![Images/quicksight_newdataset.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_newdataset.png)

4. Click **Athena**:
![Images/quicksight_athenadataset.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_athenadataset.png)

5. Enter a Data source name of **SP_Usage** and click **Create data source**:
![Images/quicksight_namedatasource.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_namedatasource.png)

6. Select the **costmaster** database, and the **sp_usage** table, click **Select**:
![Images/quicksight_choosetable.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_choosetable.png)

7. Ensure SPICE is selected, click **Visualize**:
![Images/quicksight_datasetfinish.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_datasetfinish.png)

8. Click on **QuickSight** to go to the home page:
![Images/quicksight_home.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_home.png)

9. Click on **Manage data**:
![Images/quicksight_managedata.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_managedata.png)

10. Select the **sp_usage** Dataset:
![Images/quicksight_refresh1.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_refresh1.png)

11. Click **Schedule refresh**:
![Images/quicksight_refresh2.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_refresh2.png)

12. Click **Create**:
![Images/quicksight_refresh3.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_refresh3.png)

13. Enter a schedule, it needs to be refreshed daily, and click **Create**:
![Images/quicksight_refresh4.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_refresh4.png)

14. Click **Cancel** to exit:
![Images/quicksight_refresh5.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_refresh5.png)

15. Click the **x** in the top corner:
![Images/quicksight_refresh6.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_refresh6.png)

{{% notice tip %}}
You now have your data set setup ready to create a visualization.
{{% /notice %}}




### Advanced Setup
This section is **optional** and replaces the next two steps by creating the dashboard from a template. You will require access and knowledge of the AWS CLI, and **Enterprise** edition of QuickSight. If you do not have the access, go to the next step and manually create the dashboard as per the lab.

1. Go to this web page to request access to the template. Enter you AWS AccountID and click Submit: [Template Access](http://d3ozd1vexgt67t.cloudfront.net/)


2. Edit the following command, replacing **AccountID** and **region**, then using the CLI list the QuickSight datasets and copy the **Arn** for the **sp_usage** dataset:

        aws quicksight list-data-sets --aws-account-id (AccountID) --region (region)

![Images/quicksight_datasets.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_datasets.png)

3. Edit the following command, replacing **AccountID** and **region**, then using the CLI list your QuickSight users ARNs:

        aws quicksight list-users --aws-account-id (AccountID) --namespace default --region (region)

![Images/quicksight_users.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_users.png)

4. Create a local file **create-dashboard.json** with the text below, replace the values **(Account ID)**, **(User ARN)**, **(Dataset ARN)**:

        {
            "AwsAccountId": "(Account ID)",
            "DashboardId": "SP_usage_analysis",
            "Name": "sp_usage analysis",
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
                            "DataSetPlaceholder": "sp_usage",
                            "DataSetArn": "(Dataset ARN)"

                        }
                    ],
                            "Arn": "arn:aws:quicksight:us-east-1:869004330191:template/SP-Analysis-template"
                }
            },
            "VersionDescription": "1"
        }

5. Edit the following command, replacing **(region)**, Run the command to create the dashboard and you should get a 200 response:

        aws quicksight create-dashboard --cli-input-json file://create-dashboard.json --region (region)

![Images/cli_dashboard_creating.png](/Cost/200_Pricing_Model_Analysis/Images/cli_dashboard_creating.png)

6. After a few minutes the dashboard will become available in QuickSight, click on the **Dashboard name**:
![Images/qsdashboard_analysis.png](/Cost/200_Pricing_Model_Analysis/Images/qsdashboard_analysis.png)

7. Click **Share**, click **Share dashboard**, 
![Images/qsdashboard_share.png](/Cost/200_Pricing_Model_Analysis/Images/qsdashboard_share.png)

8. Add the required users, or share with all users, ensure you check **Save as** for each user:
![Images/qsshare_details.png](/Cost/200_Pricing_Model_Analysis/Images/qsshare_details.png)

9. Click **Save as**:
![Images/qsdashboard_saveas.png](/Cost/200_Pricing_Model_Analysis/Images/qsdashboard_saveas.png)

10. Enter an **Analysis name** and click **Create**:
![Images/qssaveas_analysis.png](/Cost/200_Pricing_Model_Analysis/Images/qssaveas_analysis.png)

11. You will now have the analysis created automatically from the template:
![Images/qs_finished.png](/Cost/200_Pricing_Model_Analysis/Images/qs_finished.png)

{{% notice tip %}}
You have successfully created the analysis from a template, this lab is complete.
{{% /notice %}}



