---
title: CUR Query Building
weight: 19
---

## Last Updated
May 2021

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: curquery@amazon.com

## Introduction
This lab will demonstrate the basic principles for constructing a basic CUR query. The skills you learn will help you construct your own CUR queries or modify queries already in use. While this lab cannot cover every use case for cost and usage analysis, many AWS services follow similar CUR logic and can be easily adapted.

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

## Table of Contents
 * [Query Framework](#query-framework)
 * [Query Description](#query-description)
 * [Finding Product Names and Codes](#finding-product-names-and-codes)
 * [Interesting CUR Fields](#interesting-cur-fields)
 * [CUR Data Dictionary](#cur-data-dictionary)

#### Query Framework

This example shows how to query the usage and cost of an individual product in a specific date range. The results are summed for each individual account that incurred charges. The following sections will break the query down by section and explain the individual components.

```tsql
    SELECT 
        bill_payer_account_id,
        line_item_usage_account_id,
        line_item_line_item_description,
        DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
        SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
        SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost
    FROM 
        ${table_name}
    WHERE
        year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
        AND product_product_name LIKE '%${product_name}%'
    GROUP BY
        bill_payer_account_id,
        line_item_usage_account_id,
        line_item_line_item_description,
        DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),    
    ORDER BY
        sum_line_item_unblended_cost DESC;
```

[Back to Table of Contents](#table-of-contents)


#### Query Description
Let's take a look at each section of the query framework:

```tsql
    SELECT 
        bill_payer_account_id,
        line_item_usage_account_id,
        line_item_line_item_description,
        DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
        SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost
```

In this section, you select a number of fields from the CUR.
- **bill_payer_account_id**: this is the payer account responsible for all charge of it and associated member accounts.
- **line_item_usage_account_id**: this is the account where the usage charge was incurred. 
- **line_item_line_item_description**: this is a description of the usage you are being charged for.
- **line_item_usage_start_date**: this is the date the charge was incurred. The **DATE_FORMAT** function is formatting this field in YYYY/MM/DD format. This field can be omitted if you are not looking for daily costs.
- **line_item_unblended_cost**: this is the actual cost of the usage being charged for. The **SUM** function totals all records returned and is optional. 
___
```tsql
    FROM 
        ${table_name}
    WHERE
        year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
        AND product_product_name LIKE '%${product_name}%'
```

In this section, you set parameters to filter a subset of records in CUR. The first line of the WHERE clause sets a date range. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
- **${table_name}**: this is the name of your table in Athena. 
- **${product_product_name}**: this is the name of the product reflected in CUR. Using the LIKE operator allows you to match with wildcards if you do not know the specific product name in CUR.
___

```tsql
    GROUP BY
        bill_payer_account_id,
        line_item_usage_account_id,
        line_item_line_item_description,
        DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),    
    ORDER BY
        sum_line_item_unblended_cost DESC;
```

In this section, you set grouping and ordering. 
- **GROUP BY** groups like records together. In this example, all records are grouped as follows:
  - First, group all records by payer account. 
  - Next, group all records by usage account. 
  - Next, group all records by description. 
  - Finally, group records by date. This wil result in a sum of all charges per product per day in each usage account.
- Note: you cannot group by fields that use a SUM function. 

- **ORDER BY** sorts the list of returned records by cost in descending order (largest to smallest).

[Back to Table of Contents](#table-of-contents)

#### Finding Product Names and Codes

```tsql
    SELECT DISTINCT 
        product_product_name,
        line_item_product_code
    FROM
        ${table_name}
```

The above query will list each distinct product names and codes in CUR. You can use this list as a reference for filtering CUR queries by product name or product code.  The product columns provide metadata about the product that incurred the expense, and the line item. [The product columns are dynamic](https://docs.aws.amazon.com/cur/latest/userguide/product-columns.html) and their visibility in Cost and Usage Reports depends on the usage of product in the billing period.

When working with AWS Marketplace products it is best to use the column [product_product_name](https://docs.aws.amazon.com/cur/latest/userguide/product-columns.html#product-details-P-productname) as it contains a friendly name for the third party product.  If you were to use line_item_product_code for AWS Marketplace products it will contain a unique ID. 

```
product_product_name = CloudBeaver
line_item_product_code = 581uljmnj07lfrc1uqfd9skb2p
```

When working with Native AWS products is is best to use the column [line_item_product_code](https://docs.aws.amazon.com/cur/latest/userguide/Lineitem-columns.html#Lineitem-details-P-ProductCode).  You could also add into your query a CASE statement to handle this:

```tsql
CASE
 WHEN ("bill_billing_entity" = 'AWS Marketplace' AND "line_item_line_item_type" NOT LIKE '%Discount%') THEN "product_product_name"
 WHEN ("bill_billing_entity" = 'AWS') THEN "line_item_product_code" END "Service",
```

It is always best to confirm your query output against Cost Explorer before using it in a production setting. 

[Back to Table of Contents](#table-of-contents)

#### Interesting CUR Fields
Detailed descriptions of the all CUR fields can be found in the CUR Data Dictionary: https://docs.aws.amazon.com/cur/latest/userguide/data-dictionary.html

 - **line_item_blended_cost**: this field shows the average cost of usage billed at different rates. An example is EC2 on-demand vs. Savings Plan discounted rate
 - **line_item_line_item_type**: this field is used to differentiate between credits, fees, tax, refunds, and discounted usage.
 - **line_item_resource_id**: if enabled in CUR, this field will show resource IDs for services that support this field.
 - **reservation_reservation_a_r_n**: the Amazon Resource Name (ARN) of an RI that has been applied to usage.
 - **resource_tags_user_TAGNAME**: user-defined resource tags and cost allocation tags will  appear in CUR.
 - **cost_category_TAGNAME**: Cost Category tags will  appear in CUR.
 -----
More information:
  - Resource Tags: https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html
  - Cost Categories: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/manage-cost-categories.html

[Back to Table of Contents](#table-of-contents)

{{% email_button category_text="QueryBuilding" service_text="BasicFramework" button_text="Help & Feedback" %}}

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}
