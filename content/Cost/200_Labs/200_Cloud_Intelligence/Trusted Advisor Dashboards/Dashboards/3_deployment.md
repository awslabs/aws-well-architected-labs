---
title: "TAO Dashboard Deployment"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Deployment Options
There are 2 options to deploy the TAO Dashboard.

### Option 1: Automation Scripts Deployment
The [Cloud Intelligence Dashboards automation repo](https://github.com/aws-samples/aws-cudos-framework-deployment) is an optional way to create the Cloud Intelligence Dashboards using a collection of setup automation scripts. The supplied scripts allow you to complete the workshops in less than half the time as the standard manual setup.

{{%expand "Click here to continue with the Automation Scripts Deployment" %}}

- Follow the [How to use steps](https://github.com/aws-samples/aws-cudos-framework-deployment#how-to-use) for installation and dashboard deployment. We recommend to use **AWS CloudShell** for automated deployment
{{% /expand%}}

### Option 2: CloudFormation Deployment
This section is optional way to deploy TAO Dashboard using a **CloudFormation template**. The CloudFormation template allows you to complete the lab in less than half the time as the standard setup. You will require permissions to modify CloudFormation templates and create an IAM role. **If you do not have the required permissions use Automation Scripts Deployment**. 

{{%expand "Click here to continue with the CloudFormation Deployment" %}}

Please use the CloudFormation documentation described in the section for [CUR related dashboards](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/).

{{% /expand%}}


### Saving and Sharing your Dashboard in QuickSight 
Now that you have your dashboard created you will need want to share your dashboard with users or customize your own version of this dashboard
	- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)

{{< prev_next_button link_prev_url="../2_create-upload-ta-report" link_next_url="../4_update-dashboard" />}}
