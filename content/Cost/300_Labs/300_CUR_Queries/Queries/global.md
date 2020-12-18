---
title: "Global Queries"
date: 2020-09-27T06:36:09-04:00
chapter: false
weight: 8
pre: "<b> </b>"
---


These are queries which return information about global usage.  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
You may need to change variables used as placeholders in your query. **${table_Name}** is a common variable which needs to be replaced. **Example: cur_db.cur_table**
{{% /notice %}}

### Table of Contents
{{< expand "Account" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide monthly unblended and amortized costs per linked account for all services.  The query also includes ri_sp_trueup and ri_sip_upfront_fees columns to allow you to visualize the calculated difference between unblended and amortized costs.  Unblended = Amortized + True-up + Upfront Fees, the +/- logic has already been included for you in the columns.  We are showing in our example the exclusion of Route 53 Domains, as the monthly charges for these do not match between CUR and Cost Explorer.  Finally we are excluding discounts, credits, refunds and taxes.

#### Pricing
Please refer to the [AWS pricing page](https://aws.amazon.com/pricing/).

#### Cost Explorer Links
These links are provided as an example to compare CUR report output to Cost Explorer output.

Unblended Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=LinkedAccount&hasBlended=false&hasAmortized=false&excludeDiscounts=true&excludeTaggedResources=false&excludeCategorizedResources=false&excludeForecast=false&timeRangeOption=Last12Months&granularity=Monthly&reportName=&reportType=CostUsage&isTemplate=true&startDate=2019-12-01&endDate=2020-11-30&filter=%5B%7B%22dimension%22:%22UsageType%22,%22values%22:%5B%7B%22value%22:%22Route53-Domains%22,%22unit%22:%22Quantity%22%7D%5D,%22include%22:false,%22children%22:null%7D,%7B%22dimension%22:%22RecordType%22,%22values%22:%5B%22Credit%22,%22Enterprise%20Discount%20Program%20Discount%22,%22Refund%22,%22SavingsPlanNegation%22,%22Tax%22%5D,%22include%22:false,%22children%22:null%7D%5D&forecastTimeRangeOption=None&usageAs=usageQuantity&chartStyle=Stack)

Amortized Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=LinkedAccount&hasBlended=false&hasAmortized=true&excludeDiscounts=true&excludeTaggedResources=false&excludeCategorizedResources=false&excludeForecast=false&timeRangeOption=Last12Months&granularity=Monthly&reportName=&reportType=CostUsage&isTemplate=true&startDate=2019-12-01&endDate=2020-11-30&filter=%5B%7B%22dimension%22:%22UsageType%22,%22values%22:%5B%7B%22value%22:%22Route53-Domains%22,%22unit%22:%22Quantity%22%7D%5D,%22include%22:false,%22children%22:null%7D,%7B%22dimension%22:%22RecordType%22,%22values%22:%5B%22Credit%22,%22Enterprise%20Discount%20Program%20Discount%22,%22Refund%22,%22SavingsPlanNegation%22,%22Tax%22%5D,%22include%22:false,%22children%22:null%7D%5D&forecastTimeRangeOption=None&usageAs=usageQuantity&chartStyle=Stack)

#### Sample Output:
![Images/spendaccount.png](/Cost/300_CUR_Queries/Images/Global/spendaccount.png)

#### Download SQL File:
[Link to file](/Cost/300_CUR_Queries/Code/Global/spendaccount.sql)

#### Query Preview:
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') AS month_line_item_usage_start_date
      , sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0 ELSE "line_item_unblended_cost" END) "sum_line_item_unblended_cost"
      , sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "savings_plan_savings_plan_effective_cost" 
          WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment") 
          WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
          WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
          WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "reservation_effective_cost"  
          WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
          WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE "line_item_unblended_cost" END) "amortized_cost"
      , sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN (-"savings_plan_amortized_upfront_commitment_for_billing_period") 
          WHEN ("line_item_line_item_type" = 'RIFee') THEN (-"reservation_amortized_upfront_fee_for_billing_period")
          WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN (-"line_item_unblended_cost" ) ELSE 0 END) "ri_sp_trueup"
      , sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN "line_item_unblended_cost"
          WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN "line_item_unblended_cost"ELSE 0 END) "ri_sp_upfront_fees"
    
    FROM
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND line_item_usage_type != 'Route53-Domains'
      AND line_item_line_item_type != 'Tax'
      AND line_item_line_item_type != 'EdpDiscount' 
      AND line_item_line_item_type != 'Credit' 
      AND line_item_line_item_type != 'Refund'
      AND line_item_line_item_type != 'BundledDiscount'
    GROUP BY 
      bill_payer_account_id,
      line_item_usage_account_id,
      3
    ORDER BY
      month_line_item_usage_start_date ASC,
      sum_line_item_unblended_cost DESC;

