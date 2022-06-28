---
title: "Utilize Data"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

## Utilizing Your Data 
Now you have pulled together optimization data there different ways in which you can analyze and visualize it and use to make infrastructure optimization decisions 

### Visualization of Trusted Advisor data with Amazon QuickSight
You can visualize Trusted Advisor Data with [TAO Dashboard.](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/) To deploy [TAO Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/) please follow either [automated](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/dashboards/3_auto_deployment/) or [manual](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/dashboards/4_manual-deployment-prepare/) deployment steps and specify organizational data collection bucket created in this lab as a source

### Visualization of Compute Optimizer data with Amazon QuickSight
You can visualize Compute Optimizer Data with [Compute Optimizer Dashboard.](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/compute-optimizer-dashboards/). 

### AWS Organisation Data and The Cost Intelligence Dashboard

This video shows you how to use the Optimization Data Collection Lab to pull in AWS Organisation data such as Account names and Tags into the Cost And Usage report so it can be used in the CID.

{{< rawhtml >}}
<iframe width="560" height="315" src="https://www.youtube.com/embed/IaqtlkkdTs8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
{{< /rawhtml >}}

### Snapshots and AMIs
When a AMI gets created it takes a Snapshot of the volume. This is then needed to be kept in the account whilst the AMI is used. Once the AMI is released the Snapshot can no longer be used but it still incurs costs. Using this query we can identify Snapshots that have the 'AMI Available', those where the 'AMI Removed' and those that fall outside of this scope and are 'NOT AMI'. Data must be collected and the crawler finished running before this query can be run. 

{{%expand "Optimization Data Snapshots and AMIs Query" %}}


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
    
{{% /expand%}}

There is an option to add pricing data to this query. This assumes you have already run the accounts collector lambda. 

{{%expand "Optimization Data Snapshots and AMIs with pricing data" %}}

**Lambda**
1. Go to AWS Lambda 
2. Find the **pricing-Lambda-Function** function
3. Test the function


**Athena**
1. Go to AWS Athena
2. Go to *Saved queries* at the top of the screen
3. Run the *ec2_pricing* Query to create a pricing table
4. In *Saved queries* Run the *region_names* Query to create a normalized region name table 
5. In *Saved queries* run *snapshot-ami-query* to create a view 
6. Run the below to see your data
        
        SELECT * FROM "optimization_data"."snapshot_ami_quicksight_view" limit 10;

{{% /expand%}}

### EBS Volumes and Trusted Advisor Recommendations

Trusted advisor identifies idle and underutilized volumes. This query joins together the data so you can see what portion of your volumes are flagged. Data must be collected and the crawler finished running before this query can be run. 

This section requires you to have the **Inventory Module** and the **Trusted Advisor Module** deployed.

{{%expand "Optimization Data EBS Volumes and Trusted Advisors Query" %}}

        SELECT * FROM
            "optimization_data"."ebs_data"
        LEFT JOIN 
        (select "volume id","volume name", "volume type","volume size",	"monthly storage cost" ,accountid, category, region, year,month
        from
        "optimization_data".ta_data ) ta
        ON "ebs_data"."volumeid" = "ta"."volume id" and "ebs_data"."year" = "ta"."year" and "ebs_data"."month" = "ta"."month"

{{% /expand%}}

There is an option to add pricing data to this query.

{{%expand "Optimization Data EBS Volumes and Trusted Advisor with pricing data" %}}

**Lambda**
1. Go to AWS Lambda 
2. Find the **pricing-Lambda-Function** function
3. Test the function

**Athena** 
1. Go to AWS Athena and run the below
2. Go to **Saved queries** at the top of the screen
3. Run the **ec2-view** Query to create a view of ebs and ta data
4. Run the **ec2_pricing** Query to create a pricing table
5. In **Saved queries** run the **region_names** Query to create a normalized region name table 
6. In **Saved queries** run **ebs-ta-query-pricing** to create a view 
7. Run the below to see your data
        
        SELECT * FROM "optimization_data"."ebs_quicksight_view" limit 10;

{{% /expand%}}

The section below will bring in opportunities to move EBS volumes to gp3

{{%expand "EBS Volumes and Trusted Advisor moving to gp3" %}}

1. Go to AWS Athena and run the below
2. Go to **Saved queries** at the top of the screen
3. Run the **ec2-view** Query to create a view of ebs and ta data
4. Run the **ec2_pricing** Query to create a pricing table
5. In **Saved queries** run the **region_names** Query to create a normalized region name table 
6. In **Saved queries** run **gp3-opportunity** to create a view 


