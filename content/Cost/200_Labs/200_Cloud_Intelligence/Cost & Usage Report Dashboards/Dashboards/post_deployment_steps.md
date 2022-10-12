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

1. In CloudShell (or if you prefer your Terminal with credentials into the AWS account), run the following command and make sure you hit enter ```python3 -m ensurepip --upgrade```
2. Then type the following command and press enter ```pip3 install --upgrade cid-cmd``` 
3. Then type the following command and press enter ```cid-cmd update``` 
4. Choose the dashboard you wish to update and press enter.  
{{% /expand%}}

### Next Steps ###
- Visit our [customizations lab](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/customizations/) to learn some ways to customize your dashboards. 
- Having trouble? Visit [our FAQ](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/faq/). 



{{< prev_next_button link_prev_url="../deploy_dashboards" link_next_url="../alternative_deployments" />}}


