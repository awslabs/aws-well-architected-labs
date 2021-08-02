---
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 999
hidden: FALSE
---

### View 4 - S3
This view will be used to create the **S3** dashboard page.
Use one of the following queries depending on whether you have Reserved Instances, or Savings Plans.


- {{%expand "Click here - if you have both Savings Plans and Reserved Instances" %}}

Modify the following SQL query for View4 - S3:
 - Update line 22, replace (database).(tablename) with your CUR database and table name 

		CREATE OR REPLACE VIEW "s3_view" AS 
		SELECT DISTINCT
		"year"
		, "month"
		, "bill_billing_period_start_date" "billing_period"
		, "date_trunc"('day', "line_item_usage_start_date") "usage_date"
		, "bill_payer_account_id" "payer_account_id"
		, "line_item_usage_account_id" "linked_account_id"
		, "line_item_resource_id" "resource_id"
		, "line_item_product_code" "product_code"
		, "line_item_operation" "operation"
		, "product_region" "region"
		, "line_item_line_item_type" "charge_type"
		, "pricing_unit" "pricing_unit"
		, "sum"(CASE
			WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_usage_amount"
			ELSE 0
			END) "usage_quantity"
		, "sum"("line_item_unblended_cost") "unblended_cost"
		, "sum"("pricing_public_on_demand_cost") "public_cost"
		FROM 
		(ADD YOUR CUR TABLE NAME)
		WHERE (((("bill_billing_period_start_date" >= ("date_trunc"('month', current_timestamp) - INTERVAL  '3' MONTH)) AND ("line_item_usage_start_date" < ("date_trunc"('day', current_timestamp) - INTERVAL  '1' DAY))) AND ("line_item_operation" LIKE '%Storage%')) AND (("line_item_product_code" LIKE '%AmazonGlacier%') OR ("line_item_product_code" LIKE '%AmazonS3%')))
		GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12
		

{{% /expand%}}



- {{%expand "Click here - if you have Savings Plans, but do not have Reserved Instances" %}}
If your usage changes you can delete and recreate the required view with Savings Plans or Reserved Instance usage.

Modify the following SQL query for View4 - S3:
 - Update line 22, replace (database).(tablename) with your CUR database and table name 

		CREATE OR REPLACE VIEW "s3_view" AS 
		SELECT DISTINCT
		"year"
		, "month"
		, "bill_billing_period_start_date" "billing_period"
		, "date_trunc"('day', "line_item_usage_start_date") "usage_date"
		, "bill_payer_account_id" "payer_account_id"
		, "line_item_usage_account_id" "linked_account_id"
		, "line_item_resource_id" "resource_id"
		, "line_item_product_code" "product_code"
		, "line_item_operation" "operation"
		, "product_region" "region"
		, "line_item_line_item_type" "charge_type"
		, "pricing_unit" "pricing_unit"
		, "sum"(CASE
			WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_usage_amount"
			ELSE 0
			END) "usage_quantity"
		, "sum"("line_item_unblended_cost") "unblended_cost"
		, "sum"("pricing_public_on_demand_cost") "public_cost"
		FROM 
		(ADD YOUR CUR TABLE NAME)
		WHERE (((("bill_billing_period_start_date" >= ("date_trunc"('month', current_timestamp) - INTERVAL  '3' MONTH)) AND ("line_item_usage_start_date" < ("date_trunc"('day', current_timestamp) - INTERVAL  '1' DAY))) AND ("line_item_operation" LIKE '%Storage%')) AND (("line_item_product_code" LIKE '%AmazonGlacier%') OR ("line_item_product_code" LIKE '%AmazonS3%')))
		GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12
		

{{% /expand%}}




- {{%expand "Click here - if you have Reserved Instances, but do not have Savings Plans" %}}
If your usage changes you can delete and recreate the required view with Savings Plans or Reserved Instance usage.

Modify the following SQL query for View4 - S3:
 - Update line 22, replace (database).(tablename) with your CUR database and table name 

		CREATE OR REPLACE VIEW "s3_view" AS 
		SELECT DISTINCT
		"year"
		, "month"
		, "bill_billing_period_start_date" "billing_period"
		, "date_trunc"('day', "line_item_usage_start_date") "usage_date"
		, "bill_payer_account_id" "payer_account_id"
		, "line_item_usage_account_id" "linked_account_id"
		, "line_item_resource_id" "resource_id"
		, "line_item_product_code" "product_code"
		, "line_item_operation" "operation"
		, "product_region" "region"
		, "line_item_line_item_type" "charge_type"
		, "pricing_unit" "pricing_unit"
		, "sum"(CASE
			WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_usage_amount"
			ELSE 0
			END) "usage_quantity"
		, "sum"("line_item_unblended_cost") "unblended_cost"
		, "sum"("pricing_public_on_demand_cost") "public_cost"
		FROM 
		(ADD YOUR CUR TABLE NAME)
		WHERE (((("bill_billing_period_start_date" >= ("date_trunc"('month', current_timestamp) - INTERVAL  '3' MONTH)) AND ("line_item_usage_start_date" < ("date_trunc"('day', current_timestamp) - INTERVAL  '1' DAY))) AND ("line_item_operation" LIKE '%Storage%')) AND (("line_item_product_code" LIKE '%AmazonGlacier%') OR ("line_item_product_code" LIKE '%AmazonS3%')))
		GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12
		
{{% /expand%}}




- {{%expand "Click here - if you do not have Reserved Instances, and do not have Savings Plans" %}}
If your usage changes you can delete and recreate the required view with Savings Plans or Reserved Instance usage.

Modify the following SQL query for View4 - S3:
 - Update line 22, replace (database).(tablename) with your CUR database and table name 

		CREATE OR REPLACE VIEW "s3_view" AS 
		SELECT DISTINCT
		"year"
		, "month"
		, "bill_billing_period_start_date" "billing_period"
		, "date_trunc"('day', "line_item_usage_start_date") "usage_date"
		, "bill_payer_account_id" "payer_account_id"
		, "line_item_usage_account_id" "linked_account_id"
		, "line_item_resource_id" "resource_id"
		, "line_item_product_code" "product_code"
		, "line_item_operation" "operation"
		, "product_region" "region"
		, "line_item_line_item_type" "charge_type"
		, "pricing_unit" "pricing_unit"
		, "sum"(CASE
			WHEN ("line_item_line_item_type" = 'Usage') THEN "line_item_usage_amount"
			ELSE 0
			END) "usage_quantity"
		, "sum"("line_item_unblended_cost") "unblended_cost"
		, "sum"("pricing_public_on_demand_cost") "public_cost"
		FROM 
		(ADD YOUR CUR TABLE NAME)
		WHERE (((("bill_billing_period_start_date" >= ("date_trunc"('month', current_timestamp) - INTERVAL  '3' MONTH)) AND ("line_item_usage_start_date" < ("date_trunc"('day', current_timestamp) - INTERVAL  '1' DAY))) AND ("line_item_operation" LIKE '%Storage%')) AND (("line_item_product_code" LIKE '%AmazonGlacier%') OR ("line_item_product_code" LIKE '%AmazonS3%')))
		GROUP BY 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11,12
		


{{% /expand%}}

- Confirm the view is working, run the following Athena query and you should receive 10 rows of data:

        select * from costmaster.s3_view
        limit 10