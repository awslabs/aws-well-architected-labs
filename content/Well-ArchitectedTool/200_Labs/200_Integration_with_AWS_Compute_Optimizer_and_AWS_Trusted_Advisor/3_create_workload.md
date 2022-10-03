---
title: "Create a Well-Architected Workload with Tags"
date: 2020-12-17T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---
 
Let’s define a workload and associate the necessary AWS tags with it. The Well-Architected Framework Reviews are conducted per workload. A workload is a collection of resources and code that delivers business value, such as a customer-facing application or a backend process. 
 
1. We will start with creating a workload in the Well-Architected Tool. Click **Define workload** associated with the necessary AWS tags.
![Section3 WATool](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section3/WATool.png)
 
2. Now you can [define a workload](https://docs.aws.amazon.com/wellarchitected/latest/userguide/define-workload.html):
 
![Section3 DefiningAWorkload](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section3/DefiningAWorkload.png)
 
The following are the required workload properties:
 
* workload-name - This is a unique identifier for the workload. Must be between 3 and 100 characters.
* description - A brief description of the workload. Must be between 3 and 250 characters.
* review-owner - The name, email address, or identifier for the primary individual or group that owns the review process. Must be between 3 and 255 characters.
* environment - The environment in which your workload runs. This must either be PRODUCTION or PREPRODUCTION
* aws-regions - The aws-regions in which your workload runs (us-east-1, etc).
* lenses - The list of lenses associated with the workload. All workloads must include the "wellarchitected" lens as a base, but can include additional lenses. 


3. You need to attach the same tags associated with your EC2 instances. 
    ```
    Key = Environment
    Value = watooldemo
    ```
![Section3 Tags](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section3/Tags.png)

{{% notice note %}}
**Note:** AWS Lambda function will use AWS Tags to determine if EC2 instances are being used for a new workload you defined.  
AWS Lambda functions will only ingest data into Notes when tags on EC2 Instance and workload are the same.
{{% /notice %}}

4. Choose the lenses that apply to this workload. **AWS Well-Architected Framework** has been selected by default.
 
![Section3 Lenses](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section3/Lenses.png)

## Congratulations! 

You have defined a workload to review.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../2_configure_env/" link_next_url="../4_perform_review/" />}}
 
