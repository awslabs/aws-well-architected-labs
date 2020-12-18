---
title: "Security, Identity, & Compliance"
date: 2020-08-28T11:16:09-04:00
chapter: false
weight: 12
pre: "<b> </b>"
---

These are queries for AWS Services under the [Security, Identity, & Compliance product family](https://aws.amazon.com/products/security/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
You may need to change variables used as placeholders in your query. **${table_Name}** is a common variable which needs to be replaced. **Example: cur_db.cur_table**
{{% /notice %}}

### Table of Contents

{{< expand "Amazon GuardDuty" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides daily unblended cost and usage information about Amazon GuardDuty Usage. The usage amount and cost will be summed.

#### Pricing
Please refer to the [Amazon GuardDuty pricing page](https://aws.amazon.com/guardduty/pricing/) for more details.

#### Sample Output
![Images/guardduty.png](/Cost/300_CUR_Queries/Images/Security_Identity_&_Compliance/guardduty.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Security_Identity_&_Compliance/guardduty.sql)

#### Copy Query
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      line_item_usage_type,
      TRIM(REPLACE(product_group, 'Security Services - Amazon GuardDuty ', '')) AS trim_product_group,   
      pricing_unit, 
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${tableName}
    WHERE
          (year = '2020' AND month IN ('1','01') OR year = '2020' AND month IN ('2','02'))
      AND product_product_name = 'Amazon GuardDuty'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id, 
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      line_item_usage_type,
      product_group,
      pricing_unit
    ORDER BY
      day_line_item_usage_start_date,
      sum_line_item_usage_amount,
      sum_line_item_unblended_cost,
      trim_product_group;

{{% /markdown_wrapper %}}

{{% email_button category_text="Security, Identity, & Compliance" service_text="Amazon GuardDuty" query_text="Amazon GuardDuty Query1" button_text="Help & Feedback" %}}

{{< /expand >}}



{{< expand "Amazon Cognito" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides daily unblended cost and usage information about Amazon Cognito Usage. The usage amount and cost will be summed.

#### Pricing
Please refer to the [Amazon Cognito pricing page](https://aws.amazon.com/cognito/pricing/) for more details.

#### Sample Output
![Images/cognito.png](/Cost/300_CUR_Queries/Images/Security_Identity_&_Compliance/cognito.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Security_Identity_&_Compliance/cognito.sql)

#### Copy Query
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      product_product_name,
      line_item_operation, 
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM
      ${tableName}
    WHERE
      (year = '2020' AND month IN ('1','01') OR year = '2020' AND month IN ('2','02'))
      AND product_product_name = 'Amazon Cognito'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      product_product_name,
      line_item_operation
    ORDER BY
      day_line_item_usage_start_date,
      sum_line_item_usage_amount,
      sum_line_item_unblended_cost,
      line_item_operation;

{{% /markdown_wrapper %}}

{{% email_button category_text="Security, Identity, & Compliance" service_text="Amazon Cognito" query_text="Amazon Cognito Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{< expand "AWS WAF" >}}

{{% markdown_wrapper %}}

#### Query Description
This query provides daily unblended cost and usage information about AWS WAF Usage including web acl, rule id, and region. The usage amount and cost will be summed and the cost will be in descending order.

#### Pricing
Please refer to the [WAF pricing page](https://aws.amazon.com/waf/pricing/) for more details.

#### Sample Output
![Images/waf.png](/Cost/300_CUR_Queries/Images/Security_Identity_&_Compliance/waf.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Security_Identity_&_Compliance/waf.sql)

#### Copy Query
    SELECT 
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d') AS day_line_item_usage_start_date,
      SPLIT_PART(SPLIT_PART(line_item_resource_id,'/',2),'+',1) AS split_webaclid_line_item_resource_id,
      SPLIT_PART(SPLIT_PART(line_item_resource_id,'/',2),'+',2) AS split_ruleid_line_item_resource_id,
      line_item_usage_type,
      product_group,
      product_group_description,
      product_location,
      product_location_type,
      line_item_line_item_description,
      pricing_unit,
      SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
    FROM 
      ${tableName}
    WHERE
      (year = '2020' AND month IN ('1','01') OR year = '2020' AND month IN ('2','02'))
      AND product_product_name = 'AWS WAF'
      AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m-%d'),
      line_item_resource_id,
      line_item_usage_type,
      product_group,
      product_group_description,
      product_location,
      product_location_type,
      line_item_line_item_description,
      pricing_unit
    ORDER BY
      day_line_item_usage_start_date,
      sum_line_item_usage_amount,
      sum_line_item_unblended_cost,
      product_group;

{{% /markdown_wrapper %}}

{{% email_button category_text="Security, Identity, & Compliance" service_text="Amazon Cognito" query_text="Amazon Cognito Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}




