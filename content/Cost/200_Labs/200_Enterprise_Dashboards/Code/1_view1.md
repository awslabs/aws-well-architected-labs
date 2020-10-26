---
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 999
hidden: FALSE
---

### View 1 - Summary View
This view will be used to create the main **Usage Cost Summary** dashboard page.
Use one of the following queries depending on whether you have Reserved Instances, or Savings Plans.

{{% notice note %}}
We recommend large customers with over 500 linked accounts or more than $10M a month in invoiced cost update the usage date field in the query from 'day' to 'month' for improved performance
{{% /notice %}}


- {{%expand "Click here - if you have both Savings Plans and Reserved Instances" %}}

Modify the following SQL query for View1: 
- Update line 74 replace (database).(tablename) with your CUR database and table name 
- Optional: Adjust the granularity to monthly, by changing 'day' to 'month' in row 6 
- Optional: Adjust the look back from '7' months to desired time-frame in row 75

		CREATE OR REPLACE VIEW summary_view AS
		SELECT
		"year"
		, "month"
		,  "bill_billing_period_start_date" "billing_period"
		, "date_trunc"('day', "line_item_usage_start_date") "usage_date"
		, "bill_payer_account_id" "payer_account_id"
		, "line_item_usage_account_id" "linked_account_id"
		, "bill_invoice_id" "invoice_id"
		, "line_item_line_item_type" "charge_type"
		, CASE 
			WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN 'Running_Usage' 
			WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN 'Running_Usage' 
			WHEN ("line_item_line_item_type" = 'Usage') THEN 'Running_Usage' ELSE 'non_usage' END "charge_category"
		, CASE 
			WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN 'SavingsPlan' 
			WHEN ("reservation_reservation_a_r_n" <> '') THEN 'Reserved' 
			WHEN ("line_item_usage_type" LIKE '%Spot%') THEN 'Spot' 
			ELSE 'OnDemand' END "purchase_option"
		, CASE 
			WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_savings_plan_a_r_n" 
			WHEN ("reservation_reservation_a_r_n" <> '') THEN "reservation_reservation_a_r_n" ELSE '' END "ri_sp_arn"
		, "line_item_product_code" "product_code"
		, "product_product_name" "product_name"
		, CASE 
			WHEN ("bill_billing_entity" = 'AWS Marketplace' AND "line_item_line_item_type" NOT LIKE '%Discount%') THEN "Product_Product_Name" 
			WHEN ("product_servicecode" = '') THEN "line_item_product_code" ELSE "product_servicecode" END "service"
		, "product_product_family" "product_family"
		, "line_item_usage_type" "usage_type"
		, "line_item_operation" "operation"
		, "line_item_line_item_description" "item_description"
		, "line_item_availability_zone" "availability_zone"
		, "product_region" "region"
		, CASE
			WHEN (("line_item_usage_type" LIKE '%Spot%') AND ("line_item_product_code" = 'AmazonEC2') AND ("line_item_line_item_type" = 'Usage')) THEN "split_part"("line_item_line_item_description", '.', 1) ELSE "product_instance_type_family" END "instance_type_family"
		, CASE 
		WHEN (("line_item_usage_type" LIKE '%Spot%') AND ("line_item_product_code" = 'AmazonEC2') AND ("line_item_line_item_type" = 'Usage')) THEN "split_part"("line_item_line_item_description", ' ', 1) ELSE "product_instance_type" END "instance_type"
		, CASE 
		WHEN (("line_item_usage_type" LIKE '%Spot%') AND ("line_item_product_code" = 'AmazonEC2') AND ("line_item_line_item_type" = 'Usage')) THEN "split_part"("split_part"("line_item_line_item_description", ' ', 2), '/', 1) ELSE "product_operating_system" END "platform" 
		, "product_tenancy" "tenancy"
		, "product_physical_processor" "processor"
		, "product_processor_features" "processor_features"
		, "product_database_engine" "database_engine"
		, "product_group" "product_group"
		, "product_from_location" "product_from_location"
		, "product_to_location" "product_to_location"
		, "product_current_generation" "current_generation"
		, "line_item_legal_entity" "legal_entity"
		, "bill_billing_entity" "billing_entity"
		, "pricing_unit" "pricing_unit"
		, approx_distinct("Line_item_resource_id") "resource_id_count"
		, sum(CASE 
		WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "line_item_usage_amount" 
		WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "line_item_usage_amount" 
		WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_usage_amount" ELSE 0 END) "usage_quantity"
		, sum ("line_item_unblended_cost") "unblended_cost"
		, sum(CASE
			WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "savings_plan_savings_plan_effective_cost" 
			WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment") 
			WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
			WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
			WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "reservation_effective_cost"  
			WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
			WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE "line_item_unblended_cost" END) "amortized_cost"
		, sum(CASE
			WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN (-"savings_plan_amortized_upfront_commitment_for_billing_period") 
			WHEN ("line_item_line_item_type" = 'RIFee') THEN (-"reservation_amortized_upfront_fee_for_billing_period") ELSE 0 END) "ri_sp_trueup"
		, sum(CASE
			WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN "line_item_unblended_cost"
			WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN "line_item_unblended_cost"ELSE 0 END) "ri_sp_upfront_fees"
		, sum(CASE
			WHEN ("line_item_line_item_type" <> 'SavingsPlanNegation') THEN "pricing_public_on_demand_cost" ELSE 0 END) "public_cost" 
		FROM
		(ADD YOUR CUR TABLE NAME)
		WHERE (("bill_billing_period_start_date" >= ("date_trunc"('month', current_timestamp) - INTERVAL  '7' MONTH)) AND (CAST("concat"("year", '-', "month", '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '7' MONTH)))

		GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34

{{% /expand%}}



- {{%expand "Click here - if you have Savings Plans, but do not have Reserved Instances" %}}
The query is the same as the first query, except some of lines have been commented out. If your usage changes you can delete and recreate the required view with Savings Plans or Reserved Instance usage.

Modify the following SQL query for View1: 
 - Update line 78 replace (database).(tablename) with your CUR database and table name 
 - Optional: Adjust the granularity to monthly, by changing 'day' to 'month' in row 6
 - Optional: Adjust the look back from '7' months to desired timeframe in row 79

		CREATE OR REPLACE VIEW summary_view AS
		SELECT
		"year"
		, "month"
		, "bill_billing_period_start_date" "billing_period"
		, "date_trunc"('day', "line_item_usage_start_date") "usage_date"
		, "bill_payer_account_id" "payer_account_id"
		, "line_item_usage_account_id" "linked_account_id"
		, "bill_invoice_id" "invoice_id"
		, "line_item_line_item_type" "charge_type"
		, CASE 
			-- WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN 'Running_Usage' 
			WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN 'Running_Usage' 
			WHEN ("line_item_line_item_type" = 'Usage') THEN 'Running_Usage' ELSE 'non_usage' END "charge_category"
		, CASE 
			WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN 'SavingsPlan' 
			-- WHEN ("reservation_reservation_a_r_n" <> '') THEN 'Reserved' 
			WHEN ("line_item_usage_type" LIKE '%Spot%') THEN 'Spot' 
			ELSE 'OnDemand' END "purchase_option"
		, CASE 
			WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_savings_plan_a_r_n" 
			-- WHEN ("reservation_reservation_a_r_n" <> '') THEN "reservation_reservation_a_r_n"
			ELSE '' END "ri_sp_arn"
		, "line_item_product_code" "product_code"
		, "product_product_name" "product_name"
		, CASE 
			WHEN ("bill_billing_entity" = 'AWS Marketplace' AND "line_item_line_item_type" NOT LIKE '%Discount%') THEN "Product_Product_Name" 
			WHEN ("product_servicecode" = '') THEN "line_item_product_code" ELSE "product_servicecode" END "service"
		, "product_product_family" "product_family"
		, "line_item_usage_type" "usage_type"
		, "line_item_operation" "operation"
		, "line_item_line_item_description" "item_description"
		, "line_item_availability_zone" "availability_zone"
		, "product_region" "region"
		, CASE 
			WHEN (("line_item_usage_type" LIKE '%Spot%') AND ("line_item_product_code" = 'AmazonEC2') AND ("line_item_line_item_type" = 'Usage')) THEN "split_part"("line_item_line_item_description", '.', 1) ELSE "product_instance_type_family" END "instance_type_family"
		, CASE 
			WHEN (("line_item_usage_type" LIKE '%Spot%') AND ("line_item_product_code" = 'AmazonEC2') AND ("line_item_line_item_type" = 'Usage')) THEN "split_part"("line_item_line_item_description", ' ', 1) ELSE "product_instance_type" END "instance_type"
		, CASE 
			WHEN (("line_item_usage_type" LIKE '%Spot%') AND ("line_item_product_code" = 'AmazonEC2') AND ("line_item_line_item_type" = 'Usage')) THEN "split_part"("split_part"("line_item_line_item_description", ' ', 2), '/', 1) ELSE "product_operating_system" END "platform" 
		, "product_tenancy" "tenancy"
		, "product_physical_processor" "processor"
		, "product_processor_features" "processor_features"
		, "product_database_engine" "database_engine"
		, "product_group" "product_group"
		, "product_from_location" "product_from_location"
		, "product_to_location" "product_to_location"
		, "product_current_generation" "current_generation"
		, "line_item_legal_entity" "legal_entity"
		, "bill_billing_entity" "billing_entity"
		, "pricing_unit" "pricing_unit"
		, "count"(DISTINCT "Line_item_resource_id") "resource_id_count"
		, sum(CASE 
			WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "line_item_usage_amount" 
			-- WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "line_item_usage_amount" 
			WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_usage_amount" ELSE 0 END) "usage_quantity"
		, sum ("line_item_unblended_cost") "unblended_cost"
		, sum(CASE
			WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "savings_plan_savings_plan_effective_cost" 
			WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment") 
			WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
			WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
			-- WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "reservation_effective_cost"  
			-- WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
			-- WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 
			ELSE "line_item_unblended_cost" END) "amortized_cost"
		, sum(CASE
			WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN (-"savings_plan_amortized_upfront_commitment_for_billing_period") 
			-- WHEN ("line_item_line_item_type" = 'RIFee') THEN (-"reservation_amortized_upfront_fee_for_billing_period") 
			ELSE 0 END) "ri_sp_trueup"
		, sum(CASE
			WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN "line_item_unblended_cost"
			-- WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN "line_item_unblended_cost"
			ELSE 0 END) "ri_sp_upfront_fees"
		, sum(CASE
			WHEN ("line_item_line_item_type" <> 'SavingsPlanNegation') THEN "pricing_public_on_demand_cost" ELSE 0 END) "public_cost" 
		FROM
 		(ADD YOUR CUR TABLE NAME)
		WHERE (("bill_billing_period_start_date" >= ("date_trunc"('month', current_timestamp) - INTERVAL  '7' MONTH)) AND (CAST("concat"("year", '-', "month", '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '7' MONTH)))

		GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,33,34

{{% /expand%}}


- {{%expand "Click here - if you have Reserved Instances, but do not have Savings Plans" %}}
The query is the same as the first query, except some of lines have been commented out. If your usage changes you can delete and recreate the required view with Savings Plans or Reserved Instance usage.


Modify the following SQL query for View1: 
 - Update line 74 replace (database).(tablename) with your CUR database and table name 
 - Optional: Adjust the granularity to monthly, by changing 'day' to 'month' in row 6
 - Optional: Adjust the look back from '7' months to desired timeframe in row 75
 
 		CREATE OR REPLACE VIEW summary_view AS
		SELECT
		"year"
		, "month"
		, "bill_billing_period_start_date" "billing_period"
		, "date_trunc"('day', "line_item_usage_start_date") "usage_date"
		, "bill_payer_account_id" "payer_account_id"
		, "line_item_usage_account_id" "linked_account_id"
		, "bill_invoice_id" "invoice_id"
		, "line_item_line_item_type" "charge_type"
		, CASE 
			WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN 'Running_Usage' 
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN 'Running_Usage' 
			WHEN ("line_item_line_item_type" = 'Usage') THEN 'Running_Usage' ELSE 'non_usage' END "charge_category"
		, CASE 
		-- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN 'SavingsPlan' 
			WHEN ("reservation_reservation_a_r_n" <> '') THEN 'Reserved' 
			WHEN ("line_item_usage_type" LIKE '%Spot%') THEN 'Spot' 
			ELSE 'OnDemand' END "purchase_option"
		, CASE 
		-- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_savings_plan_a_r_n" 
			WHEN ("reservation_reservation_a_r_n" <> '') THEN "reservation_reservation_a_r_n" ELSE '' END "ri_sp_arn"
		, "line_item_product_code" "product_code"
		, "product_product_name" "product_name"
		, CASE 
			WHEN ("bill_billing_entity" = 'AWS Marketplace' AND "line_item_line_item_type" NOT LIKE '%Discount%') THEN "Product_Product_Name" 
			WHEN ("product_servicecode" = '') THEN "line_item_product_code" ELSE "product_servicecode" END "service"
		, "product_product_family" "product_family"
		, "line_item_usage_type" "usage_type"
		, "line_item_operation" "operation"
		, "line_item_line_item_description" "item_description"
		, "line_item_availability_zone" "availability_zone"
		, "product_region" "region"
		, CASE 
			WHEN (("line_item_usage_type" LIKE '%Spot%') AND ("line_item_product_code" = 'AmazonEC2') AND ("line_item_line_item_type" = 'Usage')) THEN "split_part"("line_item_line_item_description", '.', 1) ELSE "product_instance_type_family" END "instance_type_family"
		, CASE 
			WHEN (("line_item_usage_type" LIKE '%Spot%') AND ("line_item_product_code" = 'AmazonEC2') AND ("line_item_line_item_type" = 'Usage')) THEN "split_part"("line_item_line_item_description", ' ', 1) ELSE "product_instance_type" END "instance_type"
		, CASE 
			WHEN (("line_item_usage_type" LIKE '%Spot%') AND ("line_item_product_code" = 'AmazonEC2') AND ("line_item_line_item_type" = 'Usage')) THEN "split_part"("split_part"("line_item_line_item_description", ' ', 2), '/', 1) ELSE "product_operating_system" END "platform" 
		, "product_tenancy" "tenancy"
		, "product_physical_processor" "processor"
		, "product_processor_features" "processor_features"
		, "product_database_engine" "database_engine"
		, "product_group" "product_group"
		, "product_from_location" "product_from_location"
		, "product_to_location" "product_to_location"
		, "product_current_generation" "current_generation"
		, "line_item_legal_entity" "legal_entity"
		, "bill_billing_entity" "billing_entity"
		, "pricing_unit" "pricing_unit"
		, "count"(DISTINCT "Line_item_resource_id") "resource_id_count"
		, sum(CASE 
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "line_item_usage_amount" 
			WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "line_item_usage_amount" 
			WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_usage_amount" ELSE 0 END) "usage_quantity"
		, sum ("line_item_unblended_cost") "unblended_cost"
		, sum(CASE
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "savings_plan_savings_plan_effective_cost" 
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment") 
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
			WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "reservation_effective_cost"  
			WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
			WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE "line_item_unblended_cost" END) "amortized_cost"
		, sum(CASE
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN (-"savings_plan_amortized_upfront_commitment_for_billing_period") 
			WHEN ("line_item_line_item_type" = 'RIFee') THEN (-"reservation_amortized_upfront_fee_for_billing_period") ELSE 0 END) "ri_sp_trueup"
		, sum(CASE
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN "line_item_unblended_cost"
			WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN "line_item_unblended_cost" ELSE 0 END) "ri_sp_upfront_fees"
		, sum(CASE
			WHEN ("line_item_line_item_type" <> 'SavingsPlanNegation') THEN "pricing_public_on_demand_cost" ELSE 0 END) "public_cost" 
		FROM
		 (ADD YOUR CUR TABLE NAME)
		WHERE (("bill_billing_period_start_date" >= ("date_trunc"('month', current_timestamp) - INTERVAL  '7' MONTH)) AND (CAST("concat"("year", '-', "month", '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '7' MONTH)))
		
		GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,33,34
		
{{% /expand%}}


- {{%expand "Click here - if you do not have Reserved Instances, and do not have Savings Plans" %}}
The query is the same as the first query, except some of lines have been commented out. If your usage changes you can delete and recreate the required view with Savings Plans or Reserved Instance usage.


Modify the following SQL query for View1: 
 - Update line 84 replace (database).(tablename) with your CUR database and table name 
 - Optional: Adjust the granularity to monthly, by changing 'day' to 'month' in row 6
 - Optional: Adjust the look back from '7' months to desired timeframe in row 85

		CREATE OR REPLACE VIEW summary_view AS
		SELECT
		"year"
		, "month"
		, "bill_billing_period_start_date" "billing_period"
		, "date_trunc"('day', "line_item_usage_start_date") "usage_date"
		, "bill_payer_account_id" "payer_account_id"
		, "line_item_usage_account_id" "linked_account_id"
		, "bill_invoice_id" "invoice_id"
		, "line_item_line_item_type" "charge_type"
		, CASE 
		-- WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN 'Running_Usage' 
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN 'Running_Usage' 
		 WHEN ("line_item_line_item_type" = 'Usage') THEN 'Running_Usage' 
		ELSE 'non_usage' END "charge_category"
		, CASE 
		-- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN 'SavingsPlan' 
		-- WHEN ("reservation_reservation_a_r_n" <> '') THEN 'Reserved' 
			WHEN ("line_item_usage_type" LIKE '%Spot%') THEN 'Spot' 
			ELSE 'OnDemand' END "purchase_option"
		,CASE 
		 WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_savings_plan_a_r_n" 
		-- WHEN ("reservation_reservation_a_r_n" <> '') THEN "reservation_reservation_a_r_n"
		 WHEN ("line_item_line_item_type" = 'Usage') THEN '' 
		 ELSE '' END "ri_sp_arn"
		, "line_item_product_code" "product_code"
		, "product_product_name" "product_name"
		, CASE 
			WHEN ("bill_billing_entity" = 'AWS Marketplace' AND "line_item_line_item_type" NOT LIKE '%Discount%') THEN "Product_Product_Name" 
			WHEN ("product_servicecode" = '') THEN "line_item_product_code" ELSE "product_servicecode" END "service"
		, "product_product_family" "product_family"
		, "line_item_usage_type" "usage_type"
		, "line_item_operation" "operation"
		, "line_item_line_item_description" "item_description"
		, "line_item_availability_zone" "availability_zone"
		, "product_region" "region"
		, CASE 
			WHEN (("line_item_usage_type" LIKE '%Spot%') AND ("line_item_product_code" = 'AmazonEC2') AND ("line_item_line_item_type" = 'Usage')) THEN "split_part"("line_item_line_item_description", '.', 1) ELSE "product_instance_type_family" END "instance_type_family"
		, CASE 
			WHEN (("line_item_usage_type" LIKE '%Spot%') AND ("line_item_product_code" = 'AmazonEC2') AND ("line_item_line_item_type" = 'Usage')) THEN "split_part"("line_item_line_item_description", ' ', 1) ELSE "product_instance_type" END "instance_type"
		, CASE 
			WHEN (("line_item_usage_type" LIKE '%Spot%') AND ("line_item_product_code" = 'AmazonEC2') AND ("line_item_line_item_type" = 'Usage')) THEN "split_part"("split_part"("line_item_line_item_description", ' ', 2), '/', 1) ELSE "product_operating_system" END "platform" 
		, "product_tenancy" "tenancy"
		, "product_physical_processor" "processor"
		, "product_processor_features" "processor_features"
		, "product_database_engine" "database_engine"
		, "product_group" "product_group"
		, "product_from_location" "product_from_location"
		, "product_to_location" "product_to_location"
		, "product_current_generation" "current_generation"
		, "line_item_legal_entity" "legal_entity"
		, "bill_billing_entity" "billing_entity"
		, "pricing_unit" "pricing_unit"
		, "count"(DISTINCT "Line_item_resource_id") "resource_id_count"
		, sum(CASE 
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "line_item_usage_amount" 
		-- WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "line_item_usage_amount" 
		WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_usage_amount" 
		ELSE 0 END) "usage_quantity"
		, sum ("line_item_unblended_cost") "unblended_cost"
		, sum(CASE
			WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_unblended_cost"
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "savings_plan_savings_plan_effective_cost" 
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment") 
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
		-- WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "reservation_effective_cost"  
		-- WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
		-- WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 
		ELSE "line_item_unblended_cost" END) "amortized_cost"
		, sum(CASE
			WHEN (line_item_line_item_type = 'Usage') THEN 0
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN (-"savings_plan_amortized_upfront_commitment_for_billing_period") 
		-- WHEN ("line_item_line_item_type" = 'RIFee') THEN (-"reservation_amortized_upfront_fee_for_billing_period") 
		ELSE 0 END) "ri_sp_trueup"
		, sum(CASE
		WHEN ("line_item_line_item_type" = 'Usage') THEN 0
		-- WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN "line_item_unblended_cost"
		-- WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN "line_item_unblended_cost"
		ELSE 0 END) "ri_sp_upfront_fees"
		, sum(CASE
			WHEN ("line_item_line_item_type" <> 'SavingsPlanNegation') THEN "pricing_public_on_demand_cost" ELSE 0 END) "public_cost" 
		FROM
		 (ADD YOUR CUR TABLE NAME)
		WHERE (("bill_billing_period_start_date" >= ("date_trunc"('month', current_timestamp) - INTERVAL  '7' MONTH)) AND (CAST("concat"("year", '-', "month", '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '7' MONTH)))
		
		GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32,33,34
		
	
{{% /expand%}}

- Confirm the view is working, run the following Athena query and you should receive 10 rows of data:

        select * from costmaster.summary_view
        limit 10