{{% /expand%}}


### EBS Volumes and Trusted Advisor Recommendations

Trusted advisor identifies idle and underutilized volumes. This query joins together the data so you can see what portion of your volumes are flagged. Data must be collected and the crawler finished running before this query can be run. 

This section requires you to have the **Inventory Module** and the **Trusted Advisor Module** deployed.

{{%expand "Optimization Data EBS Volumes and Trusted Advisors Query" %}}
        
        CREATE OR REPLACE VIEW "ebs_view" AS 
        SELECT *FROM
                    "optimization_data"."ebs_data"
                LEFT JOIN 
                (select "volume id","volume name", "volume type","volume size",	"monthly storage cost" ,accountid as ta_accountid, status, category, region as ta_region, year as ta_year ,month as ta_month
                from
                "optimization_data".ta_data
                where category = 'cost_optimizing') ta
                ON "ebs_data"."volumeid" = "ta"."volume id" and "ebs_data"."year" = "ta"."ta_year" and "ebs_data"."month" = "ta"."ta_month"
                LEFT JOIN (
          SELECT
            "region" "region_code"
          , "regionname"
          FROM
            storage.region_names
        )  region ON ("ebs_data"."region" = "region"."region_code")

{{% /expand%}}

### AWS Budgets into Cost Dashboard

In these labs we have a couple of amazing cost dashboards that can be found [here](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/). If you would like to add your budget data into these dashboard please follow the below steps. Data must be collected and the crawler finished running before this query can be run. 
There is a saved query called **aws_budgets** created in the CloudFormation. This is used when connecting to dashboard.

{{< rawhtml >}}
<iframe width="560" height="315" src="https://www.youtube.com/embed/2SFO4SF0WN8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
{{< /rawhtml >}}


{{%expand "Guide to add AWS Budgets into Cost Dashboard" %}}

1. Ensure you have budget data in your Amazon Athena table

2. Create a Amazon Athena View of this data to extract the relevant information. The **costfilters** identifies if this is just an account spend budget or filtered. As this if for CUDOS we have filtered these out for the query but all budgets data is in the table. 

        CREATE OR REPLACE VIEW aws_budgets_view AS 
            SELECT
              budgetname budget_name
            , CAST(budgetlimit.amount AS decimal) budget_amount
            , CAST(calculatedspend.actualspend.amount AS decimal) actualspend
            , CAST(calculatedspend.forecastedspend.amount AS decimal) forecastedspend
            , timeunit
            , account_id
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
{{% /expand%}}

### AWS EBS Volumes and Snapshots

