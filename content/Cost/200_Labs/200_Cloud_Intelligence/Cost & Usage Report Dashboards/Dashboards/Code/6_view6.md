---
date: 2021-03-15T10:00:02-04:00
chapter: false
weight: 999
hidden: FALSE
---

## View 6 - Customer_All
The customer_all view is used to direct query a small portion of the full cost and usage report. 


- {{%expand "Click here - to create your customer_all view" %}}

Modify the following SQL query for View0 - Account Map: 
 - On line 5, replace **(database.table_name)** with your Cost & Usage Report database and table name

		CREATE OR REPLACE VIEW customer_all AS
		SELECT 
			*
		FROM
			(database.table_name)
		WHERE (CAST("concat"("year", '-', "month", '-01') AS date) >= ("date_trunc"('month', current_date) - INTERVAL  '3' MONTH))
{{% /expand%}}

### Validate View

- Confirm the view is working, run the following Athena query and you should receive 10 rows of data:

        select * from (database).customer_all
        limit 10
		
