---
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 999
hidden: FALSE
---


## View 5 - RI SP Mapping
This view will be used to create the **RI SP Mapping** dashboard page.
Use one of the following queries depending on whether you have Reserved Instances, or Savings Plans.

### Create View
- {{%expand "Click here - if you have both Savings Plans and Reserved Instances" %}}

Modify the following SQL query for View5 - RI SP Mapping:
 - Update lines 23 and 44, replace (database).(tablename) with your CUR database and table name 

	 CREATE OR REPLACE VIEW "ri_sp_mapping" AS 
	 SELECT DISTINCT
	   "a"."billing_period_mapping"
	 , "a"."payer_account_id_mapping"
	 , "a"."ri_sp_arn_mapping"
	 , "a"."ri_sp_end_date"
	 , "b"."ri_sp_term"
	 , "b"."ri_sp_offering"
	 , "b"."ri_sp_payment"
	 
	 FROM
	   ((
		SELECT DISTINCT
	  "bill_billing_period_start_date" "billing_period_mapping"
	 , "bill_payer_account_id" "payer_account_id_mapping"
	 , CASE 
		WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_savings_plan_a_r_n" 
		WHEN ("reservation_reservation_a_r_n" <> '') THEN "reservation_reservation_a_r_n"ELSE '' END "ri_sp_arn_mapping"
	 , CASE 
		WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN CAST(from_iso8601_timestamp("savings_plan_end_time") AS timestamp)
		WHEN ("reservation_reservation_a_r_n" <> '' AND "reservation_end_time" <> '') THEN CAST(from_iso8601_timestamp("reservation_end_time") AS timestamp) ELSE NULL END "ri_sp_end_date"
		FROM
		  (database).(tablename)
		WHERE (("line_item_line_item_type" = 'RIFee') OR ("line_item_line_item_type" = 'SavingsPlanRecurringFee'))
	 
	 )  a
	 LEFT JOIN (
		SELECT DISTINCT
	  "bill_billing_period_start_date" "billing_period_mapping"
	 , "bill_payer_account_id" "payer_account_id_mapping"
	 , CASE 
		WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_savings_plan_a_r_n" 
		WHEN ("reservation_reservation_a_r_n" <> '') THEN "reservation_reservation_a_r_n"ELSE '' END "ri_sp_arn_mapping"
	 , CASE 
		WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_purchase_term" 
	 WHEN ("reservation_reservation_a_r_n" <> '') THEN "pricing_lease_contract_length"ELSE '' END "ri_sp_term"
	 , CASE 
		WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_offering_type" 
		WHEN ("reservation_reservation_a_r_n" <> '') THEN "pricing_offering_class" ELSE '' END "ri_sp_offering"
	 , CASE 
		WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_payment_option" 
		WHEN ("reservation_reservation_a_r_n" <> '') THEN "pricing_purchase_option"	ELSE '' END "ri_sp_Payment"
		FROM
		  (database).(tablename)
		WHERE (("line_item_line_item_type" = 'DiscountedUsage') OR ("line_item_line_item_type" = 'SavingsPlanCoveredUsage'))
	 
	 )  b ON (("a"."ri_sp_arn_mapping" = "b"."ri_sp_arn_mapping") AND ("a"."billing_period_mapping" = "b"."billing_period_mapping") AND ("a"."payer_account_id_mapping" = "b"."payer_account_id_mapping")))
	

{{% /expand%}}



- {{%expand "Click here - if you have Savings Plans, but do not have Reserved Instances" %}}
If your usage changes you can delete and recreate the required view with Savings Plans or Reserved Instance usage.


