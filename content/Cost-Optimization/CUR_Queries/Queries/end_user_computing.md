---
title: "End User Computing"
weight: 7
---

These are queries for AWS Services under the [End User Computing product family](https://aws.amazon.com/products/end-user-computing/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [Amazon WorkSpaces](#amazon-workspaces)
  * [Amazon WorkSpaces - Auto Stop](#amazon-workspaces---auto-stop)
  * [Amazon AppStream 2.0](#amazon-appstream-20)

### Amazon WorkSpaces

#### Query Description
This query will provide unblended cost and usage information per linked account for Amazon WorkSpaces.  The output will include detailed information about the resource id (WorkSpace ID), usage type, running mode, product bundle, and API operation. The cost will be summed and in descending order.

#### Pricing
Please refer to the [WorkSpaces pricing page](https://aws.amazon.com/workspaces/pricing/).  If you are interested in Cost Optimization, please refer to the AWS Solution, [Amazon WorkSpaces Cost Optimizer](https://aws.amazon.com/solutions/implementations/amazon-workspaces-cost-optimizer/).

{{% notice note %}}
This query will **not** run against CUR data that does not have any Amazon WorkSpaces usage.  
{{% /notice%}}

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/End_User_Computing/workspaceswrid.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      SPLIT_PART(line_item_resource_id,'/',2) AS split_line_item_resource_id,
      SPLIT_PART(product_bundle,'-',1) AS split_product_bundle,
      product_operating_system,
      product_memory,
      product_storage,
      product_vcpu,
      product_running_mode,
      product_license,
      product_software_included,
      pricing_unit,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost 
    FROM 
      ${table_name}
    WHERE
      ${date_filter}
      AND product_product_name = 'Amazon WorkSpaces'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_resource_id,
      product_bundle,
      product_operating_system,
      product_memory,
      product_storage,
      product_vcpu,
      product_running_mode,
      product_license,
      product_software_included,
      pricing_unit
    ORDER BY
      day_line_item_usage_start_date,
      sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="End User Computing" service_text="Amazon WorkSpaces" query_text="Amazon WorkSpaces Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon WorkSpaces - Auto Stop

#### Query Description
AutoStop Workspaces are cost effective when used for several hours per day. If AutoStop Workspaces run for more than 80 hrs per month it is more cost effective to switch to AlwaysOn mode. This query shows AutoStop Workspaces which ran more that 80 hrs in previous month. If the usage pattern for these Workspaces is the same month over month it's possible to optimize cost by switching to AlwaysOn mode. For example, Windows PowerPro (8 vCPU, 32GB RAM) bundle in eu-west-1 runs for 400 hrs per month. In AutoStop mode it costs $612/month ($8.00/month + 400 * $1.53/hour) while if used in AlwaysOn mode it would cost $141/month.

#### Pricing
Please refer to the [WorkSpaces pricing page](https://aws.amazon.com/workspaces/pricing/).  If you are interested in Cost Optimization, please refer to the AWS Solution, [Amazon WorkSpaces Cost Optimizer](https://aws.amazon.com/solutions/implementations/amazon-workspaces-cost-optimizer/).

{{% notice note %}}
This query will **not** run against CUR data that does not have any Amazon WorkSpaces usage.  
{{% /notice%}}

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/End_User_Computing/amazon-workspaces-auto-stop.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      SPLIT_PART(line_item_resource_id, '/', 2) AS split_line_item_resource_id,
      product_region,
      product_operating_system,
      product_bundle_description,
      product_software_included,
      product_license,
      product_rootvolume,
      product_uservolume,
      pricing_unit,
      sum_line_item_usage_amount,
      CAST(total_cost_per_resource AS DECIMAL(16, 8)) AS "sum_line_item_unblended_cost(incl monthly fee)"
    FROM
      (
        SELECT
          bill_payer_account_id,
          line_item_usage_account_id,
          line_item_resource_id,
          product_operating_system,
          pricing_unit,
          product_region,
          product_bundle_description,
          product_rootvolume,
          product_uservolume,
          product_software_included,
          product_license,
          SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
          SUM(SUM(line_item_unblended_cost)) OVER (PARTITION BY line_item_resource_id) AS total_cost_per_resource,
          SUM(SUM(line_item_usage_amount)) OVER (PARTITION BY line_item_resource_id, pricing_unit) AS usage_amount_per_resource_and_pricing_unit
        FROM
          $ {table_name}
        WHERE
          line_item_product_code = 'AmazonWorkSpaces' 
          -- get previous month
          AND CAST(month AS INT) = CAST(month(current_timestamp + -1 * INTERVAL '1' MONTH) AS INT) 
          -- get year for previous month
          AND CAST(year AS INT) = CAST(year(current_timestamp + -1 * INTERVAL '1' MONTH) AS INT)
          AND line_item_line_item_type = 'Usage'
          AND line_item_usage_type LIKE '%AutoStop%'
        GROUP BY
          line_item_usage_account_id,
          line_item_resource_id,
          product_operating_system,
          pricing_unit,
          product_region,
          product_bundle_description,
          product_rootvolume,
          product_uservolume,
          bill_payer_account_id,
          product_software_included,
          product_license
      )     
    WHERE
      -- return only workspaces which ran more than 80 hrs
      usage_amount_per_resource_and_pricing_unit > 80
    ORDER BY
      total_cost_per_resource DESC,
      line_item_resource_id,
      line_item_usage_account_id,
      product_operating_system,
      pricing_unit;
```

{{< email_button category_text="End User Computing" service_text="Amazon WorkSpaces" query_text="Amazon WorkSpaces Query2" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon AppStream 2.0

#### Query Description
This query will provide unblended cost and usage information per linked account for Amazon AppStream 2.0.  The output will include detailed information about the product family, product instance type, pricing unit, region along with usage amount. The cost will be summed and in descending order.

#### Pricing
Please refer to the [Amazon AppStream 2.0 pricing page](https://aws.amazon.com/appstream2/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/End_User_Computing/appstream.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
      product_product_family, -- Stopped Instance, Streaming Instance, User Fees
      product_instance_type,  -- stream.TYPE.SIZE
      pricing_unit, -- Hrs, Users
      product_region, 
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      CASE line_item_line_item_type
        WHEN 'DiscountedUsage' THEN SUM(CAST(reservation_effective_cost AS DECIMAL(16,8)))
        WHEN 'Usage' THEN SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8)))
        ELSE SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8)))
      END AS sum_line_item_unblended_cost_reservation_effective_cost
    FROM
      ${table_name}
    WHERE
      ${date_filter}
      AND product_product_name = 'Amazon AppStream'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
      product_product_family,
      product_instance_type,
      pricing_unit,
      product_region,
      line_item_line_item_type
    ORDER BY
      month_line_item_usage_start_date,
      sum_line_item_usage_amount DESC,
      sum_line_item_unblended_cost_reservation_effective_cost,
      product_product_family;
```

{{< email_button category_text="End User Computing" service_text="Amazon AppStream 2.0" query_text="Amazon AppStream Query" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}






