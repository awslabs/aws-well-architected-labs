---
title: "Install the AWS Cost and Usage Queries from the AWS Serverless Application Repository"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 5
pre: "<b>1.4 </b>"
---

# Lab 1.4

You might want to automate the setup of the AWS Glue resources and deploy further pre-canned queries automatically. Everything is packaged and available in the [AWS Serverless Application Repository](https://aws.amazon.com/serverless/serverlessrepo/) called [AWS Usage Queries](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:387304072572:applications~aws-usage-queries) (find the [source code on GitHub](https://github.com/aws-samples/aws-usage-queries)).

Let's deploy this from the AWS Serverless Application Repository:

1. Go to the [AWS Usage Queries in the AWS Serverless Application Repository](https://serverlessrepo.aws.amazon.com/applications/arn:aws:serverlessrepo:us-east-1:387304072572:applications~aws-usage-queries)
2. Choose **Deploy**.
3. Change the AWS Management Console's **region** to the region in which the bucket with the CUR data is, as set up in [lab 1.1]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/1-1_prepare_cur_data.md" >}}).
4. Fill the fields according to the configuration of your AWS Cost & Usage Report:
    * CurBucketName: **your bucket name**
    * ReportName: **your report name**
    * ReportPathPrefix: **your report path prefix**
{{% notice note %}}
**Note** If you chose Option C in [lab 1.1]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/1-1_prepare_cur_data.md" >}}), use:
  * CurBucketName: **your-bucket-name**
  * ReportName: `proxy-metrics-lab`
  * ReportPathPrefix: `cur-data/hourly`
{{% /notice %}}
6. Select **I acknowledge that this app creates custom IAM roles and resource policies**.
7. Click **Deploy**. AWS Lambda will initiate the deployment and redirect you to a page for the application you are deploying.
![Deploy](/Sustainability/300_cur_reports_as_efficiency_reports/lab1-4/images/deploy-sar.png)
8. Click **Deployments** and wait approximately 2 minutes until the application is deployed.
9. When the deployment status is **Create complete** go to the Amazon Athena console.
10. Choose the `aws_usage_queries_database` database.
11. As the tables are created now, they won't query the partitions with the sample data from 2018. You need to change the table's data range to also extend to 2018. Execute the following query:
```sql
ALTER TABLE `cur_hourly` SET TBLPROPERTIES ('projection.year.range'='2018,2022')
```
12. Explore the data. Choose the **three dots** next to the tables and views and choose **Preview table**.

Congratulations! With a two click deployment from the AWS Serverless Application Repository you can query the CUR data, have pre-canned queries for proxy metrics of Amazon EC2 and Amazon S3, and additional reference data for the EC2 instance types in the table `ref_instance_types`.

You can now continue with Part 2.

{{< prev_next_button link_prev_url="../1-3_query_s3_usage_by_class" link_next_url="../2_add_assumptions" />}}
