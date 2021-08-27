-- modified: 2021-08-24
-- query_id: amazon-ebs-snapshot-trends
-- query_description: This query looks across your EC2 EBS Snapshots to identify all snapshots that still exist today with their previous month spend. It then provides the start date which is the first billing period the snapshot appeared in your CUR and groups them so you can see if they are over 6 months old. Snapshots over 6 months old should be tagged to keep or cleaned up.  
-- query_columns: billing_period,current_billing_period,start_date,payer_account_id,linked_account_id,resource_id,usage_quantity,ebs_snapshot_cost,public_cost,ebs_snapshots_under_6mo_cost,ebs_snapshots_over_6mo_cost

-- query_link: /cost/300_labs/300_cur_queries/queries/cost_optimization

		-- Step 1: Filter CUR to return all ebs ec2 snapshot usage data
		WITH snapshot_usage_all_time AS (
			SELECT
			  year
			, month
			, bill_billing_period_start_date AS billing_period
			, bill_payer_account_id AS payer_account_id
			, line_item_usage_account_id AS linked_account_id
			, line_item_resource_id AS resource_id
			, sum(line_item_usage_amount) AS usage_quantity
			, sum(line_item_unblended_cost) AS unblended_cost
			, sum(pricing_public_on_demand_cost) AS public_cost 
			FROM ${table_name}
			WHERE bill_payer_account_id <> ''
			  AND line_item_resource_id <> ''
			  AND line_item_line_item_type LIKE '%Usage%'
			  AND line_item_product_code = 'AmazonEC2' 
			  AND line_item_usage_type LIKE '%EBS:Snapshot%'
			GROUP BY 1, 2, 3, 4, 5,6 
		),	
		-- Step 2: Return most recent billing_period and the first billing_period
		request_dates AS (
			SELECT
			  resource_id AS request_dates_resource_id
			, max(billing_period) AS current_billing_period
			, min(billing_period) AS start_date	
			FROM snapshot_usage_all_time
			GROUP BY 1
		)	
		(
		-- Step 3: Pivot table so looking at previous month filtered for only snapshots still available in the current month
			SELECT
			  billing_period
			, request_dates.current_billing_period
			, request_dates.start_date
			, payer_account_id
			, linked_account_id
			, resource_id
			, sum(usage_quantity) AS usage_quantity	
			, sum(unblended_cost) AS ebs_snapshot_cost
			, sum(public_cost) AS public_cost
			, sum((CASE WHEN (request_dates.start_date > (request_dates.current_billing_period - INTERVAL  '6' MONTH)) THEN unblended_cost ELSE 0 END)) "ebs_snapshots_under_6mo_cost"
			, sum((CASE WHEN (request_dates.start_date <= (request_dates.current_billing_period - INTERVAL  '6' MONTH)) THEN unblended_cost ELSE 0 END))"ebs_snapshots_over_6mo_cost"
		 /*No savings estimate since it uses uses 100% of snapshot cost for snapshots over 6mos as savings estimate*/ 
			FROM snapshot_usage_all_time snapshot
			LEFT JOIN request_dates ON request_dates.request_dates_resource_id = snapshot.resource_id
			WHERE CAST(concat(snapshot.year, '-', snapshot.month, '-01') AS date) = (date_trunc('month', current_date) - INTERVAL '1' MONTH) AND request_dates.current_billing_period = (date_trunc('month', current_date) - INTERVAL '0' MONTH)
			GROUP BY 1,2,3,4,5,6
			)