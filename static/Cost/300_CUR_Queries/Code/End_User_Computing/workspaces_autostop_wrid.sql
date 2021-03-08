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
  CAST(total_cost_per_resource AS decimal(16, 8)) AS "sum_line_item_unblended_cost(incl monthly fee)"
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
      SUM("line_item_usage_amount") AS "sum_line_item_usage_amount",
      SUM(SUM("line_item_unblended_cost")) OVER (PARTITION BY "line_item_resource_id") AS "total_cost_per_resource",
      SUM(SUM("line_item_usage_amount")) OVER (PARTITION BY "line_item_resource_id", "pricing_unit") AS "usage_amount_per_resource_and_pricing_unit"
    FROM
      $ {table_name}
    WHERE
      line_item_product_code = 'AmazonWorkSpaces' 
      -- get previous month
      AND month = cast(month(current_timestamp + -1 * interval '1' MONTH) AS VARCHAR) 
      -- get year for previous month
      AND year = cast(year(current_timestamp + -1 * interval '1' MONTH) AS VARCHAR)
      AND line_item_line_item_type = 'Usage'
      AND line_item_usage_type like '%AutoStop%'
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
  "usage_amount_per_resource_and_pricing_unit" > 80
ORDER BY
  total_cost_per_resource DESC,
  line_item_resource_id,
  line_item_usage_account_id,
  product_operating_system,
  pricing_unit