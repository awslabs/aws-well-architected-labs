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

AWS Compute Optimizer for rightsizing - TBD

{{% notice note %}}
**Note** - It may take up to 12 hours for AWS Compute Optimizer to fully analyze the AWS resources in your account,which will incur costs in your account.You may refer to the follwing screenshots instead to minimize the cost for this lab. 
{{% /notice %}}

### 4.1. Optimizing the compute layer of your AWS Infrastructure

1. Search compute optimizer and select AWS Compute Optimizer from Services.
![Section4 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/compute_optimizer.png)

2. Savings opportunity, performance improvement opportunity, and optimization findings for your resources are displayed on the Compute Optimizer dashboard. Scroll down to the bottom and click **View recommendations**.
![Section4 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/dashboard.png)
![Section4 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/dashboard2.png)

3. EC2 instance for SustainabilityApp was considered over-provisioned, which can be sized down while still meeting the performance requirements of your workload. Click **Over-provisioned** to see more details.

    Please see three finding classifications [here](https://docs.aws.amazon.com/compute-optimizer/latest/ug/view-ec2-recommendations.html#ec2-recommendations-findings).
![Section4 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/finding.png)

4. Based on the workload for the past 12 hours, AWS Compute Optimizer analyzed that 2 vCPUs are optimal compute resources to reduces idle resources and to meet performance requirement to deliver your business outcomes. One thing you need to carefully look into this recommended options is **CPU architecture** in **Platform differences** before you select. For this case, the current **t4g.xlarge** instance is a custom-built processor from AWS that’s based on the Arm64 architecture. We will select **c7g.xlarge** that is the same CPU Architecture and uses up to 60 percent less energy for the same performance as comparable EC2 instances, which helps you reduce your carbon footprint.
Graviton3 processors, deliver up to 25 percent higher performance, up to 2x higher floating-point performance, and 50 percent faster memory access based on leading-edge DDR5 memory technology compared with Graviton2 processors.
![Section4 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/recommendations.png)

5. The CPU utilization graph includes a comparison of the CPU utilization data of your current instance type against that of the selected recommended instance type.
![Section4 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/cpu_utilization.png)


### 4.2. Optimizing the compute layer of your AWS Infrastructure

You can get the CloudFormation template [here.](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Code/SustainabilityDemo-c7g.yaml "Section4 CFTemplate")

The firsecond CloudFormation template will replace **t4g.xlarge** with **c7g.xlarge**. You can create CloudFormation Stack directly via the AWS console.

{{%expand "Click here for CloudFormation console deployment steps"%}}
#### Console:

If you need detailed instructions on how to deploy CloudFormation stacks from within the console, please follow this [guide.](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html)

1. Open the CloudFormation console at [https://console.aws.amazon.com/cloudformation](https://console.aws.amazon.com/cloudformation/) and select the correct region you used to deploy this lab.

    Select the previous CloudFormation stack you used and click **Update**.
![Section4 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/update_stack.png)

2. Select **Replace current template** and **Upload a template file**. Click **Choose file** to upload **SustainabilityDemo-c7g.yaml**. Then Click **Next**.
![Section4 Upload_CFStack](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/select_update_stack.png)

3. Click **Next**.
![Section4 Upload_CFStack](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/stack_details.png)

4. Scroll down to the bottom to click **Next**.
![Section4 Upload_CFStack](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/advanced_options.png)

5. Scroll down to the bottom of the stack creation page and acknowledge the IAM resources creation by selecting all the check boxes. Then click **Update stack**. It may take 3 minutes to replace EC2 isnstance.
![Section4 Upload_CFStack](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/IAM.png)

6. Search EC2 and click EC2 from Services.
![Section4 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/ec2.png)

7. Now you successfully repalced **t4g.xlarge** with **c7g.xlarge**. Let's generate the same workloads to compare sustainability KPI we previously created using CloudWatch metrics with metric math function. Tick a box to **select SustainabilityApp** and click **Connect**.
![Section4 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/ec2_details.png)

8. Connect to instance. Click **Connect**.
![Section4 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/connect.png)

9. Generate the same workload using the following curl.
    ```
    screen -d -m watch -n 20 "curl 'http://127.0.0.1/load.php'"
    ```
![Section4 StackOptions](/Sustainability/200_optimize_ec2_using_cloudwatch_compute_optimizer/Images/section4/workloads.png)
    Wait for 5~10 minutes to see metrics in Amazon CloudWatch.
{{% /expand%}}


{{< prev_next_button link_prev_url="../3_baseline_sustainability_kpi" link_next_url="../5_review_sustainability_kpi_optimization" />}}
