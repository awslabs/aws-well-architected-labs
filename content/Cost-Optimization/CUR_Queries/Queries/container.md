---
title: "Container"
weight: 5.0
---

These are queries for AWS Services under the [Container product family](https://aws.amazon.com/containers).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [Amazon Elastic Container Services](#amazon-elastic-container-services)
  * [Amazon ECS - Daily Usage Hours and Cost by Usage Type and Purchase Option](#amazon-ecs---daily-usage-hours-and-cost-by-usage-type-and-purchase-option)
  
### Amazon Elastic Container Services

#### Query Description
This query will output the daily cost and usage per resource, by operation and service, for Elastic Consainer Services, ECS and EKS, both unblended and amortized costs are shown.  To provide you with a complete picture of the data, to match totals in cost explorer, if you are using Savings Plans you will likely see results with *blank* resource IDs, these represent the Savings Plans Negation values for compute cost already covered by Savings Plans.

#### Pricing
Please refer to the [Amazon ECS pricing page](https://aws.amazon.com/ecs/pricing/) and the [Amazon EKS pricing page](https://aws.amazon.com/eks/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Container/ecs_eks.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  SPLIT_PART(line_item_resource_id,':',6) AS split_line_item_resource_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  line_item_operation,
  line_item_product_code,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(line_item_unblended_cost) sum_line_item_unblended_cost,
  SUM(CASE
    WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN savings_plan_savings_plan_effective_cost
    WHEN line_item_line_item_type = 'SavingsPlanRecurringFee' THEN (savings_plan_total_commitment_to_date - savings_plan_used_commitment)
    WHEN line_item_line_item_type = 'SavingsPlanNegation' THEN 0
    WHEN line_item_line_item_type = 'SavingsPlanUpfrontFee' THEN 0
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
    ELSE line_item_unblended_cost 
  END) AS sum_amortized_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  and line_item_product_code IN ('AmazonECS','AmazonEKS')
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage','SavingsPlanRecurringFee','SavingsPlanNegation','SavingsPlanUpfrontFee')
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  SPLIT_PART(line_item_resource_id,':',6),
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  line_item_operation,
  line_item_product_code
ORDER BY 
  day_line_item_usage_start_date,
  sum_line_item_unblended_cost,
  sum_line_item_usage_amount,
  line_item_operation;
```

{{< email_button category_text="Container" service_text="Amazon ECS" query_text="Amazon ECS/EKS Query" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amazon ECS - Daily Usage Hours and Cost by Usage Type and Purchase Option

#### Query Description
This query will output the daily ECS cost and usage per resource, by usage type and purchase option, both unblended and amortized costs are shown.  To provide you with a complete picture of the data, to match totals in cost explorer, if you are using Savings Plans you will likely see results with *blank* resource IDs, these represent the Savings Plans Negation values for compute cost already covered by Savings Plans.

#### Pricing
Please refer to the [Amazon ECS pricing page](https://aws.amazon.com/ecs/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Container/ecs_hours_day.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  SPLIT_PART(SPLIT_PART(line_item_resource_id,':',6),'/',2) AS split_line_item_resource_id,
  CASE
    WHEN line_item_usage_type LIKE '%Fargate-GB%' THEN 'GB per hour'
    WHEN line_item_usage_type LIKE '%Fargate-vCPU%' THEN 'vCPU per hour'
  END AS case_line_item_usage_type,
  CASE line_item_line_item_type
    WHEN 'SavingsPlanCoveredUsage' THEN savings_plan_offering_type
    WHEN 'SavingsPlanNegation' THEN savings_plan_offering_type
    ELSE 
      CASE pricing_term
        WHEN 'OnDemand' THEN 'OnDemand'
        WHEN '' THEN 'Spot Instance'
        ELSE pricing_term
      END
  END AS case_purchase_option,
  SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(CASE pricing_term
    WHEN 'OnDemand' THEN line_item_unblended_cost
    WHEN '' THEN line_item_unblended_cost
    END) AS sum_line_item_unblended_cost,
  SUM(CASE
    WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN savings_plan_savings_plan_effective_cost
    WHEN line_item_line_item_type = 'SavingsPlanRecurringFee' THEN savings_plan_total_commitment_to_date - savings_plan_used_commitment
    WHEN line_item_line_item_type = 'SavingsPlanNegation' THEN 0
    WHEN line_item_line_item_type = 'SavingsPlanUpfrontFee' THEN 0
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
    ELSE line_item_unblended_cost 
  END) AS sum_amortized_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND line_item_product_code IN ('AmazonECS')
  AND line_item_operation != 'ECSTask-EC2'
  AND product_product_family != 'Data Transfer'
  AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage','SavingsPlanNegation','SavingsPlanRecurringFee','SavingsPlanUpfrontFee')
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  SPLIT_PART(SPLIT_PART(line_item_resource_id,':',6),'/',2),
  5, --refers to case_line_item_usage_type
  6 -- refers to case_purchase_option
ORDER BY 
  day_line_item_usage_start_date ASC,
  case_purchase_option,
  sum_line_item_usage_amount DESC;
```

{{< email_button category_text="Container" service_text="Amazon ECS" query_text="Amazon ECS Daily Usage Hours and Cost by Usage Type and Purchase Option" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}






