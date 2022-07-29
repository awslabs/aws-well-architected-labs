---
title: "Performing a data-driven review"
date: 2020-12-17T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

![Section4 Integration](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/Integration.png)

## Overview
Now that we have defined a workload, we will review the question **COST 6. How do you meet cost targets when you select resource type, size and number**. 
Defining a workload generates an event called **CreateWorkload** that Amazon EventBridge receives, which will invoke AWS Lambda function that collects cost optimization data from AWS Compute Optimizer and AWS Trusted Advisor. Then this data will be automatically available before the review, reviewer and customer could have a data-driven cost optimization review.

1. To start AWS Well-Architected Framework Review, click **Continue reviewing** and select **AWS Well-Architected Framework Lens**.

![Section4 WAFR](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/WAFR.png)

2. Choose **Cost Optimization** pillar and click question **COST 6. How do you meet cost targets when you select resource type, size and number?** 
For **COST 6** question, there are the best practices that you are following from the list provided. If you need details about a best practice, choose Info and view the additional information and resources in the right panel.

* Perform cost modeling
* Select resource type, size, and number based on data
* Select resource type, size, and number automatically based on metrics

![Section4 COST6](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/COST6.png)


3. Scroll down to the bottom of Well-Architected Tool.  

![Section4 Notes](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/Notes.png)

{{< prev_next_button link_prev_url="../3_create_workload/" link_next_url="../5_expand_review/" />}}
