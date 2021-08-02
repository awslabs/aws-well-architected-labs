-- FINAL
SELECT bu_usage_view.line_item_usage_account_id, sum(sum_line_item_usage_amount) AS task_usage, total_usage, (sum(sum_line_item_usage_amount)/total_usage) as "percent",  ec2_cost, ((sum(sum_line_item_usage_amount)/total_usage)*ec2_cost) as ecs_cost,
         "cluster",
         services,
         servicearn,
         value,
         bu_usage_view.month,
         bu_usage_view.year
FROM "bu_usage_view"

left join (select line_item_usage_account_id, sum(sum_line_item_usage_amount) as total_usage, year, month from "bu_usage_view" where "cluster" <> '' group by line_item_usage_account_id, year, month) sum
on sum.line_item_usage_account_id = bu_usage_view.line_item_usage_account_id
and sum.month=bu_usage_view.month
and sum.year=bu_usage_view.year
left join
(SELECT line_item_usage_account_id, month, year, sum(sum_line_item_amortized_cost) as ec2_cost FROM "ec2_cluster_costs_view" group by  line_item_usage_account_id,month,year) ec2_cost
on ec2_cost.month=bu_usage_view.month
and ec2_cost.year=bu_usage_view.year
and ec2_cost.line_item_usage_account_id=bu_usage_view.line_item_usage_account_id
where "cluster" <> '' 
and bu_usage_view.month = '6'  -- if((date_format(current_timestamp , '%M') = 'January'),bu_usage_view.month = '12', bu_usage_view.month = CAST((month(now())-1) AS VARCHAR) )
and bu_usage_view.year = '2021' -- if((date_format(current_timestamp , '%M') = 'January'), bu_usage_view.year = CAST((year(now())-1) AS VARCHAR) ,bu_usage_view.year = CAST(year(now()) AS VARCHAR))
GROUP BY  "cluster", services, servicearn, value, bu_usage_view.month, bu_usage_view.year, bu_usage_view.line_item_usage_account_id, total_usage, ec2_cost