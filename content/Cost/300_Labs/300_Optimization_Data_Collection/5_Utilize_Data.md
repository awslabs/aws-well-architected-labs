---
title: "Utilize Data"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

## Utilizing Your Data 
Now you have pulled together optimization data there different ways in which you can analyze and visualize it and use to make infrastructure optimization decisions 

### Visualization of Trusted Advisor data with Amazon QuickSight
You can visualize Trusted Advisor Data with [TAO Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/). To deploy [TAO Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/) please follow either [automated](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/dashboards/3_auto_deployment/) or [manual](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/dashboards/4_manual-deployment-prepare/) deployment steps and specify organizational data collection bucket created in this lab as a source

### Snapshots and AMIs
When a AMI gets created it takes a Snapshot of the volume. This is then needed to be kept in the account whilst the AMI is used. Once the AMI is released the Snapshot can no longer be used but it still incurs costs. Using this query we can identify Snapshots that have the 'AMI Available', those where the 'AMI Removed' and those that fall outside of this scope and are 'NOT AMI'. Data must be collected and the crawler finished running before this query can be run. 

      SELECT *,
      CASE
      WHEN snap_ami_id = imageid THEN
      'AMI Avalible'
      WHEN snap_ami_id LIKE 'ami%' THEN
      'AMI Removed'
      ELSE 'Not AMI'
      END AS status
        FROM ( 
      (SELECT snapshotid AS snap_id,
          volumeid as volume,
          volumesize,
          starttime,
          Description AS snapdescription,
          year,
          month,
          ownerid,
          
          CASE
          WHEN substr(Description, 1, 22) = 'Created by CreateImage' THEN
          split_part(Description,' ', 5)
          WHEN substr(Description, 2, 11) = 'Copied snap' THEN
          split_part(Description,' ', 9)
          WHEN substr(Description, 1, 22) = 'Copied for Destination' THEN
          split_part(Description,' ', 4)
          ELSE ''
          END AS "snap_ami_id"
      FROM "optimization_data"."snapshot_data"
      ) AS snapshots
      LEFT JOIN 
          (SELECT imageid,
          name,
          description,
          state,
          rootdevicetype,
          virtualizationtype
          FROM "optimization_data"."ami_data") AS ami
              ON snapshots.snap_ami_id = ami.imageid )
    


### EBS Volumes and Trusted Advisor Recommendations

Trusted advisor identifies idle and underutilized volumes. This query joins together the data so you can see what portion of your volumes are flagged. Data must be collected and the crawler finished running before this query can be run. 


        SELECT *FROM
            "optimization_data"."ebs_data"
        LEFT JOIN 
        (select "volume id","volume name", "volume type","volume size",	"monthly storage cost" ,accountid, category, region, year,month
        from
        "optimization_data".ta_data ) ta
        ON "ebs_data"."volumeid" = "ta"."volume id" and "ebs_data"."year" = "ta"."year" and "ebs_data"."month" = "ta"."month"



### AWS Budgets into Cost Dashboard

In these labs we have a couple of amazing cost dashboards that can be found [here](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/). If you would like to add your budget data into these dashboard please follow the below steps. Data must be collected and the crawler finished running before this query can be run. 
There is a saved query called **aws_budgets** created in the CloudFormation. This is used when connecting to dashboard.

1. Ensure you have budget data in your Amazon Athena table

2. Create a Amazon Athena View of this data to extract the relevant information. The **costfilters** identifies if this is just an account spend budget or filtered. As this if for CUDOS we have filtered these out for the query but all budgets data is in the table. 

        CREATE OR REPLACE VIEW aws_budgets_view AS 
            SELECT
              budgetname budget_name
            , CAST(budgetlimit.amount AS decimal) budget_amount
            , CAST(calculatedspend.actualspend.amount AS decimal) actualspend
            , CAST(calculatedspend.forecastedspend.amount AS decimal) forecastedspend
            , timeunit
            , budgettype budget_type
            , year budget_year
            , month budget_month
            FROM
              "optimization_data"."budgets"
            WHERE (budgettype = 'COST')  AND costfilters.filter[1] = 'None'

3. Go to the **Amazon QuickSight** service homepage

2. In **QuickSight**, select the **summary_view** Data Set

3. Select **Edit data set**

4. Select **Add data**:
![Images/dashboard_mapping_3.png](/Cost/300_Organization_Data_CUR_Connection/Images/dashboard_mapping_3.png)

5. Select your Amazon Athena **aws_budgets_view** table and click **Select**
![Images/Budget_Data.png](/Cost/300_Optimization_Data_Collection/Images/Budget_Data.png)

6. Click on the join and choose month, year from summary_view and budget_month, budget_year to join. Click **Save**.
![Images/Budget_join.png](/Cost/300_Optimization_Data_Collection/Images/Budget_join.png)

7. In your Analysis you can now add a Budget figure to your lines. Make sure to change to **Average**.
![Images/Budget_viz.png](/Cost/300_Optimization_Data_Collection/Images/Budget_viz.png)


{{< prev_next_button link_prev_url="../4_Create_Custom_Data_Collection_Module/" link_next_url="../6_teardown/" />}}