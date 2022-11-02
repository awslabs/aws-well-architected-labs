---
title: "Visualize the workload data"
date: 2021-03-24T15:16:08+10:00
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
3.  Choose **Directly Query your data**. *![Under Tables contain the data you can visualize, well_architected_reports_view is selected.](/Well-ArchitectedTool/300_Labs/300_Building_custom_AWS_Well-Architected_reports_with_Amazon_Athena_and_Amazon_QuickSight/Images/fig-11-choose-quicksight-table.png)

#### Create your analysis

Now create a single-page dashboard using the three Athena datasets you just created.

1.  In the QuickSight console, choose **Create Analysis**.
2.  Choose one of the Athena datasets, and then choose **Create Analysis**.
3.  Choose the pencil icon to add the other Athena datasets.
4.  After you have added the datasets, they should be available for analysis.

#### Build your dashboard

Each dataset can be used to build visualizations. To add a new visual, click in an empty space, click *Visualize*, and select one or more fields. Here are a few visuals you might find useful:

**Top high risk questions**

1. Under *Visualize*, add **questiontitle** and **risk**
2. Under *Filter*, add **risk**
3. Choose *Filter type*: **Filter list**, *Filter condition*: **Include**, de-select all values except **High**
4. Click **Apply**
5. Hover over the visual and click the pencil icon in the upper right corner to open the *Format visual* pane on the left
6. De-select *Show subtitle*
7. Click *Edit title* and enter **Top high risk questions**, then click *Save*
8. Expand *Y-axis* and de-select *Show title*, *Show sort*


**Total Reviews Conducted**

1. Under *Visualize*, add **workload_id**
2. Under *Visual types,* select **Key Performance Indicator** (represented by a down arrow and up arrow)
3. Expand the *Field wells* section at the top
4. Drag **workload_id** from the *Fields list* on the left to the *Value* field in the *Field wells* area
5. Click the drop-down arrow on *Trend Group* and click *Remove*
6. Hover over the visual and click the pencil icon in the upper right corner to open the *Format visual* pane on the left
7. De-select *Show subtitle*
8. Click *Edit title* and enter **Total Reviews Conducted**, then click *Save*


**Total High Risk Items Identified**

1. Under *Visualize*, add **risk**
2. Under *Visual types,* select **Key Performance Indicator** (represented by a down arrow and up arrow)
3. Expand the *Field wells* section at the top
4. Drag **risk** from the *Fields list* on the left to the *Value* field in the *Field wells* area
5. Click the drop-down arrow on *Trend Group* and click *Remove*
6. Under *Filter*, add **Risk**
7. Choose *Filter type*: **Filter list**, *Filter condition*: **Include**, de-select all values except **High**
8. Hover over the visual and click the pencil icon in the upper right corner to open the *Format visual* pane on the left
9. De-select *Show subtitle*
10. Click *Edit title* and enter **Total High Risk Items Identified**, then click *Save*


**Total Medium Risk Items Identified**

1. Under *Visualize*, add **risk**
2. Under *Visual types,* select **Key Performance Indicator** (represented by a down arrow and up arrow)
3. Expand the *Field wells* section at the top
4. Drag **risk** from the *Fields list* on the left to the *Value* field in the *Field wells* area
5. Click the drop-down arrow on *Trend Group* and click *Remove*
6. Under *Filter*, add **Risk**
7. Choose *Filter type*: **Filter list**, *Filter condition*: **Include**, de-select all values except **Medium**
8. Hover over the visual and click the pencil icon in the upper right corner to open the *Format visual* pane on the left
9. De-select *Show subtitle*
10. Click *Edit title* and enter **Total Medium Risk Items Identified**, then click *Save*


**Risks by Workload**

1. Under *Visualize*, add **workload_name**, **high**, **medium**, and **none** (if these fields aren’t shown, ensure **well_architected_workload_lens_risk_view** is selected in the *Dataset* drop-down at the top of the pane)
2. Under *Visual types,* select **Horizontal stacked bar chart**
3. Expand the *Field wells* section at the top
4. Drag **workload_id** from the *Fields list* on the left to the *Value* field in the *Field wells* area
5. Hover over the visual and click the pencil icon in the upper right corner to open the *Format visual* pane on the left
6. De-select *Show subtitle*
7. Click *Edit title* and enter **Risks by Workload**, then click *Save*


**Risk distribution by Pillar**

1. Under *Visualize*, add **pillarid**, **high**, **medium**, and **none** (if these fields aren’t shown, ensure **well_architected_workload_lens_risk_view** is selected in the *Dataset* drop-down at the top of the pane)
2. Under *Visual types,* select **Vertical stacked bar chart**
3. Expand the *Field wells* section at the top
4. Under *Value*, drag the values to order them (from top to bottom): **high**, **medium**, **none**
5. Hover over the visual and click the pencil icon in the upper right corner to open the *Format visual* pane on the left
6. Click *Edit title* and enter **Risk distribution by Pillar**, then click *Save*


**Top High Risk questions**

1. Under *Visualize*, add **questiontitle** and **risk**
2. Under *Visual types,* select **Horizontal stacked bar chart**
3. Under *Filter*, add **risk**
4. Choose *Filter type*: **Filter list**, *Filter condition*: **Include**, de-select all values except **High**
5. Under *Filter*, add **questiontitle**
6. Choose *Filter type*: **Top and bottom filter**, **Top**, *Show top*: **5**, *By* **risk**, *Aggregation* **Count** and click *Apply*
7. Hover over the visual and click the pencil icon in the upper right corner to open the *Format visual* pane on the left
8. Click *Edit title* and enter **Top High Risk questions**, then click *Save*


**Workloads with the most High Risk Items**

1. Under *Visualize*, add **workload_name** and **risk**
2. Under *Visual types,* select **Horizontal stacked bar chart**
3. Under *Filter*, add **risk**
4. Choose *Filter type*: **Filter list**, *Filter condition*: **Include**, de-select all values except **High**
5. Under *Filter*, add **workload_name**
6. Choose *Filter type*: **Top and bottom filter**, **Top**, *Show top*: **5**, *By* **risk**, *Aggregation* **Count** and click *Apply*
7. Hover over the visual and click the pencil icon in the upper right corner to open the *Format visual* pane on the left
8. Click *Edit title* and enter **Workloads with the most High Risk Items**, then click *Save*


This list not exhaustive. At AWS, we look forward to seeing the visualizations you'll build for your organization. Below shows an example of a dashboard:

![The Overview tab of the dashboard shows that 12 reviews have been conducted. It displays the top three high-risk questions and the workloads with the most high-risk items.](/Well-ArchitectedTool/300_Labs/300_Building_custom_AWS_Well-Architected_reports_with_Amazon_Athena_and_Amazon_QuickSight/Images/fig-12-dashboard-example.png)


{{< prev_next_button link_prev_url="../" link_next_url="../5_clean_up/" />}}
