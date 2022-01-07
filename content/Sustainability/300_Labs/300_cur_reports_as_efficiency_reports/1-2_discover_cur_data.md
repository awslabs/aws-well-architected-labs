---
title: "Discover CUR data with Amazon Athena"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 3
pre: "<b>1.2 </b>"
---

# Lab 1.2

In the previous step, you provided AWS Cost & Usage Report data in an Amazon S3 bucket. In this step you will make this usage data available in the AWS Glue data catalog for Amazon Athena. Amazon Athena allows you to run SQL (Structured Query Language) queries on the data without loading it into a database and calculate proxy metrics for sustainability.

1. Go to the [Amazon Athena console](https://console.aws.amazon.com/athena/home?force#query) in a region in which your CUR data is stored. This is the same region your S3 bucket resides as defined in [lab 1.1]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/1-1_prepare_cur_data.md" >}}).
2. If this is your first time to visit the Athena console in your current AWS Region, choose **Explore the query editor**, then choose **set up a query result location in Amazon S3** and follow the steps from the (Amazon Athena docs to specify a query result location)[https://docs.aws.amazon.com/athena/latest/ug/querying.html#query-results-specify-location]. Depending on your setup, you may need to create a new workgroup within Amazon Athena.
3. Create a new AWS Glue database via the Amazon Athena's query editor. Enter the query:
```sql
CREATE DATABASE proxy_metrics_lab
```
4. Click **Run query**
5. Choose the **Database** `proxy_metrics_lab` from the drop down menu.
![proxy_metrics_lab database](/Sustainability/300_cur_reports_as_efficiency_reports/lab1-2/images/database-selection.png)
6. Now you need to tell AWS Glue where the data to query is stored. You create a table in AWS Glue via a DDL (Data Definition Language) SQL statement in Amazon Athena. Fill the **New Query** field with the following query. You need to replace `S3 URL HERE` on line 160 of the query with the URI of the root of your cost and usage reports in the form of `s3://<bucket>/<Report path prefix>/<Report name>/`.
  * If you followed option B in [lab 1.1]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/1-1_prepare_cur_data.md" >}}), your S3 URI may look like `s3://<bucket>/cur-data/hourly/proxy-metrics-lab/proxy-metrics-lab/`.
  * If you followed option C in [lab 1.1]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/1-1_prepare_cur_data.md" >}}), your S3 URI may look like `s3://<bucket>/cur-data/hourly/proxy-metrics-lab/`.  
```sql
CREATE EXTERNAL TABLE `cur_hourly`(
  `identity_line_item_id` string,
  `identity_time_interval` string,
  `bill_invoice_id` string,
  `bill_billing_entity` string,
  `bill_bill_type` string,
  `bill_payer_account_id` string,
  `bill_billing_period_start_date` timestamp,
  `bill_billing_period_end_date` timestamp,
  `line_item_usage_account_id` string,
  `line_item_line_item_type` string,
  `line_item_usage_start_date` timestamp,
  `line_item_usage_end_date` timestamp,
  `line_item_product_code` string,
  `line_item_usage_type` string,
  `line_item_operation` string,
  `line_item_availability_zone` string,
  `line_item_resource_id` string,
  `line_item_usage_amount` double,
  `line_item_normalization_factor` double,
  `line_item_normalized_usage_amount` double,
  `line_item_currency_code` string,
  `line_item_unblended_rate` string,
  `line_item_unblended_cost` double,
  `line_item_blended_rate` string,
  `line_item_blended_cost` double,
  `line_item_line_item_description` string,
  `line_item_tax_type` string,
  `line_item_legal_entity` string,
  `product_product_name` string,
  `product_activity_type` string,
  `product_alarm_type` string,
  `product_availability` string,
  `product_capacitystatus` string,
  `product_category` string,
  `product_clock_speed` string,
  `product_current_generation` string,
  `product_data_type` string,
  `product_datatransferout` string,
  `product_dedicated_ebs_throughput` string,
  `product_description` string,
  `product_durability` string,
  `product_ecu` string,
  `product_edition` string,
  `product_endpoint_type` string,
  `product_enhanced_networking_supported` string,
  `product_event_type` string,
  `product_fee_code` string,
  `product_fee_description` string,
  `product_finding_group` string,
  `product_finding_source` string,
  `product_finding_storage` string,
  `product_from_location` string,
  `product_from_location_type` string,
  `product_group` string,
  `product_group_description` string,
  `product_instance_family` string,
  `product_instance_type` string,
  `product_instance_type_family` string,
  `product_intel_avx2_available` string,
  `product_intel_avx_available` string,
  `product_intel_turbo_available` string,
  `product_license_model` string,
  `product_location` string,
  `product_location_type` string,
  `product_logs_destination` string,
  `product_logs_source` string,
  `product_logs_type` string,
  `product_max_iops_burst_performance` string,
  `product_max_iopsvolume` string,
  `product_max_throughputvolume` string,
  `product_max_volume_size` string,
  `product_maximum_extended_storage` string,
  `product_memory` string,
  `product_memory_gib` string,
  `product_message_delivery_frequency` string,
  `product_message_delivery_order` string,
  `product_network_performance` string,
  `product_normalization_size_factor` string,
  `product_operating_system` string,
  `product_operation` string,
  `product_physical_processor` string,
  `product_pre_installed_sw` string,
  `product_processor_architecture` string,
  `product_processor_features` string,
  `product_product_family` string,
  `product_protocol` string,
  `product_queue_type` string,
  `product_region` string,
  `product_request_description` string,
  `product_request_type` string,
  `product_resource_price_group` string,
  `product_routing_target` string,
  `product_routing_type` string,
  `product_servicecode` string,
  `product_servicename` string,
  `product_sku` string,
  `product_standard_group` string,
  `product_standard_storage` string,
  `product_standard_storage_retention_included` string,
  `product_storage` string,
  `product_storage_class` string,
  `product_storage_media` string,
  `product_storage_type` string,
  `product_subscription_type` string,
  `product_tenancy` string,
  `product_to_location` string,
  `product_to_location_type` string,
  `product_transfer_type` string,
  `product_usagetype` string,
  `product_vcpu` string,
  `product_version` string,
  `product_volume_api_name` string,
  `product_volume_type` string,
  `pricing_rate_id` string,
  `pricing_currency` string,
  `pricing_public_on_demand_cost` double,
  `pricing_public_on_demand_rate` string,
  `pricing_term` string,
  `pricing_unit` string,
  `reservation_amortized_upfront_cost_for_usage` double,
  `reservation_amortized_upfront_fee_for_billing_period` double,
  `reservation_effective_cost` double,
  `reservation_end_time` string,
  `reservation_modification_status` string,
  `reservation_normalized_units_per_reservation` string,
  `reservation_number_of_reservations` string,
  `reservation_recurring_fee_for_usage` double,
  `reservation_start_time` string,
  `reservation_subscription_id` string,
  `reservation_total_reserved_normalized_units` string,
  `reservation_total_reserved_units` string,
  `reservation_units_per_reservation` string,
  `reservation_unused_amortized_upfront_fee_for_billing_period` double,
  `reservation_unused_normalized_unit_quantity` double,
  `reservation_unused_quantity` double,
  `reservation_unused_recurring_fee` double,
  `reservation_upfront_value` double,
  `savings_plan_total_commitment_to_date` double,
  `savings_plan_savings_plan_a_r_n` string,
  `savings_plan_savings_plan_rate` double,
  `savings_plan_used_commitment` double,
  `savings_plan_savings_plan_effective_cost` double,
  `savings_plan_amortized_upfront_commitment_for_billing_period` double,
  `savings_plan_recurring_commitment_for_billing_period` double,
  `resource_tags_aws_cloudformation_logical_id` string,
  `resource_tags_aws_cloudformation_stack_id` string,
  `resource_tags_aws_cloudformation_stack_name` string,
  `resource_tags_user_name` string)
PARTITIONED BY (
  `year` int,
  `month` int)
ROW FORMAT SERDE
  'org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe'
STORED AS INPUTFORMAT
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat'
OUTPUTFORMAT
  'org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat'
LOCATION
  'S3 URL HERE' <<< REPLACE ME
TBLPROPERTIES (
  'classification'='parquet',
  'has_encrypted_data'='false',
  'projection.enabled'='true',
  'projection.month.range'='1,12',
  'projection.month.type'='integer',
  'projection.year.range'='2018,2022',
  'projection.year.type'='integer')
```

7. Choose **Run query**. The Results section of the Query editor should display "Query successful [...]". As the query does use partition projection (see the `TBLPROPERTIES` clause), you do not load the partitions to query the data. Amazon Athena is clever enough to calculate them as long as they are in the range of Jan 2018 to December 2022.
8. Now you can preview random 10 entries. Choose the three dots next to the `cur_hourly` table and choose **Preview table**.
![Preview Table](/Sustainability/300_cur_reports_as_efficiency_reports/lab1-2/images/preview-table.png)

Congratulations! You now can explore your CUR data with Amazon Athena with SQL queries. As soon as new CUR data gets written to Amazon S3, it will be returned in your next query immediately. Take the time to expirement with Amazon Athena's query editor and explore the columns of your reports.

{{< prev_next_button link_prev_url="../1-1_prepare_cur_data" link_next_url="../1-3_query_s3_usage_by_class" />}}
