---
title: "Multiple CURs"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

This step is used when there are multiple CURs being delivered into the same bucket - for example a CUR with hourly granularity and one with daily granularity. This will automatically update Athena/Glue when there are new versions and new months data for both reports.

The easiest way to work with multiple CURs is to deliver each CUR to a different S3 bucket, and follow the previous process. If you **must** deliver to a single bucket, configure your CURs with different prefixes or folders and follow this process.

1. Log into the console as an IAM user with the required permissions, verify you have multiple CURs with different prefixes being delivered into the same bucket.
We will have the following configuration:
```
Format:
<bucket name>/<prefix>/<report_name>/

Configuration:
<bucket name>/DailyCUR/daily/
<bucket name>/HourlyCUR/hourly/
```

2. Open the S3 console, and navigate to one of the directories where CURs are stored. Open and save the **crawler-cfn.yml** file:
![Images/AWSMultiCUR0.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSMultiCUR0.png)

3. Open the file in your favourite text editor

4. Modify the following lines to remove all references to the prefix or report name. Replace the first line with the second in each case:<br/>
Under **AWSCurDatabase:**
```
Name: 'athenacurcfn_daily'
Name: 'athenacurcfn'
```

Under **AWSCURCrawlerComponentFunction:**
```
Resource: arn:aws:s3:::<bucket name>/DailyCUR/daily/daily*
Resource: arn:aws:s3:::<bucket name>*                
```

Under **AWSCURCrawler:**
```
Name: AWSCURCrawler-daily
Name: AWSCURCrawler
```
and
```
Path: 's3://<bucket name>/DailyCUR/daily/daily'
Path: 's3://<bucket name>'
```
and under Exclusions after **.zip** add:
```
'aws-programmatic-access-test-object'
```              

Under **AWSPutS3CURNotification:**
```
ReportKey: 'DailyCUR/daily/daily'
ReportKey: ''
```

Under **AWSCURReportStatusTable:**
```
DatabaseName: athenacurcfn_daily
DatabaseName: athenacurcfn
```
and
```
Location: 's3://<bucket name>/DailyCUR/daily/cost_and_usage_data_status/'
Location: 's3://<bucket name>/cost_and_usage_data_status/'
```

A modified sample is provided here:
[Code/crawler-cfn.yml](/Cost/300_Automated_CUR_Updates_and_Ingestion/Code/crawler-cfn.yml)
Look for the comments: ### New line


5. Save the template file.


6. Go to the CloudFormation dashboard and execute the template you just created
![Images/AWSMultiCUR1.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSMultiCUR1.png)

7. Go to the Glue dashboard and verify that there is a single database, containing multiple tables:
![Images/AWSMultiCUR2.png](/Cost/300_Automated_CUR_Updates_and_Ingestion/Images/AWSMultiCUR2.png)
