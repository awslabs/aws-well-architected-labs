-- modified: 2023-07-06
-- query_id: ecs-split-cost-allocation
-- query_description: This query calculates costs by considering the amortized cost of the instance and the proportion of CPU and memory resources utilized by the containers.
-- query_columns: 
-- query_link: /cost/300_labs/300_cur_queries/queries/container/
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  line_item_usage_type,
  SPLIT_PART(line_item_resource_id,':',6) AS split_line_item_resource_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m') AS month_line_item_usage_start_date, 
  line_item_operation,
  line_item_product_code,
  split_line_item_parent_resource_id,
  SUM(CAST(split_line_item_split_usage AS DECIMAL(16,8))) AS sum_split_line_item_split_usage,
  SUM(CAST(split_line_item_split_cost AS DECIMAL(16,8))) AS sum_split_line_item_split_cost,
  SUM(CAST(split_line_item_unused_cost AS DECIMAL(16,8))) sum_split_line_item_unused_cost
FROM 
  ${table_name}
WHERE 
  ${date_filter}
  and line_item_product_code IN ('AmazonECS') AND line_item_operation like 'ECSTask%'
  and split_line_item_split_usage !='' and split_line_item_split_cost !='' and split_line_item_unused_cost !=''
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  line_item_usage_type,
  SPLIT_PART(line_item_resource_id,':',6),
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m'),
  line_item_operation,
  line_item_product_code,
  split_line_item_parent_resource_id,
  split_line_item_split_usage,
  split_line_item_split_cost,
  split_line_item_unused_cost
ORDER BY 
  month_line_item_usage_start_date ASC,
  split_line_item_unused_cost DESC,
  line_item_operation