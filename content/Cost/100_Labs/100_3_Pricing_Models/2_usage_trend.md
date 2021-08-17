---
title: "Understand your usage trend"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>2. </b>"
weight: 2
---

In large organizations usage can be distributed across many teams, and could take significant effort to collect. We can assist this effort by using tooling to understand your overall trends in usage to make an informed choice on Savings Plan commitments.

You can use the **Compute Savings Plan** for this exercise if you plan on purchasing a compute plan. For this lab we will use an **EC2 Instance Savings Plans** to provide more granularity and insights into usage.

1. On the [AWS Cost Management](https://console.aws.amazon.com/cost-management/home#/dashboard) page, select **Recommendations** under **Savings Plans** and then select **EC2 Instance Savings Plans** Savings Plans type, **1-year** Savings Plans term, **All upfront**, and **60 days** time period:
![Images/UsageTrend1.png](/Cost/100_3_Pricing_Models/Images/UsageTrend1.png?classes=lab_picture_small)
If **Payer** is selected and you see few or no recommendations, select **Linked account** to display recommendations to the linked accounts within your AWS Organization.

2. Scroll down to **Recommended Savings Plans**, take note of the **Commitment**:
![Images/UsageTrend2.png](/Cost/100_3_Pricing_Models/Images/UsageTrend2.png?classes=lab_picture_small)

3. Scroll up and change it to **30 days**:
![Images/UsageTrend3.png](/Cost/100_3_Pricing_Models/Images/UsageTrend3.png?classes=lab_picture_small)

4. Scroll down to **Recommended Savings Plans**, take note of the **Commitment**:
![Images/UsageTrend4.png](/Cost/100_3_Pricing_Models/Images/UsageTrend4.png?classes=lab_picture_small)

5. Scroll up and change it to **7 days**:
![Images/UsageTrend5.png](/Cost/100_3_Pricing_Models/Images/UsageTrend5.png?classes=lab_picture_small)

6. Scroll down to **Recommended Savings Plans**, take note of the **Commitment**:
![Images/UsageTrend6.png](/Cost/100_3_Pricing_Models/Images/UsageTrend6.png?classes=lab_picture_small)

7. Compare the trends in usage to see if your usage is increasing or decreasing, the higher the recommended commitment, the higher the usage. If usage is decreasing make a smaller initial hourly commitment, then re-analyze in 2-4 weeks. If usage is steady or increasing make a commitment closer to the recommended commitment:  
![Images/UsageTrend7.png](/Cost/100_3_Pricing_Models/Images/UsageTrend7.png?classes=lab_picture_small)

You now have an understanding of your overall usage trend, and can use this information to make a commitment that is matched to your business requirements.

{{< prev_next_button link_prev_url="../1_view_recommendations/" link_next_url="../3_analyze_recommendations/" />}}
