---
title: "Teardown"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---


To perform a teardown for this lab, perform the following steps:

1. Remove QuickSight email reports
    - Go into **QuickSight**
    - Select **All dashboards**
    - Click on the **dashboard name**
    - Click **Reports**
    - Select **Unsubscribe**
    - Click **Update**

2. Remove any created QuickSight dashboards
    - Go into **QuickSight**
    - Select **All dashboards**
    - Click the **3 dots** next to the dashboard name
    - Click **Delete**
    - Click **Delete**

3. Remove any QuickSight analyses
    - Go into **QuickSight**
    - Select **All analyses**
    - Click the **3 dots** next to the analysis name
    - Click **Delete**
    - Click **Delete**

4. Remove QuickSight Datasets
    - Go into **QuickSight**
    - Click **Manage data**
    - Click on the dataset, we created 
        - **summary_view**
        - **s3_view**
        - **compute_savings_plan_eligible_spend**
        - **ec2_running_cost**
        - **data_transfer_view**
    - Click **Delete data set**
    - Click **Delete**

5. Remove the Athena views
    - Go into **Athena**
    - Execute the following commands to remove the Cost Intelligence views:
        - ```drop view costmaster.compute_savings_plan_eligible_spend```
        - ```drop view costmaster.ec2_running_cost```
        - ```drop view costmaster.ri_sp_mapping```
        - ```drop view costmaster.s3_view```
        - ```drop view costmaster.summary_view```
        - ```drop view costmaster.data_transfer_view```