{{% /markdown_wrapper %}}

{{% email_button category_text="Global" service_text="AWS Account" query_text="Global - Account" button_text="Help & Feedback" %}}

{{< /expand >}}


{{< expand "Region" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide monthly unblended and amortized costs per linked account for all services by region where the service is operating.  The query also includes ri_sp_trueup and ri_sip_upfront_fees columns to allow you to visualize the calculated difference between unblended and amortized costs.  Unblended = Amortized + True-up + Upfront Fees, the +/- logic has already been included for you in the columns.  We are showing in our example the exclusion of Route 53 Domains, as the monthly charges for these do not match between CUR and Cost Explorer.  Finally we are excluding discounts, credits, refunds and taxes.

#### Pricing

Please refer to the [AWS pricing page](https://aws.amazon.com/pricing/).

#### Cost Explorer Links
These links are provided as an example to compare CUR report output to Cost Explorer output.

Unblended Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=Region&hasBlended=false&hasAmortized=false&excludeDiscounts=true&excludeTaggedResources=false&excludeCategorizedResources=false&excludeForecast=false&timeRangeOption=Last12Months&granularity=Monthly&reportName=&reportType=CostUsage&isTemplate=true&startDate=2019-12-01&endDate=2020-11-30&filter=%5B%7B%22dimension%22:%22UsageType%22,%22values%22:%5B%7B%22value%22:%22Route53-Domains%22,%22unit%22:%22Quantity%22%7D%5D,%22include%22:false,%22children%22:null%7D,%7B%22dimension%22:%22RecordType%22,%22values%22:%5B%22Credit%22,%22Enterprise%20Discount%20Program%20Discount%22,%22Refund%22,%22SavingsPlanNegation%22,%22Tax%22%5D,%22include%22:false,%22children%22:null%7D%5D&forecastTimeRangeOption=None&usageAs=usageQuantity&chartStyle=Stack)

Amortized Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=Region&hasBlended=false&hasAmortized=true&excludeDiscounts=true&excludeTaggedResources=false&excludeCategorizedResources=false&excludeForecast=false&timeRangeOption=Last12Months&granularity=Monthly&reportName=&reportType=CostUsage&isTemplate=true&startDate=2019-12-01&endDate=2020-11-30&filter=%5B%7B%22dimension%22:%22UsageType%22,%22values%22:%5B%7B%22value%22:%22Route53-Domains%22,%22unit%22:%22Quantity%22%7D%5D,%22include%22:false,%22children%22:null%7D,%7B%22dimension%22:%22RecordType%22,%22values%22:%5B%22Credit%22,%22Enterprise%20Discount%20Program%20Discount%22,%22Refund%22,%22SavingsPlanNegation%22,%22Tax%22%5D,%22include%22:false,%22children%22:null%7D%5D&forecastTimeRangeOption=None&usageAs=usageQuantity&chartStyle=Stack)

#### Sample Output:                                                                                                                              
![Images/spendregion.png](/Cost/300_CUR_Queries/Images/Global/spendregion.png)                                                                      

#### Download SQL File:                                                                                                
[Link to file](/Cost/300_CUR_Queries/Code/Global/spendregion.sql)                                                                                                                       

#### Query Preview:                
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') AS month_line_item_usage_start_date,
      CASE product_region
        WHEN NULL THEN 'Global'
        WHEN '' THEN 'Global'
        WHEN 'global' THEN 'Global'
        ELSE product_region
      END AS product_region
      , sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0 ELSE "line_item_unblended_cost" END) "sum_line_item_unblended_cost"
      , sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "savings_plan_savings_plan_effective_cost" 
          WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment") 
          WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
          WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
          WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "reservation_effective_cost"  
          WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
          WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE "line_item_unblended_cost" END) "amortized_cost"
      , sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN (-"savings_plan_amortized_upfront_commitment_for_billing_period") 
          WHEN ("line_item_line_item_type" = 'RIFee') THEN (-"reservation_amortized_upfront_fee_for_billing_period")
          WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN (-"line_item_unblended_cost" ) ELSE 0 END) "ri_sp_trueup"
      , sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN "line_item_unblended_cost"
          WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN "line_item_unblended_cost"ELSE 0 END) "ri_sp_upfront_fees"
          
    FROM
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND line_item_usage_type != 'Route53-Domains'
      AND line_item_line_item_type != 'Tax'
      AND line_item_line_item_type != 'EdpDiscount' 
      AND line_item_line_item_type != 'Credit' 
      AND line_item_line_item_type != 'Refund'
      AND line_item_line_item_type != 'BundledDiscount'
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      3,
      4;


