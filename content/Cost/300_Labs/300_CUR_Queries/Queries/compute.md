---
title: "Compute"
date: 2020-08-28T11:16:09-04:00
chapter: false
weight: 4
pre: "<b> </b>"
---

These are queries for AWS Services under the [Compute product family](https://aws.amazon.com/products/compute/).  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
You may need to change variables used as placeholders in your query. **${table_Name}** is a common variable which needs to be replaced. **Example: cur_db.cur_table**
{{% /notice %}}

### Table of Contents

{{< expand "Lambda" >}}

{{% markdown_wrapper %}}

#### Query Description
This query focuses on Lambda and the breakdown of its costs by different usage element. Split by Resource IDs you can view the usage, unblended costs and amortized cost broken down by different pricing plans. These results will be ordered by date and costs. 

#### Pricing
Please refer to the [Lambda pricing page](https://aws.amazon.com/lambda/pricing/).

#### Sample Output
![Images/lambda_sp.png](/Cost/300_CUR_Queries/Images/Compute/lambda_sp.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/lambda_sp.sql)

#### Copy Query
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
                      WHEN line_item_usage_type LIKE '%%Lambda-Edge-GB-Second%%' THEN 'Lambda EDGE GB x Sec.'
                      WHEN line_item_usage_type LIKE '%%Lambda-Edge-Request%%' THEN 'Lambda EDGE Requests'
                      WHEN line_item_usage_type LIKE '%%Lambda-GB-Second%%' THEN 'Lambda GB x Sec.'
                      WHEN line_item_usage_type LIKE '%%Request%%' THEN 'Lambda Requests'
                      WHEN line_item_usage_type LIKE '%%In-Bytes%%' THEN 'Data Transfer (IN)'
                      WHEN line_item_usage_type LIKE '%%Out-Bytes%%' THEN 'Data Transfer (Out)'
                      WHEN line_item_usage_type LIKE '%%Regional-Bytes%%' THEN 'Data Transfer (Regional)'
                      ELSE 'Other'
                  END as UsageType,
                  line_item_resource_id,
                  pricing_term,
                  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
                  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost, 
                  sum(CASE
              WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN
              "savings_plan_savings_plan_effective_cost"
              WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN
              ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment")
              WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN
              0
              WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN
              0
              WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN
              "reservation_effective_cost"
              WHEN ("line_item_line_item_type" = 'RIFee') THEN
              ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
              WHEN (("line_item_line_item_type" = 'Fee')
                  AND ("reservation_reservation_a_r_n" <> '')) THEN
              0
              ELSE "line_item_unblended_cost" END) "amortized_cost"
              FROM ${table_name}
                WHERE year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
                AND product_product_name = 'AWS Lambda'
                AND line_item_line_item_type like '%%Usage%%'
                AND product_product_family IN ('Data Transfer', 'Serverless')
                AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
              GROUP BY
              bill_payer_account_id,
                line_item_usage_account_id,
                DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
                product_region,
                line_item_usage_type,
                line_item_resource_id,
                pricing_term,
                line_item_line_item_type
              ORDER BY 
                day_line_item_usage_start_date,
                sum_line_item_usage_amount,
                sum_line_item_unblended_cost
            )

            UNION

            (
              SELECT
                bill_payer_account_id,
                  line_item_usage_account_id,
              line_item_line_item_type,
                  DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d') AS day_line_item_usage_start_date,
                  product_region AS Region,
                  CASE
                      WHEN line_item_usage_type LIKE '%%Lambda-Edge-GB-Second%%' THEN 'Lambda EDGE GB x Sec.'
                      WHEN line_item_usage_type LIKE '%%Lambda-Edge-Request%%' THEN 'Lambda EDGE Requests'
                      WHEN line_item_usage_type LIKE '%%Lambda-GB-Second%%' THEN 'Lambda GB x Sec.'
                      WHEN line_item_usage_type LIKE '%%Request%%' THEN 'Lambda Requests'
                      WHEN line_item_usage_type LIKE '%%In-Bytes%%' THEN 'Data Transfer (IN)'
                      WHEN line_item_usage_type LIKE '%%Out-Bytes%%' THEN 'Data Transfer (Out)'
                      WHEN line_item_usage_type LIKE '%%Regional-Bytes%%' THEN 'Data Transfer (Regional)'
                      ELSE 'Other'
                  END as UsageType,
                  line_item_resource_id,
                  CASE savings_plan_offering_type 
                      WHEN 'ComputeSavingsPlans' THEN 'Compute Savings Plans'
                      ELSE savings_plan_offering_type
                  END AS ChargeType,
                  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
                  SUM(CAST(savings_plan_savings_plan_effective_cost AS decimal(16,8))) AS sum_savings_plan_savings_plan_effective_cost,
              sum(CASE
              WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN
              "savings_plan_savings_plan_effective_cost"
              WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN
              ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment")
              WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN
              0
              WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN
              0
              WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN
              "reservation_effective_cost"
              WHEN ("line_item_line_item_type" = 'RIFee') THEN
              ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
              WHEN (("line_item_line_item_type" = 'Fee')
                  AND ("reservation_reservation_a_r_n" <> '')) THEN
              0
              ELSE "line_item_unblended_cost" END) "amortized_cost"
              
                FROM ${table_name}
                WHERE year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
                AND product_product_name = 'AWS Lambda'
                AND product_product_family IN ('Data Transfer', 'Serverless')
                AND line_item_line_item_type NOT IN ('Tax','Credit','Refund','EdpDiscount','Fee','RIFee')
              GROUP BY
              bill_payer_account_id,
                line_item_usage_account_id,
                DATE_FORMAT((line_item_usage_start_date),'%Y-%m-%d'),
                product_region,
                line_item_usage_type,
                line_item_resource_id,
                savings_plan_offering_type, 
                line_item_line_item_type
              ORDER BY  
                day_line_item_usage_start_date ASC,
                sum_line_item_usage_amount DESC
            )
          ) AS aggregatedTable

          ORDER BY
            day_line_item_usage_start_date,
            sum_line_item_usage_amount,
            sum_line_item_unblended_cost;

