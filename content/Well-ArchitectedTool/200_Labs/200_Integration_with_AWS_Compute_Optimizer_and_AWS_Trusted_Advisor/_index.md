---
title: "Level 200: Integration with AWS Compute Optimizer and AWS Trusted Advisor"
#menutitle: "Lab #1"
date: 2021-01-15T11:16:09-04:00
chapter: false
weight: 1
hidden: false
---
 
## Authors
- **Jang Whan Han**, Solutions Architect, AWS Well-Architected
- **Phong Le**, Geo Solutions Architect, AWS Well-Architected
 
## Contributor
- **Ben Mergen**, Senior Cost Lead Solutions Architect, AWS Well-Architected
- **Stephen Salim**, Senior Geo Solutions Architect, AWS Well-Architected
 
## Introduction
 
The AWS Well-Architected Framework Review gives the opportunity for architects to discuss key architectural decisions with customers. One of the best ways to maximize the impact of the review is to be equipped with the necessary data points aligned to the workload. A reviewer can then use this collected data within their customer discussion to provide insight into areas of improvement providing a data driven experience for the customer. In this lab, we will focus on **rightsizing EC2 instances** in alignment with workload demand to provide data for a **cost optimization** review. This allows customers to see an immediate cost reduction benefit using insights from the data within the review. The purpose of this lab is to walk you through one of many integration examples with the Well-Architected Tool to conduct a data-driven Cost Optimization review using [AWS Cloud Financial Management Services](https://aws.amazon.com/aws-cost-management/). 
 
## Goals
 
* Identify cost optimization opportunities through a data-driven Well-Architected Framework Review
* Learn about AWS Cloud Financial Management Services.
* Evaluate Cost When Selecting Services
* Select the Correct Resource Type, Size, and Number
* Select the Best Pricing Model
 
## Prerequisites
To retrieve cost optimization data from AWS Compute Optimizer and AWS Trusted Advisor, there are a couple of prerequisites required.
 
* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you can use for testing, that is not used for production or other purposes.

* We assume that you already have Amazon EC2 instances up and running. We will not provision new EC2 instances to minimize your cost. 
 
* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to use Well-Architected Tool ([WellArchitectedConsoleFullAccess managed policy](https://docs.aws.amazon.com/wellarchitected/latest/userguide/security_iam_id-based-policy-examples.html#security_iam_id-based-policy-examples-full-access)).
 
* [Opt in for AWS Compute Optimizer](https://docs.aws.amazon.com/compute-optimizer/latest/ug/getting-started.html). You will need to opt in for AWS Compute Optimizer if you have not done so. 
 
* [AWS Trusted Advisor](https://aws.amazon.com/premiumsupport/knowledge-center/trusted-advisor-intro/) Amazon Trusted Advisor provides best practices (or checks) in four categories: cost optimization, security, fault tolerance, and performance improvement. This demo will use "Low Utilization Amazon EC2 Instances" check in Cost Optimization.
 
* [Attach AWS Tags](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/Using_Tags.html) to your existing AWS resources that you want to review against if you have not done so. 
 
## Costs
{{% notice note %}}
**NOTE:** You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}
* [AWS Pricing](https://aws.amazon.com/pricing/)
 
## Time to complete
- The lab should take approximately 30 minutes to complete
 
## Steps
{{% children /%}}
 
{{< prev_next_button link_next_url="./1_prerequisites/" button_next_text="Start Lab" first_step="true" />}}
