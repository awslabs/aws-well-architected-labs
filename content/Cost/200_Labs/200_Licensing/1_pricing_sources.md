---
title: "Create Pricing Data Source"
date: 2020-08-30T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---



{{% notice info %}}
If you have RHEL usage in your CUR you can skip this step, this step sets up a provided Cost and Usage report with RHEL usage for analysis.
{{% /notice %}}


### Create the pricing data source
We will create a data source with approximately 24 hours of usage. This is a sample data source which contains multiple workloads, which is representative of running small web server applications.


### Create the pricing data
1. Log into the console via SSO.

2. Go to the **S3 service dashboard**

3. Create a bucket, with a name starting with **cost-** 

4. Go into the bucket and create 2 folders, **before** and **after**:
![Images/s3_folders.png](/Cost/200_Licensing/Images/s3_folders.png)

5. Go into the **before** folder and upload the following file:
[Code/BeforeCUR.gz](/Cost/200_Licensing/Code/BeforeCUR.gz)

6. Go into the **after** folder and upload the following file:
[Code/AfterCUR.gz](/Cost/200_Licensing/Code/AfterCUR.gz)

{{% notice tip %}}
You now have your sample usage files ready to be setup.
{{% /notice %}}


### Setup Athena
1. Go into the **Athena** service dashboard

2. Create the costmaster database if it does not exist, copy and paste the following command:

        create database if not exists costmaster;


3. Create the **before table**, modify the **location** line at the bottom, in the query below by replacing **(bucketname)** with the name of your bucket, and paste the following query into Athena:


{{%expand "Create before table - Athena query" %}}

		CREATE EXTERNAL TABLE if not exists `costmaster.before`(
		  `identity_line_item_id` string, 
		  `identity_time_interval` string, 
		  `bill_invoice_id` string, 
		  `bill_billing_entity` string, 
		  `bill_bill_type` string, 
		  `bill_payer_account_id` bigint, 
		  `bill_billing_period_start_date` string, 
		  `bill_billing_period_end_date` string, 
		  `line_item_usage_account_id` bigint, 
		  `line_item_line_item_type` string, 
		  `line_item_usage_start_date` string, 
		  `line_item_usage_end_date` string, 
		  `line_item_product_code` string, 
		  `line_item_usage_type` string, 
		  `line_item_operation` string, 
		  `line_item_availability_zone` string, 
		  `line_item_resource_id` string, 
		  `line_item_usage_amount` double, 
		  `line_item_normalization_factor` double, 
		  `line_item_normalized_usage_amount` double, 
		  `line_item_currency_code` string, 
		  `line_item_unblended_rate` double, 
		  `line_item_unblended_cost` double, 
		  `line_item_blended_rate` double, 
		  `line_item_blended_cost` string, 
		  `line_item_line_item_description` string, 
		  `line_item_tax_type` string, 
		  `line_item_legal_entity` string, 
		  `product_product_name` string, 
		  `product_availability` string, 
		  `product_capacitystatus` string, 
		  `product_clock_speed` string, 
		  `product_current_generation` string, 
		  `product_database_engine` string, 
		  `product_dedicated_ebs_throughput` string, 
		  `product_deployment_option` string, 
		  `product_description` string, 
		  `product_durability` string, 
		  `product_ecu` string, 
		  `product_edition` string, 
		  `product_engine_code` string, 
		  `product_enhanced_networking_supported` string, 
		  `product_event_type` string, 
		  `product_free_query_types` string, 
		  `product_from_location` string, 
		  `product_from_location_type` string, 
		  `product_group` string, 
		  `product_group_description` string, 
		  `product_instance_family` string, 
		  `product_instance_type` string, 
		  `product_instance_type_family` string, 
		  `product_license_model` string, 
		  `product_location` string, 
		  `product_location_type` string, 
		  `product_max_iops_burst_performance` string, 
		  `product_max_iopsvolume` bigint, 
		  `product_max_throughputvolume` string, 
		  `product_max_volume_size` string, 
		  `product_memory` string, 
		  `product_message_delivery_frequency` string, 
		  `product_message_delivery_order` string, 
		  `product_min_volume_size` string, 
		  `product_network_performance` string, 
		  `product_normalization_size_factor` double, 
		  `product_operating_system` string, 
		  `product_operation` string, 
		  `product_physical_processor` string, 
		  `product_pre_installed_sw` string, 
		  `product_processor_architecture` string, 
		  `product_processor_features` string, 
		  `product_product_family` string, 
		  `product_queue_type` string, 
		  `product_region` string, 
		  `product_servicecode` string, 
		  `product_servicename` string, 
		  `product_sku` string, 
		  `product_storage` string, 
		  `product_storage_class` string, 
		  `product_storage_media` string, 
		  `product_subscription_type` string, 
		  `product_tenancy` string, 
		  `product_to_location` string, 
		  `product_to_location_type` string, 
		  `product_transfer_type` string, 
		  `product_usagetype` string, 
		  `product_vcpu` bigint, 
		  `product_version` string, 
		  `product_volume_type` string, 
		  `pricing_lease_contract_length` string, 
		  `pricing_offering_class` string, 
		  `pricing_purchase_option` string, 
		  `pricing_rate_id` bigint, 
		  `pricing_public_on_demand_cost` string, 
		  `pricing_public_on_demand_rate` double, 
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
		  `reservation_reservation_a_r_n` string, 
		  `reservation_start_time` string, 
		  `reservation_subscription_id` bigint, 
		  `reservation_total_reserved_normalized_units` string, 
		  `reservation_total_reserved_units` string, 
		  `reservation_units_per_reservation` string, 
		  `reservation_unused_amortized_upfront_fee_for_billing_period` double, 
		  `reservation_unused_normalized_unit_quantity` double, 
		  `reservation_unused_quantity` double, 
		  `reservation_unused_recurring_fee` double, 
		  `reservation_upfront_value` double, 
		  `resource_tags_aws_autoscaling_group_name` string, 
		  `resource_tags_aws_created_by` string, 
		  `resource_tags_aws_ec2spot_fleet_request_id` string, 
		  `resource_tags_user_cost_center` string, 
		  `resource_tags_user_department` string, 
		  `resource_tags_user_environment` string, 
		  `resource_tags_user_name` string, 
		  `resource_tags_user_workload` string, 
		  `resource_tags_user_workload_type` string, 
		  `product_category` string, 
		  `resource_tags_user_tag21_nov` string, 
		  `resource_tags_user_application` string, 
		  `resource_tags_user_tier` string, 
		  `product_content_type` string, 
		  `product_granularity` string, 
		  `product_origin` string, 
		  `product_recipient` string, 
		  `product_volume_api_name` string, 
		  `savings_plan_total_commitment_to_date` double, 
		  `savings_plan_savings_plan_a_r_n` string, 
		  `savings_plan_savings_plan_rate` double, 
		  `savings_plan_used_commitment` double, 
		  `savings_plan_savings_plan_effective_cost` double, 
		  `savings_plan_amortized_upfront_commitment_for_billing_period` double, 
		  `savings_plan_recurring_commitment_for_billing_period` double, 
		  `product_instance` string, 
		  `product_provisioned` string, 
		  `product_request_description` string, 
		  `product_request_type` string, 
		  `product_fee_code` string, 
		  `product_fee_description` string, 
		  `year` bigint, 
		  `month` bigint)
		ROW FORMAT DELIMITED 
		  FIELDS TERMINATED BY '\u0001' 
		STORED AS INPUTFORMAT 
		  'org.apache.hadoop.mapred.TextInputFormat' 
		OUTPUTFORMAT 
		  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
		LOCATION
		  's3://(bucketname)/before/'
        TBLPROPERTIES (
            "skip.header.line.count"="1")

