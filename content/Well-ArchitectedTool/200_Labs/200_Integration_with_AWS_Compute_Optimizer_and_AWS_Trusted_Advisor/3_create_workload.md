---
title: "Create a Well-Architected Workload with Tags"
date: 2020-12-17T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---
 
## Overview
Well-Architected Framework Reviews are conducted per workload. A workload is a collection of resources and code that delivers business value, such as a customer-facing application or a backend process. Let’s define a workload. 
 
1. We will start with creating a Well-Architected workload to use throughout this lab. Click **Define workload**.
![Section3 WATool](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section3/WATool.png)
 
2. If this is your first time using AWS WA Tool, you see [Defining a workload steps](https://docs.aws.amazon.com/wellarchitected/latest/userguide/define-workload.html) that introduces you to the features of the service. Now you can create a new Well-Architected workload:
 
![Section3 DefiningAWorkload](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section3/DefiningAWorkload.png)
 
The following are the required workload properties:
 
* workload-name - This is a unique identifier for the workload. Must be between 3 and 100 characters.
* description - A brief description of the workload. Must be between 3 and 250 characters.
* review-owner - The name, email address, or identifier for the primary individual or group that owns the review process. Must be between 3 and 255 characters.
* environment - The environment in which your workload runs. This must either be PRODUCTION or PREPRODUCTION
* aws-regions - The aws-regions in which your workload runs (us-east-1, etc).
* lenses - The list of lenses associated with the workload. All workloads must include the "wellarchitected" lens as a base, but can include additional lenses. 
 
3. When AWS lambda function retrieves cost optimization data, it will validate if Amazon EC2 Instances are being used for the particular workload that you defined in Well-Architected tool using Amazon Tags before ingesting data points into notes in Well-Architected Tool. Therefore, a reviewer can focus on EC2 Instances used only for the particular workload. Attach the same tags we have attached to Amazon EC2 Instances to this workload. Use **workload** as Key and **wademo** as Value.
AWS Lambda functions will verify if cost optimization data from AWS Compute Optimizer and AWS Trusted Advisor has the same tags as the following tags to ensure Amazon EC2 Instances are being used for this workload.
    ```
    Key = workload
    Value = wademo
    ```
![Section3 Tags](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section3/Tags.png)
 
4. Choose the lenses that apply to this workload. **AWS Well-Architected Framework** has been selected by default.
 
![Section3 Lenses](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section3/Lenses.png)
 
{{< prev_next_button link_prev_url="../2_configure_env/" link_next_url="../4_perform_review/" />}}
 
