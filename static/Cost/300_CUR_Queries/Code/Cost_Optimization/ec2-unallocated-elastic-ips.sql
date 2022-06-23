-- modified: 2022-01-27
-- query_id: ec2-unallocated-elastic-ips
-- query_description: This query will return cost for unallocated Elastic IPs. Elastic IPs incur hourly charges when they are not allocated to a Network Load Balancer, NAT gateway or an EC2 instance (or when there are multiple Elastic IPs allocated to the same EC2 instance). The usage amount (in hours) and cost are summed and returned in descending order, along with the associated Account ID and Region.

-- query_link: /cost/300_labs/300_cur_queries/queries/cost_optimization

SELECT
  line_item_usage_account_id,
  line_item_usage_type,
  product_location,
  line_item_line_item_description,
  SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost
FROM
  ${table_name}
WHERE
  ${date_filter}
  AND line_item_product_code = 'AmazonEC2'
  AND line_item_usage_type LIKE '%ElasticIP:IdleAddress'
GROUP BY
  line_item_usage_account_id,
  line_item_usage_type,
  product_location,
  line_item_line_item_description
ORDER BY
  sum_line_item_unblended_cost DESC,
  sum_line_item_usage_amount DESC
;
