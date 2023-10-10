---
title: "Compute"
weight: 4
---

These are queries for AWS Services under the [Compute product family](https://aws.amazon.com/products/compute/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [EC2 Total Spend](#ec2-total-spend)
  * [EC2 Hours a Day](#ec2-hours-a-day)
  * [EC2 Effective Savings Plans](#ec2-effective-savings-plans)
  * [Compute with Savings Plans](#compute-with-savings-plans)
  * [Account Spend of Shared Savings Plan](#account-spend-of-shared-savings-plan)
  * [Lambda](#lambda)
  * [Elastic Load Balancing - Idle ELB](#elastic-load-balancing---idle-elb)
  * [EC2 Savings Plans Inventory](#ec2-savings-plans-inventory)
  * [EC2 Reserved Instance Coverage](#ec2-reserved-instance-coverage)
  * [AWS Outposts - EC2 Hours a Day](#aws-outposts---ec2-hours-a-day)

### EC2 Total Spend

#### Query Description
This query will display the top costs for all spend with the product code of 'AmazonEC2'.  This will include all pricing categories (i.e. OnDemand, Reserved etc..) as well as charges for storage on EC2 (i.e. gp2).  The query will output the product code as well as the product description to provide context.  It is ordered by largest to smallest spend.

#### Pricing
Please refer to the [EC2 pricing page](https://aws.amazon.com/ec2/pricing/).

#### Cost Explorer Links

These links are provided as an example to compare CUR report output to Cost Explorer output.

Unblended Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=None&hasBlended=false&hasAmortized=false&excludeDiscounts=true&excludeTaggedResources=false&excludeCategorizedResources=false&excludeForecast=false&timeRangeOption=Custom&granularity=Monthly&reportName=&reportType=CostUsage&isTemplate=true&filter=%5B%7B%22dimension%22:%22Service%22,%22values%22:%5B%22Amazon%20Elastic%20Compute%20Cloud%20-%20Compute%22,%22Amazon%20Elastic%20Block%20Store%22%5D,%22include%22:true,%22children%22:null%7D%5D&chartStyle=Group&forecastTimeRangeOption=None&usageAs=usageQuantity&startDate=2020-12-01&endDate=2020-12-31)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/ec2totalspend.sql)

#### Copy Query
```tsql
SELECT 
  line_item_product_code, 
  line_item_line_item_description, 
  SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost 
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND line_item_product_code = 'AmazonEC2'
  AND line_item_line_item_type NOT IN ('Tax','Refund','Credit')
GROUP BY 
  line_item_product_code, 
  line_item_line_item_description
ORDER BY 
  sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Compute" service_text="EC2" query_text="EC2 Total Spend" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### EC2 Hours a Day

#### Query Description
This query will provide the EC2 usage quantity measured in hours for each purchase option and each instance type.  The output will include detailed information about the instance type, amortized cost, purchase option, and usage quantity.  The output will be ordered by usage quantity in descending order. 

{{% notice note %}}
This query will **not** run against CUR data from accounts which have purchased EC2 Reserved Instances or Savings Plans.  
{{% /notice%}}

#### Pricing Page
Please refer to the [EC2 pricing page](https://aws.amazon.com/ec2/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/ec2runninghours.sql)

#### Copy Query
```tsql
SELECT 
  bill_billing_period_start_date,
  line_item_usage_start_date, 
  bill_payer_account_id, 
  line_item_usage_account_id,
  CASE 
    WHEN (line_item_usage_type LIKE '%SpotUsage%') THEN SPLIT_PART(line_item_usage_type, ':', 2)
    ELSE product_instance_type
  END AS case_product_instance_type,
  CASE
    WHEN (savings_plan_savings_plan_a_r_n <> '') THEN 'SavingsPlan'
    WHEN (reservation_reservation_a_r_n <> '') THEN 'Reserved'
    WHEN (line_item_usage_type LIKE '%Spot%') THEN 'Spot'
    ELSE 'OnDemand' 
  END AS case_purchase_option, 
  SUM(CASE
    WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN savings_plan_savings_plan_effective_cost
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
    WHEN line_item_line_item_type = 'Usage' THEN line_item_unblended_cost
    ELSE 0 
  END) AS sum_amortized_cost, 
  SUM(line_item_usage_amount) AS sum_line_item_usage_amount
FROM 
  ${table_name}  
WHERE 
  ${date_filter} 
  AND (line_item_product_code = 'AmazonEC2'
    AND product_servicecode <> 'AWSDataTransfer'
    AND line_item_operation LIKE '%RunInstances%'
    AND line_item_usage_type NOT LIKE '%DataXfer%'
  )
  AND (line_item_line_item_type = 'Usage'
    OR (line_item_line_item_type = 'SavingsPlanCoveredUsage')
    OR (line_item_line_item_type = 'DiscountedUsage')
  )
  -- excludes consumed ODCR hours from total
  AND product_capacitystatus != 'AllocatedCapacityReservation'
GROUP BY 
  bill_billing_period_start_date,
  line_item_usage_start_date, 
  bill_payer_account_id, 
  line_item_usage_account_id,
  5, --refers to case_product_instance_type
  6 --refers to case_purchase_option 
ORDER BY 
  sum_line_item_usage_amount DESC;
```

{{< email_button category_text="Compute" service_text="EC2" query_text="EC2 Hours a Day" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


### EC2 Effective Savings Plans

#### Query Description
This query will provide EC2 consumption of Savings Plans across Compute resources by linked accounts. It also provides you with the savings received from these Savings Plans and which Savings Plans its connected to. The output is ordered by date. 

#### Pricing
Please refer to the [EC2 pricing page](https://aws.amazon.com/ec2/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/ec2speffective.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  SPLIT_PART(savings_plan_savings_plan_a_r_n, '/', 2) AS savings_plan_savings_plan_a_r_n,
  savings_plan_offering_type,
  savings_plan_region,
  CASE 
  	WHEN line_item_product_code = 'AmazonECS' THEN 'Fargate'
  	WHEN line_item_product_code = 'AWSLambda' THEN 'Lambda'
  	ELSE product_instance_type_family 
  END AS case_instance_type_family,
  savings_plan_end_time,
  SUM(TRY_CAST(line_item_unblended_cost AS DECIMAL(16, 8))) AS sum_line_item_unblended_cost,
  SUM(TRY_CAST(savings_plan_savings_plan_effective_cost AS DECIMAL(16, 8))) AS sum_savings_plan_savings_plan_effective_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND savings_plan_savings_plan_a_r_n <> ''
  AND line_item_line_item_type = 'SavingsPlanCoveredUsage'
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  SPLIT_PART(savings_plan_savings_plan_a_r_n, '/', 2),
  savings_plan_offering_type,
  savings_plan_region,
  7, -- refers to case_instance_type_family
  savings_plan_end_time
ORDER BY 
  day_line_item_usage_start_date;
```


{{< email_button category_text="Compute" service_text="EC2" query_text="EC2 Effective Savings Plans" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Compute with Savings Plans

#### Query Description
This query will provide details about Compute usage that is covered by Savings Plans.  The output will include detailed information about the usage type, usage amount, Savings Plans ARN, line item description, and Savings Plans effective savings as compared to On-Demand pricing.  The public pricing on-demand cost will be summed and in descending order.

#### Pricing
Please refer to the [Savings Plans pricing page](https://aws.amazon.com/savingsplans/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/computesp.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  bill_billing_period_start_date,
  line_item_usage_account_id,
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date, 
  savings_plan_savings_plan_a_r_n,
  line_item_product_code,
  line_item_usage_type,
  SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
  line_item_line_item_description,
  pricing_public_on_demand_rate,
  SUM(pricing_public_on_demand_cost) AS sum_pricing_public_on_demand_cost,
  savings_plan_savings_plan_rate,
  SUM(savings_plan_savings_plan_effective_cost) AS sum_savings_plan_savings_plan_effective_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND line_item_line_item_type LIKE 'SavingsPlanCoveredUsage'
GROUP BY 
  bill_payer_account_id, 
  bill_billing_period_start_date, 
  line_item_usage_account_id, 
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'), 
  savings_plan_savings_plan_a_r_n, 
  line_item_product_code, 
  line_item_usage_type, 
  line_item_unblended_rate, 
  line_item_line_item_description, 
  pricing_public_on_demand_rate, 
  savings_plan_savings_plan_rate
ORDER BY 
  sum_pricing_public_on_demand_cost DESC;
```

{{< email_button category_text="Compute" service_text="Compute" query_text="Compute with Savings Plans" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Account Spend of Shared Savings Plan

#### Query Description
This query focuses on surfacing accounts which have utilized AWS Savings Plans for which they are not a buyer.  

#### Pricing
Please refer to the [Savings Plans pricing page](https://aws.amazon.com/savingsplans/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/accountspendofsharedsp.sql)

#### Copy Query
```tsql
SELECT 
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
  bill_payer_account_id,
  line_item_usage_account_id,
  split(savings_plan_savings_plan_a_r_n,':')[5] AS savings_plan_owner_account_id,
  savings_plan_offering_type,
  line_item_resource_id,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16, 8))) AS sum_line_item_unblended_cost,
  SUM(CAST(savings_plan_savings_plan_effective_cost AS DECIMAL(16, 8))) AS sum_savings_plan_savings_plan_effective_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter}
  AND bill_payer_account_id = '111122223333' 
  AND line_item_usage_account_id = '444455556666' 
  AND line_item_line_item_type = 'SavingsPlanCoveredUsage'
  AND savings_plan_savings_plan_a_r_n NOT LIKE '%444455556666%'
GROUP BY 
  DATE_FORMAT(line_item_usage_start_date,'%Y-%m'),
  line_item_resource_id,
  line_item_usage_account_id,
  split(savings_plan_savings_plan_a_r_n,':')[5],
  bill_payer_account_id,
  savings_plan_offering_type
ORDER BY 
  sum_savings_plan_savings_plan_effective_cost DESC;
```

{{< email_button category_text="Compute" service_text="Compute" query_text="Account Spend of Shared Savings Plan" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Lambda

#### Query Description
This query focuses on Lambda and the breakdown of its costs by different usage element. Split by Resource IDs you can view the usage, unblended costs and amortized cost broken down by different pricing plans. These results will be ordered by date and costs. 

#### Pricing
Please refer to the [Lambda pricing page](https://aws.amazon.com/lambda/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/lambdasp.sql)

#### Copy Query
```tsql
SELECT *
FROM
(
  (  
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id, 
      line_item_line_item_type,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      product_region,
      CASE
        WHEN line_item_usage_type LIKE '%Lambda-Edge-GB-Second%' THEN 'Lambda EDGE GB x Sec.'
        WHEN line_item_usage_type LIKE '%Lambda-Edge-Request%' THEN 'Lambda EDGE Requests'
        WHEN line_item_usage_type LIKE '%Lambda-GB-Second%' THEN 'Lambda GB x Sec.'
        WHEN line_item_usage_type LIKE '%Request%' THEN 'Lambda Requests'
        WHEN line_item_usage_type LIKE '%In-Bytes%' THEN 'Data Transfer (IN)'
        WHEN line_item_usage_type LIKE '%Out-Bytes%' THEN 'Data Transfer (Out)'
        WHEN line_item_usage_type LIKE '%Regional-Bytes%' THEN 'Data Transfer (Regional)'
        ELSE 'Other'
      END AS case_line_item_usage_type,
      line_item_resource_id,
      pricing_term,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost, 
      SUM(CASE
        WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN savings_plan_savings_plan_effective_cost
        WHEN line_item_line_item_type = 'SavingsPlanRecurringFee' THEN savings_plan_total_commitment_to_date - savings_plan_used_commitment
        WHEN line_item_line_item_type = 'SavingsPlanNegation' THEN 0 
        WHEN line_item_line_item_type = 'SavingsPlanUpfrontFee' THEN 0
        WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
        WHEN line_item_line_item_type = 'RIFee' THEN reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee
        WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN 0
        ELSE line_item_unblended_cost 
      END) AS sum_amortized_cost
    FROM ${table_name}
      WHERE ${date_filter}
      AND product_product_name = 'AWS Lambda'
      AND line_item_line_item_type LIKE '%Usage%'
      AND product_product_family IN ('Data Transfer', 'Serverless')
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      line_item_line_item_type,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      product_region,
      6, -- refers to case_line_item_usage_type
      line_item_resource_id,
      pricing_term
  )

  UNION

  (
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      line_item_line_item_type,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
      product_region,
      CASE
        WHEN line_item_usage_type LIKE '%Lambda-Edge-GB-Second%' THEN 'Lambda EDGE GB x Sec.'
        WHEN line_item_usage_type LIKE '%Lambda-Edge-Request%' THEN 'Lambda EDGE Requests'
        WHEN line_item_usage_type LIKE '%Lambda-GB-Second%' THEN 'Lambda GB x Sec.'
        WHEN line_item_usage_type LIKE '%Request%' THEN 'Lambda Requests'
        WHEN line_item_usage_type LIKE '%In-Bytes%' THEN 'Data Transfer (IN)'
        WHEN line_item_usage_type LIKE '%Out-Bytes%' THEN 'Data Transfer (Out)'
        WHEN line_item_usage_type LIKE '%Regional-Bytes%' THEN 'Data Transfer (Regional)'
        ELSE 'Other'
      END AS case_line_item_usage_type,
      line_item_resource_id,
      savings_plan_offering_type,
      SUM(CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
      SUM(CAST(savings_plan_savings_plan_effective_cost AS DECIMAL(16,8))) AS sum_savings_plan_savings_plan_effective_cost,
      SUM(CASE
        WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN savings_plan_savings_plan_effective_cost
        WHEN line_item_line_item_type = 'SavingsPlanRecurringFee' THEN savings_plan_total_commitment_to_date - savings_plan_used_commitment
        WHEN line_item_line_item_type = 'SavingsPlanNegation' THEN 0
        WHEN line_item_line_item_type = 'SavingsPlanUpfrontFee' THEN 0
        WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
        WHEN line_item_line_item_type = 'RIFee' THEN reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee
        WHEN line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '' THEN 0
        ELSE line_item_unblended_cost 
      END) AS sum_amortized_cost
    FROM 
      ${table_name}
    WHERE 
      ${date_filter}
      AND product_product_name = 'AWS Lambda'
      AND product_product_family IN ('Data Transfer', 'Serverless')
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      line_item_line_item_type,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
      product_region,
      6, --refers to case_line_item_usage_type
      line_item_resource_id,
      savings_plan_offering_type
  )
) AS aggregatedTable

ORDER BY
  day_line_item_usage_start_date,
  sum_line_item_usage_amount,
  sum_line_item_unblended_cost;
```

{{< email_button category_text="Compute" service_text="Lambda" query_text="Lambda Query1" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Elastic Load Balancing - Idle ELB

#### Query Description
This query will display cost and usage of Elastic Load Balancers which didn't receive any traffic last month and ran for more than 336 hours (14 days). Resources returned by this query could be considered for deletion.

#### Pricing
Please refer to the [Elastic Load Balancing pricing page](https://aws.amazon.com/elasticloadbalancing/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/elastic-load-balancing-idle-elbs.sql)

#### Copy Query
```tsql
SELECT
  bill_payer_account_id,
  line_item_usage_account_id,
  SPLIT_PART(line_item_resource_id, ':', 6) split_line_item_resource_id,
  product_region,
  pricing_unit,
  sum_line_item_usage_amount,
  CAST(cost_per_resource AS DECIMAL(16, 8)) AS sum_line_item_unblended_cost
FROM
  (
    SELECT
      line_item_resource_id,
      product_region,
      pricing_unit,
      line_item_usage_account_id,
      bill_payer_account_id,
      SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
      SUM(SUM(line_item_unblended_cost)) OVER (PARTITION BY line_item_resource_id) AS cost_per_resource,
      SUM(SUM(line_item_usage_amount)) OVER (PARTITION BY line_item_resource_id, pricing_unit) AS usage_per_resource_and_pricing_unit,
      COUNT(pricing_unit) OVER (PARTITION BY line_item_resource_id) AS pricing_unit_per_resource
    FROM
      ${table_name}
    WHERE
      line_item_product_code = 'AWSELB'
      -- get previous month
      AND month = CAST(month(current_timestamp + -1 * INTERVAL '1' MONTH) AS VARCHAR)
      -- get year for previous month
      AND year = CAST(year(current_timestamp + -1 * INTERVAL '1' MONTH) AS VARCHAR)
      AND line_item_line_item_type = 'Usage'
    GROUP BY
      line_item_resource_id,
      product_region,
      pricing_unit,
      line_item_usage_account_id,
      bill_payer_account_id
  )
WHERE
  -- filter only resources which ran more than half month (336 hrs)
  usage_per_resource_and_pricing_unit > 336
  AND pricing_unit_per_resource = 1
ORDER BY
  cost_per_resource DESC;
```

{{< email_button category_text="Compute" service_text="ELB" query_text="Elastic Load Balancing" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


### EC2 Savings Plans Inventory

#### Query Description
This query will provide an inventory for EC2 Savings Plans.  It will show useful information about the Savings Plans purchased including ID (ARN), type, term length, commitment (used, hourly, etc...), and utilization.  Cost Explorer can also provide this information in the Inventory and Utilization reports however, this combines elements from both into a single report. 

#### Pricing
Please refer to the [Savings Plans pricing page](https://aws.amazon.com/savingsplans/pricing/).

#### Cost Explorer Links
[Savings Plans Utilization Report](https://console.aws.amazon.com/cost-management/home?region=us-east-1#/savings-plans/utilization?subscriptionIds=%5B%5D&chartStyle=Line&timeRangeOption=LastMonth&granularity=Daily&reportName=Utilization%20report&reportType=SavingsPlansUtilization&isTemplate&startDate=2021-01-01&endDate=2021-01-31&filter=%5B%5D)

[Savings Plans Inventory Report](https://console.aws.amazon.com/cost-management/home?region=us-east-1#/savings-plans/inventory)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/ec2_sp_inventory.sql)

#### Copy Query
```tsql
SELECT
  SPLIT_PART(savings_plan_savings_plan_a_r_n, '/', 2) AS split_savings_plan_savings_plan_a_r_n,
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m') AS month_line_item_usage_start_date,
  savings_plan_offering_type,
  savings_plan_region,
  DATE_FORMAT(FROM_ISO8601_TIMESTAMP(savings_plan_start_time),'%Y-%m-%d') AS day_savings_plan_start_time,
  DATE_FORMAT(FROM_ISO8601_TIMESTAMP(savings_plan_end_time),'%Y-%m-%d') AS day_savings_plan_end_time,
  savings_plan_payment_option,
  savings_plan_purchase_term,
  SUM(TRY_CAST(savings_plan_recurring_commitment_for_billing_period AS DECIMAL(16, 8))) AS sum_savings_plan_recurring_committment_for_billing_period,
  SUM(TRY_CAST(savings_plan_total_commitment_to_date AS DECIMAL(16, 8))) AS sum_savings_plan_total_commitment_to_date, 
  SUM(TRY_CAST(savings_plan_used_commitment AS DECIMAL(16, 8))) AS sum_savings_plan_used_commitment,
  AVG(CASE
    WHEN line_item_line_item_type = 'SavingsPlanRecurringFee' THEN TRY_CAST(savings_plan_total_commitment_to_date AS DECIMAL(8, 2))
  END) AS "Hourly Commitment",
  -- (used commitment / total commitment) * 100 = utilization %
  TRY_CAST(((SUM(TRY_CAST(savings_plan_used_commitment AS DECIMAL(16, 8))) / SUM(TRY_CAST(savings_plan_total_commitment_to_date AS DECIMAL(16, 8)))) * 100) AS DECIMAL(3, 0)) AS calc_savings_plan_utilization_percent
FROM
  ${table_name}
WHERE 
  ${date_filter}
  AND savings_plan_savings_plan_a_r_n <> ''
  AND line_item_line_item_type = 'SavingsPlanRecurringFee'
GROUP BY
  SPLIT_PART(savings_plan_savings_plan_a_r_n, '/', 2),
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m'),
  savings_plan_offering_type,
  savings_plan_region,
  DATE_FORMAT(FROM_ISO8601_TIMESTAMP(savings_plan_start_time),'%Y-%m-%d'),
  DATE_FORMAT(FROM_ISO8601_TIMESTAMP(savings_plan_end_time),'%Y-%m-%d'),
  savings_plan_payment_option,
  savings_plan_purchase_term
ORDER BY
  split_savings_plan_savings_plan_a_r_n,
  month_line_item_usage_start_date;
```

{{< email_button category_text="Compute" service_text="ELB" query_text="EC2 Savings Plans Inventory" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### EC2 Reserved Instance Coverage

#### Query Description
The [Reserved Instance Utilization and Coverage reports](https://aws.amazon.com/aws-cost-management/reserved-instance-reporting/) are available out-of-the-box in AWS Cost Explorer. This query provides coverage for EC2 Reserved Instances.  It shows useful information about the Reserved Instances purchased including Lease ID, instance type and family, used and unused amounts, and On-Demand usage that could be covered by additional Savings Plans if this is your preferred savings method.

{{% notice note %}}
Cost and Usage columns are dynamic and their visibility in the Athena tables depends on usage.  This query will only work if you have reserved instance usage in the table/view you are querying.  If you do not have usage you will receive an error that reservation_reservation_a_r_n is an invalid column name. 
{{% /notice %}}

#### Pricing
Please refer to the [EC2 reserved instances pricing page](https://aws.amazon.com/ec2/pricing/reserved-instances/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/ec2ricoverage.sql)

#### Copy Query
```tsql
SELECT 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  CASE 
    WHEN line_item_line_item_type IN ('Usage') THEN 'OnDemand'
    WHEN line_item_line_item_type IN ('Fee','RIFee','DiscountedUsage') THEN 'ReservedInstance' 
  END AS case_purchase_option,
  SPLIT_PART(SPLIT_PART(reservation_reservation_a_r_n,':',6),'/',2) AS split_reservation_reservation_a_r_n,
  SPLIT_PART(line_item_usage_type ,':',2) AS split_line_item_usage_type_instance_type,
  SPLIT_PART(SPLIT_PART(line_item_usage_type ,':',2), '.', 1) AS split_line_item_usage_type_instance_family,
  CASE product_region
    WHEN NULL THEN 'Global'
    WHEN '' THEN 'Global'
    ELSE product_region
  END AS case_product_region,
  line_item_line_item_type,
  SUM(TRY_CAST(line_item_usage_amount AS DOUBLE)) AS sum_line_item_usage_amount,
  SUM(TRY_CAST(reservation_unused_quantity AS DOUBLE)) AS sum_reservation_unused_quantity,
  SUM(TRY_CAST(line_item_normalized_usage_amount AS DOUBLE)) AS sum_line_item_normalized_usage_amount,
  SUM(TRY_CAST(reservation_unused_normalized_unit_quantity AS DOUBLE)) AS sum_reservation_unused_normalized_unit_quantity,
  SUM(CAST(reservation_effective_cost AS DECIMAL(16,8))) AS sum_reservation_effective_cost,
  SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8))) AS sum_line_item_unblended_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND product_product_name = 'Amazon Elastic Compute Cloud'
  AND line_item_operation LIKE '%RunInstance%'
  AND line_item_line_item_type IN ('Usage','Fee','RIFee','DiscountedUsage')
  AND product_product_family NOT IN ('Data Transfer')
GROUP BY 
  bill_payer_account_id,
  line_item_usage_account_id,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  4, -- refers to case_purchase_option
  SPLIT_PART(SPLIT_PART(reservation_reservation_a_r_n,':',6),'/',2),
  SPLIT_PART(line_item_usage_type ,':',2),
  SPLIT_PART(SPLIT_PART(line_item_usage_type ,':',2), '.', 1),
  8, -- refers to case_product_region
  line_item_line_item_type
ORDER BY 
  day_line_item_usage_start_date,
  split_line_item_usage_type_instance_type,
  sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Compute" service_text="EC2" query_text="EC2 Reserved Instance Coverage" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### AWS Outposts - EC2 Hours a Day

#### Query Description
AWS Services running locally on [AWS Outposts](https://docs.aws.amazon.com/whitepapers/latest/how-aws-pricing-works/aws-outposts.html)  will be charged on usage only. Operating system charges are billed based on usage as an uplift to cover the license fee and no minimum fee required. This query will provide the Amazon EC2 software costs (like Windows, RHEL or others) on AWS Outposts. These software fees are not included with the cost of the AWS Outposts racks and are billed separately here. The output will include detailed information about the instance type, pre-installed softwares, operating system, description, amortized cost, and usage quantity. The output will be ordered by amortized cost in descending order.

#### Pricing
Please refer to the [AWS Outposts pricing page](https://aws.amazon.com/outposts/pricing/).

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/outposts_ec2runninghours.sql)

#### Copy Query
```tsql
SELECT 
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date, 
  bill_payer_account_id, 
  line_item_usage_account_id,  
  line_item_resource_id,
  product_instance_type,
  product_operating_system,
  product_pre_installed_sw,
  line_item_line_item_description, 
  SUM(line_item_usage_amount) AS sum_line_item_usage_amount,
  SUM(CASE
    WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN savings_plan_savings_plan_effective_cost
    WHEN line_item_line_item_type = 'DiscountedUsage' THEN reservation_effective_cost
    WHEN line_item_line_item_type = 'Usage' THEN line_item_unblended_cost
    ELSE 0 
  END) AS sum_amortized_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
  AND product_location_type='AWS Outposts'
  AND product_product_family='Compute Instance'
  AND line_item_operation LIKE '%RunInstance%'
  AND (line_item_line_item_type = 'Usage'
    OR (line_item_line_item_type = 'SavingsPlanCoveredUsage')
    OR (line_item_line_item_type = 'DiscountedUsage')
  )
GROUP BY
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
  bill_payer_account_id, 
  line_item_usage_account_id,  
  line_item_resource_id,
  product_instance_type,
  product_operating_system,
  product_pre_installed_sw,
  line_item_line_item_description
ORDER BY
  day_line_item_usage_start_date ASC,
  sum_amortized_cost DESC;
```

{{< email_button category_text="Compute" service_text="Outposts" query_text="AWS Outposts EC2 Hours a Day" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)
