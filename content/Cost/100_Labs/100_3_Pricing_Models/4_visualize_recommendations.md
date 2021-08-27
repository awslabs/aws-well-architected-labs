---
title: "Visualize your Savings Plan recommendations"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

A visualization of your recommendation can be used as a quick double check, and also assist to demonstrate the savings and risks to other job functions.

We will use the **Cost Explorer** hourly granularity feature to visualize Savings Plan recommendations. You need to have this enabled to view hourly usage, and there are associated costs.

1. In the console go to **AWS Cost Management** by opening **Cost Explorer**:
![Images/VisualizeSP1.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP1.png?classes=lab_picture_small)

2. Click on **Recommendations**:
![Images/VisualizeSP2.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP2.png?classes=lab_picture_small)

3. Select **EC2 Instance Savings Plans**, **1-year**, **All upfront** and **7 days**:
![Images/VisualizeSP3.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP3.png?classes=lab_picture_small)
If **Payer** is selected and you see few or no recommendations, select **Linked account** to display recommendations to the linked accounts within your AWS Organization.

4. Scroll down and identify an instance family within your recommendations for later in this lab. If it is displaying the same instance family in multiple accounts, also note the account number:
![Images/VisualizeSP4.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP4.png?classes=lab_picture_small)

5. Scroll up and click **Cost Explorer**:
![Images/VisualizeSP5.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP5.png?classes=lab_picture_small)

6. To show the last 7 Days, click on the date range dropdown and select **7D**, then click **Apply**:
![Images/VisualizeSP6.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP6.png?classes=lab_picture_small)

7. From the granularity dropdown select **Hourly**:
![Images/VisualizeSP7.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP7.png?classes=lab_picture_small)

8. Click the **Service** filter, select **EC2-Instances (Elastic Compute Cloud - Compute)** and click **Apply filters**:
![Images/VisualizeSP8.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP8.png?classes=lab_picture_small)

9. In the **Group by:** options select **Instance Type**:
![Images/VisualizeSP9.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP9.png?classes=lab_picture_small)

10. From the visualization dropdown select **Line**:
![Images/VisualizeSP10.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP10.png?classes=lab_picture_small)

11. Apply a filter on the region if you use multiple regions:
![Images/VisualizeSP11.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP11.png?classes=lab_picture_small)

12. If you have multiple instance types for a single family, you can select them by using a filter and choosing a stack graph. This will show the total costs for that family in the required region.

13. Click **More filters**:
![Images/VisualizeSP12.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP12.png?classes=lab_picture_small)

14. Click **Purchase Option**, select **On Demand** and click **Apply**:
![Images/VisualizeSP13.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP13.png?classes=lab_picture_small)
{{% notice info %}}
If you have the same instance family in multiple accounts, select **Linked Acount** from the filters menu. Then select the account number you chose earlier in the lab and apply the filter.
{{% /notice %}}

15. Hover over a recommendation that matches the family you chose earlier in the lab:
![Images/VisualizeSP14.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP14.png?classes=lab_picture_small)

16. Cost Explorer gives **$0.58 hourly usage of our m5.xlarge**. Our **recommended commitment was $0.354/hour** for m5, 1-year, all upfront.
![Images/VisualizeSP15.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP15.png?classes=lab_picture_small)

17. Now open the [Savings Plan Pricing Page](https://aws.amazon.com/savingsplans/pricing/) and select the **EC2 Instance Savings Plans** tab.

18. Select the correct parameters that match the recommendation and view the rates:
![Images/VisualizeSP16.png](/Cost/100_3_Pricing_Models/Images/VisualizeSP16.png?classes=lab_picture_small)

19. The savings is **41%**. We were using **$0.58**, so multiplied by **1.00-41% (0.59)** = **$0.344/hour**.

We can see the recommendation is accurate and valid within $.01.

{{< prev_next_button link_prev_url="../3_analyze_recommendations/" link_next_url="../5_tear_down/" />}}
