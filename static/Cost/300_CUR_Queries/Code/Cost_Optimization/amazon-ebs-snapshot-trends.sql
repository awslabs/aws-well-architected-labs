-- modified: 2022-02-08
-- query_id: amazon-ebs-snapshot-trends
-- query_description: This query looks across your EC2 EBS Snapshots to identify all snapshots that still exist today with their previous month spend. It then provides the start date which is the first billing period the snapshot appeared in your CUR and groups them so you can see if they are over 1yr old. Snapshots over 1yr old should be tagged to keep, cleaned up, or archived.  
-- query_columns: billing_period,start_date,payer_account_id,linked_account_id,resource_id,snapshot_type,usage_quantity,ebs_snapshot_cost,public_cost,ebs_snapshots_under_1yr_cost,ebs_snapshots_over_1yr_cost

-- query_link: /cost/300_labs/300_cur_queries/queries/cost_optimization

WITH snapshot_usage_all_time AS (
  SELECT
    year,
	month,
	bill_billing_period_start_date billing_period,
	line_item_usage_start_date usage_start_date,
	bill_payer_account_id payer_account_id,
	line_item_usage_account_id linked_account_id,
	line_item_resource_id resource_id,
	(CASE 
	  WHEN (line_item_usage_type LIKE '%EBS:SnapshotArchive%') THEN 'Snapshot_Archive' 
	  WHEN (line_item_usage_type LIKE '%EBS:Snapshot%') THEN 'Snapshot' 
	  ELSE "line_item_operation" 
	END) AS snapshot_type,
	line_item_usage_amount,
	line_item_unblended_cost,
	pricing_public_on_demand_cost
  FROM
    ${table_name}
  WHERE 
    (((((bill_payer_account_id <> '') 
	AND (line_item_resource_id <> '')) 
	AND (line_item_line_item_type LIKE '%Usage%')) 
	AND (line_item_product_code = 'AmazonEC2')) 
	AND (line_item_usage_type LIKE '%EBS:Snapshot%'))
),	
-- Step 2: Return most recent billing_period and the first billing_period
request_dates AS (
  SELECT DISTINCT
    resource_id AS request_dates_resource_id, 
	MIN(usage_start_date) AS start_date
  FROM
    snapshot_usage_all_time
  WHERE
    (snapshot_type = 'Snapshot')
  GROUP BY 
    1
), 
-- Step 3: Pivot table so looking at previous month filtered for only snapshots still available in the current month
snapshot_usage_all_time_before_map AS (
  SELECT DISTINCT
    billing_period,
	request_dates.start_date,
	payer_account_id,
	linked_account_id,
	snapshot_type,
	resource_id,
	SUM(line_item_usage_amount) usage_quantity,
	SUM(line_item_unblended_cost) ebs_snapshot_cost,
	SUM(pricing_public_on_demand_cost) public_cost,
	SUM((CASE 
	  WHEN ((request_dates.start_date > (billing_period - INTERVAL  '12' MONTH)) AND (snapshot_type = 'Snapshot')) THEN line_item_unblended_cost 
	  ELSE 0 
	END)) AS ebs_snapshots_under_1yr_cost,  
	/*No savings estimate since it uses uses 100% of snapshot cost for snapshots over 6mos as savings estimate*/ 
	SUM((CASE 
	  WHEN ((request_dates.start_date <= (billing_period - INTERVAL  '12' MONTH)) AND (snapshot_type = 'Snapshot')) THEN line_item_unblended_cost 
	  ELSE 0 
	END)) AS ebs_snapshots_over_1yr_cost
  FROM
    (snapshot_usage_all_time snapshot
	LEFT JOIN request_dates ON (request_dates.request_dates_resource_id = snapshot.resource_id))
      WHERE (CAST("concat"(snapshot.year, '-', snapshot.month, '-01') AS date) = ("date_trunc"('month', current_date) - INTERVAL  '1' MONTH))
  GROUP BY 
    1, 2, 3, 4, 5, 6
)

-- Step 4: Add all data
SELECT
  billing_period,
  start_date,
  payer_account_id,
  linked_account_id,
  resource_id,
  snapshot_type,
  usage_quantity,
  ebs_snapshot_cost,
  public_cost,
  ebs_snapshots_under_1yr_cost,
  ebs_snapshots_over_1yr_cost
FROM
  snapshot_usage_all_time_before_map
;
