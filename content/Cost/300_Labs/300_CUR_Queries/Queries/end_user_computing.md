---
title: "End User Computing"
date: 2020-08-28T11:16:09-04:00
chapter: false
weight: 7
pre: "<b> </b>"
---

These are queries for AWS Services under the [End User Computing product family](https://aws.amazon.com/products/end-user-computing/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
You may need to change variables used as placeholders in your query. **${table_Name}** is a common variable which needs to be replaced. **Example: cur_db.cur_table**
{{% /notice %}}

### Table of Contents

{{< expand "Amazon WorkSpaces" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide unblended cost and usage information per linked account for Amazon WorkSpaces.  The output will include detailed information about the resource id (WorkSpace ID), usage type, running mode, product bundle, and API operation. The cost will be summed and in descending order.

#### Pricing
Please refer to the [WorkSpaces pricing page](https://aws.amazon.com/workspaces/pricing/).  If you are interested in Cost Optimization, please refer to the AWS Solution, [Amazon WorkSpaces Cost Optimizer](https://aws.amazon.com/solutions/implementations/amazon-workspaces-cost-optimizer/).

{{% notice note %}}
This query will **not** run against CUR data that does not have any Amazon WorkSpaces usage.  
{{% /notice%}}

#### Sample Output
![Images/workspaceswrid.png](/Cost/300_CUR_Queries/Images/End_User_Computing/workspaceswrid.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/End_User_Computing/workspaceswrid.sql)

#### Copy Query
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      SPLIT_PART(line_item_resource_id,'/',2) as split_line_item_resource_id,
      SPLIT_PART(product_bundle,'-',1) as split_product_bundle,
      product_operating_system,
      product_memory,
      product_storage,
      product_vcpu,
      product_running_mode,
      product_license,
      product_software_included,
      pricing_unit,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost 
    FROM 
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND product_product_name = 'Amazon WorkSpaces'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
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

{{% /markdown_wrapper %}}

{{% email_button category_text="End User Computing" service_text="Amazon WorkSpaces" query_text="Amazon WorkSpaces Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}






