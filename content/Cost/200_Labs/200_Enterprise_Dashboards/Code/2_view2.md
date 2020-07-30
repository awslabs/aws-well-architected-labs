---
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 999
hidden: FALSE
---


### View 2 - EC2 Running Costs
This view will be used to create the **EC2 Running Costs and Elasticity** portion for the RI/SP Summary dashboard page.
Use one of the following queries depending on whether you have Reserved Instances, or Savings Plans.


- {{%expand "Click here - if you have both Savings Plans and Reserved Instances" %}}

Modify the following SQL query for View2 - EC2_Running_Cost: 
 - Update line 17 replace (database).(tablename) with your CUR database and table name 

		CREATE OR REPLACE VIEW "ec2_running_cost" AS 
		SELECT DISTINCT
		"year"
		, "month"
		, "bill_billing_period_start_date" "billing_period"
		,  "date_trunc"('hour', "line_item_usage_start_date") "usage_date"
		, "bill_payer_account_id" "payer_account_id"
		, "line_item_usage_account_id" "linked_account_id"
		, (CASE WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN 'SavingsPlan' WHEN ("reservation_reservation_a_r_n" <> '') THEN 'Reserved' WHEN ("line_item_usage_type" LIKE '%Spot%') THEN 'Spot' ELSE 'OnDemand' END) "purchase_option"
		, "sum"(CASE
			WHEN "line_item_line_item_type" = 'SavingsPlanCoveredUsage' THEN "savings_plan_savings_plan_effective_cost"
			WHEN "line_item_line_item_type" = 'DiscountedUsage' THEN "reservation_effective_cost"
			WHEN "line_item_line_item_type" = 'Usage' THEN "line_item_unblended_cost"
			ELSE 0 END) "amortized_cost"
		, "round"("sum"("line_item_usage_amount"), 2) "usage_quantity"
		FROM
		(ADD YOUR CUR TABLE NAME)
		WHERE (((((("bill_billing_period_start_date" >= ("date_trunc"('month', current_timestamp) - INTERVAL  '1' MONTH)) AND ("line_item_product_code" = 'AmazonEC2')) AND ("product_servicecode" <> 'AWSDataTransfer')) AND ("line_item_operation" LIKE '%RunInstances%')) AND ("line_item_usage_type" NOT LIKE '%DataXfer%')) AND ((("line_item_line_item_type" = 'Usage') OR ("line_item_line_item_type" = 'SavingsPlanCoveredUsage')) OR ("line_item_line_item_type" = 'DiscountedUsage')))
		GROUP BY 1, 2, 3, 4,5,6,7

{{% /expand%}}



- {{%expand "Click here - if you have Savings Plans, but do not have Reserved Instances" %}}
The query is the same as the first query, except some of lines have been commented out. If your usage changes you can delete and recreate the required view with Savings Plans or Reserved Instance usage.

Modify the following SQL query for View2 - EC2_Running_Cost: 
 - Update line 21 replace (database).(tablename) with your CUR database and table name 


		CREATE OR REPLACE VIEW "ec2_running_cost" AS 
		SELECT DISTINCT
		"year"
		, "month"
		, "bill_billing_period_start_date" "billing_period"
		,  "date_trunc"('hour', "line_item_usage_start_date") "usage_date"
		, "bill_payer_account_id" "payer_account_id"
		, "line_item_usage_account_id" "linked_account_id"
		, (CASE 
		WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN 'SavingsPlan' 
		-- WHEN ("reservation_reservation_a_r_n" <> '') THEN 'Reserved' 
		WHEN ("line_item_usage_type" LIKE '%Spot%') THEN 'Spot' 
		ELSE 'OnDemand' END) "purchase_option"
		, "sum"(CASE
		WHEN "line_item_line_item_type" = 'SavingsPlanCoveredUsage' THEN "savings_plan_savings_plan_effective_cost"
		-- WHEN "line_item_line_item_type" = 'DiscountedUsage' THEN "reservation_effective_cost"
		    WHEN "line_item_line_item_type" = 'Usage' THEN "line_item_unblended_cost"
		    ELSE 0 END) "amortized_cost"
		, "round"("sum"("line_item_usage_amount"), 2) "usage_quantity"
		FROM
		(ADD YOUR CUR TABLE NAME)
		WHERE (
		("bill_billing_period_start_date" >= ("date_trunc"('month', current_timestamp) - INTERVAL  '1' MONTH)) AND ("line_item_product_code" = 'AmazonEC2') AND ("product_servicecode" <> 'AWSDataTransfer') AND ("line_item_operation" LIKE '%RunInstances%') AND ("line_item_usage_type" NOT LIKE '%DataXfer%') AND 
		(("line_item_line_item_type" = 'Usage') 
		OR
		("line_item_line_item_type" = 'SavingsPlanCoveredUsage') 
		 OR 
		 ("line_item_line_item_type" = 'DiscountedUsage')))
		GROUP BY 1, 2, 3, 4,5,6,7
		



