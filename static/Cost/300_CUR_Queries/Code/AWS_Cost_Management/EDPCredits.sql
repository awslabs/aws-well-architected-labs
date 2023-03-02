select 
    month, 
	year, 
	SUM(line_item_unblended_cost) as monthly_cost
FROM "customer_cur_data"."customer_all" 
where line_item_line_item_type ='EdpDiscount'
-- default is all EDP credits for the entire account for all time, add next line to filter
-- and ${date_filter}
group by 
	1, --month
	2 --year