{{% /markdown_wrapper %}}

{{% email_button category_text="Compute" service_text="Lambda" query_text="Lambda Query1" button_text="Help & Feedback" %}}

{{< /expand >}}

{{< expand "Compute with Savings Plans" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide details about Compute usage that is covered by Savings Plans.  The output will include detailed information about the usage type, usage amount, Savings Plans ARN, line item description, and Savings Plans effective savings as compared to On-Demand pricing.  The public pricing on-demand cost will be summed and in descending order.

#### Pricing
Please refer to the [Savings Plans pricing page](https://aws.amazon.com/savingsplans/pricing/).

#### Sample Output
![Images/compute_sp.png](/Cost/300_CUR_Queries/Images/Compute/compute_sp.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/compute_sp.sql)

#### Copy Query
    SELECT  
      bill_payer_account_id,
      bill_billing_period_start_date,
      line_item_usage_account_id,
      DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
      savings_plan_savings_plan_a_r_n,
      line_item_product_code,
      line_item_usage_type,
      sum(line_item_usage_amount) sum_line_item_usage_amount,
      line_item_line_item_description,
      pricing_public_on_demand_rate,
      sum(pricing_public_on_demand_cost) AS sum_pricing_public_on_demand_cost,
      savings_plan_savings_plan_rate,
      sum(savings_plan_savings_plan_effective_cost) AS sum_savings_plan_savings_plan_effective_cost
    FROM ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
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
      sum_pricing_public_on_demand_cost DESC

{{% /markdown_wrapper %}}

{{% email_button category_text="Compute" service_text="Compute" query_text="Compute with Savings Plans" button_text="Help & Feedback" %}}

{{< /expand >}}


{{< expand "EC2 Hours a Day" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide the EC2 usage quantity measured in hours for each purchase option and each instance type.  The output will include detailed information about the instance type, amortized cost, purchase option, and usage quantity.  The output will be ordered by usage quantity in descending order. 

{{% notice note %}}
This query will **not** run against CUR data from accounts which have purchased EC2 Reserved Instances or Savings Plans.  
{{% /notice%}}

#### Pricing Page
Please refer to the [EC2 pricing page](https://aws.amazon.com/ec2/pricing/).

#### Sample Output
![Images/ec2runninghours.png](/Cost/300_CUR_Queries/Images/Compute/ec2runninghours.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/ec2runninghours.sql)

#### Copy Query
    SELECT 
      year,
      month,
      bill_billing_period_start_date,
      product_instance_type,
      date_trunc('hour', line_item_usage_start_date) as hour_line_item_usage_start_date, 
      bill_payer_account_id, 
      line_item_usage_account_id, 
      (CASE
        WHEN (savings_plan_savings_plan_a_r_n <> '') THEN
          'SavingsPlan'
        WHEN (reservation_reservation_a_r_n <> '') THEN
          'Reserved'
        WHEN (line_item_usage_type LIKE '%Spot%') THEN
          'Spot'
        ELSE 'OnDemand' END) as purchase_option, 
        sum(CASE
          WHEN line_item_line_item_type = 'SavingsPlanCoveredUsage' THEN
            savings_plan_savings_plan_effective_cost
          WHEN line_item_line_item_type = 'DiscountedUsage' THEN
            reservation_effective_cost
          WHEN line_item_line_item_type = 'Usage' THEN
            line_item_unblended_cost
          ELSE 0 END) as amortized_cost, 
      round(sum(line_item_usage_amount), 2) usage_quantity
    FROM ${table_name}
    WHERE 
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND ( (line_item_product_code = 'AmazonEC2')
            AND (product_servicecode <> 'AWSDataTransfer')
            AND (line_item_operation LIKE '%RunInstances%')
            AND (line_item_usage_type NOT LIKE '%DataXfer%') 
          )
      AND (
            (line_item_line_item_type = 'Usage')
            OR (line_item_line_item_type = 'SavingsPlanCoveredUsage')
            OR (line_item_line_item_type = 'DiscountedUsage')
          )
    GROUP BY  
      year, 
      month, 
      bill_billing_period_start_date,  
      product_instance_type,
      date_trunc('hour', line_item_usage_start_date),
      bill_payer_account_id,
      7,
      8
    ORDER BY 
      usage_quantity DESC

{{% /markdown_wrapper %}}

{{% email_button category_text="Compute" service_text="EC2" query_text="EC2 Hours a Day" button_text="Help & Feedback" %}}

{{< /expand >}}


{{< expand "EC2 Effective Savings Plans" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide EC2 consumption of Savings Plans across Compute resources by linked accounts. It also provides you with the savings received from these Savings Plans and which Savings Plans its connected to. The output is ordered by date. 

#### Pricing
Please refer to the [EC2 pricing page](https://aws.amazon.com/ec2/pricing/).

#### Sample Output
![Images/ec2speffective.png](/Cost/300_CUR_Queries/Images/Compute/ec2speffective.png)

#### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Compute/ec2speffective.sql)

#### Copy Query
        SELECT
        bill_payer_account_id,
        line_item_usage_account_id,
        DATE_FORMAT(("line_item_usage_start_date"),'%Y-%m-%d') AS day_line_item_usage_start_date, 
        SPLIT_PART(savings_plan_savings_plan_a_r_n, '/', 2) AS savings_plan_savings_plan_a_r_n,
        CASE
          savings_plan_offering_type
          WHEN 'EC2InstanceSavingsPlans' THEN 'EC2 Instance Savings Plans'
          WHEN 'ComputeSavingsPlans' THEN 'Compute Savings Plans'
          ELSE savings_plan_offering_type
        END AS "Type",
        savings_plan_region,
        CASE 
          WHEN product_product_name = 'Amazon EC2 Container Service' THEN 'Fargate'
          WHEN product_product_name = 'AWS Lambda' THEN 'Lambda'
          ELSE product_instance_type_family 
        END AS "Instance Type Family",
        SUM (TRY_CAST(line_item_unblended_cost as decimal(16, 8))) as "On Demand Cost",
        SUM(TRY_CAST(savings_plan_savings_plan_effective_cost AS decimal(16, 8))) as "Effective Cost",
        SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost, 
        savings_plan_end_time
        FROM
        ${table_name}
      WHERE
        year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
        AND savings_plan_savings_plan_a_r_n <> ''
        AND line_item_line_item_type = 'SavingsPlanCoveredUsage'
      GROUP by
              bill_payer_account_id,
            line_item_usage_account_id,
            DATE_FORMAT(("line_item_usage_start_date"),'%Y-%m-%d'),
        savings_plan_savings_plan_a_r_n,
        savings_plan_offering_type,
        savings_plan_region,
        product_instance_type_family,
        product_product_name, 
        savings_plan_end_time
      ORDER BY
        day_line_item_usage_start_date;


{{% /markdown_wrapper %}}

{{% email_button category_text="Compute" service_text="EC2" query_text="EC2 Effective Savings Plans" button_text="Help & Feedback" %}}

{{< /expand >}}

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}