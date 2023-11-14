---
title: "Database"
weight: 6
---

These are queries for AWS Services under the [Database product family](https://aws.amazon.com/products/databases/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [Amazon Aurora Global Database](#amazon-aurora-global-database)
  * [Amazon RDS](#amazon-rds)
  * [Amazon RDS - Monthly Cost grouped by Usage Type and Resource Tag](#amazon-rds---monthly-cost-grouped-by-usage-type-and-resource-tag)
  * [Amazon RDS on AWS Outposts](#amazon-rds-on-aws-outposts)
  * [Amazon DynamoDB](#amazon-dynamodb)
  * [Amazon Redshift](#amazon-redshift)
  * [Amazon ElastiCache](#amazon-elasticache)
  * [Amazon DocumentDB](#amazon-documentdb)
  
### Amazon Aurora Global Database

#### Query Description
This query provides a breakdown of costs associated with an Aurora Global Database deployment, excluding backup costs. Output will be grouped by day, account, charge type, usage type, operation, description, and resource ID. Output will be sorted by day, then cost (descending).

Aurora Global Databases are comprised of multiple components, each of which appears as a separate line item in CUR. There is no overarching Aurora Global Database resource ID that can be used to filter query output. This means to get an accurate picture of a specific Aurora Global DB deployment, the relevant cluster and database instance resource IDs in each region where the database is replicated must be added to the WHERE filter. Placeholder variables indicated by a dollar sign and curly braces (${ }) appear where resource IDs should be inserted. Placeholder variables must be replaced before the query will run. Note that depending on your deployment model, you may need to add or remove lines from the WHERE filter as indicated.

Resource IDs can be retrieved through the console, CLI, SDK, or other tools, as normal. If you only have access to CUR, consider the simple query ```SELECT DISTINCT(line_item_resource_id) FROM ${table_name} WHERE line_item_product_code = 'AmazonRDS'``` which will turn up a list of RDS resource IDs. Even in smaller environments the number of resource IDs returned may make it challenging to identify the right resource IDs. In that case, consider adding additional columns to help differentiate and identify the correct resource, such as columns with [user-defined cost allocation tags](https://docs.aws.amazon.com/cur/latest/userguide/resource-tags-columns.html). For example, ```SELECT DISTINCT(line_item_resource_id), resource_tags_user_name, resource_tags_user_cost_center FROM ${table_name} WHERE line_item_product_code = 'AmazonRDS'```. 

Consider the following Aurora Global DB deployment example:
* Primary Region 
    * Primary writer instance 
    * One reader instance
* Secondary Region 1
  * Three reader instances
* Secondary Region 2
  * Zero instances (headless)

In this example, the following resource IDs would be needed: 
  * Primary region cluster ID 
  * Primary region writer instance name 
  * Primary region reader instance name
  * Secondary region 1 cluster ID
  * Secondary region 1 reader1 instance name
  * Secondary region 1 reader2 instance name
  * Secondary region 1 reader3 instance name
  * Secondary region 2 cluster ID 

#### Pricing 
Please refer to the [Amazon Aurora pricing page](https://aws.amazon.com/rds/aurora/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Database/auroraglobaldb.sql)

#### Copy Query
```tsql
SELECT 
  DATE_TRUNC('day',line_item_usage_start_date) AS day_line_item_usage_start_date, 
  line_item_usage_account_id,
  line_item_line_item_type,
  line_item_usage_type,
  line_item_operation,
  line_item_line_item_description,
  line_item_resource_id,
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost,
  SUM(line_item_usage_amount) AS sum_line_item_usage_amount
FROM 
  ${table_name}
WHERE 
  ${date_filter}
  AND (line_item_resource_id LIKE '%${primary_cluster_id}%' -- primary region cluster id in format 'cluster-xxxxxxxxxxxxxxxxxxxxxxxx'
    OR line_item_resource_id LIKE '%${secondary_cluster_id_1}%' -- secondary region cluster id in format 'cluster-xxxxxxxxxxxxxxxxxxxxxxxx'
    OR line_item_resource_id LIKE '%${secondary_cluster_id_n}%' -- additional secondary region cluster id. copy and paste this line once per additional region/cluster
    OR line_item_resource_id LIKE '%${primary_cluster_db_instance_name_1}%' -- primary region database instance name. user defined string, e.g 'team-a-mysql-db-1'
    OR line_item_resource_id LIKE '%${primary_cluster_db_instance_name_n}%' -- additional primary region database instance name. copy and paste this line once per additional instance
    OR line_item_resource_id LIKE '%${secondary_cluster_db_instance_name_1}%' -- secondary region database instance name. user defined string, e.g 'team-a-mysql-db-2'. optional if running headless.
    OR line_item_resource_id LIKE '%${secondary_cluster_db_instance_name_n}%' -- additional secondary region database instance name. copy and paste this line once per additional instance
  )
  AND line_item_usage_type NOT LIKE '%BackupUsage%'
GROUP BY 
  DATE_TRUNC('day', line_item_usage_start_date), 
  line_item_usage_account_id,
  line_item_line_item_type,
  line_item_usage_type,
  line_item_operation,
  line_item_line_item_description,
  line_item_resource_id
ORDER BY
  day_line_item_usage_start_date, 
  sum_line_item_unblended_cost DESC
  ;
  ```
  
### Amazon RDS

#### Query Description
This query will output the daily sum per resource for all RDS purchase options across all RDS usage types. 

#### Pricing
Please refer to the [Amazon RDS pricing page](https://aws.amazon.com/rds/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Database/rds-w-id.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS day_line_item_usage_start_date, 
  product_instance_type, 
  line_item_operation, 
  line_item_usage_type, 
  line_item_line_item_type,
  pricing_term, 
  product_product_family, 
  SPLIT_PART(line_item_resource_id,':',7) AS split_line_item_resource_id,
  product_database_engine,
  SUM(CASE WHEN line_item_line_item_type = 'DiscountedUsage' THEN line_item_usage_amount
    WHEN line_item_line_item_type = 'Usage' THEN line_item_usage_amount
    ELSE 0 
  END) AS sum_line_item_usage_amount, 
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost, 
  SUM(CASE WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
    WHEN line_item_line_item_type = 'RIFee' THEN reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee
    WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN 0
    ELSE line_item_unblended_cost 
  END) AS sum_amortized_cost, 
  SUM(CASE WHEN line_item_line_item_type = 'RIFee' THEN -reservation_amortized_upfront_fee_for_billing_period
    ELSE 0 
  END) AS sum_ri_trueup, 
  SUM(CASE WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN line_item_unblended_cost 
    ELSE 0 
  END) AS sum_ri_upfront_fees
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND product_product_name = 'Amazon Relational Database Service'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'Fee', 'RIFee')
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), 
  product_instance_type, 
  line_item_operation, 
  line_item_usage_type, 
  line_item_line_item_type,
  pricing_term, 
  product_product_family, 
  SPLIT_PART(line_item_resource_id,':',7),
  product_database_engine
ORDER BY 
  day_line_item_usage_start_date, 
  sum_line_item_usage_amount, 
  sum_amortized_cost; 
```

{{< email_button category_text="Database" service_text="Amazon RDS" query_text="Amazon RDS Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon RDS - Monthly Cost grouped by Usage Type and Resource Tag

#### Query Description
This query will output the total monthly blended costs for RDS grouped by usage type and a specified tag (e.g. Environment:Test,Dev,Prod).  The query can be modified to adjust the Cost dataset from [Blended to Unblended](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/con-bill-blended-rates.html#Blended_CB) by adjusting the specified cost column (line_item_blended_cost -> line_item_unblended_cost).  This query would be helpful to visualize a quick monthly breakdown of cost components for RDS usage with a specific tag (Environment:Test,Dev,Prod).  

#### Pricing
Please refer to the [Amazon RDS pricing page](https://aws.amazon.com/rds/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Database/monthly_rds_usage_type_by_tag.sql)

#### Copy Query
```tsql
SELECT
  line_item_usage_type,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
  resource_tags_user_environment,
  SUM(CAST(line_item_blended_cost AS DECIMAL(16,8))) AS sum_line_item_blended_cost
FROM 
  ${table_name}
WHERE 
  ${date_filter}
  AND line_item_product_code='AmazonRDS'
  AND resource_tags_user_environment = 'dev'
GROUP BY  
  line_item_usage_type,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
  resource_tags_user_environment
HAVING 
  SUM(line_item_blended_cost) > 0
ORDER BY 
  line_item_usage_type,
  month_line_item_usage_start_date,
  resource_tags_user_environment;
```

{{< email_button category_text="Database" service_text="Amazon RDS" query_text="Amazon RDS Monthly Cost grouped by Usage Type and User Tag" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon RDS on AWS Outposts

#### Query Description
This query will output the total daily unblended costs for RDS Instances running on AWS Outposts racks. This query will be helpful to visualize a quick breakdown of cost components for RDS usage based on instance type, database engine and deployment option (Multi vs Single-AZ).

#### Pricing
Please refer to the [Amazon RDS on Outposts pricing page](https://aws.amazon.com/rds/outposts/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Database/rds_outposts.sql)

#### Copy Query
```tsql
SELECT  
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  bill_payer_account_id,
  line_item_usage_account_id,
  SPLIT_PART(line_item_resource_id,':',7) AS split_line_item_resource_id,
  product_instance_type,
  product_database_engine,
  product_deployment_option,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost 
FROM  
  ${table_name} 
WHERE
  ${date_filter} 
  AND product_location_type='AWS Outposts'
  AND product_product_family='Database Instance'
  AND line_item_product_code = 'AmazonRDS'
  AND line_item_line_item_type IN ('Usage', 'DiscountedUsage')
GROUP BY
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), 
  bill_payer_account_id, 
  line_item_usage_account_id,
  line_item_resource_id,
  product_instance_type,
  product_database_engine,
  product_deployment_option
ORDER BY
  day_line_item_usage_start_date ASC,
  sum_line_item_usage_amount DESC,
  sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Database" service_text="Amazon RDS" query_text="Amazon RDS on AWS Outposts" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon DynamoDB

#### Query Description
This query will output the total monthly sum per resource for all DynamoDB purchase options (including reserved capacity) across all DynamoDB usage types (including data transfer and storage costs). The unblended cost will be summed and in descending order. 

#### Pricing
Please refer to the [DynamoDB pricing page](https://aws.amazon.com/dynamodb/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Database/dynamodb.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
  product_location,
  SPLIT_PART(line_item_resource_id, 'table/', 2) AS line_item_resource_id,
  CASE
    WHEN line_item_usage_type LIKE '%CapacityUnit%' THEN 'DynamoDB Provisioned Capacity'
    WHEN line_item_usage_type LIKE '%HeavyUsage%' THEN 'DynamoDB Provisioned Capacity'
    WHEN line_item_usage_type LIKE '%RequestUnit%' THEN 'DynamoDB On-Demand Capacity'
    WHEN line_item_usage_type LIKE '%TimedStorage%' THEN 'DynamoDB Storage'
    WHEN line_item_usage_type LIKE '%TimedBackup%' THEN 'DynamoDB Backups'
    WHEN line_item_usage_type LIKE '%TimedPITR%' THEN 'DynamoDB Backups'
    WHEN line_item_usage_type like '%DataTransfer%'THEN 'DynamoDB Data Transfer'
    ELSE 'DynamoDB Other Usage'
  END AS case_line_item_usage_type,
  CASE
    WHEN line_item_line_item_type LIKE '%Fee' THEN 'DynamoDB Reserved Capacity'
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN 'DynamoDB Reserved Capacity'
    ELSE 'DynamoDB Usage' 
  END AS case_purchase_option, 
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_blended_cost AS DECIMAL(16,8))) AS sum_line_item_blended_cost,
  SUM(CAST(reservation_unused_quantity AS DOUBLE)) AS sum_reservation_unused_quantity,
  SUM(CAST(reservation_unused_recurring_fee AS DECIMAL(16,8))) AS sum_reservation_unused_recurring_fee,
  reservation_reservation_a_r_n
FROM 
  ${table_name} 
WHERE 
  {$date_filter}
  AND line_item_product_code = 'AmazonDynamoDB'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage')
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
  product_location,
  SPLIT_PART(line_item_resource_id, 'table/', 2),
  6, -- refers to case_line_item_usage_type
  7, -- refers to case_purchase_option
  reservation_reservation_a_r_n
ORDER BY 
  sum_line_item_blended_cost DESC;
```

{{< email_button category_text="Database" service_text="Amazon DynamoDB" query_text="Amazon DynamoDB Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


### Amazon Redshift

#### Query Description
This query will provide daily unblended and amortized cost as well as usage information per linked account for Amazon Redshift.  The output will include detailed information about the resource id (cluster name), usage type, and API operation.  The usage amount and cost will be summed and the cost will be in descending order. This query includes RI and SP true up which will show any upfront fees to the account that purchased the pricing model.

#### Pricing
Please refer to the [Redshift pricing page](https://aws.amazon.com/redshift/pricing/). Please refer to the [Redshift Cost Optimization Whitepaper](https://d1.awsstatic.com/whitepapers/amazon-redshift-cost-optimization.pdf) for Cost Optimization techniques. 

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Database/redshiftwrid.sql)

#### Copy Query
```tsql
SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  product_instance_type,
  SPLIT_PART(line_item_resource_id,':',7) AS split_line_item_resource_id,
  line_item_operation,
  line_item_usage_type,
  line_item_line_item_type,
  pricing_term,
  product_usage_family,
  product_product_family,
  SUM(CASE 
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN line_item_usage_amount 
    WHEN line_item_line_item_type = 'Usage' THEN line_item_usage_amount 
    ELSE 0 
  END) AS sum_line_item_usage_amount,
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost,
  SUM(CASE
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost  
    WHEN line_item_line_item_type = 'RIFee' THEN reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee
    WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN 0 
    ELSE line_item_unblended_cost 
  END) AS sum_amortized_cost,
  SUM(CASE
    WHEN line_item_line_item_type = 'RIFee' THEN -reservation_amortized_upfront_fee_for_billing_period 
    ELSE 0 
  END) AS sum_ri_trueup,
  SUM(CASE
    WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN line_item_unblended_cost
    ELSE 0 
  END) AS ri_upfront_fees
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND product_product_name = 'Amazon Redshift'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'RIFee', 'Fee')
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  product_instance_type,
  SPLIT_PART(line_item_resource_id,':',7),
  line_item_operation,
  line_item_usage_type,
  line_item_line_item_type,
  pricing_term,
  product_usage_family,
  product_product_family
ORDER BY 
  day_line_item_usage_start_date,
  product_product_family,
  sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Database" service_text="Amazon Redshift" query_text="Amazon Redshift Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon ElastiCache

#### Query Description
This query will output the total monthly sum per resource for all Amazon ElastiCache purchase options (including reserved instances) across all ElastiCache instances types. The unblended and amortized cost will be summed and in descending order. 

#### Pricing
Please refer to the [Amazon ElastiCache pricing page](https://aws.amazon.com/elasticache/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Database/elasticachewrid.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id, 
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, 
  SPLIT_PART(line_item_resource_id,':',7) AS split_line_item_resource_id,
  SPLIT_PART(line_item_usage_type ,':',2) AS split_line_item_usage_type,
  CASE 
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN 'Reserved Instance'
    WHEN line_item_line_item_type = 'Usage' THEN 'OnDemand' 
    ELSE 'Others' 
  END AS case_purchase_option,
  SUM(CASE 
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN line_item_usage_amount 
    WHEN line_item_line_item_type = 'Usage' THEN line_item_usage_amount 
    ELSE 0 
  END) AS sum_line_item_usage_amount,
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost,
  SUM(CASE
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
    WHEN line_item_line_item_type = 'RIFee' THEN reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee
    WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN 0 
    ELSE line_item_unblended_cost 
  END) AS sum_amortized_cost,
  SUM(CASE
    WHEN line_item_line_item_type = 'RIFee' THEN -reservation_amortized_upfront_fee_for_billing_period
    ELSE 0 
  END) AS sum_ri_trueup,
  SUM(CASE
    WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN line_item_unblended_cost 
    ELSE 0 
  END) AS ri_upfront_fees
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND product_product_name = 'Amazon ElastiCache'
  AND product_product_family = 'Cache Instance'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'RIFee', 'Fee')
GROUP BY 
    DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
    bill_payer_account_id, 
    line_item_usage_account_id, 
    line_item_line_item_type, 
    line_item_resource_id, 
    line_item_usage_type
ORDER BY 
    month_line_item_usage_start_date,
    sum_line_item_usage_amount DESC, 
    sum_line_item_unblended_cost;
```

{{< email_button category_text="Database" service_text="Amazon ElastiCache" query_text="Amazon ElastiCache Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon DocumentDB

#### Query Description
This query will output the total daily cost per DocumentDB cluster. The output will include detailed information about the resource id (cluster name) and usage type.  The unblended cost will be summed and in descending order. 

#### Pricing
Please refer to the [Amazon DocumentDB pricing page](https://aws.amazon.com/documentdb/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Database/documentdb_daily_cost.sql)

#### Copy Query
```tsql
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(("line_item_usage_start_date"),'%Y-%m-%d') AS day_line_item_usage_start_date,
      SPLIT_PART(line_item_resource_id,':',7) AS line_item_resource_id,
      line_item_usage_type,
      product_region,
      line_item_product_code,
      sum(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      sum(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${table_Name}
    WHERE
      ${date_filter}
      AND line_item_product_code = 'AmazonDocDB'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','Fee','RIFee')
    GROUP BY  
      1, -- bill_payer_account_id
      2, -- line_item_usage_account_id
      3, -- day_line_item_usage_start_date
      4, -- line_item_resource_id
      5, -- line_item_usage_type
      6, -- product_region
      7 -- line_item_product_code
    ORDER BY
      sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Database" service_text="Amazon DocumentDB" query_text="Amazon DocumentDB Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}






