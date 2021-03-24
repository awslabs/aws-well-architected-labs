---
title: "Use AWS Glue to catalog the Well-Architected workload data"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

AWS Glue is a fully managed extract, transform, and load (ETL) service that makes it easy to prepare and load your data for analytics. AWS Glue provides crawlers to determine the schema and stores the metadata in the [ ](https://docs.aws.amazon.com/glue/latest/dg/components-overview.html#data-catalog-intro).

#### Create the Crawler

1.  Open the AWS Glue console, and from the left navigation pane, choose **Crawlers**.
2.  Select **Add crawler** and name the crawler `well-architected-reporting,` select **Next**.
3.  Select **Next** to accept the defaults for **Specify crawler source type**.
4.  Add the S3 path of the where you will store the extracted AWS Well-Architected data e.g. `s3://well-architected-reporting-blog`. Select
5.  Select **No** and then **Next** to on the Add another data store step.
6.  Select **Create an IAM role** and provide a name, e.g. `well-architected-reporting` , select **Next**.
7.  Select **Run on demand** as the schedule frequency. Select **Next**.
8.  Next select **Add database**, and fill-in a name e.g. `war-reports`. Select **Create** and then **Next**.
9.  Review the configuration and select **Finish** to create the Crawler.

![Image of Crawler configuration.](https://d2908q01vomqb2.cloudfront.net/972a67c48192728a34979d9a35164c1295401b71/2021/02/22/Picture-5-1.png)


#### Run the Crawler

1.  Find the crawler that was just created, select it, and then choose **Run Crawler**.
2.  Wait for the crawler to complete running, which should take approximately one minute.
3.  From the left navigation pane, choose **Databases**.
4.  Find the database that was created during the Crawler creation, select it and choose **View Tables**.
5.  In the **Name** field, you should see "workloadreports". Select this and examine the metadata that was discovered during the crawler run, as shown in Figure 6. ![The workloadreports table details include fields for database, classification, location, last updated, input format, table properties, and more. The Schema section of the page displays columns for column name, data type, partition key, and comment.](https://d2908q01vomqb2.cloudfront.net/972a67c48192728a34979d9a35164c1295401b71/2021/02/22/Picture-6-border-1.png)


{{< prev_next_button link_prev_url="../" link_next_url="../3_query_data/" />}}
