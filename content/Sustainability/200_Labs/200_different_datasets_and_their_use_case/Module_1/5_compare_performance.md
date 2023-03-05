---
title: "Comparing CSV and Parquet"
date: 2023-01-24T09:16:09-04:00
chapter: false
weight: 6
pre: "<b>Step 5: </b>"
---

Let’s recap what you have done until now. 
1. You started uploading your CSV dataset to Amazon S3. 
2. You defined a database on AWS Glue, configured a crawler to explore data in an Amazon S3 bucket, and created a table from it. 
3. Then, you transformed the CSV file into Parquet.

Now that you have the same dataset both in CSV and Parquet formats, let's see the differences.

#### 5. Compare storage and performance

#### Storage
Let’s compare now both objetcs, SaaS-Sales.csv and its Parquet transformation. If you go to your Amazon S3 bucket, and explore both objects, you can notice the smaller size of your Parquet dataset compared to your CSV dataset.

![Size](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/10_1_size.png) 

You can see the different in size of both objects:
- CSV dataset size: **1.6 MB**
- Parquet dataset size: **613.3 KB**

Here you are only using one dataset for test. However, this gives us an idea of the storage resources customers could save by using columnar format, reducing their infrastructure footprint. 


#### Query Performance

Let's know compare how these two formats compare when performing querys to the data. 

To do so you will use [Amazon Athena](https://aws.amazon.com/athena/?nc=sn&loc=0).

{{%notice info%}}
[Amazon Athena](https://aws.amazon.com/athena/?nc=sn&loc=0)a is an interactive analytics service that makes it easier to analyze data in Amazon Simple Storage Service (S3) using Python or standard SQL. Athena is serverless, so there is no infrastructure to set up or manage, and you can start analyzing data immediately. You don’t even need to load your data into Athena; it works directly with data stored in Amazon S3.
{{% /notice %}}

**5.1.** Open the Athena Console by either typing Athena on the AWS Console _Search_ bar or by opening this [link](https://eu-central-1.console.aws.amazon.com/athena/home?region=eu-central-1#/query-editor/history/39f5adac-f1ee-4d8a-87dc-84b2d0852d18).

If a banner like the one below show on your Athena console, follow [this instructions](https://docs.aws.amazon.com/athena/latest/ug/querying.html#query-results-specify-location-console). Before you can run a query, a query result bucket location in Amazon S3 must be specified, or you must use a workgroup that has specified a bucket and whose configuration overrides client settings.

![Athena banner](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/10_2_AthenaBanner.png)

**5.2.** [Athena uses the AWS Glue Data Catalog](https://docs.aws.amazon.com/athena/latest/ug/querying-glue-catalog.html) to store and retrieve table metadata for the Amazon S3 data in your Amazon Web Services account. The table metadata lets the Athena query engine know how to find, read, and process the data that you want to query. 
- In the Athena Console, under **Data**, choose _AWSDataCatalog_ under **_Data Source_**
- Choose the database you have been working with as **_database_**: `lab-module-1-databse`.
- Under **Tables** you should be able to see listed both of the tables you created with your Glue Crawlers: the one corresponding to the CSV file and the one corresponding to the Parquet file. 

![Athena data](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/10_2_Athena.png)

Let's run a couple of example queries to see which of both datasets (CSV and Parquet) is more efficient to scan. 

**5.3.** First, let's inspect your data. On the three dots on the right of each table's name, you can open a menu. Click on **Preview Table**. This will run a query to preview the first 10 rows of the dataset running automatically the following query:
`SELECT * FROM "lab-module-1-database"."csv" limit 10;`

![Preview table](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/10_3_PreviewTable.png)

Looking at the data you can see, as you mentioned at the beginning, this is a dataset listing customer orders. Let's run a test query where you want to obtain the orders in a specific `country`. 

**5.4.** **CSV data**: 

- On the query editor, write the following query: 
```
SELECT * FROM "lab-module-1-database"."csv" 
WHERE country = 'Spain';
```
![CSV Spain](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/10_5_csvSpain.png)

- Take note of the **Query results**. In this case you get the information
    - Run time: **566 ms**
    - Data scanned: **1.56 KMB**


**5.5.** **Parquet data**: On the query editor, write the following query: 
```
SELECT * FROM "lab-module-1-database"."parquet" 
WHERE country = 'Spain';
```
![CSV Parquet](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/10_6_parquetSpain.png)

- Take note of the **Query results**. In this case you get the information
    - Run time: **543 ms**
    - Data scanned: **629.15 KB**



**5.6.** As you can see, when running the same query, Athena needs to scan significantly less data on the Parquet dataset than on the CSV dataset. This means, to query our Parquet dataset, you need **less resources**.  

**5.7.** Try some other queries to see how it compares in both datasets, to keep testing this difference. 




**Click on *Next Step* to continue to the next module.**

{{< prev_next_button link_prev_url="../4_convert_to_parquet" link_next_url="../6_optional" />}}