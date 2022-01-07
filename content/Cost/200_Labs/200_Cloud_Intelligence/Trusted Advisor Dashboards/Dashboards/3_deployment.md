---
title: "TAO Dashboard Deployment"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Deployment Options
There are 3 options to deploy the TAO Dashboard. If you are unsure what option to select, we recommend using the Manual deployment


### Option 1: Manual Deployment
This option is the manual deployment and will walk you through all steps required to create this dashboard without any automation. We recommend this option users new to Athena and QuickSight. 
{{%expand "Click here to continue with the  manual deployment" %}}
### Stage 1 - Prepare config files

1. **Collect information to create config files**
    + `{account}` - AWS Account in which Dashboard is deployed
    + `{region}` - AWS region for dashboard deployment
    + `{user_arn}` - QuickSight user arn with admin permissions.
    
    Can be retrieved with following command:
    ```bash
    aws quicksight list-users --aws-account-id {account} --namespace default --region {region} --query 'UserList[*].Arn'
    ```
    + `{s3FolderPath}` - path to S3 folder created in Stage 1 in following format `s3://{bucket_name}/reports/`
    + `{databaseName}` - AWS glue data catalog database name. You can use any existing database or create new

1. **Create AWS Glue database**
    ![Image](/Cost/200_Cloud_Intelligence/Images/Glue_databaseName.png?classes=lab_picture_small)

1. **Download following files and replace placeholders with respective values**
    + [athena-table.json](/Cost/200_Cloud_Intelligence/templates/tao/athena-table.json) - placeholders `{databaseName}` in **line 2**, `{account}` in **line 3** and `{s3FolderPath}` in **line 7**
    + [dashboard-input.json](/Cost/200_Cloud_Intelligence/templates/tao/dashboard-input.json) - placeholders `{account}` in **lines 2 and 30**, `{region}` in **line 30** and `{user_arn}` in **line 7**
    + [data-set-input.json](/Cost/200_Cloud_Intelligence/templates/tao/data-set-input.json) - placeholders `{user_arn}` in **line 6**, `{account}` in **line 24**, `{region}` in **line 24**, `{databaseName}` in **line 26**
    + [data-source-input.json](/Cost/200_Cloud_Intelligence/templates/tao/data-source-input.json) - placeholder `{user_arn}` in **line 15**
    + [update-dashboard-input.json](/Cost/200_Cloud_Intelligence/templates/tao/update-dashboard-input.json) - placeholder `{account}` in **line 2 and 15** and `{region}` in **line 15**

    **OR**
    
    [download all templates in one click](/Cost/200_Cloud_Intelligence/templates/tao/templates.zip)

### Stage 2 - Create required resources and deploy dashboard

1. **We recommend to use AWS CloudShell for workshop**
    ![Image](/Cost/200_Cloud_Intelligence/Images/CloudShell.png?classes=lab_picture_small)

