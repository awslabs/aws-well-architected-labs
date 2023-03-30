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
You can visualize Trusted Advisor Data with [TAO Dashboard.](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/) To deploy TAO Dashboard please follow [TAO Dashboard deployment steps](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/trusted-advisor-dashboards/dashboards/1_prerequistes/) and specify organizational data collection bucket created in this lab as a source

### Visualization of Compute Optimizer data with Amazon QuickSight
You can visualize Compute Optimizer Data with [Compute Optimizer Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/compute-optimizer-dashboards/). [Compute Optimizer Dashboard](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/compute-optimizer-dashboards/) also deliver Athena Tables and Views.

### AWS Organization Data and The Cost Intelligence Dashboard

This video shows you how to use the Optimization Data Collection Lab to pull in AWS Organization data such as Account names and Tags into the Cost And Usage report so it can be used in the CID.

{{< rawhtml >}}
<iframe width="560" height="315" src="https://www.youtube.com/embed/EGSIpanIuH0" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
{{< /rawhtml >}}

You can also use the below query to update your **account_map** table in athena to read from this data

{{%expand "New Account Map Query" %}}

      CREATE OR REPLACE VIEW "account_map" AS 
      SELECT DISTINCT
        id account_id
      , split_part(arn, ':',5) parent_account_id
      , name account_name
      , email account_email_id
      FROM
        "optimization_data"."organization_data" 

{{% /expand%}}


### Join with Cost and Usage Report

Example query on how you can connect your CUR to this Organizations data as a one off. In this query you will see the service costs split by account names. 
{{%expand "Steps" %}}

1.	In the **Athena** service page run the below query to join the Organizations data with the CUR table. Make the below changes as needed:

- Change managementcur if your named your database differently
- month = **Chosen Month**
- year = **Chosen Year**

		SELECT line_item_usage_account_id,
			line_item_product_code,
			 name,
			sum(line_item_unblended_cost) AS line_item_unblended_cost_cost
		FROM "managementcur"."cur" cur
		JOIN  "managementcur"."organisation_data"
		ON "cur".line_item_usage_account_id = organisation_data.id
		WHERE month = '10'
				AND year = '2020'
		GROUP BY  line_item_usage_account_id,  name, line_item_product_code
		limit 10;

![Images/Join.png](/Cost/300_Organization_Data_CUR_Connection/Images/Join.png)

2. The important part of this query is the join. The **line_item_usage_account_id** from your Cost & Usage Report should match a **account_number** from the Organizations data. You can now see the account name in your data.

![Images/Athena_Example.png](/Cost/300_Organization_Data_CUR_Connection/Images/Athena_Example.png)

### Create a View with Cost and Usage Report

If you would like to always have your Organizations data connected to your CUR then we can create a view. 

1.	In the Athena service page run the below query to join the Organizations data with the CUR table as a view. 

		CREATE OR REPLACE VIEW org_cur AS
		SELECT *
		FROM ("managementcur"."cur" cur
		INNER JOIN "managementcur"."organisation_data"
			ON ("cur"."line_item_usage_account_id" = "organisation_data"."id")) 
			


2. Going forward you will now be able to run your queries from this view and have the data connected to your Organizations data. To see a preview where your org data is, which is at the end of the returned data, run the below query.

		SELECT * FROM "managementcur"."org_cur" limit 10;
{{% /expand%}}


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

{{%expand "Optimization Data Snapshots and AMIs with OD pricing data" %}}

**Lambda**
1. Go to AWS Lambda 
2. Find the **pricing-Lambda-Function** function
3. Test the function


**Athena**
1. Go to AWS Athena
2. Go to *Saved queries* at the top of the screen
3. Run the *pricing_ec2_create_table* Query to create a pricing table
4. In *Saved queries* Run the *pricing_region_names* Query to create a normalized region name table 
5. In *Saved queries* run *inventory_snapshot_connected_to_ami_with_pricing* to create a view 
6. Run the below to see your data
        
        SELECT * FROM "optimization_data"."snapshot_ami_quicksight_view" limit 10;

{{% /expand%}}


{{%expand "Optimization Data Snapshots and AMIs with CUR data" %}}

You must have access to your Cost & Usage data in the same account and region so you can join through athena