{{% /markdown_wrapper %}}

{{% email_button category_text="Global" service_text="AWS Region" query_text="Global - Region" button_text="Help & Feedback" %}}

{{< /expand >}}

{{< expand "Service" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide monthly unblended and amortized costs per linked account for all services by service.  We have additionally broken out Data Transfer for each service.  The query also includes ri_sp_trueup and ri_sip_upfront_fees columns to allow you to visualize the calculated difference between unblended and amortized costs.  Unblended = Amortized + True-up + Upfront Fees, the +/- logic has already been included for you in the columns.  We are showing in our example the exclusion of Route 53 Domains, as the monthly charges for these do not match between CUR and Cost Explorer.  Finally we are excluding discounts, credits, refunds and taxes.

#### Pricing
Please refer to the [AWS pricing page](https://aws.amazon.com/pricing/).

#### Cost Explorer Links
These links are provided as an example to compare CUR report output to Cost Explorer output.

Unblended Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=Service&hasBlended=false&hasAmortized=false&excludeDiscounts=true&excludeTaggedResources=false&excludeCategorizedResources=false&excludeForecast=false&timeRangeOption=Last12Months&granularity=Monthly&reportName=&reportType=CostUsage&isTemplate=true&startDate=2019-12-01&endDate=2020-11-30&filter=%5B%7B%22dimension%22:%22UsageType%22,%22values%22:%5B%7B%22value%22:%22Route53-Domains%22,%22unit%22:%22Quantity%22%7D%5D,%22include%22:false,%22children%22:null%7D,%7B%22dimension%22:%22RecordType%22,%22values%22:%5B%22Credit%22,%22Enterprise%20Discount%20Program%20Discount%22,%22Refund%22,%22SavingsPlanNegation%22,%22Tax%22%5D,%22include%22:false,%22children%22:null%7D%5D&forecastTimeRangeOption=None&usageAs=usageQuantity&chartStyle=Stack)

Amortized Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=Service&hasBlended=false&hasAmortized=true&excludeDiscounts=true&excludeTaggedResources=false&excludeCategorizedResources=false&excludeForecast=false&timeRangeOption=Last12Months&granularity=Monthly&reportName=&reportType=CostUsage&isTemplate=true&startDate=2019-12-01&endDate=2020-11-30&filter=%5B%7B%22dimension%22:%22UsageType%22,%22values%22:%5B%7B%22value%22:%22Route53-Domains%22,%22unit%22:%22Quantity%22%7D%5D,%22include%22:false,%22children%22:null%7D,%7B%22dimension%22:%22RecordType%22,%22values%22:%5B%22Credit%22,%22Enterprise%20Discount%20Program%20Discount%22,%22Refund%22,%22SavingsPlanNegation%22,%22Tax%22%5D,%22include%22:false,%22children%22:null%7D%5D&forecastTimeRangeOption=None&usageAs=usageQuantity&chartStyle=Stack)

#### Sample Output:                                                                                                                                     
![Images/spendservice.png](/Cost/300_CUR_Queries/Images/Global/spendservice.png)          

#### Download SQL File:                                                                                                                                       
[Link to file](/Cost/300_CUR_Queries/Code/Global/spendservice.sql)                                                                                    

#### Query Preview:                
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') AS month_line_item_usage_start_date,
      CASE 
        WHEN ("line_item_line_item_type" = 'Usage' AND "product_product_family" = 'Data Transfer') THEN CONCAT('DataTransfer-',"line_item_product_code") ELSE "line_item_product_code" END "service_line_item_product_code"
      , sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0 ELSE "line_item_unblended_cost" END) "sum_line_item_unblended_cost"
      , sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanCoveredUsage') THEN "savings_plan_savings_plan_effective_cost" 
          WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN ("savings_plan_total_commitment_to_date" - "savings_plan_used_commitment") 
          WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN 0
          WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN 0
          WHEN ("line_item_line_item_type" = 'DiscountedUsage') THEN "reservation_effective_cost"  
          WHEN ("line_item_line_item_type" = 'RIFee') THEN ("reservation_unused_amortized_upfront_fee_for_billing_period" + "reservation_unused_recurring_fee")
          WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN 0 ELSE "line_item_unblended_cost" END) "amortized_cost"
      , sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanRecurringFee') THEN (-"savings_plan_amortized_upfront_commitment_for_billing_period") 
          WHEN ("line_item_line_item_type" = 'RIFee') THEN (-"reservation_amortized_upfront_fee_for_billing_period")
          WHEN ("line_item_line_item_type" = 'SavingsPlanNegation') THEN (-"line_item_unblended_cost" ) ELSE 0 END) "ri_sp_trueup"
      , sum(CASE
          WHEN ("line_item_line_item_type" = 'SavingsPlanUpfrontFee') THEN "line_item_unblended_cost"
          WHEN (("line_item_line_item_type" = 'Fee') AND ("reservation_reservation_a_r_n" <> '')) THEN "line_item_unblended_cost"ELSE 0 END) "ri_sp_upfront_fees"
          
    FROM
      ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
      AND line_item_usage_type != 'Route53-Domains' 
      AND line_item_line_item_type != 'Tax'
      AND line_item_line_item_type != 'EdpDiscount' 
      AND line_item_line_item_type != 'Credit' 
      AND line_item_line_item_type != 'Refund'
      AND line_item_line_item_type != 'BundledDiscount'
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      3,
      4
    ORDER BY
      month_line_item_usage_start_date ASC,
      sum_line_item_unblended_cost DESC;


