---
title: "Manual Deployment - Deploy"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---
### Stage 2 - Create required resources and deploy dashboard

1. **We recommend to use AWS CloudShell for workshop**
    ![Image](/Cost/200_Cloud_Intelligence/Images/CloudShell.png?classes=lab_picture_small)

1. Verify **AWS CLI** is **v2.1.16** and above. Check the version by issuing the `aws --version` command at the shell prompt. To upgrade AWS CLI, find the [instructions here](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

1. Upload all 5 config files to **CloudShell**

1. **Using CloudShell** change a directory to where you've uploaded files in the previous step

1. Create resources

    {{%expand "Click here - if you want to bulk copy commands" %}}
    aws glue create-table --region {region} --cli-input-json file://athena-table.json
    aws quicksight create-data-source --aws-account-id {account} --region {region} --cli-input-json file://data-source-input.json
    aws quicksight create-data-set --aws-account-id {account} --region {region} --cli-input-json file://data-set-input.json
    aws quicksight create-dashboard --aws-account-id {account} --region {region} --cli-input-json file://dashboard-input.json 
    aws quicksight describe-dashboard --aws-account-id {account} --region {region} --dashboard-id ta-organizational-view
    {{% /expand%}}

    **OR**

    + Create Glue table is the metadata definition:
    ```bash
    aws glue create-table --region {region} --cli-input-json file://athena-table.json
    ```

    + Create QuickSight datasource:
    ```bash
    aws quicksight create-data-source --aws-account-id {account} --region {region} --cli-input-json file://data-source-input.json
    ```

    + Create QuickSight dataset:
    ```bash
    aws quicksight create-data-set --aws-account-id {account} --region {region} --cli-input-json file://data-set-input.json
    ```

    + Create QuickSight dashboard:
    ```bash
    aws quicksight create-dashboard --aws-account-id {account} --region {region} --cli-input-json file://dashboard-input.json
    ```

    + Get status of dashboard deployment:
    ```bash
    aws quicksight describe-dashboard --aws-account-id {account} --region {region} --dashboard-id ta-organizational-view
    
	
{{% notice tip %}}
Congratulations dashboard is deployed! Please log in to QuickSight and open `https://{region}.quicksight.aws.amazon.com/sn/dashboards/ta-organizational-view/`
{{% /notice %}}

### Saving and Sharing your Dashboard in QuickSight 
Now that you have your dashboard created you will need want to share your dashboard with users or customize your own version of this dashboard
	- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)


{{< prev_next_button link_prev_url="../4_manual-deployment-prepare" link_next_url="../6_update-dashboard" />}}