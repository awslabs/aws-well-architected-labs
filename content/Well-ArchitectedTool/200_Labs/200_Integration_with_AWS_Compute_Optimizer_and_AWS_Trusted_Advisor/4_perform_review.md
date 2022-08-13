---
title: "Performing a data-driven review"
date: 2020-12-17T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

![Section4 Integration](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/TA_Aco_integration.png)

## Overview
Now that we have defined a workload, we will review the question **COST 6. How do you meet cost targets when you select resource type, size and number**. 
Defining a workload generates an event called **CreateWorkload** that Amazon EventBridge receives, which will invoke AWS Lambda function that collects cost optimization data from AWS Compute Optimizer and AWS Trusted Advisor. Then this data will be automatically available before the review, reviewer and customer could have a data-driven cost optimization review.

1. To start AWS Well-Architected Framework Review, click **Continue reviewing** and select **AWS Well-Architected Framework Lens**.

![Section4 WAFR](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/WAFR.png)

2. Choose **Cost Optimization** pillar and click question **COST 6. How do you meet cost targets when you select resource type, size and number?** 
For **COST 6** question, the following best practices are what a reviewer is going to validate with customers. Now you assume that you are a reviewer and may create your own question to evaluate if customers have implemented them. 
* Perform cost modelling
* Select resource type, size, and number based on data
* Select resource type, size, and number automatically based on metrics

Without having any data, you can ask **"How do you match instance types and sizes to your workload at the lowest cost?"**.
If so, customer may be able to answer **"We refer to vCPU mapping for each Amazon EC2 instance type and then select the lowest priced instance."**. 

The mechanism that customer shared is not too bad but it does not tell whether the current resources are actually optimized based on the current usage from a cost and performance standpoint. Then, the reviewer will try to understand the current state from this customer by asking a follow-up question like **”How do you know if vCPU, memory, storage are currently optimized for your workload?”**.
To answer this question, customer should have collected the historical utilization data prior to the review and the conversation end. 

![Section4 COST6](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/COST6.png)

3. Scroll down to the bottom of Well-Architected Tool. 

Now data which contains the CPU, network, disk and volume metrics is automatically available for the reviewer and customers. The reviewer can rephrase the previous question based on the data that AWS Compute Optimizer and AWS Trusted Advisor provided.
Rather than asking how do you know if your resources are currently optimized, reviewer can have a data-driven cost optimization review with customer. 

The reviewer may ask **"Your largest instance is CPU over-provisioned and we could potentially save you 74% cost on that with t4g.xlarge instance type. Customer, how do you feel about us working with you to make it happen?"**. 
Now that customer can see an immediate cost benefit from data, this will enable customer to prioritize saving opportunities depending on business criticality. With these insights prior to a review, the reviewer managed to take the previous conversation to the next level. 

![Section4 Notes](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/Notes.png)

{{< prev_next_button link_prev_url="../3_create_workload/" link_next_url="../5_expand_review/" />}}