{{% /markdown_wrapper %}}

{{% email_button category_text="Global" service_text="AWS Service" query_text="Global - Service" button_text="Help & Feedback" %}}

{{< /expand >}}

{{< expand "Bill Details by Service" >}}

{{% markdown_wrapper %}}

#### Query Description
This query will provide a monthly cost summary by AWS Service Charge which is an approximation to the monthly bill in the billing console.

#### Pricing
Please refer to the [AWS pricing page](https://aws.amazon.com/pricing/).

#### Sample Output:                                                                                                                                     
![Images/billservice.png](/Cost/300_CUR_Queries/Images/Global/billservice.png)          

#### Download SQL File:                                                                                                                                       
[Link to file](/Cost/300_CUR_Queries/Code/Global/billservice.sql)                                                                                    

#### Query Preview:                
    SELECT 
        DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') AS month_line_item_usage_start_date,
        bill_bill_type,
        CASE
            WHEN ("product_product_family" = 'Data Transfer') THEN 'Data Transfer' ELSE replace(replace(replace("product_product_name", 'Amazon '),'Amazon'),'AWS ') END "product_product_name",
        product_location,
        line_item_line_item_description,
        sum(line_item_unblended_cost) AS round_sum_line_item_unblended_cost,
        sum(line_item_usage_amount) AS sum_line_item_usage_amount
    FROM 
          ${table_name}
    WHERE
      year = '2020' AND (month BETWEEN '7' AND '9' OR month BETWEEN '07' AND '09')
    GROUP BY 1,
             bill_bill_type,
             3,
             product_location,
             line_item_line_item_description
    HAVING sum(line_item_usage_amount) > 0
    ORDER BY month_line_item_usage_start_date,
             bill_bill_type,
             product_product_name,
             product_location,
             line_item_line_item_description;

{{% /markdown_wrapper %}}

{{% email_button category_text="Global" service_text="AWS Bill" query_text="Global - Bill" button_text="Help & Feedback" %}}

{{< /expand >}}

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}
