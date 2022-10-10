---
title: "Post Deployment Steps"
date: 2022-10-10T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2 </b>"
---

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

### Option 1: Command Line Tool

1. In your Terminal application write the following command and press enter. 

```bash
cid-cmd update
```

1. Choose the dashboard you wish to update and press enter.  

### Option 2: Manual Update

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



{{< prev_next_button link_prev_url="../deploy_dashboards" link_next_url="../alternative_deployments" />}}


