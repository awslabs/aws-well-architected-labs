---
title: "Performing a data-driven review"
date: 2020-12-17T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

As you can see from the following diagram, you will see data in **Notes** under COST 6 in the Well-Architected Tool.

![Section4 Integration](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/TA_Aco_integration.png)

{{% notice note %}}
**Note:**  If there was no data in Notes, ensure that you had attached the same tags to workload and EC2 instances.
{{% /notice %}}


We have data availabe in Notes, we will review the question [COST 6](https://wa.aws.amazon.com/wat.question.COST_6.en.html).   

Defining a workload generates an API event called **CreateWorkload** that Amazon EventBridge receives, invoking the AWS Lambda function that collects cost optimization data. Then, this data will be automatically available before the review.
 
1. To start AWS Well-Architected Framework Review, click **Continue reviewing** and select **AWS Well-Architected Framework Lens**.
 
![Section4 WAFR](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/WAFR.png)

2. Choose the **Cost Optimization** pillar and click question **COST 6**.
![Section4 COST6](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/COST6.png)

For this question, the following best practices will need to be validated:

* Perform cost modelling
* Select resource type, size, and number based on data
* Select resource type, size, and number automatically based on metrics

Without any data to reference during this question, lots of follow-up questions are necessary to gain the level of information required to answer the question as shown here:
![Section4 Review1](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/Review1.png)


However, with our automation implementation we can simply refer to the notes section of the review and use the information as talking points within our discussion.
 
3. Scroll down to the bottom of Well-Architected Tool. 
![Section4 Notes](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/Notes.png)
{{% notice note %}}    
**NOTE:** Maximum length of characters in Notes is 2084.
{{% /notice %}}

Now Data that contains the CPU, network, disk and volume metrics is automatically available for the reviewer and customers. Reviewer can have a data-driven cost optimization review with customer as follows:
![Section4 Review3](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section4/Review2.png)



{{< prev_next_button link_prev_url="../3_create_workload/" link_next_url="../5_expand_review/" />}}
