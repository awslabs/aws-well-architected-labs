---
title: "Perform one off Fill of Member/Linked Data"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

Perform this step if you want to generate data for all previous months available in your current CUR files. This is a one off step that is performed manually.  We create a temporary table in Athena, and write the output to the S3 location created above, for the member/linked account to access it. We then delete the temporary table - which does not delete the S3 output data.

1 - In the master/payer account go into the Athena service dashboard

2 - Create your query using the template below:

The following statement will copy **all columns** from the source table if the **line_item_usage_account_id** matches a specific Account ID. It will output each month into a separate folder by using partitioning on the **year** and **month**, and output it to the S3 output folder.

```
CREATE TABLE (database).temp_table
WITH (
      format = 'Parquet',
      parquet_compression = 'GZIP',
      external_location = 's3://(bucket)/(folder)',
      partitioned_by=ARRAY['year_1','month_1'])
AS SELECT *, year as year_1, month as month_1 FROM "(database)"."(table)"
where line_item_usage_account_id like '(account ID)'
```

Some key points for your queries:

 - Partitioning will allow us to write only the current months data each time, and not write all the data
 - Parquet format is used, which allows faster access and reduced costs through reduced data scanning
 - GZIP compression produces smaller output files than SNAPPY
 - SNAPPY is faster than GZIP to run

Example of performance with a source CUR of 6.3Gb:

 - Using Parquet and GZIP, it will take approximate 11min 16sec, and produce 8.4Gb of output files
 - Using Parquet and SNAPPY, it will take approximately 7min 8sec, and produce 12.2Gb of output files


3 - Execute the statement in Athena:
![Images/splitsharecur5.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur5.png)

4 - Go into the S3 service dashboard

5 - Go to the output bucket and folder

6 - Verify the data has been populated into the S3 folders
![Images/splitsharecur6.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur6.png)

7 - Verify the permissions are correct on the files - there should be multiple **Grantees**:
![Images/splitsharecur7.png](/Cost/300_Splitting_Sharing_CUR_Access/Images/splitsharecur7.png)

8 - Then delete the temp table from Athena by modifying the following code: (this will NOT delete the s3 data)

```
DROP TABLE (database).temp_table
```
