---
title: "Query your Amazon S3 usage by storage class"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 4
pre: "<b>1.3 </b>"
---

# Lab 1.3

In the previous steps, you learned how you can run SQL queries on your AWS Cost & Usage Report data with Amazon Athena.
In this step you will learn how you can aggregate the usage data by type and AWS account.
This way you can calculate proxy metrics for sustainability and Key Performance Indicators (KPI) of your application teams.

Let's query the `cur_hourly` table we just created to get the Amazon S3 storage by account and storage class.

1. Go to the [Amazon Athena console](https://console.aws.amazon.com/athena/home?force#query) in the same region as before.
2. Choose the **Database** `proxy_metrics_lab`.
3. Fill the **New Query** field with the following query.
```sql
SELECT line_item_usage_account_id account_id,
    product_volume_type storage_class,
    sum(line_item_usage_amount) as usage_gb,
    year,
    month
FROM cur_hourly
WHERE product_servicename LIKE '%Amazon Simple Storage Service%'
    AND product_volume_type not like ''
    AND product_volume_type not like 'Tags'
GROUP BY line_item_usage_account_id,
    product_volume_type,
    year,
    month
```
4. Click **Run query**

You have now the Amazon S3 storage grouped by month, year, storage class, and account.

You can also save the query now as a view to refer to it later. This way you don't need to remember the query and can also handle the view like a normal table, e.g. for joins with other tables.

1. Leave the previously executed query in the query editor.
2. Choose **Create**.
3. Choose **View from query**.
![View from query](/Sustainability/300_cur_reports_as_efficiency_reports/lab1-3/images/view-from-query.png?classes=lab_picture_small)
4. Enter `storage_by_class` as **Name**.
5. Choose **Create**.
![Create view](/Sustainability/300_cur_reports_as_efficiency_reports/lab1-3/images/create-view.png?classes=lab_picture_small)

You can now see new view called `storage_by_class` on the left menu. Choose the three dots next to the `storage_by_class` table and choose **Preview view** to test if it works.
![Preview view](/Sustainability/300_cur_reports_as_efficiency_reports/lab1-3/images/preview-view.png?classes=lab_picture_small)

Congratulations, by the end of this step you learned to query AWS Cost & Usage Report data with Amazon Athena. You have run SQL queries on that data to aggregate it by usage type and AWS account to calculate proxy metrics for sustainability. And finally, you saved this query as a view. Now you can use this view's data to establish KPIs for your AWS account owners and application teams.

{{< prev_next_button link_prev_url="../1-2_discover_cur_data" link_next_url="../1-4_queries_from_sar" />}}
