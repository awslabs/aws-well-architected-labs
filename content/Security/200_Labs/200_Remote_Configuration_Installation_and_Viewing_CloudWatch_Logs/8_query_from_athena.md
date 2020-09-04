---
title: "Query logs from S3 using Athena"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 8
pre: "<b>8. </b>"
---

With your log data now stored in S3, you will utilize Amazon Athena - a serverless interactive query service. You will run SQL queries on your log files to extract information from them. In this section, we will focus on the Apache access logs, although Athena can be used to query any of your log files. It is possible to query your log data from CloudWatch Insights, however, Athena querying allows you to pull data from files stored in S3, as well as other sources, where Insights only allows to query data in CloudWatch. Athena supports SQL querying - an industry standard language.

1. Open up the [Athena console](https://console.aws.amazon.com/athena/).
2. If this is the first time you are using Athena:
   1. Click **Get Started** to go to the **Query Editor**.
   2. Set up a **query result location** by clicking the link that appears at the top of the page.
3. If this is not the first time you are using Athena:
   1. Set up a **query result location** by clicking **Settings** in the top right corner of the page.

4. Enter the following into the **Query result location** field, replacing `REPLACE_ME_BUCKETNAME` with the name of the S3 bucket you created, likely `wa-lab-<your-account-id>-<date>`.

`s3://REPLACE_ME_BUCKETNAME/athenaqueries/`

5. Click **Save**.

![query-athena-1](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/query-athena-1.png)

6. You should now see the blank query editor, as seen in the image below. This is where you will enter SQL queries to manipulate and extract information from your log files.

![query-athena-2](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/query-athena-2.png)

7. Enter the following command in “**New query 1**” box to create a new [Database](https://docs.aws.amazon.com/athena/latest/ug/understanding-tables-databases-and-the-data-catalog.html), which will hold the [Table](https://docs.aws.amazon.com/athena/latest/ug/understanding-tables-databases-and-the-data-catalog.html) containing our log data. This command creates a database called `security_lab_logs`.

```sql
CREATE database security_lab_logs
```

8. Press **Run query** to execute this command. Once complete, you should see `Query successful.` displayed in the results box.
9. On the left side menu, click the dropdown under **Database** and select the newly created database called `security_lab_logs`.

![query-athena-3](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/query-athena-3.png)

10. You will create a table within this database to hold our logs. Click the plus icon next to **New query 1** to open a new query editor tab.
11. Copy the SQL code below into the editor to create a table from our log data.
    1. Replace `REPLACE_ME_BUCKET` with the name of the bucket you created to your logs in S3, likely `wa-lab-<your-last-name>-<date>`.
    2. You will need to identify the folder your logs are in for `REPLACE_ME_STRING.` Follow these steps to identify the path.
       1. Open the [S3 console](https://console.aws.amazon.com/s3/).
       2. Open the bucket you created, likely `wa-lab-<your-last-name>-<date>`.
       3. Open the `lablogs` folder.
       4. You should see a folder with a long, random looking string (e.g. `c848ff11-df30-481c-8d9f-5805741606d3`). This string is what you should use for `REPLACE_ME_STRING`.

```SQL
CREATE EXTERNAL TABLE IF NOT EXISTS `security_lab_apache_access_logs` (
  request_date string,
  request_timestamp string,
  request_ip string,
  request_method string,
  request string,
  response_code int,
  response_size int,
  user_client_data string,
  garbage string
  )
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.RegexSerDe'
WITH SERDEPROPERTIES (
 "input.regex" = "([^ ]*)T([^ ]*)Z ([^ ]*) (?:[^ ]* [^ ]*) (?:[^\"]*) \"([^ ]*) ([^\"]*)\" ([^ ]*) ([^ ]*) (?:\"[^\"]*\") (\"[^\"]*\")([^\n]*)"
 )
LOCATION 's3://REPLACE_ME_BUCKET/lablogs/REPLACE_ME_STRING/apache-access-logs/'
TBLPROPERTIES (
  'compressionType' = 'gzip'
  );
```

Let’s break this down a little.

* The `CREATE EXTERNAL TABLE...` statement creates your new table and defines its columns, such as `request_date`, `request_timestamp`, and so on.
* The `ROW FORMAT SERDE` statement specifies that the table rows are formatted using the RegEx SerDe (serializer/deserializer).
* The `WITH SERDEPROPERTIES` statement specifies the RegEx input format of your log files. This is how your raw log data is converted into columns.
* The `LOCATION` statement specifies the source of your table data, which is the S3 bucket containing your log files.
* The `TBLPROPERTIES` statement specifies that your log files are initially compressed using the GZIP format.

12. Click **Run query**. One it is successfully finished, you should see your new `'security_lab_apache_access_logs'` table in the left side menu under **Tables**.
13. Next, you will query data from this table. Click the plus icon next to **New query 2** to open a new query editor tab.
14. First, view your whole table. Copy the following commands into the query editor and press **Run query**. You should see the table in the **Results** box.

```
SELECT *
FROM security_lab_logs.security_lab_apache_access_logs limit 15
```

![query-athena-4](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/query-athena-4.png)

15. Let’s say you want to view only a certain column from this table, such as the response code frequency and size of the response. Replace the query you just made with the code below to do so.

```
SELECT response_code,
         count(response_code) AS count
FROM security_lab_logs.security_lab_apache_access_logs
WHERE response_code IS NOT NULL
GROUP BY response_code
ORDER BY count desc
```

This isolates the response_code and response_size columns from your table and creates a new column called count, which is the frequency of each response type.

If you needed to track different metrics for your workload, you can always use different Athena queries to do so, but for the purposes of this lab, we will just be focusing on response code frequency.

1. Click **Run query**. In the **Results** box, you should see a table similar to the one below.

![query-athena-5](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/query-athena-5.png)

**Recap:** In this section, you analyzed information from your workloads’s log files using Amazon Athena. Although you only focused on the response codes and sizes in this lab, Athena can be used to query any data from S3, making it a powerful tool to analyze log files without directly accessing them. This demonstrates the best practices of “enabling people to perform actions at a distance” and “keeping people away from data. You’ve been able to minimize direct interaction with your data and instances - first by using Systems Manager for configuration, and now through S3 and Athena for log analysis.

{{< prev_next_button link_prev_url="../7_export_to_s3/" link_next_url="../9_create_quicksight_dashboard/" />}}
