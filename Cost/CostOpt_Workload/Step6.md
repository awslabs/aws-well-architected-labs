# Pricing Models

## Authors
- Nathan Besh, Cost Lead Well-Architected


## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com


## Goals
- Implement pricing models for relevant components in this workload



# Table of Contents
1. [Implement pricing models](#pricing models)


For this exercise we start with the files that were used at the end of Step4, these should already be loaded if you just finished Step4: 
    - [Step4CUR.gz](Code/Step4CUR.gz)
    - [Step4access_log.gz](Code/Step4AccessLog.gz)    


<a name="pricing_models"></a>
## 1. Implement Pricing Models 
We will **NOT** do a per workload analysis, or attempt to purchase and align Savings Plans or RI's to workload components, as this is not best practice.

We know that we need to separate the analysis and purchasing of pricing models such as Savings Plans and Reserved Instances, from our internal accounting structures. We perform the analysis at the master or payer account level, as this will provide the lowest costs to the business, including our workload.

We then use our tooling to apply and allocate the discounts that were provided, to our internal accounting structure.

We will work closely with our Finance or cloud teams and perform the following lab with them:

- [Pricing Models SPs](../Cost_Fundamentals/100_3_Pricing_Models/README.md)
- [Pricng Models RIs](../Cost_Fundamentals/200_3_Pricing_Models/README.md)


1. We will confirm the rates and prices we are paying for our resources before we apply pricing models, and also throughout the operation of our workload.  If our workload no longer has pricing model discounts applied, it may mean your pricing model coverage is too low.

2. Lets have a look at our instance costs, go into the **Athena** console & run the following query:

        select line_item_product_code as product, line_item_usage_type, sum(line_item_unblended_cost) as cost FROM "costusage"."costusagefiles_reinventworkshop"
        where (resource_tags_user_application like 'ordering' and line_item_usage_type like 'BoxUsage%') or line_item_line_item_type like 'SavingsPlan%'
        group by line_item_product_code, line_item_usage_type
        order by cost desc

3. You can see the workload costs for the instances, which is **$24.9956**:
![Images/rates_prices03.png](Images/rates_prices03.png)

4. Now lets look at the rates and costs that make up that figure, run the following query:

        select line_item_product_code as product, line_item_usage_type, sum(line_item_usage_amount) as usage, line_item_unblended_rate as rate, sum(line_item_unblended_cost) as cost FROM "costusage"."costusagefiles_reinventworkshop"
        where (resource_tags_user_application like 'ordering' and line_item_usage_type like 'BoxUsage%') or line_item_line_item_type like 'SavingsPlan%'
        group by line_item_product_code, line_item_unblended_rate, line_item_usage_type
        order by cost desc

3. We can see our main workload resources and rates:
![Images/rates_prices01.png](Images/rates_prices01.png)

4. Work with your internal teams so they can understand your projected usage and business forecast. The appropriate discount models will then be applied to your workload.



<a name="validation"></a>
## 2. Simulate the change and validate
We will simulate the change of purchasing pricing models.

1. Download the updated CUR and application log files from here: 
    - [Step5CUR.gz](Code/Step5CUR.gz)
    - [Step5access_log.gz](Code/Step5AccessLog.gz)

2. Lets check our costs for the workload after savings plans have been applied, run the following query:

        select line_item_product_code as product, line_item_usage_type, sum(line_item_unblended_cost) as cost FROM "costusage"."costusagefiles_reinventworkshop"
        where (resource_tags_user_application like 'ordering' and line_item_usage_type like 'BoxUsage%') or line_item_line_item_type like 'SavingsPlan%'
        group by line_item_product_code, line_item_usage_type
        order by cost desc

3. You can see the total costs are now **$21.986**:
![Images/rates_prices04.png](Images/rates_prices04.png)

3. You can see the rates and prices by running the following query, also the savings plan commitments.  Note the negation lines:

        select line_item_product_code as product, line_item_usage_type, sum(line_item_usage_amount) as usage, line_item_unblended_rate as rate, sum(line_item_unblended_cost) as cost FROM "costusage"."costusagefiles_reinventworkshop"
        where (resource_tags_user_application like 'ordering' and line_item_usage_type like 'BoxUsage%') or line_item_line_item_type like 'SavingsPlan%'
        group by line_item_product_code, line_item_unblended_rate, line_item_usage_type
        order by cost desc
        
![Images/rates_prices02.png](Images/rates_prices02.png)



## 3. Celebrate
We have completed our last Cost Optimization cycle for today. Where did we end up? How did we go?

1. Look at the original graphs of usage and cost:
![Images/GraphCompare.png](Images/GraphCompare.png)

![Images/GraphCompare2.png](Images/GraphCompare2.png)

![Images/GraphCompare3.png](Images/GraphCompare3.png)

2. Recall our efficiency numbers:
![Images/efficiency.png](Images/efficiency.png)

3. Open up quicksight and refresh your browser, the new data will be automatically loaded:
![Images/GraphCompare4.png](Images/GraphCompare4.png)

![Images/GraphCompare5.png](Images/GraphCompare5.png)

![Images/GraphCompare6.png](Images/GraphCompare6.png)

4. Lets look at our efficiency. Run the following query to return the total number of lines in our log file, which is our total demand:

        SELECT  count(*) FROM "webserverlogs"."applogfiles_reinventworkshop" 

5. Copy the results into a spreadsheet application and label it **Total workload demand**

6. Run the following queries to get the total successful responses, and valid successful responses, record these also:

        SELECT  count(*) FROM "webserverlogs"."applogfiles_reinventworkshop" 
        where response like '200' and (request like '%index%' or request like '%image_file%')

7. We will now get the successful and valid responses by hour with the query below. Note the use of **date_parse** to turn the string into an actual date we can work with:

        SELECT date(date_parse(logdate, '%d/%b/%Y')) as date, hour(date_parse(logtime, '%H:%i:%s')) as hour, count(*) as requests FROM "webserverlogs"."applogfiles_reinventworkshop" 
        where response like '200' and (request like '%index%' or request like '%image_file%')
        group by date_parse(logdate, '%d/%b/%Y'), hour(date_parse(logtime, '%H:%i:%s'))
        order by date, hour

8. Copy the results into the same spreadsheet.

9. Now lets get the workload cost that corresponds to the demand. Select the **costusage** database, which should have a table **costusagefiles_...**

10. Get the total cost for the workload with the following statement, and put it into the spreadsheet next to the demand:

        SELECT sum(line_item_unblended_cost)  FROM "costusage"."costusagefiles_reinventworkshop" 
        where resource_tags_user_application like 'ordering'

11. Execute the following statement to get the cost by hour and put it into the spreadsheet:

        SELECT line_item_usage_start_date as date, sum(line_item_unblended_cost) as cost FROM "costusage"."costusagefiles_reinventworkshop" 
        where resource_tags_user_application like 'ordering'
        group by line_item_usage_start_date
        order by date asc

12. In the spreadsheet, calculate the efficiency by dividing the requests by the cost. This will give you the number of outcomes per dollar spent. Notice the difference when you compare total vs successful vs valid. Also notice any variation of efficiency throughout the day.

![Images/efficiency2.png](Images/efficiency2.png) 
