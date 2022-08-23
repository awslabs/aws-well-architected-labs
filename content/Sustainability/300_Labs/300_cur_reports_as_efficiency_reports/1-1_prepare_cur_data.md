---
title: "Prepare CUR Data"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 2
pre: "<b>1.1 </b>"
---

# Lab 1.1

In this lab you will provide AWS Cost & Usage Report (CUR) data in one of your Amazon S3 buckets. In later labs we will query that data to calculate proxy metrics for sustainability.

There are several options to provide AWS Cost & Usage Report data:

* Option A: use **existing CUR reports** from your AWS account. This option makes sense, if you already have configured CUR in your account.
* Option B: create a **new CUR report** in your AWS account. This option makes sense, if your account has significant resource and you are willing to **suspend the lab for at least 24 hours** to wait for CUR data collection.
* Option C: copy **CUR sample data** to your bucket.

## Option A - Existing CUR reports
If you have cost usage reporting currently enabled in your account, please check whether the setup of the report is appropriate for this lab.
{{%expand "Expand me for Option A steps"%}}

1. Go to the [AWS Cost & Usage Reports in your Billing Console](https://console.aws.amazon.com/billing/home#/reports)
2. Choose your **existing report**
3. Check that the CUR report has been created:
    1. In the **Parquet** format
    2. Time granularity set to **Hourly**
    3. Report content contains **Resource IDs**

{{% /expand%}}

## Option B - Setup new CUR reports in your AWS account
If you **do not** have cost usage reporting currently enabled in your account, follow these steps to configure reports appropriately for this lab. Be aware, if you are setting up CUR reports for the first time, you will need to wait 24 hours for data collection and report generation before continuing with the lab.
{{%expand "Expand me for Option B steps"%}}

1. Go to the [AWS Cost & Usage Reports in your Billing Console](https://console.aws.amazon.com/billing/home#/reports)
2. Click **Create Report**
3. Set a **Report name**, e.g. `proxy-metrics-lab`
4. Select **Include resource IDs**
![Create CUR Report](/Sustainability/300_cur_reports_as_efficiency_reports/lab1-1/images/create_cur_report.png?classes=lab_picture_small)
5. Click **Next**
6. For S3 bucket, click **Configure**. Choose an existing bucket or create a new bucket in a region in which you will also run the Amazon Athena queries later.

{{% notice warning %}}
**Warning:** If you decide to use an existing bucket, the wizard will overwrite any existing bucket policy.
{{% /notice %}}
![Configure Bucket](/Sustainability/300_cur_reports_as_efficiency_reports/lab1-1/images/configure_bucket.png?classes=lab_picture_small)

7. Review and accept the bucket policy (for newly created bucket)
![Verify Policy](/Sustainability/300_cur_reports_as_efficiency_reports/lab1-1/images/verify_policy.png?classes=lab_picture_small)
8. Set a **Report path prefix**, e.g. `cur-data/hourly`. AWS Cost & Usage Report require a prefix on creation, please set a prefix here.
9. Select **Enable report data integration** for **Amazon Athena**
![Delivery Options](/Sustainability/300_cur_reports_as_efficiency_reports/lab1-1/images/delivery_options.png?classes=lab_picture_small)
10. Click **Next**
11. Click **Review and complete**

Now you need to wait until the CUR data is delivered to your bucket. After delivery starts, AWS updates the AWS Cost and Usage Reports files at least once a day.

{{% /expand%}}

## Option C - Using Sample CUR data
If you do not already have CUR reports available for your account, and are not in a position to wait for data delivery from Option B, you may use sample report data to continue with the lab.
{{%expand "Expand me for Option C steps"%}}

1. Create a new bucket in the [Amazon S3 console](https://s3.console.aws.amazon.com/s3/bucket/create), with the default settings. Choose a region in which you will also run the Amazon Athena queries later:
![Create Bucket](/Sustainability/300_cur_reports_as_efficiency_reports/lab1-1/images/create_bucket.png?classes=lab_picture_small)
2. Download and put the `.parquet` files from the [aws-well-architected-labs](https://github.com/awslabs/aws-well-architected-labs/tree/master/static/Cost/200_4_Cost_and_Usage_Analysis/Code) repository to your bucket to the corresponding prefixes in your bucket:
```
s3://<your-bucket-name>/cur-data/hourly/proxy-metrics-lab/year=2018/month=12/Dec2018-WorkshopCUR-00001.snappy.parquet
s3://<your-bucket-name>/cur-data/hourly/proxy-metrics-lab/year=2018/month=11/Nov2018-WorkshopCUR-00001.snappy.parquet
s3://<your-bucket-name>/cur-data/hourly/proxy-metrics-lab/year=2018/month=10/Oct2018-WorkshopCUR-00001.snappy.parquet
```
{{% /expand%}}

Congratulations, you now have AWS Cost & Usage Report data in an Amazon S3 bucket which we can query with Athena in the next step.

{{< prev_next_button link_prev_url="../" link_next_url="../1-2_discover_cur_data" />}}
