---
title: "Cost and Usage analysis"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b> </b>"
---

In this lab you will perform some common analysis of your usage through SQL queries using Amazon Athena. You will be charged for Athena usage by the amount of data that is scanned - the source files are monthly, and in parquet format - which is compressed and partitioned to minimize cost. Be careful to include **limit 10** or similar at the end of your queries to limit the amount of data that comes back. Make sure you have Completed the [Level 200: Automated CUR Updates and Ingestion](../200_automated_cur_updates_and_ingestion/) lab before you begin.

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text.
{{% /notice %}}

{{% notice info %}}
This lab uses a placeholder variable called **${table_name}** for your CUR Athena database name and table, which must be replaced before a query will run. For example, if your CUR table is called **labscur** and is in a database called **cost_optimization_labs_cur**, you would replace **${table_name}** with "**cost_optimization_labs_cur.labscur**".
{{% /notice %}}


{{%expand "Click here to copy and paste all the examples into a text editor to replace the database and table name quickly." %}}

    SELECT * from ${table_name}
    LIMIT 10;


	SELECT distinct "line_item_line_item_description" from ${table_name}
	LIMIT 10;
	
	
	SELECT * from ${table_name}
	WHERE "line_item_line_item_type" like '%Usage%'
	LIMIT 10;
	
	
	SELECT distinct bill_billing_period_start_date FROM ${table_name}
	LIMIT 10;
	
	
	SELECT "line_item_usage_account_id", round(sum("line_item_unblended_cost"),2) as cost from ${table_name}
	GROUP BY "line_item_usage_account_id"
	ORDER BY cost desc
	LIMIT 10;
	
	
	SELECT "line_item_product_code", round(sum("line_item_unblended_cost"),2) as cost from ${table_name}
	GROUP BY "line_item_product_code"
	ORDER BY cost desc
	LIMIT 10;
	
	
	SELECT "line_item_product_code", "line_item_line_item_description", round(sum("line_item_unblended_cost"),2) as cost from ${table_name}
	GROUP BY "line_item_product_code", "line_item_line_item_description"
	ORDER BY cost desc
	LIMIT 10;
	
	
	SELECT "line_item_product_code", "line_item_line_item_description", round(sum("line_item_unblended_cost"),2) as cost from ${table_name}
	WHERE "line_item_product_code" like '%AmazonEC2%'
	GROUP BY "line_item_product_code", "line_item_line_item_description"
	ORDER BY cost desc
	LIMIT 10;
	
	
	SELECT "line_item_product_code", "line_item_line_item_description", round(sum("line_item_unblended_cost"),2) as cost from ${table_name}
	WHERE "line_item_product_code" like '%AmazonEC2%' and "line_item_usage_type" like '%BoxUsage%'
	GROUP BY "line_item_product_code", "line_item_line_item_description"
	ORDER BY cost desc
	LIMIT 10;
	
	
	SELECT "bill_payer_account_id", "product_product_name", "line_item_usage_type", "line_item_line_item_description", resource_tags_user_cost_center, round(sum(line_item_unblended_cost),2) as cost FROM ${table_name}
	WHERE length("resource_tags_user_cost_center") >0
	GROUP BY "resource_tags_user_cost_center", "bill_payer_account_id", "product_product_name", "line_item_usage_type", "line_item_line_item_description"
	ORDER BY cost desc
	LIMIT 20
	
	
	SELECT "bill_payer_account_id", "product_product_name", "line_item_usage_type", "line_item_line_item_description", round(sum(line_item_unblended_cost),2) as cost FROM ${table_name}
	WHERE length("resource_tags_user_cost_center") = 0
	GROUP BY "bill_payer_account_id", "product_product_name", "line_item_usage_type", "line_item_line_item_description"
	ORDER BY cost desc
	LIMIT 20
	
	
	SELECT "bill_payer_account_id", "bill_billing_period_start_date", "line_item_usage_account_id", "reservation_reservation_a_r_n", "line_item_product_code", "line_item_usage_type", sum("line_item_usage_amount") as Usage, "line_item_unblended_rate", sum("line_item_unblended_cost") as Cost, "line_item_line_item_description", "pricing_public_on_demand_rate", sum("pricing_public_on_demand_cost") as PublicCost from ${table_name}
	WHERE "line_item_line_item_Type" like '%DiscountedUsage%'
	GROUP BY "bill_payer_account_id", "bill_billing_period_start_date", "line_item_usage_account_id", "reservation_reservation_a_r_n", "line_item_product_code", "line_item_usage_type", "line_item_unblended_rate", "line_item_line_item_description", "pricing_public_on_demand_rate"
	LIMIT 20

	
	SELECT "line_item_usage_type", sum("line_item_usage_amount") as usage, round(sum("line_item_unblended_cost"),2) as cost from ${table_name}
	WHERE "line_item_usage_type" like '%t2.%'
	GROUP BY "line_item_usage_type"
	ORDER BY "line_item_usage_type"
	LIMIT 20
	
	
	SELECT "line_item_usage_type", round(sum("line_item_usage_amount"),2) as usage, round(sum("line_item_unblended_cost"),2) as cost, round(avg("line_item_unblended_cost"/"line_item_usage_amount"),4) as hourly_rate from ${table_name}
	WHERE "line_item_product_code" like '%AmazonEC2%' and "line_item_usage_type" like '%Usage%'
	GROUP BY "line_item_usage_type"
	ORDER BY "line_item_usage_type"
	LIMIT 20
	
	
	SELECT bill_billing_period_start_date, product_region, line_item_usage_type, reservation_reservation_a_r_n, reservation_unused_quantity, reservation_unused_recurring_fee from ${table_name}
	WHERE length(reservation_reservation_a_r_n) > 0 and reservation_unused_quantity > 0
	ORDER BY bill_billing_period_start_date, reservation_unused_recurring_fee desc
	LIMIT 20

