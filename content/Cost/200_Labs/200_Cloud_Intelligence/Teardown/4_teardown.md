---
title: "Teardown"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 4
pre: "<b> </b>"
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
        - ```drop view costmaster.account_map```
        - ```drop view costmaster.customer_all```
		
6. To disable Trusted Advisor Organizational View
    - [Follow the documentation](https://docs.aws.amazon.com/awssupport/latest/user/organizational-view.html#disable-organizational-view)


{{< prev_next_button link_prev_url="../4_distribute_dashboards/"  title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST3 - "How do you monitor usage and cost?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-expenditure-and-usage-awareness.html)
{{< /prev_next_button >}}



