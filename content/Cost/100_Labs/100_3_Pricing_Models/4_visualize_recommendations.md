---
title: "Visualize your Savings Plan recommendations"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

A visualization of your recommendation can be used as a quick double check, and also assist to demonstrate the savings and risks to other job functions.

We will use the **Cost Explorer** hourly granularity feature to visualize Savings Plan recommendations. You need to have this enabled to view hourly usage, and there are associated costs.

1. In the console go to the **Billing Dashboard**:
![Images/SavingsPlan25.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan25.png)

2. Click on **Savings Plans**:
![Images/SavingsPlan26.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan26.png)

3. Click on **Recommendations**, and select **EC2 Instance**, **1-year**, **All upfront** and **7 days**:
![Images/SavingsPlan27.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan27.png)

4. Scroll down and pick a specific instance type:
![Images/SavingsPlan28.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan28.png)

5. Scroll up and click **Cost Explorer**:
![Images/SavingsPlan29.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan29.png)

6. Click the time period **Last 7 days** in this example, then click **7D** and click **Apply**:
![Images/SavingsPlan30.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan30.png)

7. Click the granularity **Monthly** in this example, and select **Hourly**:
![Images/SavingsPlan31.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan31.png)

8. Click the **Service** filter, select **EC2-Instances (Elastic Compute Cloud - Compute)** and click **Apply filters**:
![Images/SavingsPlan32.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan32.png)

9. Click **Instance Type** in the Group by menu:
![Images/SavingsPlan33.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan33.png)

10. Click on **Stack** and select **Line**:
![Images/SavingsPlan34.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan34.png)

11. Apply a filter on the region if you use multiple regions:
![Images/SavingsPlan36.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan36.png)

12. If you have multiple instance types for a single family, you can select them by using a filter and choosing a stack graph. This will show the total costs for that family in the required region.

13. Click **More filters**:
![Images/SavingsPlan38.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan38.png)

14. Click **Purchase Option**, select **On Demand** and click **Apply**:
![Images/SavingsPlan39.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan39.png)

15. Hover over the recommendation that matches the family you chose:
![Images/SavingsPlan35.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan35.png)

16. Cost Explorer gives **$0.51 hourly usage of C5.large** which is the only instance in the C5 family. Our **recommended commitment was $0.30 per hour** for C5 all upfront. Go to the pricing page: https://aws.amazon.com/savingsplans/pricing/

17. Select the correct parameters that match the recommendation and view the rates:
![Images/SavingsPlan37.png](/Cost/100_3_Pricing_Models/Images/SavingsPlan37.png)

18. The savings is **41%**. We were using **$0.51**, so multiplied by **1-41% (0.59)** = **$0.30**.

We can see the recommendation is accurate and valid, and see the usage pattern associated with the recommendation.  
