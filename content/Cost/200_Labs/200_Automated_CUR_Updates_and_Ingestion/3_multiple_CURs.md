---
title: "Multiple CURs"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

This step is used when there are multiple CURs being delivered into the same bucket - for example CURs from two different AWS Organizations. This will automatically update Athena/Glue when there are new versions and new months data for both reports.

The easiest way to work with multiple CURs is to deliver each CUR to a different S3 bucket, and follow the previous process. If you **must** deliver to a single bucket, configure your CURs with different prefixes and follow this process.

1. Log into the console as an IAM user with the required permissions, verify you have multiple CURs with different prefixes being delivered into the same bucket.
CURs have the following configuration:
```
Format:
<bucket name>/<prefix>/<report_name>/

Example Configuration: (Yours may be different based on the name of your CUR and your selected prefix)
<bucket name>/Org1/cur/
<bucket name>/Org2/cur/
```

2. Open the S3 console, and navigate to one of the directories where CURs are stored. Open and save the **crawler-cfn.yml** file:
![Images/2.0-LocateYMLFile.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.0-LocateYMLFile.png?classes=lab_picture_small)

3. Open the file in a code or text editor.

4. Modify the following lines to remove all references to the prefix or report name. Replace the first line with the second in each case:<br/>

Under **AWSCurDatabase:** Replace the existing CUR database name
```
Name: '<original-cur-database-name>'
Name: 'athenacurcfn' (This is a suggested name, choose anything you like)
```

Under **AWSCURCrawlerComponentFunction:** Give access to crawl the entire bucket, not just one CUR
```
Resource: arn:aws:s3:::<bucket name>/Org1/cur/cur*
Resource: arn:aws:s3:::<bucket name>*                
```

Under **AWSCURCrawler:**
```
Path: 's3://<bucket name>/Org1/cur/cur'
Path: 's3://<bucket name>'
```
and under Exclusions after **.zip** add:
```
'aws-programmatic-access-test-object'
```              

Under **AWSPutS3CURNotification:**
```
ReportKey: 'Org1/cur/cur'
ReportKey: ''
```

Under **AWSCURReportStatusTable:**
```
DatabaseName: <original-cur-database-name>
DatabaseName: athenacurcfn (Use the same name you used above)
```
and
```
Location: 's3://<bucket name>/Org1/cur/cost_and_usage_data_status/'
Location: 's3://<bucket name>/cost_and_usage_data_status/'
```

A modified sample is provided here:
[Code/crawler-cfn.yml](/Cost/200_Automated_CUR_Updates_and_Ingestion/Code/crawler-cfn.yml)
Look for the comments: ### New line

5. Save the template file to you hard drive.

6. Go to the CloudFormation dashboard and create a stack with new resources using your updated template.
![Images/AWSMultiCUR1.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/AWSMultiCUR1.png?classes=lab_picture_small)

7. When the CloudFormation Script completes, open the Glue dashboard and verify that there is a single database, containing multiple tables.

{{< prev_next_button link_prev_url="../1_cf_stack/" link_next_url="../4_cleanup/" />}}