---
date: 2022-01-16T11:16:08-04:00
chapter: false
weight: 999
hidden: FALSE
---



## KPI EBS Snap View
This view will be used to create the **KPI EBS Snap view** that is used to analyze EBS snap metrics and potential savings opportunities. There is only one version of this view and it is not dependent on if you have or do not have Reserved Instances or Savings Plans.      


### Create View
- {{%expand "Click here to expand the view" %}}

Modify the following SQL query for the KPI EBS Snap view: 
 - Update line 22, replace (database).(tablename) with your CUR database and table name 

		CREATE OR REPLACE VIEW kpi_ebs_snap AS 
		WITH 
		-- Step 1: Add mapping view
		map AS(SELECT *
		FROM account_map),

		-- Step 2: Filter CUR to return all ebs ec2 snapshot usage data
		snapshot_usage_all_time AS (
		   SELECT
			 year
		   , month
		   , bill_billing_period_start_date billing_period
		   , line_item_usage_start_date usage_start_date
		   , bill_payer_account_id payer_account_id
		   , line_item_usage_account_id linked_account_id
		   , line_item_resource_id resource_id
		   , (CASE WHEN (line_item_usage_type LIKE '%EBS:SnapshotArchive%') THEN 'Snapshot_Archive' WHEN (line_item_usage_type LIKE '%EBS:Snapshot%') THEN 'Snapshot' ELSE "line_item_operation" END) snapshot_type
		   , line_item_usage_amount
		   , line_item_unblended_cost
		   , pricing_public_on_demand_cost
		   FROM
			(database).(tablename)
		   WHERE (((((bill_payer_account_id <> '') AND (line_item_resource_id <> '')) AND (line_item_line_item_type LIKE '%Usage%')) AND (line_item_product_code = 'AmazonEC2')) AND (line_item_usage_type LIKE '%EBS:Snapshot%'))

		),	
		-- Step 3: Return most recent billing_period and the first billing_period
		request_dates AS (
		   SELECT DISTINCT
			 resource_id request_dates_resource_id
		   , "min"(usage_start_date) start_date
		   FROM
			 snapshot_usage_all_time
		   WHERE (snapshot_type = 'Snapshot')
		   GROUP BY 1
		), snapshot_usage_all_time_before_map AS 	
		(
		-- Step 4: Pivot table so looking at previous month filtered for only snapshots still available in the current month
		   SELECT DISTINCT
			 billing_period
		   , request_dates.start_date
		   , payer_account_id
		   , linked_account_id
		   , snapshot_type
		   , resource_id
		   , "sum"(line_item_usage_amount) usage_quantity
		   , "sum"(line_item_unblended_cost) ebs_snapshot_cost
		   , "sum"(pricing_public_on_demand_cost) public_cost
		   , "sum"((CASE WHEN ((request_dates.start_date > (billing_period - INTERVAL  '12' MONTH)) AND (snapshot_type = 'Snapshot')) THEN line_item_unblended_cost ELSE 0 END)) "ebs_snapshots_under_1yr_cost"  /*No savings estimate since it uses uses 100% of snapshot cost for snapshots over 6mos as savings estimate*/ 
		   , "sum"((CASE WHEN ((request_dates.start_date <= (billing_period - INTERVAL  '12' MONTH)) AND (snapshot_type = 'Snapshot')) THEN line_item_unblended_cost ELSE 0 END)) "ebs_snapshots_over_1yr_cost"
		   FROM
			 (snapshot_usage_all_time snapshot
		   LEFT JOIN request_dates ON (request_dates.request_dates_resource_id = snapshot.resource_id))
		   WHERE (CAST("concat"(snapshot.year, '-', snapshot.month, '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '3' MONTH))
		   GROUP BY 1, 2, 3, 4, 5, 6
		)
		(
		-- Step 5: Add in map data
		   SELECT
			 billing_period
		   , start_date
		   , payer_account_id
		   , linked_account_id
		   , map.*
		   , resource_id
		   , snapshot_type
		   , usage_quantity
		   , ebs_snapshot_cost
		   , public_cost
		   , "ebs_snapshots_under_1yr_cost"
		   , "ebs_snapshots_over_1yr_cost"
		   FROM
			 (snapshot_usage_all_time_before_map
		   LEFT JOIN map ON (map.account_id = linked_account_id))
		) 

{{% /expand%}}

### Adding Cost Allocation Tags
{{% notice tip %}}
Cost Allocation tags can be added to any views. We recommend adding while creating the dashboard to eliminate rework. 
{{% /notice %}}

{{%expand "Click here - for an example with a cost allocation tags" %}}
Example uses the tag **resource_tags_user_project**

		 CREATE OR REPLACE VIEW kpi_ebs_snap AS 
		 WITH 
		 -- Step 1: Add mapping view
		 map AS(SELECT *
		 FROM account_map),

		 -- Step 2: Filter CUR to return all ebs ec2 snapshot usage data
		 snapshot_usage_all_time AS (
			SELECT
			  year
			, month
			, bill_billing_period_start_date billing_period
			, line_item_usage_start_date usage_start_date
			, bill_payer_account_id payer_account_id
			, line_item_usage_account_id linked_account_id
			, resource_tags_user_project
			, line_item_resource_id resource_id
			, (CASE WHEN (line_item_usage_type LIKE '%EBS:SnapshotArchive%') THEN 'Snapshot_Archive' WHEN (line_item_usage_type LIKE '%EBS:Snapshot%') THEN 'Snapshot' ELSE "line_item_operation" END) snapshot_type
			, line_item_usage_amount
			, line_item_unblended_cost
			, pricing_public_on_demand_cost
			FROM
			 (database).(tablename)
			WHERE (((((bill_payer_account_id <> '') AND (line_item_resource_id <> '')) AND (line_item_line_item_type LIKE '%Usage%')) AND (line_item_product_code = 'AmazonEC2')) AND (line_item_usage_type LIKE '%EBS:Snapshot%'))

		 ),	
		 -- Step 3: Return most recent billing_period and the first billing_period
		 request_dates AS (
			SELECT DISTINCT
			  resource_id request_dates_resource_id
			, "min"(usage_start_date) start_date
			FROM
			  snapshot_usage_all_time
			WHERE (snapshot_type = 'Snapshot')
			GROUP BY 1
		 ), snapshot_usage_all_time_before_map AS 	
		 (
		 -- Step 4: Pivot table so looking at previous month filtered for only snapshots still available in the current month
			SELECT DISTINCT
			  billing_period
			, request_dates.start_date
			, payer_account_id
			, linked_account_id
			, resource_tags_user_project
			, snapshot_type
			, resource_id
			, "sum"(line_item_usage_amount) usage_quantity
			, "sum"(line_item_unblended_cost) ebs_snapshot_cost
			, "sum"(pricing_public_on_demand_cost) public_cost
			, "sum"((CASE WHEN ((request_dates.start_date > (billing_period - INTERVAL  '12' MONTH)) AND (snapshot_type = 'Snapshot')) THEN line_item_unblended_cost ELSE 0 END)) "ebs_snapshots_under_1yr_cost"  /*No savings estimate since it uses uses 100% of snapshot cost for snapshots over 6mos as savings estimate*/ 
			, "sum"((CASE WHEN ((request_dates.start_date <= (billing_period - INTERVAL  '12' MONTH)) AND (snapshot_type = 'Snapshot')) THEN line_item_unblended_cost ELSE 0 END)) "ebs_snapshots_over_1yr_cost"
			FROM
			  (snapshot_usage_all_time snapshot
			LEFT JOIN request_dates ON (request_dates.request_dates_resource_id = snapshot.resource_id))
			WHERE (CAST("concat"(snapshot.year, '-', snapshot.month, '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '3' MONTH))
			GROUP BY 1, 2, 3, 4, 5, 6,7
		 )
		 (
		 -- Step 5: Add in map data
			SELECT
			  billing_period
			, start_date
			, payer_account_id
			, linked_account_id
			, resource_tags_user_project
			, map.*
			, resource_id
			, snapshot_type
			, usage_quantity
			, ebs_snapshot_cost
			, public_cost
			, "ebs_snapshots_under_1yr_cost"
			, "ebs_snapshots_over_1yr_cost"
			FROM
			  (snapshot_usage_all_time_before_map
			LEFT JOIN map ON (map.account_id = linked_account_id))
		 ) 


{{% /expand%}}


### Validate View 
- Confirm the view is working, run the following Athena query and you should receive 10 rows of data:

        select * from kpi_ebs_snap
        limit 10
