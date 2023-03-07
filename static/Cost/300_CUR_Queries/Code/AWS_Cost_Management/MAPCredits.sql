select
  month,
  year,
  line_item_line_item_type,
  line_item_line_item_description,
  line_item_usage_account_id,
  sum(line_item_unblended_cost) cost
from customer_all
where
  line_item_line_item_type in ('Refund','Credit') and
  line_item_line_item_description like '%MPE%'
-- default is all MAP credits for the entire account for all time, add next line to filter
-- and ${date_filter}
group by 1,2,3,4,5;