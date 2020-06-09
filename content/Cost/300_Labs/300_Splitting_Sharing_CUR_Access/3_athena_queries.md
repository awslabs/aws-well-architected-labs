---
title: "Create Athena Saved Queries to Write new Data"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

Next we setup your recurring Athena queries.  These will run each time a new CUR file is delivered, separate out the information for the sub accounts, and write it to the output S3 location. These queries will be very similar to the one above, except it will only extract data for the current month.

You must write one query for the extraction of the data, which will create a temporary table, and then a second query to delete the table. As the system has been written for future expansion, you must adhere to the guidelines below when writing and naming statements (other wise you will need to change the code):

 - The queries MUST start with: **create_linked_** and **delete_linked_** otherwise you'll need to modify the Lambda function. As Lambda looks for this string to identify these queries to automatically run when new files are delivered
 - The output location must also end in the actual word **subfolder** as this will be re-written by the lambda function, to the current year and month
 - The queries must include the component **CAST(bill_billing_period_start_date as VARCHAR) like concat(substr(CAST(current_date as VARCHAR),1,7),'-01%')** which ensures the query only gets data from the current month
 - There is no need to include the columns **year as year_1** and **month as month_1**, as that was only used for partitioning

1 - Create the saved query in Athena named **create_linked_(folder name)**, the following sample code is the accompanying query for the previous query above:

```
CREATE TABLE (database).temp_table
WITH (
      format = 'Parquet',
      parquet_compression = 'GZIP',
      external_location = 's3://(bucket)/(folder)/subfolder')
AS SELECT * FROM "(database)"."(table)"
where line_item_usage_account_id like '(some value)' and CAST(bill_billing_period_start_date as VARCHAR) like concat(substr(CAST(current_date as VARCHAR),1,7),'-01%')
```

2 - Create the accompanying delete statement named **delete_linked_(folder name)** to delete the temporary table:

```
drop TABLE IF EXISTS (database).temp_table;
```

3 - Repeat the steps above for any additional **create** and **delete** queries as required.
