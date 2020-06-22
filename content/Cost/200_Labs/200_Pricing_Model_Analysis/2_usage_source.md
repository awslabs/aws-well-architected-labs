---
title: "Create the Usage Data Source"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

We will combine the pricing information with our Cost and Usage Report (CUR). This will give us a usage data source which contains a summary of your usage at an hourly level, with multiple pricing dimensions.

1. Go to the **Athena** service page:
![Images/home_athena.png](/Cost/200_Pricing_Model_Analysis/Images/home_athena.png)

2. Run the following query to create a single pricing data source, combining the OD and SP pricing:

    <details>
    <summary> Click here to see the Athena SQL code</summary>

        CREATE VIEW pricing.pricing AS SELECT
        sp.location AS Region,
        sp.discountedoperation AS OS,
        REPLACE(od.col18, '"') AS InstanceType,
        REPLACE(od.col35, '"') AS Tenancy,
        REPLACE(od.col9, '"') AS ODRate,
        sp.discountedrate AS SPRate

        FROM pricing.sp_pricedata sp
        JOIN pricing.od_pricedata od ON
        ((sp.discountedusagetype = REPLACE(od.col46, '"'))
        AND (sp.discountedoperation = REPLACE(od.col47, '"')))

        WHERE od.col9 IS NOT NULL
        AND sp.location NOT LIKE 'Any'
        AND sp.purchaseoption LIKE 'No Upfront'
        AND sp.leasecontractlength = 1
    </details>

3. Next we'll join the CUR file with that pricing source as a view. Edit the following query, replace **costmaster.costmasterfile** with your existing database name and tablename of your CUR, then run the rollowing query:

        CREATE VIEW costmaster.SP_Usage AS SELECT
        costmaster.line_item_usage_account_id,
        costmaster.line_item_usage_start_date,
        to_unixtime(costmaster.line_item_usage_start_date) AS EpochTime,
        costmaster.product_instance_type,
        costmaster.product_location,
        costmaster.product_operating_system,
        costmaster.product_tenancy,
        SUM(costmaster.line_item_unblended_cost) AS ODPrice,
        SUM(costmaster.line_item_unblended_cost*(cast(pr.SPRate AS double)/cast(pr.ODRate AS double))) SPPrice,
        abs(SUM(cast(pr.SPRate AS double)) - SUM (cast(pr.ODRate AS double))) / SUM(cast(pr.ODRate AS double))*100 AS DiscountRate,
        SUM(costmaster.line_item_usage_amount) AS InstanceCount

        FROM costmaster.costmasterfile costmaster
        JOIN pricing.pricing pr ON (costmaster.product_location = pr.Region)
        AND (costmaster.line_item_operation = pr.OS)
        AND (costmaster.product_instance_type = pr.InstanceType)
        AND (costmaster.product_tenancy = pr.Tenancy)

        WHERE costmaster.line_item_product_code LIKE '%EC2%'
        AND costmaster.product_instance_type NOT LIKE ''
        AND costmaster.product_operating_system NOT LIKE 'NA'
        AND costmaster.line_item_unblended_cost > 0
        AND costmaster.line_item_line_item_type like 'Usage'

        GROUP BY costmaster.line_item_usage_account_id,
        costmaster.line_item_usage_start_date,
        costmaster.product_instance_type,
        costmaster.product_location,
        costmaster.product_operating_system,
        costmaster.product_tenancy

        ORDER BY costmaster.line_item_usage_start_date ASC,
        DiscountRate DESC


{{% notice warning %}}
The code above will capture ONLY on-demand usage, as defined by costmaster.line_item_line_item_type like 'Usage'. You can remove this to include Savings Plan usage, to see total commitment you should have, instead of additional commitment required.
{{% /notice %}}



4. Verify the data source is setup by editing the following query, replace **costmaster.** with the name of the database and run the following query:

        SELECT * FROM costmaster.sp_usage limit 10;

{{% notice tip %}}
You now have your usage data source setup with your pricing dimensions. You can modify the queries above to add or remove any columns you want in the view, which can later be used to visualize the data, for example tags.
{{% /notice %}}

