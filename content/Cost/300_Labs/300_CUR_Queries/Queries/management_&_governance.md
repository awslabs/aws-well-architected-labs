---
title: "Management & Governance"
date: 2020-08-28T11:16:09-04:00
chapter: false
weight: 10
pre: "<b> </b>"
---

These are queries for AWS Services under the [Management & Governance product family](https://aws.amazon.com/products/management-tools/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost/300_labs/300_CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [AWS Config](#aws-config)
  * [AWS CloudTrail](#aws-cloudtrail)
  * [AWS CloudWatch](#aws-cloudwatch)
  * [Regional Service Usage Mapping](#regional-service-usage-mapping)

### AWS Config

#### Query Description
This query will provide daily unblended and usage information per linked account for AWS Config. The output will include detailed information about the usage type and usage region. The cost will be summed by day, account, and usage type.

#### Pricing
Please refer to the [AWS Config pricing page](https://aws.amazon.com/config/pricing/).

#### Sample Output
![Images/config.png](/Cost/300_CUR_Queries/Images/Management_&_Governance/config.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Management_&_Governance/config.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      product_region,
      CASE
        WHEN line_item_usage_type LIKE '%%ConfigurationItemRecorded%%' THEN 'ConfigurationItemRecorded'
        WHEN line_item_usage_type LIKE '%%ActiveConfigRules%%' THEN 'ActiveConfigRules'
        WHEN line_item_usage_type LIKE '%%SecurityHubConfigRules%%' THEN 'SecurityHubConfigRules'
        WHEN line_item_usage_type LIKE '%%ConfigRuleEvaluations%%' THEN 'ConfigRuleEvaluations'      
        ELSE 'Others'
      END AS case_line_item_usage_type,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${tableName}
    WHERE
      (year = '2020' AND month IN ('1','01') OR year = '2020' AND month IN ('2','02'))
      AND product_product_name = 'AWS Config'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage') 
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      product_region,
      line_item_usage_type
    ORDER BY
      day_line_item_usage_start_date,
      sum_line_item_usage_amount,
      sum_line_item_unblended_cost,
      case_line_item_usage_type;
```

{{< email_button category_text="Management %26 Governance" service_text="AWS Config" query_text="AWS Config Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### AWS CloudTrail

#### Query Description
This query will provide monthly unblended and usage information per linked account for AWS CloudTrail. The output will include detailed information about the usage type and usage region. The cost will be summed by month, account, and usage type, and displayed in descending order.

#### Pricing
Please refer to the [CloudTrail pricing page](https://aws.amazon.com/cloudtrail/pricing/).

#### Sample Output
![Images/cloudtrail.png](/Cost/300_CUR_Queries/Images/Management_&_Governance/cloudtrail.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Management_&_Governance/cloudtrail.sql)

#### Copy Query
```tsql
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, 
      product_product_name, 
      SPLIT_PART(line_item_usage_type,'-',2)  AS split_line_item_usage_type, 
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount, 
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
    FROM ${table_name}
    WHERE 
      ${date_filter}
      AND product_product_name = 'AWS CloudTrail'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY  
      bill_payer_account_id, 
      line_item_usage_account_id, 
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m'), 
      SPLIT_PART(line_item_usage_type,'-',2), 
      product_product_name
    ORDER BY  
      sum_line_item_unblended_cost DESC, 
      month_line_item_usage_start_date, 
      sum_line_item_usage_amount;
```

{{< email_button category_text="Management %26 Governance" service_text="AWS CloudTrail" query_text="AWS CloudTrail Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### AWS CloudWatch

#### Query Description
This query will provide monthly unblended and usage information per linked account for AWS CloudWatch. The output will include detailed information about the usage type. The cost will be summed by month, account, and usage type, and displayed in descending order.

#### Pricing
Please refer to the [CloudWatch pricing page](https://aws.amazon.com/cloudwatch/pricing/).

#### Sample Output
![Images/cloudwatch-spend.png](/Cost/300_CUR_Queries/Images/Management_&_Governance/cloudwatch-spend.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Management_&_Governance/cloudwatch-spend.sql)

#### Copy Query
```tsql
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m') month_line_item_usage_start_date,
      CASE
        WHEN line_item_usage_type LIKE '%%Requests%%' THEN 'Requests'
        WHEN line_item_usage_type LIKE '%%DataProcessing-Bytes%%' THEN 'DataProcessing'
        WHEN line_item_usage_type LIKE '%%TimedStorage-ByteHrs%%' THEN 'Storage'
        WHEN line_item_usage_type LIKE '%%DataScanned-Bytes%%' THEN 'DataScanned'
        WHEN line_item_usage_type LIKE '%%AlarmMonitorUsage%%' THEN 'AlarmMonitors'
        WHEN line_item_usage_type LIKE '%%DashboardsUsageHour%%' THEN 'Dashboards'
        WHEN line_item_usage_type LIKE '%%MetricMonitorUsage%%' THEN 'MetricMonitor'
        WHEN line_item_usage_type LIKE '%%VendedLog-Bytes%%' THEN 'VendedLogs'
        WHEN line_item_usage_type LIKE '%%GMD-Metrics%%' THEN 'GetMetricData'
      ELSE 'Others'
      END AS line_item_usage_type,
      line_item_operation,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost 
    FROM ${tableName}
    WHERE 
      ${date_filter}
      AND product_product_name = 'AmazonCloudWatch'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
      line_item_usage_type,
      line_item_operation
    ORDER BY
    sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Management %26 Governance" service_text="AWS CloudWatch" query_text="AWS CloudWatch Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Regional Service Usage Mapping

#### Query Description
Amazon Web Services publishes our most up-to-the-minute information on our [Service Health Dashboard](https://status.aws.amazon.com/).  This dashboard is based on region and service.  While we try to notify you of ongoing problems that may be impactful to your workloads via your [Personal Health Dashboard](https://aws.amazon.com/premiumsupport/technology/personal-health-dashboard/) you may want to proactively check where you currently have service usage and cost that may be impacted by our event or another regional issue.

This Regional Service Usage Mapping query transforms your billing data into a summarized view of your usage of AWS services by region and availability zone, providing your operations teams with the ability to respond quickly and accurately during impacting service events.

#### Sample Output
![Images/rsum.png](/Cost/300_CUR_Queries/Images/Management_&_Governance/rsum.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Management_&_Governance/rsum.sql)

#### Copy Query
```tsql
    SELECT 
      CASE
        WHEN (bill_billing_entity = 'AWS Marketplace' AND line_item_line_item_type NOT LIKE '%Discount%') THEN product_product_name
        WHEN (product_product_name = '') THEN line_item_product_code 
        ELSE product_product_name 
      END AS product_name,
      CASE product_region
        WHEN NULL THEN 'Global'
        WHEN '' THEN 'Global'
        WHEN 'global' THEN 'Global'
        ELSE product_region
      END AS product_region,
      line_item_availability_zone, 
      SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost
    FROM 
      ${table_name} 
    WHERE 
      ${date_filter}
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY 
      1, 
      line_item_product_code, 
      line_item_availability_zone, 
      product_region
    HAVING 
      SUM(line_item_unblended_cost) > 0
    ORDER BY 
      product_region, 
      sum_line_item_unblended_cost DESC;
```      

{{< email_button category_text="Management %26 Governance" service_text="Regional Usage" query_text="RSUM" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}







