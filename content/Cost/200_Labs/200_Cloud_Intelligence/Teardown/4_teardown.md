---
title: "Teardown"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 6
pre: "<b> </b>"
---


### Teardown of CloudFormation deployment (Automated)
{{%expand "Click here to use the same CFN templates you used to deploy the dashboards to tear down the environment" %}}

**NOTE:** Deleting an account means that CUR data will not flow to your destionat (data collection) account anymore. However, historical data will be retained in destination account. To delete the CURs, go to the `${resource-prefix}-${payer-account-id}-shared` S3 Bucket and manualy delete account data.
    ------------ | -------------

1. Login to the Account you want to delete.
   
2. Find your existing template and choose __Delete__

![Images/multi-account/cfn_dash_param_12.png](/Cost/200_Cloud_Intelligence/Images/multi-account/cfn_dash_param_12.png?classes=lab_picture_small)

{{% /expand%}}

### Manual Teardown
{{%expand "To perform a teardown manually for this lab, perform the following steps:" %}}

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

{{% /expand%}}
{{< prev_next_button link_prev_url="../4_distribute_dashboards/"  title="Congratulations!" final_step="true"  />}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST3 - "How do you monitor usage and cost?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-expenditure-and-usage-awareness.html)
{{< prev_next_button />}}



