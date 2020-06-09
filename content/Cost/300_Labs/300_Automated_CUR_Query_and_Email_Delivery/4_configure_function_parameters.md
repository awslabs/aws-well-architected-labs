---
title: "Configure parameters of function code and upload code to S3"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---
This step is used to edit parameters (CUR database name and table, SES sender and recipient etc) in the Lambda function code, which is then uploaded to S3 for Lambda execution.

1. Download function code [https://d3h9zoi3eqyz7s.cloudfront.net/Cost/AutoCURDelivery.zip](https://d3h9zoi3eqyz7s.cloudfront.net/Cost/AutoCURDelivery.zip) to your local disk. This zip file includes:
        - auto_cur_delivery.py - Lambda function code
    - config.yml - Configuration file  
    - package/ -  All dependencies, libraries, including pandas, numpy, Xlrd, Openpyxl, Xlsxwriter, pyyaml

2. Unzip **config.yml** from within **AutoCURDelivery.zip**, and open it into a text editor.

3. Configure the following parameters in **config.yml**:
    - **CUR_Output_Location**: Your S3 bucket created previously, i.e. S3://my-cur-bucket/out-put/
    - **CUR_DB**: CUR database and table name defined in Athena, i.e. athenacurcfn_my_athena_report.myathenareport
    - **CUR_Report_Name**: Report filename that is sent with SES as an attachment, i.e. cost_utilization_report.xlsx
    - **Region**: The region where SES service is called, i.e. us-east-1
    - **Subject**: SES mail subject, i.e. Cost and Utilization Report
    - **Sender**: Your sender e-mail address, i.e. john@example.com
    - **Recipient**: Your recipient e-mail addresses. If there are multiple recipients, separate them by comma, i.e. john@example.com,alice@example.com

4. Keep other configuration unchanged and save **config.yml**.

5. Add the updated **config.yml** back to **AutoCURDelivery.zip**.

6. Upload **AutoCURDelivery.zip** to your S3 bucket. Make sure this S3 path is in the same region as Lambda function created in next step.  **NOTE** this is a large 30+MB file, so it may take a little time.