Modify the following SQL query for View5 - RI SP Mapping:
 - Update lines 25 and 54, replace (database).(tablename) with your CUR database and table name 
		
	 CREATE OR REPLACE VIEW "ri_sp_mapping" AS 
	 SELECT DISTINCT
	   "a"."billing_period_mapping"
	 , "a"."payer_account_id_mapping"
	 , "a"."ri_sp_arn_mapping"
	 , "a"."ri_sp_end_date"
	 , "b"."ri_sp_term"
	 , "b"."ri_sp_offering"
	 , "b"."ri_sp_payment"
	 
	 FROM
	   ((
		SELECT DISTINCT
	  "bill_billing_period_start_date" "billing_period_mapping"
	 , "bill_payer_account_id" "payer_account_id_mapping"
	 , CASE 
		WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_savings_plan_a_r_n" 
		-- WHEN ("reservation_reservation_a_r_n" <> '') THEN "reservation_reservation_a_r_n"
		ELSE '' END "ri_sp_arn_mapping"
	 ,CASE 
		WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN CAST(from_iso8601_timestamp("savings_plan_end_time") AS timestamp)
		-- WHEN ("reservation_reservation_a_r_n" <> '' AND "reservation_end_time" <> '') THEN CAST(from_iso8601_timestamp("reservation_end_time") AS timestamp) 
		ELSE NULL END "ri_sp_end_date"
		FROM
		 (database).(tablename)
		WHERE (
		-- ("line_item_line_item_type" = 'RIFee') 
	 -- OR 
	 ("line_item_line_item_type" = 'SavingsPlanRecurringFee')
		)
	 
	 )  a
	 LEFT JOIN (
		SELECT DISTINCT
	  "bill_billing_period_start_date" "billing_period_mapping"
	 , "bill_payer_account_id" "payer_account_id_mapping"
	 , CASE 
		WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_savings_plan_a_r_n" 
		-- WHEN ("reservation_reservation_a_r_n" <> '') THEN "reservation_reservation_a_r_n"
		ELSE '' END "ri_sp_arn_mapping"
	 , CASE 
	 WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_purchase_term" 
	 -- WHEN ("reservation_reservation_a_r_n" <> '') THEN "pricing_lease_contract_length"
	 ELSE '' END "ri_sp_term"
	 , CASE 
		WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_offering_type" 
		-- WHEN ("reservation_reservation_a_r_n" <> '') THEN "pricing_offering_class" 
		ELSE '' END "ri_sp_offering"
	 , CASE 
		WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_payment_option" 
		-- WHEN ("reservation_reservation_a_r_n" <> '') THEN "pricing_purchase_option"
		ELSE '' END "ri_sp_Payment"
		FROM
		  (database).(tablename)
		WHERE (
		-- ("line_item_line_item_type" = 'DiscountedUsage') 
	  -- OR 
	   ("line_item_line_item_type" = 'SavingsPlanCoveredUsage')
		)
	 
	 )  b ON (("a"."ri_sp_arn_mapping" = "b"."ri_sp_arn_mapping") AND ("a"."billing_period_mapping" = "b"."billing_period_mapping") AND ("a"."payer_account_id_mapping" = "b"."payer_account_id_mapping")))

			

{{% /expand%}}



- {{%expand "Click here - if you have Reserved Instances, but do not have Savings Plans" %}}
If your usage changes you can delete and recreate the required view with Savings Plans or Reserved Instance usage.


Modify the following SQL query for View5 - RI SP Mapping:
 - Update lines 25 and 54, replace (database).(tablename) with your CUR database and table name 

		
	 CREATE OR REPLACE VIEW "ri_sp_mapping" AS 
	 SELECT DISTINCT
	   "a"."billing_period_mapping"
	 , "a"."payer_account_id_mapping"
	 , "a"."ri_sp_arn_mapping"
	 , "a"."ri_sp_end_date"
	 , "b"."ri_sp_term"
	 , "b"."ri_sp_offering"
	 , "b"."ri_sp_payment"
	 
	 FROM
	   ((
		SELECT DISTINCT
	  "bill_billing_period_start_date" "billing_period_mapping"
	 , "bill_payer_account_id" "payer_account_id_mapping"
	 , CASE 
	 -- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_savings_plan_a_r_n" 
		WHEN ("reservation_reservation_a_r_n" <> '') THEN "reservation_reservation_a_r_n"
		ELSE '' END "ri_sp_arn_mapping"
	 , CASE 
	 -- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN CAST(from_iso8601_timestamp("savings_plan_end_time") AS timestamp)
		WHEN ("reservation_reservation_a_r_n" <> '' AND "reservation_end_time" <> '') THEN CAST(from_iso8601_timestamp("reservation_end_time") AS timestamp) 
		ELSE NULL END "ri_sp_end_date"
		FROM
		 (database).(tablename)
		WHERE (
		("line_item_line_item_type" = 'RIFee') 
	 -- OR 
	  -- ("line_item_line_item_type" = 'SavingsPlanRecurringFee')
		)
	 
	 )  a
	 LEFT JOIN (
		SELECT DISTINCT
	  "bill_billing_period_start_date" "billing_period_mapping"
	 , "bill_payer_account_id" "payer_account_id_mapping"
	 , CASE 
	 -- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_savings_plan_a_r_n" 
		WHEN ("reservation_reservation_a_r_n" <> '') THEN "reservation_reservation_a_r_n"
		ELSE '' END "ri_sp_arn_mapping"
	 , CASE 
	 -- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_purchase_term" 
	 WHEN ("reservation_reservation_a_r_n" <> '') THEN "pricing_lease_contract_length"
	 ELSE '' END "ri_sp_term"
	 , CASE 
	 -- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_offering_type" 
		WHEN ("reservation_reservation_a_r_n" <> '') THEN "pricing_offering_class" 
		ELSE '' END "ri_sp_offering"
	 , CASE 
	 -- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_payment_option" 
		WHEN ("reservation_reservation_a_r_n" <> '') THEN "pricing_purchase_option"
		ELSE '' END "ri_sp_Payment"
		FROM
		  (database).(tablename)
		WHERE (
		("line_item_line_item_type" = 'DiscountedUsage') 
	  -- OR 
	   -- ("line_item_line_item_type" = 'SavingsPlanCoveredUsage')
		)
	 
	 )  b ON (("a"."ri_sp_arn_mapping" = "b"."ri_sp_arn_mapping") AND ("a"."billing_period_mapping" = "b"."billing_period_mapping") AND ("a"."payer_account_id_mapping" = "b"."payer_account_id_mapping")))

		