{{% /expand%}}

1. Start by logging into the management/payer account AWS console via SSO. (or the account where your CUR data is stored)

2. Navigate to the [Amazon Athena](https://console.aws.amazon.com/athena/home) service.

3. Make sure you are in the "Query editor" before you proceed to the next step.

For each of the queries below, copy and paste each query into the query window, click the **Run** button to view the results.
![Images/3.0-AthenaQueryEditor.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/1.0-AthenaQueryEditor.png?classes=lab_picture_small)

### What data is available in the CUR file?
We will learn how to find out what data is available for querying in the CUR files, this will show what columns there are and some sample data in those columns.

Execute each of the statements below, then spend a minute to thoroughly read through the results and observe the data returned.

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

1. What are **all** the columns and data are in the CUR table?

	    SELECT * from ${table_name}
	    LIMIT 10;

2. What are all the different values in a specific column? (the column we use is **line_item_line_item_description**)

		SELECT distinct "line_item_line_item_description" from ${table_name}
		LIMIT 10;


3. What are all the columns from the CUR, where a specific value is in the column (here the column **line_item_line_item_type** contains the word **Usage**, note the capital 'U'):

		SELECT * from ${table_name}
		WHERE "line_item_line_item_type" like '%Usage%'
		LIMIT 10;

4. What billing periods are available?

		SELECT distinct bill_billing_period_start_date FROM ${table_name}
		LIMIT 10;


### Top Costs
To efficiently optimize, it is useful to view the top costs in different categories, such as service, description or tags. Here are the most useful categories to get top costs by.

1. Top10 Costs by AccountID:

		SELECT "line_item_usage_account_id", round(sum("line_item_unblended_cost"),2) as cost from ${table_name}
		GROUP BY "line_item_usage_account_id"
		ORDER BY cost desc
		LIMIT 10;


2. Top10 Costs by Product:

		SELECT "line_item_product_code", round(sum("line_item_unblended_cost"),2) as cost from ${table_name}
		GROUP BY "line_item_product_code"
		ORDER BY cost desc
		LIMIT 10;

3. Top10 Costs by Line Item Description

		SELECT "line_item_product_code", "line_item_line_item_description", round(sum("line_item_unblended_cost"),2) as cost from ${table_name}
		GROUP BY "line_item_product_code", "line_item_line_item_description"
		ORDER BY cost desc
		LIMIT 10;

4. Top EC2 Costs

		SELECT "line_item_product_code", "line_item_line_item_description", round(sum("line_item_unblended_cost"),2) as cost from ${table_name}
		WHERE "line_item_product_code" like '%AmazonEC2%'
		GROUP BY "line_item_product_code", "line_item_line_item_description"
		ORDER BY cost desc
		LIMIT 10;

5. Top EC2 OnDemand Costs

		SELECT "line_item_product_code", "line_item_line_item_description", round(sum("line_item_unblended_cost"),2) as cost from ${table_name}
		WHERE "line_item_product_code" like '%AmazonEC2%' and "line_item_usage_type" like '%BoxUsage%'
		GROUP BY "line_item_product_code", "line_item_line_item_description"
		ORDER BY cost desc
		LIMIT 10;


### Tagging and Cost Attribution
Common in large organizations is the requirement to allocate costs back to specific business units. It is also critical for optimization to be able to allocate costs to workloads, to measure workload efficiency.

{{% notice note %}}
This will only work if you have tags enabled in your billing files, and they are the same as the examples here - **resource_tags_user_cost_center**. You may need to change the examples below to match your tags.
{{% /notice %}}


1. Top 20 Costs by line item description and CostCenter Tag

		SELECT "bill_payer_account_id", "product_product_name", "line_item_usage_type", "line_item_line_item_description", resource_tags_user_cost_center, round(sum(line_item_unblended_cost),2) as cost FROM ${table_name}
		WHERE length("resource_tags_user_cost_center") >0
		GROUP BY "resource_tags_user_cost_center", "bill_payer_account_id", "product_product_name", "line_item_usage_type", "line_item_line_item_description"
		ORDER BY cost desc
		LIMIT 20

2. Top 20 costs by line item description, without a CostCenter Tag

		SELECT "bill_payer_account_id", "product_product_name", "line_item_usage_type", "line_item_line_item_description", round(sum(line_item_unblended_cost),2) as cost FROM ${table_name}
		WHERE length("resource_tags_user_cost_center") = 0
		GROUP BY "bill_payer_account_id", "product_product_name", "line_item_usage_type", "line_item_line_item_description"
		ORDER BY cost desc
		LIMIT 20


### Savings Plans, Reserved Instance, On Demand and Spot Usage
To improve the use of pricing models across a business, these queries can assist to highlight the top opportunities for Savings Plans and Reserved Instances, by finding top On Demand costs. It also identifies who is successful with pricing models by (Top users of spot).

{{% notice note %}}
You will need specific usage in your account that matches the instance types below, for this to work correctly.
{{% /notice %}}


1. **Who used Savings Plan** Identify which usage was covered by a savings plan.

		SELECT "bill_payer_account_id", "bill_billing_period_start_date", "line_item_usage_account_id", "savings_plan_savings_plan_a_r_n", "line_item_product_code", "line_item_usage_type", sum("line_item_usage_amount") as Usage, "line_item_line_item_description", "pricing_public_on_demand_rate", sum("pricing_public_on_demand_cost") as PublicCost, savings_plan_savings_plan_rate, sum(savings_plan_savings_plan_effective_cost) as SavingsPlanCost from ${table_name}
		WHERE "line_item_line_item_Type" like 'SavingsPlanCoveredUsage'
		GROUP BY "bill_payer_account_id", "bill_billing_period_start_date", "line_item_usage_account_id", "savings_plan_savings_plan_a_r_n", "line_item_product_code", "line_item_usage_type", "line_item_unblended_rate", "line_item_line_item_description", "pricing_public_on_demand_rate", "savings_plan_savings_plan_rate" 
		LIMIT 20

2. **Unused Savings Plan** For each savings plan, look at the total commitment and total usage each month.

        SELECT "bill_payer_account_id", "bill_billing_period_start_date", "line_item_usage_account_id", "savings_plan_savings_plan_a_r_n", sum(savings_plan_savings_plan_effective_cost) as SavingsPlanUsage, sum("savings_plan_recurring_commitment_for_billing_period") as SavingsPlanCommit from ${table_name}
        WHERE  length("savings_plan_savings_plan_a_r_n") > 0
        GROUP BY "bill_payer_account_id", "bill_billing_period_start_date", "line_item_usage_account_id", "savings_plan_savings_plan_a_r_n"
        order by bill_billing_period_start_date desc, SavingsPlanCommit desc, SavingsPlanUsage
        LIMIT 10



3. **Who used Reserved Instances** Identify which accounts used the available RIs, and what they would have paid with public pricing. Ideal for chargeback within an organization.

		SELECT "bill_payer_account_id", "bill_billing_period_start_date", "line_item_usage_account_id", "reservation_reservation_a_r_n", "line_item_product_code", "line_item_usage_type", sum("line_item_usage_amount") as Usage, "line_item_unblended_rate", sum("line_item_unblended_cost") as Cost, "line_item_line_item_description", "pricing_public_on_demand_rate", sum("pricing_public_on_demand_cost") as PublicCost from ${table_name}
		WHERE "line_item_line_item_Type" like '%DiscountedUsage%'
		GROUP BY "bill_payer_account_id", "bill_billing_period_start_date", "line_item_usage_account_id", "reservation_reservation_a_r_n", "line_item_product_code", "line_item_usage_type", "line_item_unblended_rate", "line_item_line_item_description", "pricing_public_on_demand_rate"
		LIMIT 20

4. **Specific Instance family usage** Observe how much is being spent on each different family (usage type) and how much is covered by Reserved instances.

		SELECT "line_item_usage_type", sum("line_item_usage_amount") as usage, round(sum("line_item_unblended_cost"),2) as cost from ${table_name}
		WHERE "line_item_usage_type" like '%t2.%'
		GROUP BY "line_item_usage_type"
		ORDER BY "line_item_usage_type"
		LIMIT 20

5. **Costs By running type** Divide the cost by usage (hrs), and see how much is being spent per hour on each of the usage types. Compare **BoxUsage** (On Demand), to **HeavyUsage** (Reserved instance), to **SpotUsage** (Spot).

     	SELECT "line_item_usage_type", round(sum("line_item_usage_amount"),2) as usage, round(sum("line_item_unblended_cost"),2) as cost, round(avg("line_item_unblended_cost"/"line_item_usage_amount"),4) as hourly_rate from ${table_name}
		WHERE "line_item_product_code" like '%AmazonEC2%' and "line_item_usage_type" like '%Usage%'
		GROUP BY "line_item_usage_type"
		ORDER BY "line_item_usage_type"
		LIMIT 20

4. **Show unused Reserved Instances** This will show how much of your reserved instances are not being used, and sorts it via cost of unused portion (recurring fee).
You can use this in two ways:
- See where you have spare RI's and modify instances to match, so they will use the RIs
- Convert your existing RI's if possible

		SELECT bill_billing_period_start_date, product_region, line_item_usage_type, reservation_reservation_a_r_n, reservation_unused_quantity, reservation_unused_recurring_fee from ${table_name}
		WHERE length(reservation_reservation_a_r_n) > 0 and reservation_unused_quantity > 0
		ORDER BY bill_billing_period_start_date, reservation_unused_recurring_fee desc
		LIMIT 20

{{% notice tip %}}
You have now setup and completed basic analysis of a Cost and Usage Report (CUR). 
- [Visit the Well-Architected Cloud Intelligence Dashboards for ways to create a CUR QuickSight Dashboard using a ready to customize template]({{< ref "/Cost/200_Labs/200_Enterprise_Dashboards" >}})
- [Visit the Well-Architected CUR Query Library for queries to help you get started with analyzing your spend]({{< ref "/Cost/300_Labs/300_CUR_Queries" >}})
{{% /notice %}}

{{< prev_next_button link_prev_url="../2_setup_athena/"  title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST3 - "How do you monitor usage and cost?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-expenditure-and-usage-awareness.html)
{{< /prev_next_button >}}
