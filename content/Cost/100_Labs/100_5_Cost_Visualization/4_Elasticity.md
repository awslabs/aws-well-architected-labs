---
title: "View your Elasticity"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

**NOTE**: This exercise requires you have enabled hourly granularity within Cost Explorer, this can be done by following the instructions here - [AWS Account Setup]({{< ref "100_1_AWS_Account_Setup" >}}), Step 6 - Enable Cost Explorer.
There are additional costs to enable this granularity.

A key part of cost optimization is ensuring that your systems scale with your usage. This visualization will show how your systems operate over time.

1. Click on **Cost Explorer** to go back to the default view:
![Images/AWSElasticity1.png](/Cost/100_5_Cost_Visualization/Images/AWSElasticity1.png)

2. Click the **down arrow** to change the period, select **14D** and click **Apply**:
![Images/AWSElasticity2.png](/Cost/100_5_Cost_Visualization/Images/AWSElasticity2.png)

3. Click on **Monthly** and change the granularity to **Hourly**:
![Images/AWSElasticity3.png](/Cost/100_5_Cost_Visualization/Images/AWSElasticity3.png)

4. Click on **Bar**, then select **Line**:
![Images/AWSElasticity4.png](/Cost/100_5_Cost_Visualization/Images/AWSElasticity4.png)

5. You will now have in depth insight to how your environment is operating. You can see in this example the EC2 Instances scaling every day, you can see a period of large ELB usage, and EC2-Other, which includes charges related to EC2 such as data transfer.
![Images/AWSElasticity5.png](/Cost/100_5_Cost_Visualization/Images/AWSElasticity5.png)
