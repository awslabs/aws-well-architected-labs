---
title: "View an RI report"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

We are going to view the RI reports within AWS Cost Explorer, to understand the potential savings and usage trends.

1. Log into the console via SSO, go to the master/payer account and go to the **AWS Cost Explorer** service page:
![Images/AWSRI1.png](/Cost/200_3_Pricing_Models/Images/AWSRI1.png)

2. In the left menu under **Reservations** select **Recommendations**:
![Images/AWSRI2.png](/Cost/200_3_Pricing_Models/Images/AWSRI2.png)

3. On the right select the filters: **Select recommendation type** non-EC2 service, **RI term** 1 year, **Payment Option** (your preference), **Based on the past** 7 days:
![Images/AWSRI3.png](/Cost/200_3_Pricing_Models/Images/AWSRI3.png)

The top section will show the estimated savings and number of recommendations, take note of the **Purchase Recommendations**

4. On the right select the filter: **Based on the past** 30 days:
![Images/AWSRI4.png](/Cost/200_3_Pricing_Models/Images/AWSRI4.png)

View the **Purcahse Recommendations**, if the 7 days recommendation is more than the 30 days recommendation - your usage is **increasing** and the recommendations are lower risk.  If the 7 days recommendation is less than 30 days, then your usage is **decreasing** and you need to look further into your usage patterns to see which RI's would be suitable.

{{% notice tip %}}
You now have an overview of your potential savings and your usage trends.
{{% /notice %}}