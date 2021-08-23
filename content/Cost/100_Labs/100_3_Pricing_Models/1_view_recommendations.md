---
title: "View your Savings Plan recommendations"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

## Introduction

Savings Plans are a commitment based discount model. By making a commitment of spend you will use for 1 or 3 years, you receive a discount of up to 72%. They offer the same discounts as Reserved Instances, however offer a great deal more flexibility, and do not have the same management overhead.

In this workshop we will take you through your recommendations, and help you choose the right savings plan for your future business requirements.

1. Log into the console via SSO and open the AWS Cost Management dashboard by searching and selecting **Cost Explorer**:
![Images/SPRecommendations01.png](/Cost/100_3_Pricing_Models/Images/SPRecommendations01.png?classes=lab_picture_small)

2. Click on **Overview** under **Savings Plans** on the left menu:
![Images/SPRecommendations02.png](/Cost/100_3_Pricing_Models/Images/SPRecommendations02.png?classes=lab_picture_small)

3. You can see a description and some examples of Savings Plans under the **What are Savings Plans?** heading, and **Potential monthly savings** at the bottom::
![Images/SPRecommendations03.png](/Cost/100_3_Pricing_Models/Images/SPRecommendations03.png?classes=lab_picture_small)

4. Click on **Recommendations** on the left menu:
![Images/SPRecommendations04.png](/Cost/100_3_Pricing_Models/Images/SPRecommendations04.png?classes=lab_picture_small)

5. You can see the **Recommendation parameters** at the top. Here you have the ability to:
    - View recommendations by the **Savings Plans type**
    - Choose **Recommendation level** of **Payer** if you want recommentions based on all accounts that have Savings Plans discount sharing enabled or **Linked account** for sperate recommendations for each account in your Organization.
    - Choose the length of the **Savings Plans term**
    - Select from different **Payment options**
    - Choose to have recommendations made **Based on the past** 7, 30 or 60 days work of historic usage data.
![Images/SPRecommendations05.png](/Cost/100_3_Pricing_Models/Images/SPRecommendations05.png?classes=lab_picture_small)

6. Under **Recomendations** you can see your estimated **before** and **after** spend. Under **Recommended Saving Plans** you will see a breakdown the commitment per hour and the percentage of estimated savings, this is an ideal starting point to understand the overall return you can get on your commitment:
![Images/SPRecommendations06.png](/Cost/100_3_Pricing_Models/Images/SPRecommendations06.png?classes=lab_picture_small)

7. Click on **Payer**, **Compute Saving Plans**, **1-year**, **No upfront**, and **30 days** from the options above, and see the changes in the before and after below. Note down the % saving, in this example is **25%**:
![Images/SPRecommendations07.png](/Cost/100_3_Pricing_Models/Images/SPRecommendations07.png?classes=lab_picture_small)

8. Click on **EC2 Instance Savings Plans**, **3-year** and **All upfront**, and note the % saving in this example is now **58%**:
![Images/SPRecommendations08.png](/Cost/100_3_Pricing_Models/Images/SPRecommendations08.png?classes=lab_picture_small)

9. This will typically be the highest and lowest savings you can achieve based on previous analyzed usage. You can vary the options to achieve the discount and features that most suits your needs. You can also combine the options by purchasing multiple savings plans. e.g. Making a commitment for a 1-year with an upfront component, and another commitment with no upfront on a 3-year term.

While the commitment is a full 1 or 3 years, a Savings Plan will typically be paid off much sooner. We will analyze this in the next step.

{{< prev_next_button link_prev_url="../" link_next_url="../2_usage_trend/" />}}
