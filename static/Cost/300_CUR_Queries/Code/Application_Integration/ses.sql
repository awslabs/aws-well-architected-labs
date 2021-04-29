-- modified: 2021-04-25
-- query_id: ses
-- query_description: This query will provide daily unblended and usage information per linked account for Amazon SES. The output will include detailed information about the product family (Sending Attachments, Data Transfer, etc…) and usage type. The usage amount and cost will be summed and the cost will be in descending order.
-- query_columns: bill_payer_account_id,line_item_unblended_cost,line_item_usage_account_id,line_item_usage_amount,line_item_usage_start_date,line_item_usage_type,product_product_family
-- query_link: /cost/300_labs/300_cur_queries/queries/application_integration/

SELECT -- automation_select_stmt
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, -- automation_timerange_dateformat
  product_product_family,
  CASE
    WHEN line_item_usage_type LIKE '%%DataTransfer-In-Bytes%%' THEN 'Data Transfer GB (IN) '
    WHEN line_item_usage_type LIKE '%%DataTransfer-Out-Bytes%%' THEN 'Data Transfer GB (Out)'
    WHEN line_item_usage_type LIKE '%%AttachmentsSize-Bytes%%' THEN 'Attachments GB'
    WHEN line_item_usage_type LIKE '%%Recipients' THEN 'Recipients'
    WHEN line_item_usage_type LIKE '%%Recipients-EC2' THEN 'Recipients'
    WHEN line_item_usage_type LIKE '%%Recipients-MailboxSim' THEN 'Recipients (MailboxSimulator)'
    WHEN line_item_usage_type LIKE '%%Message%%' THEN 'Messages'
    WHEN line_item_usage_type LIKE '%%ReceivedChunk%%' THEN 'Received Chunk'
    ELSE 'Others'
  END as case_line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM -- automation_from_stmt
  ${table_Name} -- automation_tablename
WHERE -- automation_where_stmt
  ${date_filter} -- automation_timerange_year_month
  AND product_product_name = 'Amazon Simple Email Service'
  AND line_item_line_item_type  in ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
GROUP BY -- automation_groupby_stmt
  bill_payer_account_id, 
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'), -- automation_timerange_dateformat
  product_product_family,
  line_item_usage_type
ORDER BY -- automation_order_stmt
  day_line_item_usage_start_date,
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost DESC;