**Athena**
1. Go to AWS Athena
2. Go to *Saved queries* at the top of the screen
3. In *Saved queries* run *inventory_snapshot_connected_to_ami_with_cur* to create a view 
4. Change the value ${table_name} to your Cost and Usage report database and name and your ${date_filter} to look at a certain month/year
5. You will see the price of all Snapshots and how much they cost based on their connection with AMIS

Please note that if you delete the snapshot and it is part of a lineage you may only make a small saving

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

### AWS Transit Gateway Chargeback
AWS Transit Gateway data transfer cost billed at the central networking account is allocated proportionally to the end usage accounts. The proportion is calculated by connecting with AWS CloudWatch bytes in bytes out data at each Transit Gateway attachement level. The total central data transfer cost is calculated at the central networking account with Cost and Usage Report. The chargeback amount is the corresponding proportional cost of the total central amount. 


{{%expand "Athena Configuration" %}}

1. Navigate to the Athena service and open **Saved Queries**. 
2. Select your database where you have your Cost and Usage Report 
3. In **Saved Queries** find **"tgw_chargeback_cur"**" 
4. Replace **< CURDatabase >** with your database name in the tgw_chargeback_cur. For example: 

``` "cur"."cost_and_usage_report" ```

The Cloud Watch data collection is automated for all the regions. However, if you are destined to only chargeback to a subset of selected regions, you need to specify it in "product_location LIKE '%US%'" line. 

5. Click the **Run** button
6. In **Saved Queries** find **"tgw_chargeback_cw"**" 
7. Select the "optimization data" database
8. Replace **< CURDatabase >**  with your database name in the tgw_chargeback_cw.
9. Click the **Run** button

Now your views are created and you can run your report
{{% /expand%}}


### RDS Graviton Eligibility
Graviton2 instances provide up to 35% performance improvement and up to 52% price/performance improvement for open source databases depending on database engine, version, and workload. You can easily determine what databases in your account can take advantage of Graviton using the RDS Graviton Eligibility query. This query will output all existing RDS databases, if they are eligible for graviton, if it requires any version upgrades in order to to migrate, the target graviton instance, as well as estimated savings. 

This section requires you to have the **RDS Module** deployed. 

{{%expand "Optimize RDS with Graviton" %}}

1. Navigate to Lambda and test the **Accounts-Collector-Function-OptimizationDataCollectionStack** and **pricing-Lambda-Function-OptimizationDataCollectionStack** lambdas 
2. Navigate to Athena 
3. Go to Saved queries at the top of the screen
4. Run the region_names Query to create a normalized region name table
5. Run the rds_pricing_table Query to create a pricing look up table for RDS
6. Run the graviton_mapping Query to create a mapping of existing Intel based instances to the proper Graviton based instance
7. Run the rds_metrics-rds-graviton Query to provide the output of your RDS instances and their graviton eligibility and savings. You can download the results to further filter and analyze the results 

{{%expand "Analyzing Your Results" %}}
1. Use the **graviton_eligible** column to sort through 
  * Already Graviton - this instance is already a graviton instance and is already receiving the price performance benefits
  * Eligible - this instance meets both DB Engine and Version Number requirements, and can be immediately moved to Graviton with no modifications necessary
  * Requires Updates - this instance meets the DB Engine requirement, but will [require a version upgrade prior to being migrated to Graviton](https://aws.amazon.com/blogs/database/key-considerations-in-moving-to-graviton2-for-amazon-rds-and-amazon-aurora-databases/)
  * Ineligible - this database engine is not eligible to be moved to graviton
2. **graviton_instancetype** will tell you what the equivilant graviton instance type is
3. Calculate your savings by moving to graviton: 
  * existing_unit_price	- your hourly price based on the configuration of your database
  * existing_monthly_price - price to run your database for 24 hours per day for 30 days
  * graviton_unit_price	- hourly price for the graviton equivilant of your existing database configuration
  * graviton_montlhy_price - price to run your database for 24 hours per day for 30 days after being moved to Graviton	
  * monthly_savings	- savings seen by moving a database to to Graviton if it ran 24 hours per day for 30 days
  * estimated_annual_savings - savings seen by moving a database to to Graviton if it ran 24 hours per day for 365 days
  * percentage_savings - percent difference in unit cost between the existing instance and its Graviton equivilant

{{< prev_next_button link_prev_url="../3_data_collection_modules/" link_next_url="../5_create_custom_data_collection_module/" />}}

