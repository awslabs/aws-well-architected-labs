-- modified: 2021-05-14
-- query_id: serverless
-- query_description: This query will provide monthly unblended costs for all Serverless products.
-- query_columns: bill_payer_account_id,line_item_line_item_type,line_item_usage_account_id,line_item_usage_start_date
-- query_link: /cost/300_labs/300_cur_queries/queries/global/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  -- if uncommenting, also uncomment three other occurrences of line_item_usage_account_id:
  -- two in SELECTs that are UNIONed and one in GROUP BY or ^F.
  -- line_item_usage_account_id,
  month_line_item_usage_start_date, -- automation_timerange_dateformat
  line_item_product_code,
  split_line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt 
(

  SELECT -- automation_select_stmt
    bill_payer_account_id,
    -- line_item_usage_account_id,
    DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
    line_item_product_code,
    CASE REGEXP_REPLACE(SPLIT_PART(line_item_usage_type, ':', 1), '^[^-]*-')
      WHEN 'Fargate-GB-Hours' THEN 'Fargate'
      WHEN 'Fargate-vCPU-Hours' THEN 'Fargate'
      WHEN 'SpotUsage-Fargate-GB-Hours' THEN 'Fargate'
      WHEN 'SpotUsage-Fargate-vCPU-Hours' THEN 'Fargate'
      ELSE '--'    -- should not be reached!
    END AS split_line_item_usage_type,
    line_item_usage_amount,
    line_item_unblended_cost,
    year,
    month
  FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
  WHERE -- automation_where_stmt
    (
      line_item_line_item_type IN ('DiscountedUsage',
                                   'Usage',
                                   'Credit',
                                   'RIFee',
                                   'SavingsPlanCoveredUsage',
                                   'SavingsPlanNegation')
    )
    AND
    (
      line_item_usage_type LIKE '%Fargate%' AND
      line_item_product_code IN ('AmazonECS', 'AmazonEKS')
    )

  UNION ALL

  SELECT -- automation_select_stmt
    bill_payer_account_id,
    -- line_item_usage_account_id,
    DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, -- automation_timerange_dateformat
    line_item_product_code,
    CASE SPLIT_PART(line_item_usage_type, ':', 2)
      WHEN 'ProxyUsage' THEN 'RDS Proxy Usage'
      WHEN 'ServerlessUsage' THEN 'Aurora Serverless'
      ELSE '--'
    END AS split_line_item_usage_type,
    line_item_usage_amount,
    line_item_unblended_cost,
    year,
    month
  FROM -- automation_from_stmt
  ${table_name} -- automation_tablename
  WHERE -- automation_where_stmt
    (
      line_item_line_item_type IN ('DiscountedUsage',
                                   'Usage',
                                   'Credit',
                                   'RIFee',
                                   'SavingsPlanCoveredUsage',
                                   'SavingsPlanNegation')
    )
    AND
    (
      (
        line_item_product_code = 'AmazonRDS' AND
        SPLIT_PART(line_item_usage_type, ':', 2) IN ('ServerlessUsage', 'ProxyUsage')
      )
      OR
      (
        line_item_product_code IN ('AmazonDynamoDB', 'AmazonDAX',
                                   'AmazonS3', 'AWSAppSync',
                                   'AmazonApiGateway',
                                   'Amazon Simple Notification Service',
                                   'AWSQueueService', 'AWSLambda',
                                   'AWSEvents'
                                  )
      )
    )
)

WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id,
  -- line_item_usage_account_id,
  month_line_item_usage_start_date,
  line_item_product_code,
  split_line_item_usage_type

ORDER BY -- automation_order_stmt
  month_line_item_usage_start_date,
  line_item_product_code,
  split_line_item_usage_type;