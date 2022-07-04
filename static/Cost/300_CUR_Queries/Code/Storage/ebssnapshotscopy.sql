-- modified: 2022-06-08
-- query_id: ebssnapshotscopy
-- query_description: This query helps correlate cross-region data transfer cost and usage with EBS Snapshot Copy operations for specific EBS snapshots. Understanding the amount of data transfer associated with specific snapshots, and tangentially how much data change is happening on the associated volume, can be used to inform changes to snapshotting strategy. The query provides total unblended cost and usage information grouped by snapshot, usage type, and line item description. Output is sorted by cost in descending order.

SELECT 
  line_item_resource_id,
  line_item_usage_type,
  line_item_line_item_description,
  SUM(line_item_usage_amount) as sum_line_item_usage_amount,
  SUM(line_item_unblended_cost) as sum_line_item_unblended_cost
FROM 
  ${table_name}    
WHERE 
  ${date_filter}
  AND line_item_operation = 'EBS Snapshot Copy'
GROUP BY
  line_item_resource_id,
  line_item_usage_type,
  line_item_line_item_description
ORDER BY 
  SUM(line_item_unblended_cost) DESC
;