---
title: "Configure Lab Environment"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 3
pre: "<b>2. </b>"
---


## Overview
The following example scenario is referenced in this lab:

Your company has a workload running on an Amazon EC2 instance. You have a number of API calls served and measured as metrics to quantify the achievement of business outcomes.

In this section, we will deploy our base lab infrastructure using AWS CloudFormation as follows:
![Section2 Architecture](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/lab_architecture.png)

Note the following:

1. As part of the deployment steps, **3 API calls per minute** will be generated continuously and these activities will be logged to **access_log** in **/var/log/httpd**.

2. **Access log data** will automatically be forwarded to log group in Amazon CloudWatch. You will use this log when you define your **business metrics**.

3. There will be a new customized metric created to monitor **the total number of vCPU of Amazon EC2 instance** in the Sustainability namespace in Amazon CloudWatch. You will use this metric as **proxy metric** to inform the sustainability KPI.

4. You will analyze a workload's configuration and resource utilization to identify Amazon EC2 instances that might be **overprovisioned or underprovisioned**. You will make changes based on AWS Compute Optimizer's recommendations for right-sizing Amazon EC2 instances.


### 2.1. Get the CloudFormation Template and Deploy it.

You can get the first CloudFormation template used in this lab [here.](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Code/SustainabilityDemo.yaml "Section2 CFTemplate")

The first CloudFormation template will deploy an Amazon EC2 Instance, log group and metrics in Amazon CloudWatch. You can create a CloudFormation Stack directly via the AWS console.

#### Console:

If you need detailed instructions on how to deploy a CloudFormation stack from within the console, please follow this [guide.](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html)

1. Open the CloudFormation console at [https://console.aws.amazon.com/cloudformation](https://console.aws.amazon.com/cloudformation/) and select any region you would like to use. Click **create a stack**. 
![Section2 CFStack](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/CFStack.png)

2. Select the stack template which you downloaded earlier, and click **choose file** to upload **SustainabilityDemo.yaml** and click **Next**.
![Section2 Upload_CFStack](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/upload_CFStack.png)

For the stack name use any stack name you can identify and click **Next**. For this case, I used sustainability-demo as a stack name.
![Section2 StackName](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/stackName.png)

3. Skip stack options and click **Next**.
![Section2 StackOptions](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/stackOptions.png)

4. Scroll down to the bottom of the stack creation page and acknowledge the IAM resources creation by selecting **all the check boxes**. Then launch the stack. It may take 5 minutes to complete the baseline deployment.
![Section2 IAM](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/IAM.png)

5. Now go to your newly created stack and go to the **Outputs** section of the CloudFormation stack. Then, click **WebsiteURL** to make sure this deployment has been successfully completed.
![Section2 output](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/output.png)

6. It may take 2~3 minutes to see the following website. The script in UserData will automatically generate 3 API calls per a minute continuously. No action is required here.
![Section2 website](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/website.png)


### 2.2. Verify Baseline Infrastructure.

1. Search for EC2 service in AWS Console and click EC2 from Services.
![Section2 ec2](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/ec2.png)

2. The EC2 service will show an Amazon EC2 Instance called **SustainabilityApp**. The instance type will show as **t4g.xlarge** powered by **Arm-based Amazon Graviton2 processors**. If you select the **Monitoring** tab, you will notice the CPU utilization will be ~12-13%.
{{% notice note %}}
**Note** - It may take 5~10 minutes for CPU metrics to be shown in the monitoring tab.
{{% /notice %}}
![Section2 utilization](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/utilization.png)

3. Search for CloudWatch in AWS Console and click CloudWatch from Services.
![Section2 cloudwatch](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/cloudwatch.png)

4. Click **Log groups** and make sure there is log group called **httpd_access_log**.
![Section2 httpd_access_log](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/httpd_access_log.png)

5. Expand **Metrics** and click **All metrics**. In Custom namespaces, there will be a namespace named **Sustainability**. Click Sustainability.
![Section2 custom_namespace](/Sustainability/200_optimize_hardware_patterns_observe_sustainability_KPIs/Images/section2/custom_namespace.png)


### Congratulations!
You have completed this section of the lab. In this section you successfully deployed the first AWS CloudFormation template of the lab and confirmed the relevant resources were created using the AWS Console.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="../1_prerequisites" link_next_url="../3_baseline_sustainability_kpi" />}}
