---
title: "Manual Deployment - Prepare"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

### Stage 2 - Prepare config files

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

{{< prev_next_button link_prev_url="../3_auto_deployment" link_next_url="../5_manual-deployment-deploy/" />}}