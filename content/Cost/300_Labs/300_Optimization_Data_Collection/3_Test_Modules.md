---
title: "Testing Deployment"
date: 2020-10-21T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Testing your deployment 

Your lambda functions will run automatically on the schedule you chose at deployment. However, if you would like to test your functions please see the steps below. 
Once you have deployed your modules you will be able to test your Lambda function to get your first set of data in Amazon S3. 

1. Depending on the module which you would like to test the following Lambda functions should be triggered. Find your module and search for the function in the [AWS Lambda Portal](console.aws.amazon.com/lambda/home):
- **AWS Organization Data Export** module -> **Lambda_Organization_Data_OptimizationDataCollectionStack** Lambda function
- **Compute Optimizer Collector** module -> **ComputeOptimizer-Trigger-Export** Lambda function
- **Trusted Advisor** module -> **Accounts-Collector-Function-OptimizationDataCollectionStack** Lambda function
- **Inventory Collector** module -> **Accounts-Collector-Function-OptimizationDataCollectionStack** Lambda function
- **ECS Chargeback Data** module -> **Accounts-Collector-Function-OptimizationDataCollectionStack** Lambda function
- **RDS Utilization Data module** module -> **Accounts-Collector-Function-OptimizationDataCollectionStack** Lambda function
- **AWS Budgets Export module** module -> **Accounts-Collector-Function-OptimizationDataCollectionStack** Lambda function
- **AWS Transit Gateway Chargeback module** module -> **Accounts-Collector-Function-OptimizationDataCollectionStack** Lambda function
- **Cost Explorer Rightsizing Recommendations** module -> **Rightsize-Data-Lambda-Function-OptimizationDataCollectionStack** Lambda function


2. To test your Lambda function open respective Lambda in AWS Console and click **Test**
![Images/lambda_test_cf.png](/Cost/300_Optimization_Data_Collection/Images/lambda_test_cf.png) 

3. Enter an **Event name** of **Test**, click **Create**:

![Images/Configure_Test.png](/Cost/300_Organization_Data_CUR_Connection/Images/Configure_Test.png)

4.	Click **Test**

5. The function will run, it will take a minute or two given the size of the Organizations files and processing required, then return success. Click **Details** and view the output. 

For **Compute Optimizer Collector** module processing can take up to 30 mins (15 mins for Compute Optimizer to produce exports requested by lambda, and then another 15 mins for the replication from region buckets to the main bucket)

6. Go to the **Athena** service page

![Images/Athena.png](/Cost/300_Organization_Data_CUR_Connection/Images/Athena.png)

7. You will be able to see your data in the **optimization_data** Database

![Images/Optimization_Data_DB.png](/Cost/300_Optimization_Data_Collection/Images/Optimization_Data_DB.png)

8. Some modules has a saved queries, see next section for details, you will be able to see it in the **Saved queries** section. 
![Images/Saved_queries.png](/Cost/300_Optimization_Data_Collection/Images/Saved_queries.png)
Otherwise you can query each table directly by clicking on **Preview Table** button
![Images/athena_query_table.png](/Cost/300_Optimization_Data_Collection/Images/athena_query_table.png)




If you have just deployed all resources into your Management Account please see below.
{{%expand "Deployed just into Management Account" %}}

In some cases we have seen customers who have deployed all CloudFormation into just their Management Account have role access issues. If you have this issue then please do the below, if not please ignore.

To fix this, all you have to do is remove/comment out the assume role parts of the Lambda code. This will be on different lines in each lambda function. 

![Images/assume-role-comment.png](/Cost/300_Optimization_Data_Collection/Images/assume-role-comment.png)

Once this is done you can redeploy.

{{% /expand%}}



{{% notice tip %}}
If you would like to make your own modules then go to the next section to learn more on how they are made!
{{% /notice %}}


Now you have your data in AWS Athena you can use this to identify optimization opportunities using Athena Queries or visualizing data in Amazon QuickSight.


{{< prev_next_button link_prev_url="../2_deploy_main_resources/" link_next_url="../4_utilize_data/" />}}
