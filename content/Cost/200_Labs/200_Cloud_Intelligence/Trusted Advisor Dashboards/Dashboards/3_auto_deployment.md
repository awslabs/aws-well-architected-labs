---
title: "Automated Deployment - Optional"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

{{% notice tip %}}
Use our [Github repo](https://github.com/aws-samples/aws-cudos-framework-deployment/blob/main/tao/Readme.md#user-content-deployment) to perform an automated deployment following the instructions below. If you would like to deploy TAO Dashboard manually please skip this step and proceed with [Manual deployment - Prepare](../4_manual-deployment-prepare)

{{% /notice %}}

# Deployment

1. Launch [AWS CloudShell](https://console.aws.amazon.com/cloudshell/home)
2. Clone [repository](https://github.com/aws-samples/aws-cudos-framework-deployment) and navigate to tao folder:
    ```bash
    git clone https://github.com/aws-samples/aws-cudos-framework-deployment
    cd aws-cudos-framework-deployment/tao
    ```
3. Run the following script: 
    
    Note: Your user would require minimal permissions on the IAM Role described in  minimal_permissions.json
    ```bash
    ./shell-script/tao.sh --action=prepare
    ```
    ```bash
    ./shell-script/tao.sh --action=deploy
    ```
4. To refresh **AWS Trusted Advisor Organizational View** data (we recommend to perform this step at least once per month):
    - Create AWS Trusted Advisor Organizational View [report](https://docs.aws.amazon.com/awssupport/latest/user/organizational-view.html#create-organizational-view-reports)
    - Download AWS Trusted Advisor Organizational View [report](https://docs.aws.amazon.com/awssupport/latest/user/organizational-view.html#download-organizational-view-reports) and unzip it
    - Upload report unzipped folder to s3://{bucket}/reports
    - Run following script: 

        ```bash
        ./shell-script/tao.sh --action=refresh-data
        ```
# Update

1. To pull dashboard updates run

    ```bash
    ./shell-script/tao.sh --action=update
    ```

### Saving and Sharing your Dashboard in QuickSight 
Now that you have your dashboard created you will need want to share your dashboard with users or customize your own version of this dashboard
	- [Click to navigate QuickSight steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/quicksight/quicksight)

{{< prev_next_button link_prev_url="../2_create-upload-ta-report" link_next_url="../4_manual-deployment-prepare" />}}