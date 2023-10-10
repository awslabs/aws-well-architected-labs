---
title: "Global Queries"
weight: 8
---

These are queries which return information about global usage.  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [Account](#account)
  * [Region](#region)
  * [Service](#service)
  * [Bill Details by Service](#bill-details-by-service)
  * [Premium Support Chargeback by Accounts](#premium-support-chargeback-by-accounts)
  * [Unblended Cost by Charge Type](#cost-by-charge-type)
  * [Serverless Product Spend](#serverless-product-spend)
  * [Amortized Cost By Charge Type](#amortized-cost-by-charge-type)
  
### Account

#### Query Description
This query will provide monthly unblended and amortized costs per linked account for all services.  The query includes ri_sp_trueup and ri_sp_upfront_fees columns to allow you to visualize the difference between unblended and amortized costs.  Unblended cost equals usage plus upfront fees.  Amortized cost equals usage plus the portion of upfront fees applicable to the period (both used and unused). True-up therefore represents the difference between total upfront fees incurred in the period using an unblended/cash-based accounting model, and the smaller portion of upfront fees applicable to the period using an amortized/accrual-based accounting model. This query excludes discounts, credits, refunds and taxes, as well as Route 53 Domains usage type due to differences in how usage date is recorded between Cost Explorer and CUR. 

**Notes:** 
* Charges for the current billing month may differ slightly when comparing between Cost Explorer and CUR due to differences in how [current month charges are estimated](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html#how-cur-works). Charges will match between Cost Explorer and CUR once billing has been finalized at the close of the month.

* This query expects that you have reserved instances purchased within at least one of the accounts.  Running this query as is without reserved instances in the CUR data set will result in an error. To use this query without reserved instances, remove or comment out lines containing `reservation_reservation_a_r_n`.

#### Pricing
Please refer to the [AWS pricing page](https://aws.amazon.com/pricing/).

#### Cost Explorer Links
These links are provided as an example to compare CUR report output to Cost Explorer output.

Unblended Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=LinkedAccount&forecastTimeRangeOption=None&hasBlended=false&excludeRefund=false&excludeCredit=false&excludeRIUpfrontFees=false&excludeRIRecurringCharges=false&excludeOtherSubscriptionCosts=false&excludeSupportCharges=false&excludeTax=false&excludeTaggedResources=false&chartStyle=Stack&timeRangeOption=Last12Months&granularity=Monthly&isTemplate=true&filter=%5B%7B%22dimension%22:%22UsageType%22,%22values%22:%5B%7B%22value%22:%22Route53-Domains%22,%22unit%22:%22Quantity%22%7D%5D,%22include%22:false,%22children%22:null%7D,%7B%22dimension%22:%22RecordType%22,%22values%22:%5B%22Other%22,%22Recurring%22,%22DiscountedUsage%22,%22SavingsPlanCoveredUsage%22,%22SavingsPlanNegation%22,%22SavingsPlanRecurringFee%22,%22SavingsPlanUpfrontFee%22,%22Support%22,%22Upfront%22,%22Usage%22%5D,%22include%22:true,%22children%22:null%7D%5D&reportType=CostUsage&hasAmortized=false&excludeDiscounts=true&usageAs=usageQuantity&excludeCategorizedResources=false&excludeForecast=false)

Amortized Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=LinkedAccount&forecastTimeRangeOption=None&hasBlended=false&excludeRefund=false&excludeCredit=false&excludeRIUpfrontFees=false&excludeRIRecurringCharges=false&excludeOtherSubscriptionCosts=false&excludeSupportCharges=false&excludeTax=false&excludeTaggedResources=false&chartStyle=Stack&timeRangeOption=Last12Months&granularity=Monthly&isTemplate=true&filter=%5B%7B%22dimension%22:%22UsageType%22,%22values%22:%5B%7B%22value%22:%22Route53-Domains%22,%22unit%22:%22Quantity%22%7D%5D,%22include%22:false,%22children%22:null%7D,%7B%22dimension%22:%22RecordType%22,%22values%22:%5B%22Other%22,%22Recurring%22,%22DiscountedUsage%22,%22SavingsPlanCoveredUsage%22,%22SavingsPlanNegation%22,%22SavingsPlanRecurringFee%22,%22SavingsPlanUpfrontFee%22,%22Support%22,%22Upfront%22,%22Usage%22%5D,%22include%22:true,%22children%22:null%7D%5D&reportType=CostUsage&hasAmortized=true&excludeDiscounts=true&usageAs=usageQuantity&excludeCategorizedResources=false&excludeForecast=false)

#### Download SQL File:
[Link to file](/Cost/300_CUR_Queries/Code/Global/spendaccount.sql)

#### Copy Query
```tsql
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') AS month_line_item_usage_start_date, 
      SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost,
      SUM(CASE
        WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost 
        WHEN (line_item_line_item_type = 'SavingsPlanRecurringFee') THEN (savings_plan_total_commitment_to_date - savings_plan_used_commitment) 
        WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN 0
        WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN 0
        WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost  
        WHEN (line_item_line_item_type = 'RIFee') THEN (reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee)
        WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN 0 
        ELSE line_item_unblended_cost 
      END) AS amortized_cost,
      (SUM(line_item_unblended_cost)
        - SUM(CASE
          WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost 
          WHEN (line_item_line_item_type = 'SavingsPlanRecurringFee') THEN (savings_plan_total_commitment_to_date - savings_plan_used_commitment) 
          WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN 0
          WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN 0
          WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost  
          WHEN (line_item_line_item_type = 'RIFee') THEN (reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee)
          WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN 0 
          ELSE line_item_unblended_cost 
        END)
      ) AS ri_sp_trueup, 
      SUM(CASE
        WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN line_item_unblended_cost
        WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN line_item_unblended_cost 
        ELSE 0 
      END) AS ri_sp_upfront_fees
    FROM
      ${table_name}
    WHERE
      ${date_filter}
      AND line_item_usage_type != 'Route53-Domains'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage','SavingsPlanNegation','SavingsPlanRecurringFee','SavingsPlanUpfrontFee','RIFee','Fee')
    GROUP BY 
      bill_payer_account_id,
      line_item_usage_account_id,
      3
    ORDER BY
      month_line_item_usage_start_date ASC,
      sum_line_item_unblended_cost DESC;
```

{{< email_button category_text="Global" service_text="AWS Account" query_text="Global - Account" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)


### Region

#### Query Description
This query will provide monthly unblended and amortized costs per linked account for all services by region where the service is operating.  The query includes ri_sp_trueup and ri_sp_upfront_fees columns to allow you to visualize the difference between unblended and amortized costs.  Unblended cost equals usage plus upfront fees.  Amortized cost equals usage plus the portion of upfront fees applicable to the period (both used and unused). True-up therefore represents the difference between total upfront fees incurred in the period using an unblended/cash-based accounting model, and the smaller portion of upfront fees applicable to the period using an amortized/accrual-based accounting model. This query excludes discounts, credits, refunds and taxes, as well as Route 53 Domains usage type due to differences in how usage date is recorded between Cost Explorer and CUR. 

**Notes:** 
* Charges for the current billing month may differ slightly when comparing between Cost Explorer and CUR due to differences in how [current month charges are estimated](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html#how-cur-works). Charges will match between Cost Explorer and CUR once billing has been finalized at the close of the month.

* This query expects that you have reserved instances purchased within at least one of the accounts.  Running this query as is without reserved instances in the CUR data set will result in an error. To use this query without reserved instances, remove or comment out lines containing `reservation_reservation_a_r_n`.

#### Pricing

Please refer to the [AWS pricing page](https://aws.amazon.com/pricing/).

#### Cost Explorer Links
These links are provided as an example to compare CUR report output to Cost Explorer output.

Unblended Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=Region&forecastTimeRangeOption=None&hasBlended=false&excludeRefund=false&excludeCredit=false&excludeRIUpfrontFees=false&excludeRIRecurringCharges=false&excludeOtherSubscriptionCosts=false&excludeSupportCharges=false&excludeTax=false&excludeTaggedResources=false&chartStyle=Stack&timeRangeOption=Last12Months&granularity=Monthly&isTemplate=true&filter=%5B%7B%22dimension%22:%22UsageType%22,%22values%22:%5B%7B%22value%22:%22Route53-Domains%22,%22unit%22:%22Quantity%22%7D%5D,%22include%22:false,%22children%22:null%7D,%7B%22dimension%22:%22RecordType%22,%22values%22:%5B%22Other%22,%22Recurring%22,%22DiscountedUsage%22,%22SavingsPlanCoveredUsage%22,%22SavingsPlanNegation%22,%22SavingsPlanRecurringFee%22,%22SavingsPlanUpfrontFee%22,%22Support%22,%22Upfront%22,%22Usage%22%5D,%22include%22:true,%22children%22:null%7D%5D&reportType=CostUsage&hasAmortized=false&excludeDiscounts=true&usageAs=usageQuantity&excludeCategorizedResources=false&excludeForecast=false)

Amortized Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=Region&forecastTimeRangeOption=None&hasBlended=false&excludeRefund=false&excludeCredit=false&excludeRIUpfrontFees=false&excludeRIRecurringCharges=false&excludeOtherSubscriptionCosts=false&excludeSupportCharges=false&excludeTax=false&excludeTaggedResources=false&chartStyle=Stack&timeRangeOption=Last12Months&granularity=Monthly&isTemplate=true&filter=%5B%7B%22dimension%22:%22UsageType%22,%22values%22:%5B%7B%22value%22:%22Route53-Domains%22,%22unit%22:%22Quantity%22%7D%5D,%22include%22:false,%22children%22:null%7D,%7B%22dimension%22:%22RecordType%22,%22values%22:%5B%22Other%22,%22Recurring%22,%22DiscountedUsage%22,%22SavingsPlanCoveredUsage%22,%22SavingsPlanNegation%22,%22SavingsPlanRecurringFee%22,%22SavingsPlanUpfrontFee%22,%22Support%22,%22Upfront%22,%22Usage%22%5D,%22include%22:true,%22children%22:null%7D%5D&reportType=CostUsage&hasAmortized=true&excludeDiscounts=true&usageAs=usageQuantity&excludeCategorizedResources=false&excludeForecast=false)

#### Download SQL File:                                                                                                
[Link to file](/Cost/300_CUR_Queries/Code/Global/spendregion.sql)                                                                                                                       

#### Copy Query   
```tsql             
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') AS month_line_item_usage_start_date,
      CASE product_region
        WHEN NULL THEN 'Global'
        WHEN '' THEN 'Global'
        WHEN 'global' THEN 'Global'
        ELSE product_region
      END AS product_region,
      SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost,
      SUM(CASE
        WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost 
        WHEN (line_item_line_item_type = 'SavingsPlanRecurringFee') THEN (savings_plan_total_commitment_to_date - savings_plan_used_commitment) 
        WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN 0
        WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN 0
        WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost  
        WHEN (line_item_line_item_type = 'RIFee') THEN (reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee)
        WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN 0 
        ELSE line_item_unblended_cost 
      END) AS amortized_cost,
      (SUM(line_item_unblended_cost)
        - SUM(CASE
          WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost 
          WHEN (line_item_line_item_type = 'SavingsPlanRecurringFee') THEN (savings_plan_total_commitment_to_date - savings_plan_used_commitment) 
          WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN 0
          WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN 0
          WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost  
          WHEN (line_item_line_item_type = 'RIFee') THEN (reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee)
          WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN 0 
          ELSE line_item_unblended_cost 
        END)
      ) AS ri_sp_trueup, 
      SUM(CASE
        WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN line_item_unblended_cost
        WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN line_item_unblended_cost 
        ELSE 0 
      END) AS ri_sp_upfront_fees
    FROM
      ${table_name}
    WHERE
      ${date_filter}
      AND line_item_usage_type != 'Route53-Domains'
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage','SavingsPlanNegation','SavingsPlanRecurringFee','SavingsPlanUpfrontFee','RIFee','Fee')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      3,
      4;
```


{{< email_button category_text="Global" service_text="AWS Region" query_text="Global - Region" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Service

#### Query Description
This query will provide monthly unblended and amortized costs per linked account for all services by service.  Data Transfer is also broken out for each service.  The query includes ri_sp_trueup and ri_sp_upfront_fees columns to allow you to visualize the difference between unblended and amortized costs.  Unblended cost equals usage plus upfront fees.  Amortized cost equals usage plus the portion of upfront fees applicable to the period (both used and unused). True-up therefore represents the difference between total upfront fees incurred in the period using an unblended/cash-based accounting model, and the smaller portion of upfront fees applicable to the period using an amortized/accrual-based accounting model. This query excludes discounts, credits, refunds and taxes, as well as Route 53 Domains usage type due to differences in how usage date is recorded between Cost Explorer and CUR. 

**Notes:** 
* Charges for the current billing month may differ slightly when comparing between Cost Explorer and CUR due to differences in how [current month charges are estimated](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html#how-cur-works). Charges will match between Cost Explorer and CUR once billing has been finalized at the close of the month.

* This query expects that you have reserved instances purchased within at least one of the accounts.  Running this query as is without reserved instances in the CUR data set will result in an error. To use this query without reserved instances, remove or comment out lines containing `reservation_reservation_a_r_n`.

#### Pricing
Please refer to the [AWS pricing page](https://aws.amazon.com/pricing/).

#### Cost Explorer Links
These links are provided as an example to compare CUR report output to Cost Explorer output.

Unblended Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=Service&forecastTimeRangeOption=None&hasBlended=false&excludeRefund=false&excludeCredit=false&excludeRIUpfrontFees=false&excludeRIRecurringCharges=false&excludeOtherSubscriptionCosts=false&excludeSupportCharges=false&excludeTax=false&excludeTaggedResources=false&chartStyle=Stack&timeRangeOption=Last12Months&granularity=Monthly&isTemplate=true&filter=%5B%7B%22dimension%22:%22UsageType%22,%22values%22:%5B%7B%22value%22:%22Route53-Domains%22,%22unit%22:%22Quantity%22%7D%5D,%22include%22:false,%22children%22:null%7D,%7B%22dimension%22:%22RecordType%22,%22values%22:%5B%22Other%22,%22Recurring%22,%22DiscountedUsage%22,%22SavingsPlanCoveredUsage%22,%22SavingsPlanNegation%22,%22SavingsPlanRecurringFee%22,%22SavingsPlanUpfrontFee%22,%22Support%22,%22Upfront%22,%22Usage%22%5D,%22include%22:true,%22children%22:null%7D%5D&reportType=CostUsage&hasAmortized=false&excludeDiscounts=true&usageAs=usageQuantity&excludeCategorizedResources=false&excludeForecast=false)

Amortized Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=Service&forecastTimeRangeOption=None&hasBlended=false&excludeRefund=false&excludeCredit=false&excludeRIUpfrontFees=false&excludeRIRecurringCharges=false&excludeOtherSubscriptionCosts=false&excludeSupportCharges=false&excludeTax=false&excludeTaggedResources=false&chartStyle=Stack&timeRangeOption=Last12Months&granularity=Monthly&isTemplate=true&filter=%5B%7B%22dimension%22:%22UsageType%22,%22values%22:%5B%7B%22value%22:%22Route53-Domains%22,%22unit%22:%22Quantity%22%7D%5D,%22include%22:false,%22children%22:null%7D,%7B%22dimension%22:%22RecordType%22,%22values%22:%5B%22Other%22,%22Recurring%22,%22DiscountedUsage%22,%22SavingsPlanCoveredUsage%22,%22SavingsPlanNegation%22,%22SavingsPlanRecurringFee%22,%22SavingsPlanUpfrontFee%22,%22Support%22,%22Upfront%22,%22Usage%22%5D,%22include%22:true,%22children%22:null%7D%5D&reportType=CostUsage&hasAmortized=true&excludeDiscounts=true&usageAs=usageQuantity&excludeCategorizedResources=false&excludeForecast=false)

#### Download SQL File:                                                                                                                                       
[Link to file](/Cost/300_CUR_Queries/Code/Global/spendservice.sql)                                                                                    

#### Copy Query 
```tsql               
    SELECT
      bill_payer_account_id,
      line_item_usage_account_id,
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') AS month_line_item_usage_start_date,
      CASE 
        WHEN (line_item_line_item_type = 'Usage' AND product_product_family = 'Data Transfer') THEN CONCAT('DataTransfer-',line_item_product_code) 
        ELSE line_item_product_code 
      END AS service_line_item_product_code,
      SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost,
      SUM(CASE
        WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost 
        WHEN (line_item_line_item_type = 'SavingsPlanRecurringFee') THEN (savings_plan_total_commitment_to_date - savings_plan_used_commitment) 
        WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN 0
        WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN 0
        WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost  
        WHEN (line_item_line_item_type = 'RIFee') THEN (reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee)
        WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN 0 
        ELSE line_item_unblended_cost 
      END) AS amortized_cost,
      (SUM(line_item_unblended_cost)
        - SUM(CASE
          WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost 
          WHEN (line_item_line_item_type = 'SavingsPlanRecurringFee') THEN (savings_plan_total_commitment_to_date - savings_plan_used_commitment) 
          WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN 0
          WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN 0
          WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost  
          WHEN (line_item_line_item_type = 'RIFee') THEN (reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee)
          WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN 0 
          ELSE line_item_unblended_cost 
        END)
      ) AS ri_sp_trueup, 
      SUM(CASE
        WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN line_item_unblended_cost
        WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN line_item_unblended_cost
        ELSE 0 
      END) AS ri_sp_upfront_fees
    FROM
      ${table_name}
    WHERE
      ${date_filter}
      AND line_item_usage_type != 'Route53-Domains' 
      AND line_item_line_item_type  IN ('DiscountedUsage', 'Usage', 'SavingsPlanCoveredUsage','SavingsPlanNegation','SavingsPlanRecurringFee','SavingsPlanUpfrontFee','RIFee','Fee')
    GROUP BY
      bill_payer_account_id,
      line_item_usage_account_id,
      3,
      4
    ORDER BY
      month_line_item_usage_start_date ASC,
      sum_line_item_unblended_cost DESC;
```


{{< email_button category_text="Global" service_text="AWS Service" query_text="Global - Service" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Bill Details by Service

#### Query Description
This query will provide a monthly cost summary by AWS Service Charge which is an approximation to the monthly bill in the billing console.

#### Pricing
Please refer to the [AWS pricing page](https://aws.amazon.com/pricing/).

#### Download SQL File:                                                                                                                                       
[Link to file](/Cost/300_CUR_Queries/Code/Global/billservice.sql)                                                                                    

#### Copy Query    
```tsql            
    SELECT 
      DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') AS month_line_item_usage_start_date,
      bill_bill_type,
      CASE
        WHEN (product_product_family = 'Data Transfer') THEN 'Data Transfer' 
        ELSE replace(replace(replace(product_product_name, 'Amazon '),'Amazon'),'AWS ') 
      END AS product_product_name,
      product_location,
      line_item_line_item_description,
      SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost,
      SUM(line_item_usage_amount) AS sum_line_item_usage_amount
    FROM 
      ${table_name}
    WHERE
      ${date_filter}
    GROUP BY 
      1,
      bill_bill_type,
      3,
      product_location,
      line_item_line_item_description
    HAVING SUM(line_item_usage_amount) > 0
    ORDER BY 
      month_line_item_usage_start_date,
      bill_bill_type,
      product_product_name,
      product_location,
      line_item_line_item_description;
```

{{< email_button category_text="Global" service_text="AWS Bill" query_text="Global - Bill" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Premium Support Chargeback by Accounts

#### Query Description
This query will provide a monthly individual account chargeback for the premium support cost based on its contribution to overall AWS bill. This query computes the total monthly aws bill (without tax and support charges) and then calculates just the support charges. Based on the Individual accounts usage/spend percentage, its equivalent support fee is computed.

#### Pricing
Please refer to the [AWS pricing page](https://aws.amazon.com/pricing/).

#### Download SQL File:                                                                                                                                       
[Link to file](/Cost/300_CUR_Queries/Code/Global/premiumsupport.sql)                                                                                    

#### Copy Query    
```tsql            
    SELECT bill_payer_account_id,
      line_item_usage_account_id,
      SUM(line_item_unblended_cost) AS sum_line_item_unblended_cost,
      ROUND(total_support_cost *((SUM(line_item_unblended_cost)/total_cost)),2) AS support_cost,
      ROUND(SUM(line_item_unblended_cost)/total_cost*100,
      2) AS percentage_of_total_cost,
      ${table_name}.year,
      ${table_name}.month
    FROM ${table_name}
    RIGHT JOIN -- Total AWS bill without support    
      (SELECT SUM(line_item_unblended_cost) AS total_cost,
         year,
         month
       FROM ${table_name}
       WHERE line_item_line_item_type <> 'Tax'
         AND line_item_product_code <> 'OCBPremiumSupport'
       GROUP BY
         year, 
         month) AS aws_total_without_support
    ON (${table_name}.year = aws_total_without_support.year AND ${table_name}.month = aws_total_without_support.month)
    RIGHT JOIN -- Total support    
      (SELECT SUM(line_item_unblended_cost) AS total_support_cost,
         year,
         month
       FROM ${table_name}
       WHERE line_item_product_code = 'OCBPremiumSupport'
         AND line_item_line_item_type <> 'Tax'
       GROUP BY  year, month ) AS aws_support
    ON (${table_name}.year=aws_support.year AND ${table_name}.month = aws_support.month)
    WHERE line_item_line_item_type <> 'Tax'
      AND line_item_product_code <> 'OCBPremiumSupport'
      AND ${table_name}.year = '2020' AND (${table_name}.month BETWEEN '7' AND '9' OR ${table_name}.month BETWEEN '07' AND '09') 
    GROUP BY  
      bill_payer_account_id, 
      total_support_cost, 
      total_cost, 
      ${table_name}.year, 
      ${table_name}.month, 
      line_item_usage_account_id
    ORDER BY  
      support_cost DESC;
```

{{< email_button category_text="Global" service_text="AWS Premium Support" query_text="Global - AWS Premium Support" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Cost by Charge type

#### Query Description
This query will aggregate charge types for one or more payers.  For more information on various charge types please reference our [Cost Explorer documentation](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/ce-filtering.html).  This query will replicate Cost Explorer results when filtering by charge type in the cost explore filters as shown below.

![Images/cost-explorer-charge-type-view.png](/Cost/300_CUR_Queries/Images/Global/cost-explorer-charge-type-view.png)

In order to obtain more granular data, try adding the column 'line_item_line_item_description' into the SELECT and Group By Sections (see example #2). 

**Note:** This query expects that you have reserved instances purchased within at least one of the accounts.  This query will not run correctly without reserved instances within the CUR data set.

#### Pricing
N/A

#### Download SQL File:                                                                                                                                       
[Link to file](/Cost/300_CUR_Queries/Code/Global/unblended_cost_by_charge_type.sql)                                                                                    

#### Query Preview:   
Example 1: 
```tsql            
    SELECT bill_payer_account_id,
        CASE 
          WHEN (line_item_line_item_type = 'Fee' AND product_product_name = 'AWS Premium Support') THEN 'Support fee'
          WHEN (line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '') THEN 'Upfront reservation fee'
          ELSE line_item_line_item_type 
        END charge_type,
        round(sum(line_item_unblended_cost),2) sum_unblended_cost
    FROM 
      ${table_name}
    WHERE 
      ${date_filter}
    GROUP BY 
      bill_payer_account_id,
      2 -- reference to charge_type case statement
    ORDER BY 
      sum_unblended_cost DESC
    ;    
```
Example 2:
```tsql            
    SELECT bill_payer_account_id, 
        CASE 
          WHEN (line_item_line_item_type = 'Fee' AND product_product_name = 'AWS Premium Support') THEN 'Support fee'
          WHEN (line_item_line_item_type = 'Fee' AND reservation_reservation_a_r_n <> '') THEN 'Upfront reservation fee'
          ELSE line_item_line_item_type 
        END charge_type,
        line_item_line_item_description,
        round(sum(line_item_unblended_cost),2) sum_unblended_cost
    FROM 
      ${table_name}
    WHERE 
      ${date_filter}
    GROUP BY 
      bill_payer_account_id,
      2, -- reference to charge_type case statement
      line_item_line_item_description
    ORDER BY 
      sum_unblended_cost DESC
    ;    
```

{{< email_button category_text="Global" service_text="Unblended Cost by Charge Type" query_text="Global - Unblended Cost by Charge Type" button_text="Help & Feedback" >}}

### Serverless Product Spend

#### Query Description
This query will provide monthly unblended cost for all [Serverless products](https://aws.amazon.com/serverless/) in use across all regions.  This query is helpful in tracking Serverless product adoption as application teams modernize their applications.  You can expand the query to include line_item_usage_account_id to show individual service charges per linked account.  This query helps provide a view that is difficult to achieve within Cost Explorer.  

#### Pricing
* [AWS Lambda pricing page](https://aws.amazon.com/lambda/pricing/)
* [AWS Fargate pricing page](https://aws.amazon.com/fargate/pricing/)
* [Amazon EventBridge pricing page](https://aws.amazon.com/eventbridge/pricing/)
* [AWS Step Functions pricing page](https://aws.amazon.com/step-functions/pricing/)
* [Amazon SQS pricing page](https://aws.amazon.com/sqs/pricing/)
* [Amazon SNS pricing page](https://aws.amazon.com/sns/pricing/)
* [Amazon API Gateway pricing page](https://aws.amazon.com/api-gateway/pricing/)
* [AWS AppSync pricing page](https://aws.amazon.com/appsync/pricing/)
* [Amazon S3 pricing page](https://aws.amazon.com/s3/pricing/)
* [Amazon DynamoDB pricing page](https://aws.amazon.com/dynamodb/pricing/)
* [Amazon RDS Proxy pricing page](https://aws.amazon.com/rds/proxy/pricing)
* [Amazon Aurora pricing page](https://aws.amazon.com/rds/aurora/pricing/)

#### Download SQL File:                                                                                                                                       
[Link to file](/Cost/300_CUR_Queries/Code/Global/serverless.sql)                                                                                    

#### Query Preview:   
```tsql            
SELECT
  bill_payer_account_id,
  -- if uncommenting, also uncomment three other occurrences of line_item_usage_account_id:
  -- two in SELECTs that are UNIONed and one in GROUP BY or ^F.
  -- line_item_usage_account_id,
  month_line_item_usage_start_date,
  line_item_product_code,
  split_line_item_usage_type,
  SUM(CAST(line_item_usage_amount AS double)) AS sum_line_item_usage_amount,
  SUM(CAST(line_item_unblended_cost AS decimal(16,8))) AS sum_line_item_unblended_cost
FROM (

  SELECT
    bill_payer_account_id,
    -- line_item_usage_account_id,
    DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
    line_item_product_code,
    CASE REGEXP_REPLACE(SPLIT_PART(line_item_usage_type, ':', 1), '^[^-]*-')
      WHEN 'Fargate-GB-Hours' THEN 'Fargate'
      WHEN 'Fargate-vCPU-Hours' THEN 'Fargate'
      WHEN 'SpotUsage-Fargate-GB-Hours' THEN 'Fargate'
      WHEN 'SpotUsage-Fargate-vCPU-Hours' THEN 'Fargate'
      ELSE '--'    -- should not be reached!
    END AS split_line_item_usage_type,
    line_item_usage_amount,
    line_item_unblended_cost,
    year,
    month
  FROM ${table_name}
  WHERE
    (
      line_item_line_item_type IN ('DiscountedUsage',
                                   'Usage',
                                   'Credit',
                                   'RIFee',
                                   'SavingsPlanCoveredUsage',
                                   'SavingsPlanNegation')
    )
    AND
    (
      line_item_usage_type LIKE '%Fargate%' AND
      line_item_product_code IN ('AmazonECS', 'AmazonEKS')
    )

  UNION ALL

  SELECT
    bill_payer_account_id,
    -- line_item_usage_account_id,
    DATE_FORMAT(line_item_usage_start_date,'%Y-%m') AS month_line_item_usage_start_date,
    line_item_product_code,
    CASE SPLIT_PART(line_item_usage_type, ':', 2)
      WHEN 'ProxyUsage' THEN 'RDS Proxy Usage'
      WHEN 'ServerlessUsage' THEN 'Aurora Serverless'
      ELSE '--'
    END AS split_line_item_usage_type,
    line_item_usage_amount,
    line_item_unblended_cost,
    year,
    month
  FROM ${table_name}
  WHERE
    (
      line_item_line_item_type IN ('DiscountedUsage',
                                   'Usage',
                                   'Credit',
                                   'RIFee',
                                   'SavingsPlanCoveredUsage',
                                   'SavingsPlanNegation')
    )
    AND
    (
      (
        line_item_product_code = 'AmazonRDS' AND
        SPLIT_PART(line_item_usage_type, ':', 2) IN ('ServerlessUsage', 'ProxyUsage')
      )
      OR
      (
        line_item_product_code IN ('AmazonDynamoDB', 'AmazonDAX',
                                   'AmazonS3', 'AWSAppSync',
                                   'AmazonApiGateway',
                                   'Amazon Simple Notification Service',
                                   'AWSQueueService', 'AWSLambda',
                                   'AWSEvents'
                                  )
      )
    )
)

WHERE
  ${date_filter}
GROUP BY
  bill_payer_account_id,
  -- line_item_usage_account_id,
  month_line_item_usage_start_date,
  line_item_product_code,
  split_line_item_usage_type

ORDER BY
  month_line_item_usage_start_date,
  line_item_product_code,
  split_line_item_usage_type
```

{{< email_button category_text="Global" service_text="Serverless" query_text="Global - Serverless Product Spend" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

### Amortized Cost By Charge Type

#### Query Description
This query provides amortized cost by charge type for a given month. The output includes payer account ID, the month, charge types and the amortized cost for the charge type. It closely matches Cost Explorer result when "show costs as" amortized cost is selected under the advanced options and grouped by charge type.

#### Pricing
Please refer to the [AWS pricing page](https://aws.amazon.com/pricing/).

Choosing advanced options Cost Explorer documentation - [Link](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/ce-advanced.html)

#### Cost Explorer Links
These links are provided as an example to compare CUR report output to Cost Explorer output.

Amortized Cost [Link](https://console.aws.amazon.com/cost-management/home?#/custom?groupBy=RecordType&hasBlended=false&hasAmortized=true&excludeDiscounts=true&excludeTaggedResources=false&excludeCategorizedResources=false&excludeForecast=false&timeRangeOption=Last6Months&granularity=Monthly&reportName=&reportType=CostUsage&isTemplate=true&filter=%5B%5D&chartStyle=Stack&forecastTimeRangeOption=None&usageAs=usageQuantity)

#### Download SQL File:
[Link to file](/Cost/300_CUR_Queries/Code/Global/amortized_cost_by_charge_type.sql)

#### Query Preview:  
```tsql  
SELECT 
  bill_payer_account_id,
  CASE 
      WHEN (line_item_line_item_type = 'Fee' AND product_product_name = 'AWS Premium Support') THEN 'Support fee'
      WHEN (line_item_line_item_type = 'Fee' AND bill_billing_entity <> 'AWS') THEN 'Marketplace fee'
	  WHEN (line_item_line_item_type = 'DiscountedUsage') THEN 'Reservation applied usage'
      ELSE line_item_line_item_type 
    END charge_type,
  DATE_FORMAT((line_item_usage_start_date),'%Y-%m') AS month_line_item_usage_start_date
  , 
  round(sum(CASE
      WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost
      WHEN (line_item_line_item_type = 'SavingsPlanRecurringFee') THEN round((savings_plan_total_commitment_to_date - savings_plan_used_commitment),8)
      WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN 0
      WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN 0
      WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost  
      WHEN (line_item_line_item_type = 'RIFee') THEN (reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee)
      WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN 0 ELSE line_item_unblended_cost END),2) sum_amortized_cost
FROM 
  ${table_name} 
WHERE 
  ${date_filter} 
GROUP BY 
  bill_payer_account_id,
  2, -- month_line_item_usage_start_date
  3 -- sum_amortized_cost
ORDER BY 
  sum_amortized_cost DESC
  ;
```

{{< email_button category_text="Global" service_text="Global" query_text="Global - Amortized by charge type" button_text="Help & Feedback" >}}

[Back to Table of Contents](#table-of-contents)

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}
