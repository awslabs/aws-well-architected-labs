---
title: CUR Query Library Help
weight: 19
---

The CUR Query Library Help section is intended to provide tips and information about navigating the CUR dataset.  We will cover beginner topics like getting started with querying the CUR, filtering query results, common query format, links to public documentation, and getting product information.  We will also cover advanced topics like understanding your AWS Cost Datasets while working with the CUR data.  

{{% notice tip %}}
Use the clipboard in the top right of the text boxes below to copy all of the text to be pasted.  
{{% /notice %}}

{{% notice info %}}
CUR Query Library uses placeholder variables, indicated by a dollar sign and curly braces (**${  }**). **${table_name}** and **${date_filter}** are common placeholder variables used throughout CUR Query Library, which must be replaced before a query will run. For example, if your CUR table is called **cur_table** and is in a database called **cur_db**, you would replace **${table_name}** with **cur_db.cur_table**. For **${date_filter}**, you have multiple options. See [Filtering by Date]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help#filtering-by-date" >}}) in the CUR Query Library Help section for additional details.
{{% /notice %}}

### Table of Contents
  * [Documentation Links](#documentation-links)
  * [Filtering Query Results](#filtering-query-results)
    * [Filtering by Date: ${date_filter}](#filtering-by-date)
  * [Query Format Overview](#query-format-overview)
    * [Additional Functions](#additional-functions)
  * [Retrieving Data from CUR](#retrieving-data-from-cur)
  * [Understanding Cost Data](#understanding-cost-data)
    * [AWS Product Descriptions and Pricing Units](#aws-product-descriptions-and-pricing-units)
    * [CUR Table Data with Reserved Instances or Savings Plans](#cur-table-data-with-reserved-instances-or-savings-plans)
    * [Unblended, Blended, Amortized, and Net Costs](#unblended-blended-amortized-and-net-costs)
  * [CUR Query Building]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help/query-building.md" >}})

----  
### Documentation Links
* [Cost and Usage Report Data Dictionary](https://docs.aws.amazon.com/cur/latest/userguide/data-dictionary.html)

* [Cost and Usage Report User Guide](https://docs.aws.amazon.com/cur/latest/userguide/cur-user-guide.pdf)

* [Understanding your AWS Cost Datasets](https://aws.amazon.com/blogs/aws-cost-management/understanding-your-aws-cost-datasets-a-cheat-sheet/)

* [SQL Tutorials](https://www.w3schools.com/sql/)

* [Introduction to Amazon Athena](https://www.aws.training/Details/Video?id=15885)

{{% email_button category_text="Helpers" service_text="Documentation" query_text="Helpful Links -- Please include additional documentation that should be included." button_text="Links Feedback" %}}

----
### Filtering Query Results
Filtering query results allows for precise data retrieval. The WHERE clause is used to extract only those records that fulfill a specified condition. Let's review an example where we match a filtered Cost Explorer view with a CUR query to achieve the same results. 

```tsql
WHERE year = '2020' AND (month BETWEEN '8' AND '10') 
  AND product_product_name = ('AWS Glue') AND line_item_usage_type LIKE '%Crawler%' 
  AND product_region = 'us-east-1' 
  AND line_item_line_item_type NOT IN ('Tax','Credit','Refund')
```
 We will explain what the query filter is doing as well as a screenshot of the equivalent filter in Cost Explorer:
* Time frame to be August to October 2020

![Images/cetime.png](/Cost/300_CUR_Queries/Images/Helpers/cetime.png)

* The Service to be AWS Glue
* The region to be us-east-1
* The usage type to include usage like %Crawler%

![Images/cefilter.png](/Cost/300_CUR_Queries/Images/Helpers/cefilter.png)

* To exclude Charge Types like credit, refund, and tax

![Images/cecharge.png](/Cost/300_CUR_Queries/Images/Helpers/cecharge.png)

You can mimic this example using the following query:

[Link to Code](/Cost/300_CUR_Queries/Code/Analytics/gluewrid.sql)

You can configure Cost Explorer like the below screenshot:

![Images/ce.png](/Cost/300_CUR_Queries/Images/Helpers/ce.png)

In Usage Type, type **Crawler** and select all region-Crawler-DPU-Hour entries. 

You should now be able to align the unblended cost for AWS Glue using both CUR and Cost Explorer.  This is a common approach used to validate your CUR query is working as expected. 

----
#### Filtering by Date
Using SQL to filter Cost and Usage data by date can be done in a variety of ways. Throughout CUR Query Library, the placeholder variable **${date_filter}** is used to indicate where you should insert the date filter of your choice. A few date filtering examples are provided below. These examples are not exhaustive, and there are other approaches you may consider. 

Notes: 
* Athena tables created using the [CUR Athena integration](https://docs.aws.amazon.com/cur/latest/userguide/cur-query-athena.html) have, and are partioned by, **month** and **year** columns. Queries with date filters that use these columns will only scan table data from the relevant partitions, resulting in faster queries as well as lower cost, since Athena usage is billed based on quantity of data scanned.
* When using the **month** column, be aware a single-digit month is used in some cases, for example '1' for January, '2' for February, etc. In other cases, a two-digit month with leading '0' is used. For example, '01' for January, '02' for February, etc. To determine which format you have stored in your table, you can use the simple query: `SELECT DISTINCT(month) FROM ${table_name}`
* Two additional columns with date data useful for filtering are [bill_billing_period_start_date](https://docs.aws.amazon.com/cur/latest/userguide/billing-columns.html#billing-details-B-BillingPeriodStartDate) and [line_item_usage_start_date.](https://docs.aws.amazon.com/cur/latest/userguide/Lineitem-columns.html#Lineitem-details-U-UsageStartDate) **bill_billing_period_start_date** can be a good choice when you want monthly granularity in your reports. **line_item_usage_start_date** can be a good choice when you want daily or hourly granularity in your reports. 
* Throughout CUR Query Library, the [**DATE_FORMAT()**](https://prestodb.io/docs/current/functions/datetime.html?highlight=DATE_FORMAT#DATE_FORMAT) function is often used to format the **line_item_usage_start_date** column. The **DATE_FORMAT()** function should not be confused with the **${date_filter}** placeholder variable discussed here.

#### Filtering by Date with Columns **month** and **year** 
**Example: Full Year (January 1, 2020 12:00:00AM - December 31, 2020 11:59:59PM)**
```tsql
WHERE year = '2020'
```

**Example: Single Month (July 1, 2020 12:00:00AM - July 31, 2020 11:59:59PM)**
```tsql
WHERE year = '2020' 
  AND month = '7'
```

**Example: 3 Months Using BETWEEN (July 1, 2020 12:00:00AM - September 30, 2020 11:59:59PM)**
```tsql
WHERE year = '2020' 
  AND month BETWEEN '7' AND '9'
```

**Example: 3 Months Using IN (July 1, 2020 12:00:00AM - September 30, 2020 11:59:59PM)**
```tsql
WHERE year = '2020' 
  AND month IN ('7','8','9')
```

**Example: 3 Months Using Greater Than/Less Than (July 1, 2020 12:00:00AM - September 30, 2020 11:59:59PM)**
```tsql
WHERE year = '2020' 
  AND (month >= '7' AND < '10')
```

**Example: Month Range Crossing End of Calendar Year (November 1, 2020 12:00:00AM - February 28, 2021 11:59:59PM)**  
Note: due to year and month being stored in separate columns, `OR` is required to deal with date ranges crossing the end of a calendar year.

```tsql
WHERE (year = '2020' 
    AND month BETWEEN '11' AND '12') 
  OR (year = '2021' 
    AND month BETWEEN '1' AND '2')
```
**Example: Two Non-Contiguous Months (January 1, 2020 12:00:00AM - January 31, 2020 11:59:59PM & January 1, 2021 12:00:00AM - January 31, 2021 11:59:59PM)**
```tsql
WHERE (year = '2020' AND month = '1')
  AND (year = '2021' AND month = '1')
```

**Example: Two Non-Contiguous Month Ranges (January 1, 2020 12:00:00AM - March 31, 2020 11:59:59PM & January 1, 2021 12:00:00AM - March 31, 2021 11:59:59PM)**
```tsql
WHERE (year = '2020' AND month IN ('1','2','3'))
  AND (year = '2021' AND month IN ('1','2','3'))
```

#### Date Filtering with Columns **line_item_usage_start_date** and **bill_billing_period_start_date**
**bill_billing_period_start_date** and **line_item_usage_start_date** are typically stored as timestamps. In order to use these columns with comparison functions and operators, for example "all dates after (greater than) January 1, 2021" or "all dates within the past two weeks," strings must be converted to timestamps. This can be accomplished with functions such as [**FROM_ISO8601_TIMESTAMP(),**](https://prestodb.io/docs/current/functions/datetime.html?highlight=FROM_ISO8601_TIMESTAMP#FROM_ISO8601_TIMESTAMP) which parses an ISO 8601 formatted string into a timestamp with time zone, or [**CAST(),**](https://prestodb.io/docs/current/functions/conversion.html?highlight=cast#cast) which explicitly casts a value as another type. Additional date and time operators can be found in [Presto SQL documentation.](https://prestodb.io/docs/current/functions/datetime.html) 

**Example: Arbitrary Date/Time Range Using BETWEEN and FROM_ISO8601_TIMESTAMP() (July 1, 2020 12:00:00AM - July 8, 2020 01:23:45AM)** 
```tsql
WHERE line_item_usage_start_date BETWEEN FROM_ISO8601_TIMESTAMP('2020-07-01T00:00:00') AND FROM_ISO8601_TIMESTAMP('2020-07-08T01:23:45')
```

**Example: Arbitrary Date/Time Range Using Greater Than/Less Than and CAST() (July 1, 2020 12:00:00AM - July 8, 2020 01:23:45AM)** 
```tsql
WHERE line_item_usage_start_date >= CAST('2020-07-01 00:00:00' AS TIMESTAMP) 
  AND line_item_usage_start_date < CAST('2020-07-08 01:23:45' AS TIMESTAMP)
```

**Example: Arbitrary Date/Time until Present (July 8, 2020 01:23:45AM - Present)**
```tsql
WHERE line_item_usage_start_date >= FROM_ISO8601_TIMESTAMP('2020-07-01T01:23:45')
```

**Example: Previous 3 Months Before Now**  
Note: 'month' in this example is part of the [**INTERVAL**](https://prestodb.io/docs/current/functions/datetime.html?highlight=interval#interval-functions) function and should not be confused with the **month** column.
```tsql
WHERE line_item_usage_start_date >= now() - INTERVAL '3' month
```

**Example: 6 Months After an Arbitrary Date/Time (October 5, 2020 01:23:45AM - March 5, 2021 01:23:45AM)**  
Note: 'month' in this example is part of the [**INTERVAL**](https://prestodb.io/docs/current/functions/datetime.html?highlight=interval#interval-functions) function and should not be confused with the **month** column. 
```tsql
WHERE line_item_usage_start_date >= CAST('2020-10-05 01:23:45' AS TIMESTAMP) 
  AND line_item_usage_start_date < CAST('2020-10-05 01:23:45' AS TIMESTAMP) + INTERVAL '6' month 
```
{{% email_button category_text="Helpers" service_text="Compute" query_text="Filtering Query Results" button_text="Help & Feedback" %}}

----
### Query Format Overview

Below is an overview of the key elements of an Athena Query.

The **SELECT** statement is used to select data you require and the **FROM** specifies which table from which database.

Each column from the data you would like returned is placed between the SELECT and the FROM separated by a comma.

The **AS** command is used to rename a column or table with an alias.

The **WHERE** clause is used to filter records. The WHERE clause is used to extract only those records that fulfil a specified condition. For example
<em>WHERE year = '2020'</em>

The **GROUP BY** clause divides the output of a SELECT statement into groups of rows containing matching values. A simple GROUP BY clause may contain any expression composed of input columns or it may be an ordinal number selecting an output column by position (starting at one).

The **ORDER BY** clause is used to sort a result set by one or more output expressions. These can be ascending **ASC** or descending **DESC**.

----
#### Additional Functions

The **CASE** statement goes through conditions and returns a value when the first condition is met (like an IF-THEN-ELSE statement). So, once a condition is true, it will stop reading and return the result. If no conditions are true, it returns the value in the ELSE clause. 

We may use this to add information to the Athena query based on what results we get back. The example below shows how we have added the Spot Instance item into the data if there is nothing in the pricing term column. 
```tsql
    CASE pricing_term 
        WHEN 'Reserved' THEN 'Reserved Instance'
        WHEN 'OnDemand' THEN 'OnDemand'
        WHEN '' THEN 'Spot Instance'
        ELSE 'Other'
    END AS Reservation
```

The **CAST()** function converts a value (of any type) into a specified datatype. This is often use to change a column that's is a **Double** to a **Decimal**. This is because a Double is used for binary and DECIMAL floating-point arithmetic whereas a Decimal is more useful for financial reporting. You can see this in the example below.
```tsql
    CAST(line_item_unblended_cost AS DECIMAL(16,8))
```

The **SUM()** function returns the total sum of a numeric column. This is often used to calculate the total spend on a service to give you a complete total.
```tsql
    SUM(CAST(line_item_unblended_cost AS DECIMAL(16,8)))
```

The **ROUND()** function rounds a number to a specified number of DECIMAL places.


{{% notice note %}}
If you would like to learn more about SQL Queries we recommend using https://www.w3schools.com/sql/ and for Athena specific https://prestodb.io/docs/current/ 
{{% /notice %}}

----
### Retrieving Data from CUR

We will learn how to find out what data is available for querying in the CUR files, this will show what columns there are.Let's discuss a couple common examples when exploring the CUR dataset. 

#### Example 1 - Answers the question "What are all the columns and data in the CUR table?"
```tsql
        SELECT *
        FROM ${table_name}
        LIMIT 10; 
```

This is helpful when trying to understand what data is available in the CUR. Use the CSV Export functionality in Athena to obtain a copy of the query results making it is easier to see all of the columns and data.

If you are interested in just the column name, you can use the [DDL statement: SHOW TABLES IN $your table name](https://docs.aws.amazon.com/athena/latest/ug/language-reference.html). 

#### Example 2 - Answers the question of "What are all the columns from the CUR, where a specific value is in the column?"
```tsql
        SELECT * 
        FROM ${table_name}
        WHERE line_item_line_item_type LIKE '%Usage%'
        LIMIT 10; 
```

This is a helpful technique when searching for a particular Charge Type. Take note that the column values are case sensitive.

#### Example 3 - Answers the question "What services are available in my CUR?"
```tsql
        SELECT DISTINCT(line_item_product_code)
        FROM ${table_name}
        LIMIT 10;
```

This query shows the available services within your CUR. The SELECT DISTINCT statement is helpful when looking for unique values in a specific column. 

The column product_product_name contains similar information and would be a better choice for querying if you are looking for third party marketplace products since line_item_product_code provides a unique id. Be advised that when using the column product_product_name certain line_item_line_item_type's (such as discounts) do not populate this column.

#### Example 4 - Answers the question "What billing periods are available?"
```tsql
        SELECT DISTINCT(bill_billing_period_start_date)
        FROM ${table_name}
        LIMIT 10;
```

Additional helpful getting started queries can be found in the in [200 level Cost and Usage Analysis Lab](https://wellarchitectedlabs.com/cost/200_labs/200_4_cost_and_usage_analysis/3_cur_analysis/).

{{% email_button category_text="Helpers" service_text="Retrieving Data from CUR" query_text="Retrieving Data from CUR" button_text="Help & Feedback" %}}

----
### Understanding Cost Data

#### AWS Product Descriptions and Pricing Units

##### Query Description
This query will provide AWS Product Descriptions and Pricing Units including Product Name, Product Family, and Operations. This query is intended to be used to help you understand the data published in the CUR and assist in query development. 

##### Pricing
Please refer to the [AWS pricing page](https://aws.amazon.com/pricing/) for any service you are interested in.

##### Sample Output
![Images/productdescriptions.png](/Cost/300_CUR_Queries/Images/Helpers/productdescriptions.png)

##### Download SQL File
[Link to Code](/Cost/300_CUR_Queries/Code/Helpers/productdescriptions.sql)

##### Copy Query
```tsql
    SELECT
        product_product_name,
        product_product_family,
        line_item_operation,
        pricing_unit,
        product_description,
        product_usage_family
    FROM
        ${tableName}
    WHERE
        line_item_line_item_type = 'Usage'
    GROUP BY
        product_product_name,
        product_product_family,
        line_item_operation,
        pricing_unit,
        product_description,
        product_usage_family
    ORDER BY
        product_product_name,
        product_product_family,
        line_item_operation,
        pricing_unit,
        product_description,
        product_usage_family;
```

{{% email_button category_text="Helpers" service_text="Product" query_text="AWS Product Descriptions and Pricing Units" button_text="Help & Feedback" %}}

----
#### CUR Table Data with Reserved Instances or Savings Plans
In CUR many columns are dynamic, and their visibility in Cost and Usage Reports depends on the usage of product in the billing period. [6]  You will need to adjust your queries for RIs and SPs depending on your purchase of these products during the billing period that you are querying.

##### Reserved Instances - Unblended
You can use the following columns to understand the unblended costs of your RIs for the billing period. The values for these columns appear for RI line items with reservation_reservation_a_r_n filled in.  Note: When trying to calculate amortized total costs, lineItem/UnblendedCost should be removed for "Fee" line items.

    lineItem/UnblendedCost
     - CUR Column: line_item_unblended_cost
     - Description: Cost on the day that you're charged
     - Operation: Sum/Add
     - Filter: Not needed for Reserved Instances

##### Reserved Instances - Amortized
You can use the following columns to understand the amortized costs of your RIs for the billing period. The values for these columns appear only for RI subscription line items (also known as "RI Fee" line items) and not for the actual instances using the RIs. [7]
Typically you would add these two columns (reservation_unused_recurring_fee and reservation_unused_amortized_upfront_fee_for_billing_period) together, along with reservation_effective_cost documented below, to get the total amortized total costs.  Additionally you will also need to ignore lineItem/UnblendedCost for "Fee" line items.  See the examples at the bottom of this section for additional clarity.

    reservation/unusedRecurringFee 
     - CUR Column: reservation_unused_recurring_fee
     - Description: Initial upfront RI fee amortized for Partial Upfront RIs and No Upfront RIs
     - Operation: Sum/Add
     - Filter: line_item_line_item_type = 'RIFee'

    reservation/unusedAmortizedUpfrontFeeForBillingPeriod
     - CUR Column: reservation_unused_amortized_upfront_fee_for_billing_period
     - Description: Unused portion of Initial upfront RI fee amortized for Partial Upfront RIs and No 
     - Operation: Sum/Add
     - Filter: line_item_line_item_type = 'RIFee'

    lineItem/UnblendedCost
     - CUR Column: line_item_unblended_cost
     - Description: Cost on the day that you're charged [as filtered, this is the upfront RI fee]
     - Operation: Ignore (set to 0 in calculation)
     - Filter: Where reservation_reservation_a_r_n <> '' and line_item_line_item_type = 'Fee'

If you wish to compare unblended costs to amortized costs you can subtract the following reservation_amortized_upfront_fee_for_billing_period and add in the upfront RI fee from the line_item_unblended_cost, ignored right above in the amortized cost calculation.

    reservation/amortizedUpfrontFeeForBillingPeriod 
     - CUR Column: reservation_amortized_upfront_fee_for_billing_period
     - Description: Initial upfront RI fee amortized for All Upfront RIs and Partial Upfront RIs
     - Operation: Sum/Subtract
     - Filter: line_item_line_item_type = 'RIFee'

The values for these columns appear for actual instances using RIs and represent the Discounted Usage (also known as "DiscountedUsage" line items). [8]

    reservation/EffectiveCost
     - CUR Column: reservation_effective_cost
     - Description: The sum of both the upfront and hourly rate of your RI, averaged into an effective hourly rate.
     - Additional Breakdown of this column: reservation_amortized_upfront_cost_for_usage + reservation_recurring_fee_for_usage
     - Operation: Sum/Add
     - Filter: Where line_item_line_item_type = 'DiscountedUsage'

##### Savings Plans - Unblended
You can use the following columns to understand the unblended costs of your SPs for the billing period. The values for these columns appear for SP line items with savings_plan_savings_plan_a_r_n filled in.  When trying to calculate unblended costs, line_item_unblended_cost should be removed for "SavingsPlanNegation" line items. [9]

    lineItem/UnblendedCost
     - CUR Column: line_item_unblended_cost
     - Description: Cost on the day that you're charged
     - Operation: Sum/Add
     - Filter: line_item_line_item_type != 'SavingsPlanNegation'

##### Savings Plans - Amortized
You can use the following columns to understand the amortized costs of your SPs for the billing period. The values for these columns appear only for SP subscription line items (also known as "SavingsPlanCoveredUsage" and "SavingsPlanRecurringFee" line items) and not for the actual instances using the SPs.  For the amortized costs you must also ignore "SavingsPlanNegation" and "SavingsPlanUpfrontFee" line items, these can be used to show you the difference between unblended and amortized costs.

Typically you would add these two columns (savings_plan_savings_plan_effective_cost and savings_plan_total_commitment_to_date) together, and subtract the third (savings_plan_used_commitment). See the examples at the bottom of this section for additional clarity. 

    savingsPlan/SavingsPlanEffectiveCost
     - CUR Column: savings_plan_savings_plan_effective_cost
     - Description: Proportion of the SP monthly commitment amount for Upfront and Recurring
     - Operation: Sum/Add
     - Filter: line_item_line_item_type = 'SavingsPlanCoveredUsage'

    savingsPlan/TotalCommitmentToDate
     - CUR Column: savings_plan_total_commitment_to_date
     - Description: The total amortized upfront commitment and recurring commitment
     - Operation: Sum/Add
     - Filter: line_item_line_item_type = 'SavingsPlanRecurringFee'

    savingsPlan/UsedCommitment
     - CUR Column: savings_plan_used_commitment
     - Description: The total dollar amount of the Savings Plan commitment used
     - Operation: Sum/Subtract
     - Filter: line_item_line_item_type = 'SavingsPlanRecurringFee'

If you wish to compare unblended costs to amortized costs you can subtract the following two columns for AmortizedUpfrontCommitmentForBillingPeriod and the lineItem/UnblendedCost fropm the SavingsPlanNegation line items, and finally add the SavingsPlanUpfrontFee fee from the lineItem/UnblendedCost, ignored above in the amortized cost calculation. [10]

    savingsPlan/AmortizedUpfrontCommitmentForBillingPeriod
     - CUR Column: savings_plan_amortized_upfront_commitment_for_billing_period
     - Description: The amount of upfront fee a Savings Plan subscription is costing you.  Applies to all upfront and partial upfront.
     - Operation: Sum/Subtract
     - Filter: line_item_line_item_type = 'SavingsPlanRecurringFee'

    lineItem/UnblendedCost
     - CUR Column: line_item_unblended_cost
     - Description: Cost on the day that you're charged [as filtered, this is the upfront SP fee]
     - Operation: Sum/Subtract
     - Filter: line_item_line_item_type = 'SavingsPlanNegation'

    lineItem/UnblendedCost
     - CUR Column: line_item_unblended_cost
     - Description: Cost on the day that you're charged [as filtered, this is the Savings Plans discount applied]
     - Operation: Sum/Add
     - Filter: line_item_line_item_type = 'SavingsPlanUpfrontFee'

##### Reserved Instance and Savings Plan Example
The following snippits from the SELECT portion of the SQL query shows you how to put the above documented logic into practical usage.  We will use this same logic across queries where RIs and SPs are used in the CUR query library.  When comparing Cost Explorer unblended costs to your CUR queries, use sum_line_item_unblended_cost.  When comparing Cost Explorer amortized cost to your CUR queries, use amortized_cost.  The ri_sp_trueup and ri_sp_upfront_fees are included in these examples to help you reconcile the difference between unblended and amortized costs.  You will find that sum_line_item_unblended_cost = amortized_cost + ri_sp_trueup + ri_sp_upfront_fees.  We have already taken care of the additions and subtractions in the values, so you can just add them together.

Accounts have both RI and SP usage during the billing period
```tsql
    DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') AS month_line_item_usage_start_date,
    SUM(CASE
      WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN 0 
      ELSE line_item_unblended_cost 
    END) AS sum_line_item_unblended_cost,
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
    SUM(CASE
      WHEN (line_item_line_item_type = 'SavingsPlanRecurringFee') THEN (-savings_plan_amortized_upfront_commitment_for_billing_period)
      WHEN (line_item_line_item_type = 'RIFee') THEN (-reservation_amortized_upfront_fee_for_billing_period)
      WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN (-line_item_unblended_cost) 
      ELSE 0 
    END) AS ri_sp_trueup,
    SUM(CASE
      WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN line_item_unblended_cost
      WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN line_item_unblended_cost 
      ELSE 0 
    END) AS ri_sp_upfront_fees
```
Accounts have SP usage but no RI usage during the billing period
```tsql
    DATE_FORMAT((line_item_usage_start_date),'%Y-%m-01') AS month_line_item_usage_start_date,
    SUM(CASE
      WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN 0 
      ELSE line_item_unblended_cost 
    END) AS sum_line_item_unblended_cost,
    SUM(CASE
      WHEN (line_item_line_item_type = 'SavingsPlanCoveredUsage') THEN savings_plan_savings_plan_effective_cost
      WHEN (line_item_line_item_type = 'SavingsPlanRecurringFee') THEN (savings_plan_total_commitment_to_date - savings_plan_used_commitment)
      WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN 0
      WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN 0
      WHEN (line_item_line_item_type = 'DiscountedUsage') THEN reservation_effective_cost
      WHEN (line_item_line_item_type = 'RIFee') THEN (reservation_unused_amortized_upfront_fee_for_billing_period + reservation_unused_recurring_fee)
      WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN 0 
      ELSE line_item_unblended_cost END) 
    AS amortized_cost,
    SUM(CASE
      WHEN (line_item_line_item_type = 'SavingsPlanRecurringFee') THEN (-savings_plan_amortized_upfront_commitment_for_billing_period)
      WHEN (line_item_line_item_type = 'RIFee') THEN (-reservation_amortized_upfront_fee_for_billing_period)
      WHEN (line_item_line_item_type = 'SavingsPlanNegation') THEN (-line_item_unblended_cost ) 
      ELSE 0 
    END) AS ri_sp_trueup,
    SUM(CASE
      WHEN (line_item_line_item_type = 'SavingsPlanUpfrontFee') THEN line_item_unblended_cost
      WHEN ((line_item_line_item_type = 'Fee') AND (reservation_reservation_a_r_n <> '')) THEN line_item_unblended_cost
      ELSE 0 
    END) AS ri_sp_upfront_fees
```
----
#### Unblended, Blended, Amortized, and Net Costs
Each customer is unique and so are your needs when it comes to viewing and reporting on cost data. 

Unblended and blended costs allow customers with consolidated billing to understand their cost and usage in management payer and linked member accounts. Unblended costs refers to the cost incurred for the usage by an individual account while blended costs refers to costs within a consolidated billing family looking at the total usage for all accounts compared to the linked member account's usage. The ability to view linked account's unblended cost data allows you to more easily reconcile your charges across your payer and linked accounts. [1]

The amortized cost metric reflects the effective cost of the upfront and monthly reservation fees spread across the billing period. By default, Cost Explorer shows the fees for Reserved Instances and Savings Plans as a spike on the day that you're charged, but if you choose to show costs as amortized costs, the costs are amortized over the billing period.

Amortization, simply stated is breaking down cost into an effective daily rate and enables you to see your costs in accrual-based accounting as opposed to cash-based accounting. For example within the context of a Reserved Instance, if you pay $365 for an All Upfront RI for one year and you have a matching instance that uses that RI, that instance costs you $1 a day, amortized.  Unblended and blended costs would be instead report on the full initial $365 cost on the day of purchase. [2]

In the Well-Architected Labs CUR Query Library we are focused on examples showing unblended costs, amortized costs where applicable, and if applicable we will show true-up and upfront fee columns to allow you to calculate and visualize the difference between unblended and amortized costs.

##### Unblended/Blended – Consolidated Billing / Management Accounts with Linked Member Accounts 
Applicable to Reserved Instances, Savings Plans, and On-Demand Instance, as well as pricing tiers (e.g. AWS Free Tier and S3 volume tiers). Unblended costs are associated with the current cost of the product, while blended rates are the averaged costs of the Reserved Instances, On-Demand Instances, and pricing tiered products that are used by member accounts in an organization in AWS Organizations. AWS calculates blended costs by multiplying the blended rate for each service with an account's usage of that service. [4] 

##### Amortized
Applicable to Reserved Instances and Savings Plans, amortizing is when you distribute one-time reservation costs across the billing period that is affected by that cost. For example, if you pay $365 for an All Upfront RI for one year and you have a matching instance that uses that RI, that instance costs you $1 a day, amortized.

In Cost Explorer amortized costs are estimated by combining unblended costs with the amortized portion of your upfront and recurring fees. The unused portion of your upfront fees and recurring charges are shown on the first of the month. [5]

##### Net
In some cases, customers operating at scale on AWS may be able to take advantage of specialized discounts. The net unblended costs reflect usage costs after these discounts are applied while the net amortized costs adds additional logic to amortize discount-related information, in addition to your Savings Plans or Reservation-related charges. [3]

[1] https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/con-bill-blended-rates.html

[2] https://docs.aws.amazon.com/cur/latest/userguide/amortized-reservation.html

[3] https://aws.amazon.com/blogs/aws-cost-management/understanding-your-aws-cost-datasets-a-cheat-sheet/ 

[4] https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/con-bill-blended-rates.html#Blended_CB

[5] https://console.aws.amazon.com/cost-management/home?#/custom

[6] https://docs.aws.amazon.com/cur/latest/userguide/product-columns.html 

[7] https://docs.aws.amazon.com/cur/latest/userguide/amortized-reservation.html

[8] https://docs.aws.amazon.com/cur/latest/userguide/reservation-columns.html

[9] https://docs.aws.amazon.com/cur/latest/userguide/cur-sp.html 

[10] https://docs.aws.amazon.com/cur/latest/userguide/Lineitem-columns.html

{{% email_button category_text="Helpers" service_text="Compute" query_text="AWS Understanding Cost and Usage Data" button_text="Help & Feedback" %}}


## Contributing
Community contributions are encouraged and welcome.  Please follow the [Contribution Guide]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help/contribution-guide.md" >}}). The goal is to pull together useful CUR queries in to a single library that is open, standardized, and maintained.

## Contributors
Please refer to the [CUR Query Library Contributors section]({{< ref "/Cost-Optimization/CUR_Queries/Query_Help/contributors.md" >}}).

{{% notice note %}}
CUR queries are provided as is. We recommend validating your data by comparing it against your monthly bill and Cost Explorer prior to making any financial decisions. If you wish to provide feedback on these queries, there is an error, or you want to make a suggestion, please email: curquery@amazon.com
{{% /notice %}}






