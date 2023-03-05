---
title: "Explore your data"
date: 2023-01-24T09:16:09-04:00
chapter: false
weight: 4
pre: "<b>Step 3: </b>"
---

In this step, you will create a [AWS Glue Crawler](https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html) to scan your data.

#### 3. Discover your data

In the following steps you will explore your **SaaS-sales.csv** dataset. As you just saw, your dataset is in **CSV format**.  

To do so, you will use [AWS Glue](https://aws.amazon.com/glue/) and [Amazon Athena](https://aws.amazon.com/athena/?nc=sn&loc=0). 

{{% notice info %}}
[AWS Glue](https://aws.amazon.com/glue/)is a serverless data integration service that makes it easy to discover, prepare, and combine data for analytics, machine learning, and application development. AWS Glue provides all of the capabilities needed for data integration so that you can start analyzing your data and putting it to use in minutes instead of months. You will use AWS Glue and setup a Crawler to scan your dataset to obtain its schema.
{{% /notice %}}
{{% notice info %}}
[Amazon Athena](https://aws.amazon.com/athena/?nc=sn&loc=0)a is an interactive analytics service that makes it easier to analyze data in Amazon Simple Storage Service (S3) using Python or standard SQL. Athena is serverless, so there is no infrastructure to set up or manage, and you can start analyzing data immediately. You don’t even need to load your data into Athena; it works directly with data stored in Amazon S3.
{{% /notice %}}



You will use AWS Glue Crawlers to scan your data and infer schema information integrating it into your AWS Glue Data Catalog. . An [AWS Glue crawler](https://docs.aws.amazon.com/glue/latest/dg/add-crawler.html) connects to a data store, progresses through a prioritized list of classifiers to extract the schema of your data and other statistics, and then populates the [Glue Data Catalog](https://docs.aws.amazon.com/glue/latest/dg/catalog-and-crawler.html) with this metadata.

First, you will use Glue Crawlers to crawl the dataset so you can later on use the tables created by Glue Crawlers to query using Athena.

##### Exercise

**3.1.** Go to Services and type Glue. Click on AWS Glue or open the AWS console [here](https://eu-central-1.console.aws.amazon.com/glue/home?region=eu-central-1#/v2/home).On the Glue console click on Crawlers, on the left bar, select Crawlers. 
![Glue Console](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/8_1_Glue.png)

**3.2.** Choose **Create Crawler**:
![Create Crawler](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/8_2_CreateCrawler.png)

**3.3.** Enter a **name** for your crawler (e.g. `crawler-module-1`) and click **Next**.
![Crawler Name](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/8_3_CrawlerName.png) 

**3.4.** Click **Add data source**
![Add Datasource](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/8_4_AddDatasource_1.png)

**.5.** Paste the S3 URI you copied earlier (ex: `s3://[YOUR_BUCKET]/csv/SaaS-Sales.csv`),click **Add an S3 data source** and click **Next**:
![Add Datasource](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/8_5_AddDatasource_2.png)

**3.6.** From the drop down menu, select the IAM role you created at the beginnig of the lab: `AWSGlueRole-module-1-lab`. This role allows your crawler to scan the data on your bucket, and thus, the data under */csv/* folder. Click **Next**:
![IAM Role](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/8_6_IAMGlueRole.png)

**3.7.** Click **Add databse**. This will open a new window to **Create a Glue database**.
* Create a database with a name similar to `lab-module-1-databaseb`, and click on **Create**. 
* Once created, go back to the Glue Crawler tab and choose your new table from the drop down menu. 
* Keep the rest as default. (Click the refresh button if you don’t see your database shown on the list):
![Target Database](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/8_7_Database.png)
* Click **Next**.
* Review the details and click **Create Crawler**.

**3.8.** Once successfully created, select the created crawler and click **Run crawler**
![Run Crawler](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/8_8_Run.png)

**3.9.** Wait for the crawler to finish crawling your dataset stored on Amazon S3. Once it’s finished, you should be able to see a new table on Glue Data Catalog, under the database you created `database-module-1-lab`. 
![table](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/8_9_database.png)

Clicking on your new table name you can see details about your dataset including location (the S3 bucket where it’s stored) and its schema.
![table details](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/8_9_table_details.png)

Let's convert this dataset to Parquet and check the differences. 

**Click on *Next Step* to continue to the next module.**

{{< prev_next_button link_prev_url="../2_create_role" link_next_url="../4_convert_to_parquet" />}}

