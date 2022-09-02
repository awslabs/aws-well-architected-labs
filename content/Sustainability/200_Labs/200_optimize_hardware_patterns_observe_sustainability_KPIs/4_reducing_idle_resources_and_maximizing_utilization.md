---
title: "Reducing idle resources and maximizing utilization"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 5
pre: "<b>4. </b>"
---

As per the previous section of the lab, our sustainability improvement goals are:
- To eliminate waste, low utilization, and idle or unused resources.
- To maximize the value from resources you consume.


This section of the lab will allow you to learn more about the following [design principles](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/design-principles-for-sustainability-in-the-cloud.html) in the AWS Well-Architected Sustainability Pillar documentation:
* Maximize utilization
* Anticipate and adopt new, more efficient hardware and software offerings

You will improve the sustainability KPIs by optimizing the following hardware patterns:
* Right-size Amazon EC2 Instance using AWS Compute Optimizer recommendations.
* Continually monitor and evaluate more efficient hardware offerings.



### 4.1. Optimizing the Compute Layer of your AWS Infrastructure

We will now use the AWS Compute Optimizer service to rightsize your EC2 resources. AWS Compute Optimizer uses a combination of machine learning and historical trend information to provide efficiency recommendations for your workload. Follow the steps below to rightsize your compute environment:

{{% notice note %}}
**Note** - To see recommendations from the AWS Compute Optimizer dashboard, you will need to let your Amazon EC2 Instance run for 42 hours, which will incur costs generated from EC2(t4g.xlarge) in your AWS account. You can refer to the screenshots in this lab to minimize costs from EC2.
{{% /notice %}}

1. Search for compute optimizer in AWS console and select AWS Compute Optimizer from Services.
![Section4 compute_optimizer](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section4/compute_optimizer.png)

2. Scroll down to the bottom of the dashboard and click **View Recommendations** as shown:
![Section4 dashboard](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section4/dashboard.png)
![Section4 dashboard2](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section4/dashboard2.png)

3. As you can see, AWS Compute Optimizer has evaluated the EC2 instance for SustainabilityApp as over-provisioned. It is therefore possible to rightsize the instance while still meeting the performance requirements of your workload. Click **Over-provisioned** to see more details.

    Please see three finding classifications [here](https://docs.aws.amazon.com/compute-optimizer/latest/ug/view-ec2-recommendations.html#ec2-recommendations-findings).
![Section4 finding](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section4/finding.png)

4. Based on the workload for the past 12 hours, AWS Compute Optimizer recommends that **2 vCPUs with 4 GiB memory** are optimal compute resources to deliver your business outcomes.
![Section4 recommendations](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section4/recommendations.png)

5. The CPU utilization graph compares the CPU utilization data of your current instance type against the recommended instance type. It appears to be 13% CPU utilization with current t4g.xlarge instance. If you replaced it with c6g.large, you would estimate 28% of the CPU utilization.
![Section4 cpu_utilization](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section4/cpu_utilization.png)

### 4.2. Rightsize Instance Type

We will now action the recommendations which were given to us by the AWS Compute Optimizer, changing our existing t4g.xlarge instance type for a c6g.large. Complete the following steps to action the instance type change:

You can get the CloudFormation template [here.](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Code/SustainabilityDemo-c6g.yaml "Section4 CFTemplate")

The second CloudFormation template will replace your current instance with **c6g.large**. You can create a CloudFormation Stack directly via the AWS console.

#### Console:

If you need detailed instructions on how to deploy a CloudFormation stack from within the console, please follow this [guide.](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html)

1. Open the CloudFormation console at [https://console.aws.amazon.com/cloudformation](https://console.aws.amazon.com/cloudformation/) and select the correct region you used to deploy this lab.

    Select the previous CloudFormation stack you deployed and click **Update**.
![Section4 update_stack](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section4/update_stack.png)

2. Select **Replace current template** and **Upload a template file**. Click **Choose file** to upload **SustainabilityDemo-c6g.yaml**. Then Click **Next**.
![Section4 select_update_stack](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section4/select_update_stack.png)

3. Click **Next**.
![Section4 stack_details](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section4/stack_details.png)

4. Scroll down to the bottom to click **Next**.
![Section2 StackOptions](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/stackOptions.png)

5. Scroll down to the bottom of the stack creation page and acknowledge the IAM resources creation by selecting all the check boxes. Then click **Update stack**. It may take 3 minutes to replace EC2 instance.
![Section4 IAM](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section4/IAM.png)

6. Search for EC2 service in AWS console and click EC2 from Services.
![Section4 ec2](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section4/ec2.png)

7. You have now actioned the recommended changes from AWS Compute Optimizer, replacing your existing **t4g.xlarge** instance with **c6g.large**. The previous sustainability KPIs which we calculated will now have been automatically updated.
![Section4 ec2_details](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section4/ec2_details.png)

8. Wait for 5~10 minutes to see CPU utilization.

### 4.3. Applying Hardware Patterns Best Practices for Sustainability in the cloud

1. With our new c6g.large instance, CPU utilization appears to be running at ~26% compared to the previous utilization levels of ~13%. This has dramatically reduced the amount of our idle resources and allowed us to still meet our performance requirements.
![Section5 cpu_utilization](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section5/cpu_utilization.png)


In this section, you successfully replaced t4g.xlarge with c6g.large using the second AWS CloudFormation template of the lab. You generated API calls in a replaced Amazon EC2 instance. We will use these newer metrics next to review the improvements against our sustainability KPI.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../3_baseline_sustainability_kpi" link_next_url="../5_review_sustainability_kpi_optimization" />}}