{{% /expand%}}




- {{%expand "Click here - if you have Reserved Instances, but do not have Savings Plans" %}}
The query is the same as the first query, except some of lines have been commented out. If your usage changes you can delete and recreate the required view with Savings Plans or Reserved Instance usage.


Modify the following SQL query for View2 - EC2_Running_Cost: 
 - Update line 21 replace (database).(tablename) with your CUR database and table name 

		CREATE OR REPLACE VIEW "ec2_running_cost" AS 
		SELECT DISTINCT
		"year"
		, "month"
		,  "bill_billing_period_start_date" "billing_period"
		,  "date_trunc"('hour', "line_item_usage_start_date") "usage_date"
		, "bill_payer_account_id" "payer_account_id"
		, "line_item_usage_account_id" "linked_account_id"
		, (CASE 
		-- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN 'SavingsPlan' 
		WHEN ("reservation_reservation_a_r_n" <> '') THEN 'Reserved' 
		WHEN ("line_item_usage_type" LIKE '%Spot%') THEN 'Spot' 
		ELSE 'OnDemand' END) "purchase_option"
		, "sum"(CASE
		-- WHEN "line_item_line_item_type" = 'SavingsPlanCoveredUsage' THEN "savings_plan_savings_plan_effective_cost"
		    WHEN "line_item_line_item_type" = 'DiscountedUsage' THEN "reservation_effective_cost"
		    WHEN "line_item_line_item_type" = 'Usage' THEN "line_item_unblended_cost"
		    ELSE 0 END) "amortized_cost"
		, "round"("sum"("line_item_usage_amount"), 2) "usage_quantity"
		FROM
		(ADD YOUR CUR TABLE NAME)
		WHERE (
		("bill_billing_period_start_date" >= ("date_trunc"('month', current_timestamp) - INTERVAL  '1' MONTH)) AND ("line_item_product_code" = 'AmazonEC2') AND ("product_servicecode" <> 'AWSDataTransfer') AND ("line_item_operation" LIKE '%RunInstances%') AND ("line_item_usage_type" NOT LIKE '%DataXfer%') AND 
		(("line_item_line_item_type" = 'Usage') 
		-- OR
		-- ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') 
		 OR 
		 ("line_item_line_item_type" = 'DiscountedUsage')))
		GROUP BY 1, 2, 3, 4,5,6,7




{{% /expand%}}




- {{%expand "Click here - if you do not have Reserved Instances, and do not have Savings Plans" %}}
The query is the same as the first query, except some of lines have been commented out. If your usage changes you can delete and recreate the required view with Savings Plans or Reserved Instance usage.


Modify the following SQL query for View2 - EC2_Running_Cost: 
 - Update line 21 replace (database).(tablename) with your CUR database and table name 

		CREATE OR REPLACE VIEW "ec2_running_cost" AS 
		SELECT DISTINCT
		"year"
		, "month"
		,  "bill_billing_period_start_date" "billing_period"
		,  "date_trunc"('hour', "line_item_usage_start_date") "usage_date"
		, "bill_payer_account_id" "payer_account_id"
		, "line_item_usage_account_id" "linked_account_id"
		, (CASE 
		-- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN 'SavingsPlan' 
		-- WHEN ("reservation_reservation_a_r_n" <> '') THEN 'Reserved' 
		WHEN ("line_item_usage_type" LIKE '%Spot%') THEN 'Spot' 
		ELSE 'OnDemand' END) "purchase_option"
		, "sum"(CASE
		-- WHEN "line_item_line_item_type" = 'SavingsPlanCoveredUsage' THEN "savings_plan_savings_plan_effective_cost"
		-- WHEN "line_item_line_item_type" = 'DiscountedUsage' THEN "reservation_effective_cost"
		    WHEN "line_item_line_item_type" = 'Usage' THEN "line_item_unblended_cost"
		    ELSE 0 END) "amortized_cost"
		, "round"("sum"("line_item_usage_amount"), 2) "usage_quantity"
		FROM
		(ADD YOUR CUR TABLE NAME)
		WHERE (
		("bill_billing_period_start_date" >= ("date_trunc"('month', current_timestamp) - INTERVAL  '1' MONTH)) AND ("line_item_product_code" = 'AmazonEC2') AND ("product_servicecode" <> 'AWSDataTransfer') AND ("line_item_operation" LIKE '%RunInstances%') AND ("line_item_usage_type" NOT LIKE '%DataXfer%') AND 
		(("line_item_line_item_type" = 'Usage') 
		 OR
		 ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') 
		 OR 
		 ("line_item_line_item_type" = 'DiscountedUsage')
		 ))
		GROUP BY 1, 2, 3, 4,5,6,7
		
		

{{% /expand%}}

- Confirm the view is working, run the following Athena query and you should receive 10 rows of data:

        select * from costmaster.ec2_running_cost
        limit 10
