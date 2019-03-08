# Level 100: Cost Visualization

## Authors
- Nathan Besh, Cost Lead Well-Architected


## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com


# Table of Contents
1. [View your cost and usage by service](#cost_usage_service)
2. [View your cost and usage by account](#cost_usage_account)
3. [View your Reserved Instance coverage](#RI_coverage)
4. [Create a custom EC2 report](#custom_ec2)
5. [Tear down](#tear_down)
6. [Survey](#survey)



## 1. View your cost and usage by service <a name="cost_usage_service"></a>
AWS Cost Explorer is a free built in tool to that lets you dive deeper into your cost and usage data to identify trends, pinpoint cost drivers, and detect anomalies. We will examine costs by service in this exercise.

1. Log into the console as an IAM user with the required permissions, go to the **billing** dashboard:
![Images/AWSCostService0.png](Images/AWSCostService0.png)

2. Select **Cost Explorer** from the menu on the left:
![Images/AWSCostService1.png](Images/AWSCostService1.png)

3. Click on **Launch Cost Explorer**:
![Images/AWSCostService2.png](Images/AWSCostService2.png)

4. Click on **Saved reports** from the left menu:
![Images/AWSCostService3.png](Images/AWSCostService3.png)

5. You will be presented a list of pre-configured and saved reports. Click on **Monthly costs by service**:
![Images/AWSCostService4.png](Images/AWSCostService4.png)

6. This is the monthly costs by service for the last 6 months, broken down by month (your usage will most likely be different):
![Images/AWSCostService5.png](Images/AWSCostService5.png)

7. We will change to a daily view to highlight trends. Select the **Monthly** drop down and click on **Daily**:
![Images/AWSCostService6.png](Images/AWSCostService6.png)

8. The bar graph is difficult to read, so we will switch to a line graph. Click on the **Bar** dropdown, then select **Line**:
![Images/AWSCostService7.png](Images/AWSCostService7.png)

9. This is the same data with daily granularity and shows trends much more clearly. There are monthly peaks - these are monthly recurring reservation fees from Reserved Instances (Green line):
![Images/AWSCostService8.png](Images/AWSCostService8.png)

10. We will remove the RI recurring fees. Click on the **Charge Type** filter on the right, click the checkbox next to **Recurring reservation fee**, select **Exlude only** to remove the data. Then click **Apply filters**:
![Images/AWSCostService9.png](Images/AWSCostService9.png)

11. We have now excluded the monthly recurring fees and the peaks have been removed. We can see the largest cost for our usage during this period is Glue:
![Images/AWSCostService10.png](Images/AWSCostService10.png)

12. We will remove the Glue service to show the other services with better clarity. Click on the **Service** filter from the right, click the checkbox next to **Glue**, select **Exclude only**, and click **Apply filters**:
![Images/AWSCostService11.png](Images/AWSCostService11.png)

13. Glue has now been excluded, and all the other services can been seen easily:
![Images/AWSCostService12.png](Images/AWSCostService12.png)


You have now viewed the costs by service and applied multilpe filters. You can continue to modify the report by timeframe and apply other filters.



## 2. View your cost and usage by account <a name="cost_usage_account"></a>
We will now view usage by account. This helps to highlight where the costs and usage are by linked account. NOTE: you will need one or more multilpe accounts for this exercise to be effective.

1. Select **Saved reports** from the left menu:
![Images/AWSCostAccount0.png](Images/AWSCostAccount0.png)

2. Click on **Monthly costs by linked account**:
![Images/AWSCostAccount1.png](Images/AWSCostAccount1.png)

3. It will show the default last 6 months, with a monthly granularity. 
![Images/AWSCostAccount2.png](Images/AWSCostAccount2.png)

4. As above, change the graph to **Daily** granularity and from a bar graph to a **Line** graph:
![Images/AWSCostAccount3.png](Images/AWSCostAccount3.png)

5. Here is the daily granularity line graph. You can see there is one account which has the most cost, so lets focus on that by applying a filter:
![Images/AWSCostAccount4.png](Images/AWSCostAccount4.png)

6. On the right click on **Linked Account**, select the checkbox next to the account we want to focus on, then click **Include only** and **Apply filters**:
![Images/AWSCostAccount6.png](Images/AWSCostAccount6.png)

7. You can now see this one accounts usage: 
![Images/AWSCostAccount7.png](Images/AWSCostAccount7.png)

8. Lets see the services breakdown for this account, click on **Service** to group by services:
 ![Images/AWSCostAccount8.png](Images/AWSCostAccount8.png)

8. You can see the service breakdown for this account. Lets see the instance type breakdown for this account, click on **Instance Type**:
![Images/AWSCostAccount9.png](Images/AWSCostAccount9.png)

9. You can see the instance type breakdown for this account. Lets see the usage type breakdown for this account, click on **Usage Type**:
![Images/AWSCostAccount10.png](Images/AWSCostAccount10.png)

10. Here is the usage type breakdown:
![Images/AWSCostAccount11.png](Images/AWSCostAccount11.png)


You have now viewed the costs by account and applied multilpe filters. You can continue to modify the report by timeframe and apply other filters.


## 3. View your Reserved Instance coverage <a name="RI_coverage"></a>
To ensure you are paying the lowest prices for your resources, a high coverage of Reserved Instances (RI's) is required. A typical goal is to aim for approximately 80% of running instances covered by RI's, here is how you can check your coverage.

1. In Cost Explorer, click on **Saved reports** on the left:
![Images/AWSRICoverage0.png](Images/AWSRICoverage0.png)

2. Click on **RI Coverage**:
![Images/AWSRICoverage1.png](Images/AWSRICoverage1.png)

3. You will see the default RI Coverage report. It is for the **Last 3 Months**, and is for the instances within the **EC2** service:
![Images/AWSRICoverage2.png](Images/AWSRICoverage2.png)

4. Scroll down below the graph and you can see a summary of the costs and usage. Note that depending on the instance type and size, the On-Demand costs will be different per hour:
![Images/AWSRICoverage3.png](Images/AWSRICoverage3.png)

5. To help focus where you need to, click on the down arrow next to **ON-DEMAND COST** to sort by costs descending. This will put the highest on-demand costs at the top, which is where you should focus your RI purchases:
![Images/AWSRICoverage4.png](Images/AWSRICoverage4.png)


You have now viewed your RI coverage, and have insight on where to increase your coverage.


## 4. Create custom EC2 reports <a name="custom_ec2"></a>
We will now create some custom EC2 reports, which will help to show ongoing costs related to EC2 instances and their associated usage. 

1. From the left menu click **Explore**, and click **Cost & Usage**:
![Images/AWSCustomEC20.png](Images/AWSCustomEC20.png)

2. You will have the default breakdown by Service. Click on the **Service** filter on the right, select **EC2-Instances (Elastic Compute Cloud - Compute)** and **EC2-Other**, then click **Apply filters**:
![Images/AWSCustomEC21.png](Images/AWSCustomEC21.png)

3. You will now have monthly EC2 Instance and Other costs:
![Images/AWSCustomEC22.png](Images/AWSCustomEC23.png)

4. Change the **Group by** to **Usage Type**:
![Images/AWSCustomEC23.png](Images/AWSCustomEC24.png)

5. Change it to a **Daily** **Line** graph, then select **More filters**: 
![Images/AWSCustomEC24.png](Images/AWSCustomEC25.png)

6. click on **Purchase Option**, select **On Demand** and click **Apply filters**, which will ensure we are only looking at On-Demand costs: 
![Images/AWSCustomEC25.png](Images/AWSCustomEC26.png)

7. These are your on-demand EC2 costs, you should setup a report like this for your services that have the highest usage or costs. We will now save this, click on **Save as...**:
![Images/AWSCustomEC26.png](Images/AWSCustomEC27.png)

8. Enter a **report name** and click **Save Report >**:
![Images/AWSCustomEC28.png](Images/AWSCustomEC28.png)

9. Now click on the **Service** filter, and de-select **EC2-Instances**, so that only **EC2-Other** is selected:
![Images/AWSCustomEC29.png](Images/AWSCustomEC29.png)

10. Now you can clearly see what makes up the **Other** charges, typically these are EBS volumes, Data Transfer and other costs associated with EC2 usage. Click **Save as...** (do NOT click Save):
![Images/AWSCustomEC210.png](Images/AWSCustomEC210.png)

11. Enter a **report name** and click **Save Report >**:
![Images/AWSCustomEC211.png](Images/AWSCustomEC211.png)

12. You can access these by clicking on **Saved Reports**:
![Images/AWSCustomEC212.png](Images/AWSCustomEC212.png)

13. Here you can see both reports that were saved, note they do not have a lock symbol - which is reserved for AWS configured reports:
![Images/AWSCustomEC213.png](Images/AWSCustomEC213.png)




## 5. Tear down <a name="tear_down"></a>
We will delete both custom reports that were created.

1. Click on **Saved reports** on the left menu:
![Images/AWSTearDown0.png](Images/AWSTearDown0.png)

2. Select the checkbox next to the two custom reports that you created above. Click on **Delete**:
![Images/AWSTearDown1.png](Images/AWSTearDown1.png)

3. Verify the names of the reports you are going to delete, click **Delete**:
![Images/AWSTearDown2.png](Images/AWSTearDown2.png)

4. The reports are no longer listed in the reports available:
![Images/AWSTearDown3.png](Images/AWSTearDown3.png)




## 6. Survey <a name="survey"></a>
Thanks for taking the lab, We hope that you can take this short survey (<2 minutes), to share your insights and help us improve our content.

[![Survey](Images/survey.png)](https://amazonmr.au1.qualtrics.com/jfe/form/SV_cLPnfCk4ynoui9v)


This survey is hosted by an external company (Qualtrics) , so the link above does not lead to our website.  Please note that AWS will own the data gathered via this survey and will not share the information/results collected with survey respondents.  Your responses to this survey will be subject to Amazon’s Privacy Policy.





