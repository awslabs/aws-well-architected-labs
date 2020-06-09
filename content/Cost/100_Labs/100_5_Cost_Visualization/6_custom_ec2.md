---
title: "Create custom EC2 reports"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

We will now create some custom EC2 reports, which will help to show ongoing costs related to EC2 instances and their associated usage.

1. From the left menu click **Cost Explorer**, click **Reports**, and click and click **Monthly costs by service**:
![Images/AWSCustomEC20.png](/Cost/100_5_Cost_Visualization/Images/AWSCustomEC20.png)

2. You will have the default breakdown by Service. Click on the **Service** filter on the right, select **EC2-Instances (Elastic Compute Cloud - Compute)** and **EC2-Other**, then click **Apply filters**:
![Images/AWSCustomEC21.png](/Cost/100_5_Cost_Visualization/Images/AWSCustomEC21.png)

3. You will now have monthly EC2 Instance and Other costs:
![Images/AWSCustomEC22.png](/Cost/100_5_Cost_Visualization/Images/AWSCustomEC23.png)

4. Change the **Group by** to **Usage Type**:
![Images/AWSCustomEC23.png](/Cost/100_5_Cost_Visualization/Images/AWSCustomEC24.png)

5. Change it to a **Daily** **Line** graph, then select **More filters**:
![Images/AWSCustomEC24.png](/Cost/100_5_Cost_Visualization/Images/AWSCustomEC25.png)

6. click on **Purchase Option**, select **On Demand** and click **Apply filters**, which will ensure we are only looking at On-Demand costs:
![Images/AWSCustomEC25.png](/Cost/100_5_Cost_Visualization/Images/AWSCustomEC26.png)

7. These are your on-demand EC2 costs, you should setup a report like this for your services that have the highest usage or costs. We will now save this, click on **Save as...**:
![Images/AWSCustomEC26.png](/Cost/100_5_Cost_Visualization/Images/AWSCustomEC27.png)

8. Enter a **report name** and click **Save Report >**:
![Images/AWSCustomEC28.png](/Cost/100_5_Cost_Visualization/Images/AWSCustomEC28.png)

9. Now click on the **Service** filter, and de-select **EC2-Instances**, so that only **EC2-Other** is selected:
![Images/AWSCustomEC29.png](/Cost/100_5_Cost_Visualization/Images/AWSCustomEC29.png)

10. Now you can clearly see what makes up the **Other** charges, typically these are EBS volumes, Data Transfer and other costs associated with EC2 usage. Click **Save as...** (do NOT click Save):
![Images/AWSCustomEC210.png](/Cost/100_5_Cost_Visualization/Images/AWSCustomEC210.png)

11. Enter a **report name** and click **Save Report >**:
![Images/AWSCustomEC211.png](/Cost/100_5_Cost_Visualization/Images/AWSCustomEC211.png)

12. You can access these by clicking on **Saved Reports**:
![Images/AWSCustomEC212.png](/Cost/100_5_Cost_Visualization/Images/AWSCustomEC212.png)

13. Here you can see both reports that were saved, note they do not have a lock symbol - which is reserved for AWS configured reports:
![Images/AWSCustomEC213.png](/Cost/100_5_Cost_Visualization/Images/AWSCustomEC213.png)
