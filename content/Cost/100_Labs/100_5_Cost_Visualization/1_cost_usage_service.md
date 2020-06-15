---
title: "View your cost and usage by service"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

AWS Cost Explorer is a free built in tool that lets you dive deeper into your cost and usage data to identify trends, pinpoint cost drivers, and detect anomalies. We will examine costs by service in this exercise.

1. Log into the console via SSO and go to the **billing** dashboard:
![Images/AWSCostService0.png](/Cost/100_5_Cost_Visualization/Images/AWSCostService0.png)

2. Select **Cost Explorer** from the menu on the left:
![Images/AWSCostService1.png](/Cost/100_5_Cost_Visualization/Images/AWSCostService1.png)

3. Click on **Launch Cost Explorer**:
![Images/AWSCostService2.png](/Cost/100_5_Cost_Visualization/Images/AWSCostService2.png)

4. Click on **Saved reports** from the left menu:
![Images/AWSCostService3.png](/Cost/100_5_Cost_Visualization/Images/AWSCostService3.png)

5. You will be presented a list of pre-configured and saved reports. Click on **Monthly costs by service**:
![Images/AWSCostService4.png](/Cost/100_5_Cost_Visualization/Images/AWSCostService4.png)

6. This is the monthly costs by service for the last 6 months, broken down by month (your usage will most likely be different):
![Images/AWSCostService5.png](/Cost/100_5_Cost_Visualization/Images/AWSCostService5.png)

7. We will change to a daily view to highlight trends. Select the **Monthly** drop down and click on **Daily**:
![Images/AWSCostService6.png](/Cost/100_5_Cost_Visualization/Images/AWSCostService6.png)

8. The bar graph is difficult to read, so we will switch to a line graph. Click on the **Bar** dropdown, then select **Line**:
![Images/AWSCostService7.png](/Cost/100_5_Cost_Visualization/Images/AWSCostService7.png)

9. This is the same data with daily granularity and shows trends much more clearly. There are monthly peaks - these are monthly recurring reservation fees from Reserved Instances (Purple line):
![Images/AWSCostService8.png](/Cost/100_5_Cost_Visualization/Images/AWSCostService8.png)

10. We will remove the **Recurring reservation fees**. Click on **More filters** then click **Charge Type** filter on the right, click the checkbox next to **Recurring reservation fee**, select **Exclude only** to remove the data. Then click **Apply filters**:
![Images/AWSCostService9.png](/Cost/100_5_Cost_Visualization/Images/AWSCostService9.png)

11. We have now excluded the monthly recurring fees and the peaks have been removed. We can see the largest cost for our usage during this period is EC2-Instances:
![Images/AWSCostService10.png](/Cost/100_5_Cost_Visualization/Images/AWSCostService10.png)

12. We will remove the EC2 service to show the other services with better clarity. Click on the **Service** filter from the right, click the checkbox next to **EC2-Instances**, select **Exclude only**, and click **Apply filters**:
![Images/AWSCostService11.png](/Cost/100_5_Cost_Visualization/Images/AWSCostService11.png)

13. EC2-Instances has now been excluded, and all the other services can been seen easily:
![Images/AWSCostService12.png](/Cost/100_5_Cost_Visualization/Images/AWSCostService12.png)


You have now viewed the costs by service and applied multiple filters. You can continue to modify the report by timeframe and apply other filters.
