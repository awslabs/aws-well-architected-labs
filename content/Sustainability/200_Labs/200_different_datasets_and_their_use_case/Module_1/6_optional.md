---
title: "Optional exercise"
date: 2023-01-24T09:16:09-04:00
chapter: false
weight: 7
pre: "<b>Step 6: </b>"
---

At the beginning of [Step 4](../4_convert_to_parquet/), we mentioned how columnar data formats like Parquet and ORC require less storage capacity compared to row-based formats like CSV and JSON.

We saw how Parquet requires less storage capacity and allows for more efficient queries because of its columnar format. However, we haven't yet explored the posibility to partition the data to make queries even more efficient. 

In this optional module, we will create a new Glue Job to transform our CSV file into partitionned Parquet, we will crawl the data and then compare the scanning of our 3 datasets: CSV, Parquet and partitionned Parquet.

#### 6. Partitioned data

**6.1.** Create a new Glue Job. Repeat steps followed in [Section 4](../4_convert_to_parquet/):
- Click [here](https://eu-central-1.console.aws.amazon.com/gluestudio/home?region=eu-central-1#/) to open the AWS Glue Studio management console. Click on **Jobs**.

- Leave the option _Visual with a source and target_ selected, and click **Create**.

- Select the _Apply mapping_ step and click **Remove**

- Select the **Data source - S3 bucket** at the top of the graph.
    - In the panel on the right under _Data source properties - S3_, choose the `lab-database-module-1` database (or similar), that you are using throught this lab. 
    - Choose the `csv` table.

- Select the **Data target - S3 bucket** node at the bottom of the graph.
    - Change the Format to *Parquet* in the dropdown. 
    - Under Compression Type, select *Uncompressed* from the dropdown.
    - In the textbox, append `parquet_partitionned/` to the S3 url - don’t forget the "**/**" at the end. 
    - Click on **Add a partition key**
        - On the drop down menu, select the first partition key. For example, **country**.
        - Click on **Add a partition key** again and add a second partition key, for example, **industry**

- On the Job details tab:
    - Give the job a name `Glue-CSV-to-Parquet-partitioned-Module-1` 
    - For *IAM Role*, select the role you created at the begining of the lab, `AWSGlueRole-module-1-lab`. You can leave the rest of settings as default.

- Press the **Save** button in the top right-hand corner to create the job. (If you get an error saving the job, make sure that, under *Advanced properties*, the *script filename* matches the job name.

- Once you see the **Successfully created job** message in the banner, click the **Run** button to start the job.

- Once your job has succeeded, you can go to your Amazon S3 bucket to check if your new Parquet file is stored there. 

**6.2.** We need to crawl the new dataset. Repeat steps followed in [Section 2](../Module_1/3_explore_your_data.md):
* Go to Services and type Glue. Click on AWS Glue or open the AWS console [here](https://eu-central-1.console.aws.amazon.com/glue/home?region=eu-central-1#/v2/home).On the Glue console click on Crawlers, on the left bar, select Crawlers.

* Choose **Create Crawler**

* Enter a **name** for your crawler (e.g. `crawler-module-1-parquet-partitionned`) and click **Next**.

* Click **Add data source**

* Browse S3 to find the path to your Parquet object (ex: `s3://[YOUR_BUCKET]/parquet_partitioned/`) and click **Add an S3 data source**. 

* From the drop down menu, select the IAM role we created at the beginnig of the lab: `AWSGlueRole-module-1-lab`

* Click **Next**

* On the target database, choose the database you created on **Step 2**,  `lab-module-1-databaseb`.

* Click **Next**

* Review the details and click **Create Crawler**.

* Once successfully created, select the created crawler and click **Run crawler**

* Wait for the crawler to finish crawling your dataset stored on Amazon S3. Once it’s finished, you should be able to see a new table on Glue Data Catalog, under the database you created `database-module-1-lab`. 

**6.3.** Let's query our data in Athena. 

Let's run a couple of simple queries to see the differences between the different formats. For example, let's imagine we want to know how our SaaS sales are in a specific country for certain industry:

**Query 1:** Querying to the table that points at the CSV dataset
```
SELECT SUM (sales)
FROM "lab-module-1-database"."csv"
WHERE country = 'Spain' and industry= 'Energy'; 
```
![CSV query](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/11_1_csvSpainEnergy.png)

**Query 2:** Querying to the table that points at the Parquet dataset without partitions
```
SELECT SUM (sales)
FROM "lab-module-1-database"."parquet"
WHERE country = 'Spain' and industry= 'Energy'; 
```
![Parquet query](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/11_2_ParquetSpainEnergy.png)

**Query 3:** Querying to the table that points at the Parquet dataset with partitions
```
SELECT SUM (sales)
FROM "lab-module-1-database"."parque_partitioned"
WHERE country = 'Spain' and industry= 'Energy'; 
```
![Partition query](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/11_3_PartitionSpainEnergy.png)


## Results
As you can see, scanned data for the different queries changes significantly. For this lab, we have used small amount of data. But imagine the optimization of ressources we could obtain applying this to larges amounts of data across an organization. 

File format | Data scanned for the query 
--- | --- 
CSV| **1.56MB** 
Parquet | **87.53 KB** 
Parquet with partitions | **0.28 KB**

**Click on *Next Step* to continue to the next module.**

{{< prev_next_button link_prev_url="../5_compare_performance" link_next_url="../7_conclusion" />}}