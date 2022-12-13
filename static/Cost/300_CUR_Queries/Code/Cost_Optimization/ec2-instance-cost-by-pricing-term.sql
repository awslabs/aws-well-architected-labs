-- modified: 2022-12-10
-- query_id: ec2-instance-cost-by-pricing-term
-- query_description: This query may be used to group instance usage by account in a given time period and filter by pricing term. It will help customers find old generation instances running on-demand which may be candidates for an upgrade.
-- query_columns: line_item_usage_account_id,pricing_term,instance_type,amortized_cost

-- query_link: /cost/300_labs/300_cur_queries/queries/cost_optimization

SELECT
  line_item_usage_account_id, 
	(CASE 
		WHEN (line_item_usage_type LIKE '%SpotUsage%') THEN 'Spot' 
		WHEN 
			(((product_usagetype LIKE '%BoxUsage%') 
			OR (product_usagetype LIKE '%DedicatedUsage:%')) 
			AND ("line_item_line_item_type" LIKE 'SavingsPlanCoveredUsage')) 
			OR (line_item_line_item_type = 'SavingsPlanNegation') 
		THEN 'SavingsPlan' 
		WHEN 
			(("product_usagetype" LIKE '%BoxUsage%') 
			AND ("line_item_line_item_type" LIKE 'DiscountedUsage')) 
		THEN 'ReservedInstance' 
		WHEN 
			((("product_usagetype" LIKE '%BoxUsage%') 
			OR ("product_usagetype" LIKE '%DedicatedUsage:%')) 
			AND ("line_item_line_item_type" LIKE 'Usage')) 
		THEN 'OnDemand' 
		ELSE 'Other' END) pricing_term, 
	CASE 
		WHEN 
			line_item_usage_type like '%BoxUsage' 
			OR line_item_usage_type LIKE '%DedicatedUsage' 
		THEN product_instance_type 
		ELSE SPLIT_PART (line_item_usage_type, ':', 2) END instance_type, 
	ROUND(SUM (line_item_unblended_cost),2) BilledCost, 
	ROUND (
		SUM((
			CASE 
				WHEN line_item_usage_type LIKE '%SpotUsage%' 
				THEN line_item_unblended_cost  
				WHEN 
					((product_usagetype LIKE '%BoxUsage%') 
					OR (product_usagetype LIKE '%DedicatedUsage:%')) 
					AND (line_item_line_item_type LIKE 'Usage') 
				THEN line_item_unblended_cost 
				WHEN 
					((line_item_line_item_type LIKE 'SavingsPlanCoveredUsage')) 
				THEN TRY_CAST(savings_plan_savings_plan_effective_cost AS double) 
				WHEN ((line_item_line_item_type LIKE 'DiscountedUsage')) 
				THEN reservation_effective_cost
				WHEN (line_item_line_item_type = 'SavingsPlanNegation') 
				THEN 0
				ELSE line_item_unblended_cost END)), 2) amortized_cost  
FROM 
	${table_name}
WHERE
	${date_filter}
	AND line_item_operation LIKE '%RunInstance%' AND line_item_product_code = 'AmazonEC2' 
	AND (product_instance_type <> '' OR (line_item_usage_type  LIKE '%SpotUsage%' AND line_item_line_item_type = 'Usage'))  
GROUP BY 
1, -- account id
2, -- pricing term
3  -- instance type
;
