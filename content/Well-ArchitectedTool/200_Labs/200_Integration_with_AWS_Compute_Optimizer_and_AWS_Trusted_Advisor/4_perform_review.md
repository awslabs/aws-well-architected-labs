---
title: "Performing a data-driven review"
date: 2020-12-17T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---
 
![Section4 Integration](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/TA_Aco_integration.png)
 
## Overview
Now that we have defined a workload, we will review the question **COST 6. How do you meet cost targets when you select resource type, size, and number**. 
Defining a workload generates an event called **CreateWorkload** that Amazon EventBridge receives, invoking the AWS Lambda function that collects cost optimization data from AWS Compute Optimizer and AWS Trusted Advisor. Then, this data will be automatically available before the review, reviewer and customer could have a data-driven cost optimization review.
 
1. To start AWS Well-Architected Framework Review, click **Continue reviewing** and select **AWS Well-Architected Framework Lens**.
 
![Section4 WAFR](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/WAFR.png)
 
2. Choose **Cost Optimization** pillar and click question **COST 6. How do you meet cost targets when you select resource type, size and number?** 
For **COST 6** question, the following best practices are what a reviewer will validate with customers. Now you assume that you are a reviewer and may create your own question to determine whether customers have implemented them. 
* Perform cost modelling
* Select resource type, size, and number based on data
* Select resource type, size, and number automatically based on metrics

For example, let’s take a scenario of right-sizing an Amazon EC2 Instance and we assume we do not have enough data that supports your answer. 
![Section4 Review1](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/Review1.png)

The methodology that the customer used to determine the size of EC2 Instance is not bad approach, but it does not tell whether the current resources are optimized based on the actual usage from a cost and performance standpoint. Then, the reviewer will try to identify if vCPU, memory, and storage are the most cost optimized by asking a follow-up question as follows:
![Section4 Review2](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/Review2.png)

To answer this question, customer should have implemented monitoring to capture the historical utilization data of EC2 instance over a period of time prior to the review. Otherwise, that is where the conversation ends. 
![Section4 COST6](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/COST6.png)
 
3. Scroll down to the bottom of Well-Architected Tool. 
  
![Section4 Notes](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/Notes.png)

{{% notice note %}}    
**NOTE:** Maximum length of characters in Notes is 2084.
{{% /notice %}}

 
Now Data that contains the CPU, network, disk and volume metrics is automatically available for the reviewer and customers. Now reviewer can have a data-driven cost optimization review with customer as follows:
![Section4 Review3](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/Review3.png)
Now that customer can see an immediate cost benefit from data, this will help them prioritize saving opportunities based on the criticality of the business. With these insights before a review, the reviewer managed to take the previous conversation to the next level. 


{{< prev_next_button link_prev_url="../3_create_workload/" link_next_url="../5_expand_review/" />}}