If you wish to see whats volumes have what snapshots attached to them from a holistic view then this query can combine these two data sources. This could provide information into which snapshots you could archive using [Elastic Block Storage Snapshots Archive](https://aws.amazon.com/ebs/snapshots/faqs/#Snapshots_Archive)

{{%expand "Optimization Data Snapshots with EBS" %}}
        WITH data as (
            Select volumeid,
              snapshotid,
              ownerid "account_id",
              cast(  replace(split(split(starttime, '+') [ 1 ], '.') [ 1 ], 'T', ' ') as timestamp) as start_time,
              CAST("concat"("year", '-', "month", '-01') AS date) "data_date", 
              sum(volumesize) "volume_size" 
            from "optimization_data"."snapshot_data"
            group by 1,2,3,4,5
          ),
          latest AS(
            Select max(data_date) "latest_date" from data
          ),
          ratio AS(
            Select distinct volumeid, data_date, latest_date,
              count(distinct snapshotid) AS "snapshot_count_per_volume"
            from data
            LEFT JOIN latest ON latest.latest_date = data_date
              WHERE volumeid like 'vol%' and data_date = latest_date
            group by 1,2,3
          )
          select data.volumeid,
            data.snapshotid,
            account_id,
            data.data_date,
            start_time,
            volume_size,
            snapshot_count_per_volume,
              CASE WHEN data.volumeid NOT LIKE 'vol%' THEN 1 ELSE dense_rank() OVER (partition by data.volumeid ORDER by start_time) END AS "snapshot_lineage"  
            from data
            Left JOIN ratio ON ratio.volumeid = data.volumeid
            ORDER by volumeid, snapshot_lineage
{{% /expand%}}

If you wish to connect to your Cost and Usage report for snapshot costs please use the below:

{{%expand "Optimization Data Snapshots with EBS and CUR" %}}
          WITH cur_mapping AS (
            SELECT DISTINCT 
            split_part(line_item_resource_id,'/',2) AS "snapshot_id",
            line_item_usage_account_id AS "linked_account_id",
            CAST("concat"("year", '-', "month", '-01') AS date) "billing_period", sum(line_item_usage_amount) "snapshot_size",
            sum(line_item_unblended_cost) "snapshot_cost"
            FROM "athenacurcfn_mybillingreport"."mybillingreport"
            WHERE (CAST("concat"("year", '-', "month", '-01') AS date) = ("date_trunc"('month', current_date) - INTERVAL  '1' MONTH)) AND (line_item_resource_id <> '') AND (line_item_line_item_type LIKE '%Usage%') AND (line_item_product_code = 'AmazonEC2') AND (line_item_usage_type LIKE '%EBS:Snapshot%')
            group by 1,2,3
          ),
          snapshot_data AS (
            Select volumeid,
              snapshotid,
              ownerid "account_id",
              cast(
                replace(split(split(starttime, '+') [ 1 ], '.') [ 1 ], 'T', ' ') as timestamp
              ) as start_time,
              CAST("concat"("year", '-', "month", '-01') AS date) "data_date", 
              sum(volumesize) "volume_size" 
            from "optimization_data"."snapshot_data"
            group by 1,2,3,4,5
          ),
          data AS (
            SELECT DISTINCT volumeid,
              snapshotid,
              account_id,
              billing_period,
              data_date,
              start_time,
              sum(snapshot_size) AS snapshot_size,
              sum(snapshot_cost) AS snapshot_cost,
              sum(volume_size) AS "volume_size" 
            FROM snapshot_data
            LEFT JOIN cur_mapping ON cur_mapping.snapshot_id = snapshotid AND cur_mapping.linked_account_id = account_id
            group by 1,2,3,4,5,6
          ),
          latest AS(
            Select max(data_date) "latest_date"
                from data
          ),
          ratio AS(
            Select distinct volumeid, data_date, latest_date,
              count(distinct snapshotid) AS "snapshot_count_per_volume",
              sum(snapshot_cost) AS "all_snapshot_cost_per_volume",
              sum(snapshot_size) AS "all_snapshot_size_per_volume"
            from data
            LEFT JOIN latest ON latest.latest_date = data_date
            WHERE volumeid like 'vol%' and data_date = latest_date
            group by 1,2,3
          )
          select data.volumeid,
            data.snapshotid,
            account_id,
            data.data_date,
            start_time,
            billing_period,
            snapshot_size,
            volume_size,
            all_snapshot_cost_per_volume
            all_snapshot_size_per_volume,
            snapshot_count_per_volume,
            CASE WHEN data.volumeid NOT LIKE 'vol%' THEN 1 ELSE dense_rank() OVER (partition by data.volumeid ORDER by start_time) END AS "snapshot_lineage"  
            from data
            LEFT JOIN ratio ON ratio.volumeid = data.volumeid

{{% /expand%}}


### ECS Chargeback

Report to show costs associated with ECS Tasks leveraging EC2 instances within a Cluster
{{%expand "Athena Configuration" %}}


1. Navigate to the Athena service
2. Select the "optimization data" database
3. In **Saved Queries** find **"cluster_metadata_view"**" Change 'BU' to the tag you wish to do chargeback for
4. Click the **Run** button
5. In **Saved Queries** find **"ec2_cluster_costs_view"**" 
	-- Replace ${CUR} in the "FROM" clause with your CUR table name 
	-- For example, "curdb"."ecs_services_clusters_data" 
6. Click the **Run** button
7. In **Saved Queries** find **"bu_usage_view"**" 
	-- Replace ${CUR} in the "FROM" clause with your CUR table name 
	-- For example, "curdb"."ecs_services_clusters_data"
8. Click the **Run** button

Now your views are created you can run your report

#### Manually execute billing report

* In **Saved Queries** find **"ecs_chargeback_report"** 
	-- Replace "bu_usage_view.month" value with the appropriate month desired for the report
	-- For example, a value of '2' returns the charges for February 
* Click the **Run** button


#### Example Output


![Images/Example_output.png](/Cost/300_Optimization_Data_Collection/Images/Example_output.png)
Breakdown: 
* task_usage: total memory resources reserved (in GBs) by all tasks over the billing period (i.e. – monthly)
* percent: task_usage / total_usage
* ec2_cost: monthly cost for EC2 instance in $
* Services: Name of service 
* servicearn: Arn of service
* Value: Value of specified tag for the ECS service (could be App, TeamID, etc?)
{{% /expand%}}

{{< prev_next_button link_prev_url="../3_data_collection_modules/" link_next_url="../5_create_custom_data_collection_module/" />}}