{{% /expand%}}




- {{%expand "Click here - if you do not have Reserved Instances, and do not have Savings Plans" %}}
If your usage changes you can delete and recreate the required view with Savings Plans or Reserved Instance usage.


Modify the following SQL query for View5 - RI SP Mapping:
 - Update lines 27 and 62, replace (database).(tablename) with your CUR database and table name 

	 CREATE OR REPLACE VIEW "ri_sp_mapping" AS 
	 SELECT DISTINCT
	   "a"."billing_period_mapping"
	 , "a"."payer_account_id_mapping"
	 , "a"."ri_sp_arn_mapping"
	 , "a"."ri_sp_end_date"
	 , "b"."ri_sp_term"
	 , "b"."ri_sp_offering"
	 , "b"."ri_sp_payment"
	 
	 FROM
	   ((
		SELECT DISTINCT
	  "bill_billing_period_start_date" "billing_period_mapping"
	 , "bill_payer_account_id" "payer_account_id_mapping"
	 , CASE 
	 -- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_savings_plan_a_r_n" 
	 -- WHEN ("reservation_reservation_a_r_n" <> '') THEN "reservation_reservation_a_r_n"
		WHEN ("line_item_line_item_type" = 'Usage') THEN ' '
		ELSE '' END "ri_sp_arn_mapping"
	 , CAST(CASE 
	  -- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN CAST(from_iso8601_timestamp("savings_plan_end_time") AS timestamp)
	  -- WHEN ("reservation_reservation_a_r_n" <> '' AND "reservation_end_time" <> '') THEN CAST(from_iso8601_timestamp("reservation_end_time") AS timestamp) 
		 WHEN ("line_item_line_item_type" = 'Usage') THEN ' '
		ELSE NULL END AS timestamp) "ri_sp_end_date"
		FROM
		 (database).(tablename)
	 WHERE (
	  ("line_item_line_item_type" <> 'Usage') 
	 -- OR
	 --   ("line_item_line_item_type" = 'RIFee') 
	 -- OR 
	  -- ("line_item_line_item_type" = 'SavingsPlanRecurringFee')
	 )
	 
	 )  a
	 LEFT JOIN (
		SELECT DISTINCT
	  "bill_billing_period_start_date" "billing_period_mapping"
	 , "bill_payer_account_id" "payer_account_id_mapping"
	 , CASE 
	 -- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_savings_plan_a_r_n" 
	 -- WHEN ("reservation_reservation_a_r_n" <> '') THEN "reservation_reservation_a_r_n"
		WHEN ("line_item_line_item_type" = 'Usage') THEN ' '
		ELSE '' END "ri_sp_arn_mapping"
	 , CASE 
	 -- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_purchase_term" 
	 -- WHEN ("reservation_reservation_a_r_n" <> '') THEN "pricing_lease_contract_length"
		WHEN ("line_item_line_item_type" = 'Usage') THEN ' '
	 ELSE '' END "ri_sp_term"
	 , CASE 
	 -- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_offering_type" 
	 -- WHEN ("reservation_reservation_a_r_n" <> '') THEN "pricing_offering_class" 
	  WHEN ("line_item_line_item_type" = 'Usage') THEN ' '
		ELSE '' END "ri_sp_offering"
	 , CASE 
	 -- WHEN ("savings_plan_savings_plan_a_r_n" <> '') THEN "savings_plan_payment_option" 
	 -- WHEN ("reservation_reservation_a_r_n" <> '') THEN "pricing_purchase_option"
	  WHEN ("line_item_line_item_type" = 'Usage') THEN ' '
		ELSE '' END "ri_sp_Payment"
		FROM
		  (database).(tablename)
	 WHERE (
	  ("line_item_line_item_type" <> 'Usage') 
	  -- OR
	  -- ("line_item_line_item_type" = 'DiscountedUsage') 
	  -- OR 
	  -- ("line_item_line_item_type" = 'SavingsPlanCoveredUsage')
	  )
	 
	 )  b ON (("a"."ri_sp_arn_mapping" = "b"."ri_sp_arn_mapping") AND ("a"."billing_period_mapping" = "b"."billing_period_mapping") AND ("a"."payer_account_id_mapping" = "b"."payer_account_id_mapping")))


{{% /expand%}}

### Validate View

- Confirm the view is working, run the following Athena query and you should receive 10 rows of data:

        select * from costmaster.ri_sp_mapping
        limit 10
		
