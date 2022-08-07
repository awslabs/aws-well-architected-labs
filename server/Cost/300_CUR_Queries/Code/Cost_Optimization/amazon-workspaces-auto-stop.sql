-- modified: 2021-07-08
-- query_id: amazon-workspaces-auto-stop
-- query_description: AutoStop Workspaces are cost effective when used for several hours per day. If AutoStop Workspaces run for more than 80 hrs per month it is more cost effective to switch to AlwaysOn mode. This query shows AutoStop Workspaces which ran more that 80 hrs in previous month. If usage pattern for these Workspaces is the same month over month it's possible to optimize cost with switching to AlwaysOn mode. 
-- query_columns: bill_payer_account_id,line_item_operation,line_item_resource_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,product_region,product_operating_system,product_bundle_description,product_software_included,product_license,product_rootvolume,product_uservolume,pricing_unit
-- query_link: /cost/300_labs/300_cur_queries/queries/cost_optimization

SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  SPLIT_PART(line_item_resource_id, '/', 2) AS split_line_item_resource_id,
  product_region,
  product_operating_system,
  product_bundle_description,
  product_software_included,
  product_license,
  product_rootvolume,
  product_uservolume,
  pricing_unit,
  sum_line_item_usage_amount,
  CAST(total_cost_per_resource AS DECIMAL(16, 8)) AS "sum_line_item_unblended_cost(incl monthly fee)"
FROM
  (
  SELECT
    bill_payer_account_id,
    line_item_usage_account_id,
	  line_item_resource_id,
	  product_operating_system,
	  pricing_unit,
	  product_region,
	  product_bundle_description,
	  product_rootvolume,
	  product_uservolume,
	  product_software_included,
	  product_license,
	  SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
	  SUM(SUM(line_item_unblended_cost)) OVER (PARTITION BY line_item_resource_id) AS total_cost_per_resource,
	  SUM(SUM(line_item_usage_amount)) OVER (PARTITION BY line_item_resource_id, pricing_unit) AS usage_amount_per_resource_and_pricing_unit
	FROM
	  ${table_name}
	WHERE
	  line_item_product_code = 'AmazonWorkSpaces' 
	  -- get previous month
	  AND CAST(month AS INT) = CAST(month(current_timestamp + -1 * INTERVAL '1' MONTH) AS INT) 
	  -- get year for previous month
	  AND CAST(year AS INT) = CAST(year(current_timestamp + -1 * INTERVAL '1' MONTH) AS INT)
	  AND line_item_line_item_type = 'Usage'
	  AND line_item_usage_type LIKE '%AutoStop%'
	GROUP BY
	  line_item_usage_account_id,
	  line_item_resource_id,
	  product_operating_system,
	  pricing_unit,
	  product_region,
	  product_bundle_description,
	  product_rootvolume,
	  product_uservolume,
	  bill_payer_account_id,
	  product_software_included,
	  product_license
  )     
WHERE
  -- return only workspaces which ran more than 80 hrs
  usage_amount_per_resource_and_pricing_unit > 80
ORDER BY
  total_cost_per_resource DESC,
  line_item_resource_id,
  line_item_usage_account_id,
  product_operating_system,
  pricing_unit
;
