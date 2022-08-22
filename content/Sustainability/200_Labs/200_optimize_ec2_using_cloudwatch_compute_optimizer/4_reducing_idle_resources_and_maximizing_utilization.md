---
title: "Reducing idle resources and maximizing utilization"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 5
pre: "<b>4. </b>"
---

# Overview

Recall, our sustainability improvement goal is:
- To eliminate waste, low utilization, and idle or unused resources.
- To maximize the value from resources you consume.

You will learn more about the following [design principles](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/design-principles-for-sustainability-in-the-cloud.html) in AWS Well-Architected Sustainability Pillar:
* Maximize utilization
* Anticipate and adopt new, more efficient hardware and software offerings

We shall achieve this by optimizing hardware patterns:
* Right-size Amazon EC2 Instance using AWS Compute Optimizer recommendations
* Continually monitor and evaluate new, more efficient hardware and software offerings



### 4.1. Optimizing the compute layer of your AWS Infrastructure

We are going to use AWS Compute Optimizer that recommends optimal AWS resources for your workloads to reduce costs and improve performance by using machine learning to analyze historical utilization metrics. 

{{% notice note %}}
**Note** - It may take up to 12 hours for AWS Compute Optimizer to fully analyze the AWS resources in your account, which will incur costs in your account. You may refer to the following screenshots instead to minimize your cost for this lab. 
{{% /notice %}}

1. Search compute optimizer and select AWS Compute Optimizer from Services.
![Section4 compute_optimizer](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/compute_optimizer.png)

2. Savings opportunity, performance improvement opportunity, and optimization findings for your resources are displayed on the Compute Optimizer dashboard. Scroll down to the bottom and click **View recommendations**.
![Section4 dashboard](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/dashboard.png)
![Section4 dashboard2](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/dashboard2.png)

3. EC2 instance for SustainabilityApp was considered over-provisioned, which can be sized down while still meeting the performance requirements of your workload. Click **Over-provisioned** to see more details.

    Please see three finding classifications [here](https://docs.aws.amazon.com/compute-optimizer/latest/ug/view-ec2-recommendations.html#ec2-recommendations-findings).
![Section4 finding](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/finding.png)

4. Based on the workload for the past 12 hours, AWS Compute Optimizer recommends that **2 vCPUs with 4 GiB memory** are optimal compute resources to meet performance requirements as well as to deliver your business outcomes. One thing you need to carefully look into this recommended options is **CPU Architecture** in **Platform differences** before you select. You will need additional migration efforts to change instance type if CPU Architecture is different. 
For this case, the current **t4g.xlarge** instance is AWS Graviton2 processor based on the Arm64 architecture. We can simply change instance type as option 1,2, and 3 are all the same AWS Graviton2 processors.
**c6g.large** seems to be the best instance type from performance and cost efficiency perspective.
![Section4 recommendations](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/recommendations.png)

5. The CPU utilization graph includes a comparison of the CPU utilization data of your current instance type against that of the selected recommended instance type. It appears to be 13% CPU Utilization with current t4g.xlarge instance. If you replaced t4g.xlarge with c6g.large, you would estimate 28% of the CPU utilization.
![Section4 cpu_utilization](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/cpu_utilization.png)

### 4.2. Optimizing the compute layer of your AWS Infrastructure

You can get the CloudFormation template [here.](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Code/SustainabilityDemo-c6g.yaml "Section4 CFTemplate")

The second CloudFormation template will replace **t4g.xlarge** with **c6g.large**. You can create CloudFormation Stack directly via the AWS console.

{{%expand "Click here for CloudFormation console deployment steps"%}}
#### Console:

If you need detailed instructions on how to deploy CloudFormation stacks from within the console, please follow this [guide.](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html)

1. Open the CloudFormation console at [https://console.aws.amazon.com/cloudformation](https://console.aws.amazon.com/cloudformation/) and select the correct region you used to deploy this lab.

    Select the previous CloudFormation stack you used and click **Update**.
![Section4 update_stack](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/update_stack.png)

2. Select **Replace current template** and **Upload a template file**. Click **Choose file** to upload **SustainabilityDemo-c6g.yaml**. Then Click **Next**.
![Section4 select_update_stack](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/select_update_stack.png)

3. Click **Next**.
![Section4 stack_details](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/stack_details.png)

4. Scroll down to the bottom to click **Next**.
![Section4 advanced_options](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/advanced_options.png)

5. Scroll down to the bottom of the stack creation page and acknowledge the IAM resources creation by selecting all the check boxes. Then click **Update stack**. It may take 3 minutes to replace EC2 instance.
![Section4 IAM](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/IAM.png)

6. Search EC2 and click EC2 from Services.
![Section4 ec2](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/ec2.png)

7. Now you successfully replaced **t4g.xlarge** with **c6g.xlarge**. Let's generate the same workloads to compare sustainability KPI we previously created using CloudWatch metrics with metric math function. Tick a box to **select SustainabilityApp** and click **Connect**.
![Section4 ec2_details](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/ec2_details.png)

8. Connect to instance. Click **Connect**.
![Section4 connect](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/connect.png)

9. Generate the same workload using the following curl.
    ```
    screen -d -m watch -n 20 "curl 'http://127.0.0.1/load.php'"
    ```
![Section4 workloads](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/workloads.png)
    Wait for 5~10 minutes to see Sustainability KPI metrics in Amazon CloudWatch.
{{% /expand%}}


{{% notice note %}}
**Note** - Remind you of "**Anticipate and adopt new, more efficient hardware and software offerings**" design principle in Sustainability pillar. AWS Graviton3 processors instance use up to **60 percent less energy** for the same performance as comparable EC2 instances, which helps you **reduce your carbon footprint**. AWS Compute Optimizer will recommend Graviton3 instance types soon.
{{% /notice %}}
c6g.large is **AWS Graviton2** processors that deliver up to 40% better price performance over comparable current generation x86-based instances for a variety of workloads. However, AWS also announced **AWS Graviton3** processors that deliver up to 25 percent higher performance, up to 2x higher floating-point performance, and 50 percent faster memory access based on leading-edge DDR5 memory technology compared with Graviton2 processors. 

Let's see which AWS Graviton3 processors instance type has **2 vCPUs with 4 GiB memory**. 
You can see [Amazon EC2 instance types](https://aws.amazon.com/ec2/instance-types/#Compute_Optimized) and click [here](https://aws.amazon.com/ec2/pricing/on-demand/) to see its On-Demand price.
![Section4 ec2_types](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/ec2_types.png) 


{{< prev_next_button link_prev_url="../3_baseline_sustainability_kpi" link_next_url="../5_review_sustainability_kpi_optimization" />}}