{{% /expand%}}
    


4. Create the **after** table, modify the **location** line at the bottom, in the query below by replacing **(bucketname)** with the name of your bucket, and paste the following query into Athena:
 

{{%expand "Create after table - Athena query" %}}

		CREATE EXTERNAL TABLE if not exists `costmaster.after`(
		  `identity_line_item_id` string, 
		  `identity_time_interval` string, 
		  `bill_invoice_id` string, 
		  `bill_billing_entity` string, 
		  `bill_bill_type` string, 
		  `bill_payer_account_id` bigint, 
		  `bill_billing_period_start_date` string, 
		  `bill_billing_period_end_date` string, 
		  `line_item_usage_account_id` bigint, 
		  `line_item_line_item_type` string, 
		  `line_item_usage_start_date` string, 
		  `line_item_usage_end_date` string, 
		  `line_item_product_code` string, 
		  `line_item_usage_type` string, 
		  `line_item_operation` string, 
		  `line_item_availability_zone` string, 
		  `line_item_resource_id` string, 
		  `line_item_usage_amount` double, 
		  `line_item_normalization_factor` double, 
		  `line_item_normalized_usage_amount` double, 
		  `line_item_currency_code` string, 
		  `line_item_unblended_rate` double, 
		  `line_item_unblended_cost` double, 
		  `line_item_blended_rate` double, 
		  `line_item_blended_cost` string, 
		  `line_item_line_item_description` string, 
		  `line_item_tax_type` string, 
		  `line_item_legal_entity` string, 
		  `product_product_name` string, 
		  `product_availability` string, 
		  `product_capacitystatus` string, 
		  `product_clock_speed` string, 
		  `product_current_generation` string, 
		  `product_database_engine` string, 
		  `product_dedicated_ebs_throughput` string, 
		  `product_deployment_option` string, 
		  `product_description` string, 
		  `product_durability` string, 
		  `product_ecu` string, 
		  `product_edition` string, 
		  `product_engine_code` string, 
		  `product_enhanced_networking_supported` string, 
		  `product_event_type` string, 
		  `product_free_query_types` string, 
		  `product_from_location` string, 
		  `product_from_location_type` string, 
		  `product_group` string, 
		  `product_group_description` string, 
		  `product_instance_family` string, 
		  `product_instance_type` string, 
		  `product_instance_type_family` string, 
		  `product_license_model` string, 
		  `product_location` string, 
		  `product_location_type` string, 
		  `product_max_iops_burst_performance` string, 
		  `product_max_iopsvolume` bigint, 
		  `product_max_throughputvolume` string, 
		  `product_max_volume_size` string, 
		  `product_memory` string, 
		  `product_message_delivery_frequency` string, 
		  `product_message_delivery_order` string, 
		  `product_min_volume_size` string, 
		  `product_network_performance` string, 
		  `product_normalization_size_factor` double, 
		  `product_operating_system` string, 
		  `product_operation` string, 
		  `product_physical_processor` string, 
		  `product_pre_installed_sw` string, 
		  `product_processor_architecture` string, 
		  `product_processor_features` string, 
		  `product_product_family` string, 
		  `product_queue_type` string, 
		  `product_region` string, 
		  `product_servicecode` string, 
		  `product_servicename` string, 
		  `product_sku` string, 
		  `product_storage` string, 
		  `product_storage_class` string, 
		  `product_storage_media` string, 
		  `product_subscription_type` string, 
		  `product_tenancy` string, 
		  `product_to_location` string, 
		  `product_to_location_type` string, 
		  `product_transfer_type` string, 
		  `product_usagetype` string, 
		  `product_vcpu` bigint, 
		  `product_version` string, 
		  `product_volume_type` string, 
		  `pricing_lease_contract_length` string, 
		  `pricing_offering_class` string, 
		  `pricing_purchase_option` string, 
		  `pricing_rate_id` bigint, 
		  `pricing_public_on_demand_cost` string, 
		  `pricing_public_on_demand_rate` double, 
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
		  `reservation_reservation_a_r_n` string, 
		  `reservation_start_time` string, 
		  `reservation_subscription_id` bigint, 
		  `reservation_total_reserved_normalized_units` string, 
		  `reservation_total_reserved_units` string, 
		  `reservation_units_per_reservation` string, 
		  `reservation_unused_amortized_upfront_fee_for_billing_period` double, 
		  `reservation_unused_normalized_unit_quantity` double, 
		  `reservation_unused_quantity` double, 
		  `reservation_unused_recurring_fee` double, 
		  `reservation_upfront_value` double, 
		  `resource_tags_aws_autoscaling_group_name` string, 
		  `resource_tags_aws_created_by` string, 
		  `resource_tags_aws_ec2spot_fleet_request_id` string, 
		  `resource_tags_user_cost_center` string, 
		  `resource_tags_user_department` string, 
		  `resource_tags_user_environment` string, 
		  `resource_tags_user_name` string, 
		  `resource_tags_user_workload` string, 
		  `resource_tags_user_workload_type` string, 
		  `product_category` string, 
		  `resource_tags_user_tag21_nov` string, 
		  `resource_tags_user_application` string, 
		  `resource_tags_user_tier` string, 
		  `product_content_type` string, 
		  `product_granularity` string, 
		  `product_origin` string, 
		  `product_recipient` string, 
		  `product_volume_api_name` string, 
		  `savings_plan_total_commitment_to_date` double, 
		  `savings_plan_savings_plan_a_r_n` string, 
		  `savings_plan_savings_plan_rate` double, 
		  `savings_plan_used_commitment` double, 
		  `savings_plan_savings_plan_effective_cost` double, 
		  `savings_plan_amortized_upfront_commitment_for_billing_period` double, 
		  `savings_plan_recurring_commitment_for_billing_period` double, 
		  `product_instance` string, 
		  `product_provisioned` string, 
		  `product_request_description` string, 
		  `product_request_type` string, 
		  `product_fee_code` string, 
		  `product_fee_description` string, 
		  `year` bigint, 
		  `month` bigint)
		ROW FORMAT DELIMITED 
		  FIELDS TERMINATED BY '\u0001' 
		STORED AS INPUTFORMAT 
		  'org.apache.hadoop.mapred.TextInputFormat' 
		OUTPUTFORMAT 
		  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
		LOCATION
		  's3://(bucketname)/after/'
	    TBLPROPERTIES (
            "skip.header.line.count"="1")

{{% /expand%}}
    



### Test and Verify

1. Confirm the **before** table is readable, copy and paste the following query into Athena and ensure it returns lines:

        SELECT * FROM "costmaster"."before" limit 10;

2. Confirm the **after** table is readable, copy and paste the following query into Athena and ensure it returns lines:

        SELECT * FROM "costmaster"."after" limit 10;

![Images/athena_verify.png](/Cost/200_Licensing/Images/athena_verify.png)


{{% notice tip %}}
You have successfully setup the cost and usage data source. We have a database of licensed and unlicensed usage to analyze and verify.
{{% /notice %}}

{{< prev_next_button link_prev_url="../" link_next_url="../2_analyze_understand/" />}}