1. Verify **AWS CLI** is **v2.1.16** and above. Check the version by issuing the `aws --version` command at the shell prompt. To upgrade AWS CLI, find the [instructions here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

1. Upload all 5 config files to **CloudShell**

1. **Using CloudShell** change a directory to where you've uploaded files in the previous step

1. Create resources
    + Create Glue table is the metadata definition:
    ```
    aws glue create-table --region {region} --cli-input-json file://athena-table.json
    ```

    + Create QuickSight datasource:
    ```
    aws quicksight create-data-source --aws-account-id {account} --region {region} --cli-input-json file://data-source-input.json
    ```

    + Create QuickSight dataset:
    ```
    aws quicksight create-data-set --aws-account-id {account} --region {region} --cli-input-json file://data-set-input.json
    ```

    + Create QuickSight dashboard:
    ```
    aws quicksight create-dashboard --aws-account-id {account} --region {region} --cli-input-json file://dashboard-input.json
    ```

    + Get status of dashboard deployment:
    ```
    aws quicksight describe-dashboard --aws-account-id {account} --region {region} --dashboard-id ta-organizational-view
    ```
**NOTE:** Congratulations dashboard is deployed! Please log in to QuickSight and open `https://{region}.quicksight.aws.amazon.com/sn/dashboards/ta-organizational-view/`
    ------------ | -------------	

{{% /expand%}}
### Option 2: Automation Scripts Deployment
The [Cloud Intelligence Dashboards automation repo](https://github.com/aws-samples/aws-cudos-framework-deployment) is an optional way to create the Cloud Intelligence Dashboards using a collection of setup automation scripts. The supplied scripts allow you to complete the workshops in less than half the time as the standard manual setup.

{{%expand "Click here to continue with the Automation Scripts Deployment" %}}

- Follow the [How to use steps](https://github.com/aws-samples/aws-cudos-framework-deployment#how-to-use) for installation and dashboard deployment. We recommend to use **AWS CloudShell** for automated deployment
{{% /expand%}}

### Option 3: CloudFormation Deployment
This section is optional way to deploy TAO Dashboard using a **CloudFormation template**. The CloudFormation template allows you to complete the lab in less than half the time as the standard setup. You will require permissions to modify CloudFormation templates and create an IAM role. **If you do not have the required permissions use the Manual or Automation Scripts Deployment**. 

{{%expand "Click here to continue with the CloudFormation Deployment" %}}

**NOTE:** An IAM role will be created when you create the CloudFormation stack. Please review the CloudFormation template with your security team and switch to the manual setup if required
    ------------ | -------------

### Create TAO Dashboard using a CloudFormation Template

1. Login via SSO in your Cost Optimization account

2. Click the **Launch CloudFormation button** below to open the **pre-populated stack template** in your CloudFormation console and select **Next**

	- [Launch CloudFormation Template](https://console.aws.amazon.com/cloudformation/home#/stacks/new?&templateURL=https://aws-well-architected-labs.s3.us-west-2.amazonaws.com/Cost/Labs/200-cloud-intelligence-dashboards/tao.cfn.yml)
	
![Images/cf_dash_2.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_2.png?classes=lab_picture_small)

3. Enter a **Stack name** for your template such as **TAO-Dashboard-QuickSight**
![Images/cf_dash_3.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_3.png?classes=lab_picture_small)

4. Review **Information** parameter to confirm prerequisites before specifying the other parameters
![Images/cf_dash_4.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_4.png?classes=lab_picture_small)

5. Update your **S3 Bucket Path to the TA Reports** with the S3 path where your **Trusted Advisor reports** are stored. Path should look like ``s3://{bucketname}/reports`` or ``s3://costoptimizationdata{account_id}/optics-data-collector/ta-data/`` depending on data collection method used in [Create and Upload Trusted Advisor Report](http://localhost:1313/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/dashboards/2_create-upload-ta-report/) step before.
![Images/cf_dash_5.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_5.png?classes=lab_picture_small)


6. Update your **Athena Database Name** with the name of the CUR Athena Database where you want to deploy table for TA reports. Leave **default** if you are not sure which database name provide:
![Images/cf_dash_6.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_6.png?classes=lab_picture_small)

7. Update **QuickSight Username** parameter with your **QuickSight username** 
![Images/cf_dash_7.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_7.png?classes=lab_picture_small)
To validate your QuickSight username complete the tasks below:
	- Open a new tab or window and navigate to the **QuickSight** console
	- Find your username in the top right navigation bar
![Images/cf_dash_7_2.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_7_2.png?classes=lab_picture_small)
	- Add the identified username to the CloudFormation parameter
	
8. Update **Quicksight Identity Region** parameter with your **QuickSight region** 
![Images/cf_dash_8.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_8.png?classes=lab_picture_small)

	- **Optional** add a **Suffix** if you want to create multiple instances of the same account. 
    - **Optional** specify a **Preferred Refresh Schedule** for QuickSight dataset refresh. Leave empty if no automated refresh is needed.
9. Select **Next** at the bottom of **Specify stack details** and then select **Next** again on the **Configure stack options** page

10. Review the configuration, click **I acknowledge that AWS CloudFormation might create IAM resources, and click Create stack**.
![Images/cf_dash_10.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_9.png?classes=lab_picture_small)

11. You will see the stack will start in **CREATE_IN_PROGRESS** 
![Images/cf_dash_10.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_10.png?classes=lab_picture_small)

**NOTE:** This step can take 5-15mins
    ------------ | -------------

12. Once complete, the stack will show **CREATE_COMPLETE**
![Images/cf_dash_11.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_11.png?classes=lab_picture_small)

13. Navigate to **Dashboards** page in your QuickSight console, click on **Trusted Advisor Organizational View** dashboard to open it
![Images/cf_dash_12.png](/Cost/200_Cloud_Intelligence/Images/tao/cf_dash_12.png?classes=lab_picture_small)
{{% /expand%}}



### Saving and Sharing your Dashboard in QuickSight 
Now that you have your dashboard created you will need want to share your dashboard with users or customize your own version of this dashboard
	- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)

{{< prev_next_button link_prev_url="../2_create-upload-ta-report" link_next_url="../4_update-dashboard" />}}