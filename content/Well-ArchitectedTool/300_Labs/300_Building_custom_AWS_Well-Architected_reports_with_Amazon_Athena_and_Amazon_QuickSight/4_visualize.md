---
title: "Visualize the data with Amazon QuickSight"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

Now that you can query your data in Amazon Athena, you can use Amazon QuickSight to visualize the results.

#### Grant Amazon QuickSight access to Amazon Athena and your S3 bucket

First, grant Amazon QuickSight access to the S3 bucket where your Well-Architected data is stored.

1.  Sign in to the Amazon QuickSight console.
2.  In the upper right corner of the console, choose **Admin/username**, and then choose **Manage QuickSight**
3.  Choose **Security and permissions**.
4.  Under **QuickSight access to AWS services**, choose **Add or remove**.
5.  Choose **Amazon Athena**, and then choose **Next**.
6.  Give QuickSight access to the S3 bucket where you will store the extracted AWS Well-Architected data, e.g. "well-architected-reporting-blog".

#### Create your datasets

Before you can analyze and visualize the data in QuickSight, you must create datasets for your Athena views and tables for each of the Athena views. Create QuickSight datasets for:

-   well_architected_workload_milestone_view
-   well_architected_workload_lens_risk_view
-   well_architected_reports_view

1.  To create a dataset, on the **Datasets** page, choose **New dataset**, and then choose **Athena**.
2.  Choose the Glue database that was created as part of the Glue Crawler creation step.
3.  Choose **Directly Query your data**. *![Under Tables contain the data you can visualize, well_architected_reports_view is selected.](https://d2908q01vomqb2.cloudfront.net/972a67c48192728a34979d9a35164c1295401b71/2021/02/22/Picture-11-border.png)

#### Create your analysis

Now create a single-page dashboard using the three Athena datasets you just created.

1.  In the QuickSight console, choose **Create Analysis**.
2.  Choose one of the Athena datasets, and then choose **Create Analysis**.
3.  Choose the pencil icon to add the other Athena datasets.
4.  After you have added the datasets, they should be available for analysis.

#### Build your dashboard

Each dataset can be used to build visualizations for the following:

-   Number of conducted reviews
-   Number of HRIs
-   Top high-risk questions
-   Top high-risk workloads
-   Mix of risk across reviews, lenses, and pillars
-   Trends of risks across reviews, milestones, lenses, and pillars

This list not exhaustive. At AWS, we look forward to seeing the visualizations you'll build for your organization. Below shows an example of a dashboard:

![The Overview tab of the dashboard shows that 12 reviews have been conducted. It displays the top three high-risk questions and the workloads with the most high-risk items.](https://d2908q01vomqb2.cloudfront.net/972a67c48192728a34979d9a35164c1295401b71/2021/02/22/Picture-13-blur.png)


{{< prev_next_button link_prev_url="../" link_next_url="../5_clean_up/" />}}
