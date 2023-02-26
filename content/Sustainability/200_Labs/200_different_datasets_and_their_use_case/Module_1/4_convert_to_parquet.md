---
title: "Convert from CSV to Parquet"
date: 2023-01-24T09:16:09-04:00
chapter: false
weight: 5
pre: "<b>Step 4: </b>"
---

#### 4. Convert your data from CSV to Parquet

Columnar data formats like Parquet and ORC require less storage capacity compared to row-based formats like CSV and JSON.

* Parquet consumes up to [six times](https://docs.aws.amazon.com/redshift/latest/dg/r_UNLOAD.html) less storage in Amazon S3 compared to text formats. This is because of features such as column-wise compression, different encodings, or compression based on data type, as shown in the [Top 10 Performance Tuning Tips for Amazon Athena](https://aws.amazon.com/blogs/big-data/top-10-performance-tuning-tips-for-amazon-athena/) blog post.
* You can improve performance and reduce query costs of [Amazon Athena](https://aws.amazon.com/athena/) by [30–90 percent](https://aws.amazon.com/athena/faqs/) by compressing, partitioning, and converting your data into columnar formats. **Using columnar data formats and compressions reduces the amount of data scanned**.

(More info can be found in this [blog](https://aws.amazon.com/blogs/architecture/optimizing-your-aws-infrastructure-for-sustainability-part-ii-storage/))

In this step, you will convert our dataset to a columnar format so you can compare the storage and query efficiency. To do so, you will use [AWS Glue Studio.](https://docs.aws.amazon.com/glue/latest/ug/what-is-glue-studio.html)

{{% notice info %}}
[AWS Glue Studio](https://docs.aws.amazon.com/glue/latest/ug/what-is-glue-studio.html) is a new graphical interface that makes it easy to create, run, and monitor extract, transform, and load (ETL) jobs in AWS Glue. You can visually compose data transformation workflows and seamlessly run them on AWS Glue’s Apache Spark-based serverless ETL engine. You can inspect the schema and data results in each step of the job.
{{% /notice %}}

**4.1.** On AWS Glue left bar, click on AWS Glue Studio or click [here](https://eu-central-1.console.aws.amazon.com/gluestudio/home?region=eu-central-1#/). AWS Glue Studio management console should open. Click on Jobs.
![Glue Studio](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/9_1_GlueStudio.png)

**4.2.** Leave the option _Visual with a source and target_ selected, and click **Create**.
![Glue Studio](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/9_2_CreateJob.png)

**4.3.** Select the **Data source - S3 bucket** at the top of the graph. 
* In the panel on the right under _Data source properties - S3_, choose the `database-module-1-lab` databas (or similar), that you created on the previous step. 
* On *Table*, select the table created by the crawler, similar to `csv` table.
![Source](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/9_3_source.png)

**4.4.** Select the *Apply mapping* step and click **Remove**

**4.5.** Select the **Data target - S3 bucket** node at the bottom of the graph. 
* Change the Format to *Parquet* in the dropdown. Under Compression Type, select *Uncompressed* from the dropdown.

* Under “S3 Target Location”, select “*Browse S3*” browse to the bucket you created for this lab and select it. 

* In the textbox, append parquet/ to the S3 url. The path should look similar to`s3://[YOUR_BUCKET]/parquet/` - don’t forget the "**/**" at the end. The job will automatically create the folder (as it has the permissions, thanks to the IAM role you created).
![destination](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/9_5_destination.png)

**4.6.** Finally, select the **Job details** tab at the top. 

* Enter something similar to `Glue-CSV-to-Parquet-Module-1` under Name.

* For *IAM Role*, select the role you created at the begining of the lab, `AWSGlueRole-module-1-lab`. You can leave the rest of settings as default.
![job details](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/9_6_jobDetails.png)

* Scroll down the page and under **Job bookmark**, select *Disable* in the drop down. You can try out the bookmark functionality later in this lab.

**4.7.** Press the **Save** button in the top right-hand corner to create the job. (If you get an error saving the job, make sure that, under *Advanced properties*, the *script filename* matches the job name.

**4.8.** Once you see the **Successfully created job** message in the banner, click the **Run** button to start the job.
![job run](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/9_7_runJob.png)

**4.9.** Let's check the job run.
* Select **Jobs** from the navigation panel on the left-hand side to see a list of your jobs.
* Select **Monitoring** from the navigation panel on the left-hand side to view your running jobs, success/failure rates and various other statistics. 

![monitoring](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/9_8_monitoring.png)

**4.10** Once your job has succeeded, you can go to your Amazon S3 bucket to check if your new Parquet file is stored there. 

![result](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/9_9_s3parquet.png)

Congrats! You have converted your dataset from CSV to Parquet. 

**4.11** Before jumping to the next section, you need to crawl the new dataset, so it's included in our Glue Data Catalog. Repeat steps followed in [Section 2](../Module_1/3_explore_your_data.md) to create a new crawler to scan your new data:

* Go to Services and type Glue. Click on AWS Glue or open the AWS console [here](https://eu-central-1.console.aws.amazon.com/glue/home?region=eu-central-1#/v2/home).On the Glue console click on Crawlers, on the left bar, select Crawlers.
* Choose **Create Crawler**
* Enter a **name** for your crawler (e.g. `crawler-module-1-parquet`) and click **Next**.
* Click **Add data source**
* Browse S3 to find the path to your Parquet object (ex: `s3://[YOUR_BUCKET]/parquet/`) and click **Add an S3 data source**. 
* From the drop down menu, select the IAM role you created at the beginnig of the lab: `AWSGlueRole-module-1-lab`
* Click **Next**
* On the target database, choose the database you created on **Step 2**,  `lab-module-1-databaseb`.
* Click **Next**
* Review the details and click **Create Crawler**.
* Once successfully created, select the created crawler and click **Run crawler**
* Wait for the crawler to finish crawling your dataset stored on Amazon S3. Once it’s finished, you should be able to see a new table on Glue Data Catalog, under the database you created `database-module-1-lab`. 

![2 tables](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/9_10_2tables.png)


Let's compare the differences in the next section!

**Click on *Next Step* to continue to the next module.**

{{< prev_next_button link_prev_url="../3_explore_your_data" link_next_url="../5_compare_performance" />}}


