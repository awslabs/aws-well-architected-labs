---
title: "Deploy the workload"
menutitle: "Deploy workload"
date: 2020-12-07T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

Traditionally most workloads are designed to withstand infrastructure failure by deploying workload components across multiple Availability Zones/Regions, implementing self-healing capabilities such as AutoScaling, etc. While such techniques are effective in ensuring uptime of workload resources, they do not address issues introduced at the workload application level (i.e. a software bug). Leveraging techniques like sharding and shuffle sharding will provide additional reliability to workloads by limiting the blast radius of failures so that only a subset of users are impacted by such failures.

The following diagram shows the initial architecture you will deploy.  This architecture has **_no_** sharding:
![ArchitectureRegular](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/Architecture-regular.png?classes=lab_picture_auto)

You will use AWS CloudFormation to provision the resources needed for this lab. The CloudFormation stack that you provision will create an Application Load Balancer, Target Groups, and EC2 instances in a new VPC.

### 1.1 Log into the AWS console {#awslogin}

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

{{%expand "Click here for instructions to access your assigned AWS account:" %}} {{% common/Workshop_AWS_Account noCreds="true" %}} {{% /expand%}}

**If you are using your own AWS account**:
{{%expand "Click here for instructions to use your own AWS account:" %}}
* Sign in to the AWS Management Console as an IAM user who has PowerUserAccess or AdministratorAccess permissions, to ensure successful execution of this lab.
{{% /expand%}}

### 1.2 Deploy the workload using AWS CloudFormation

1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation> and click **Create Stack** > **With new resources (standard)**

    ![CFNCreateStackButton](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNCreateStackButton.png?classes=lab_picture_auto)

1. For **Prepare template** select **Template is ready**

    * For **Template source** select **Amazon S3 URL**
    * In the text box under **Amazon S3 URL** specify `https://aws-well-architected-labs-virginia.s3.amazonaws.com/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/regular.yaml`

    ![CFNSpecifyTemplate](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNSpecifyTemplate.png?classes=lab_picture_auto)

1. Click **Next**
1. For **Stack name** use `Shuffle-sharding-lab`
1. No changes are required for **Parameters**. Click **Next**
1. For **Configure stack options** click **Next**
1. On the **Review** page:
    * Scroll to the end of the page and select **I acknowledge that AWS CloudFormation might create IAM resources with custom names.** This ensures CloudFormation has permission to create resources related to IAM. Additional information can be found [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html).

    **Note:** The template creates an IAM role and Instance Profile for EC2. These are the minimum permissions necessary for the instances to be managed by AWS Systems Manager. These permissions can be reviewed in the CloudFormation template under the "Resources" section - **InstanceRole**.

    * Click **Create stack**

    ![CFNIamCapabilities](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNIamCapabilities.png?classes=lab_picture_auto)

This will take you to the CloudFormation stack status page, showing the stack creation in progress.

  * Click on the **Events** tab
  * Scroll through the listing. It shows (in reverse order) the activities performed by CloudFormation, such as starting to create a resource and then completing the resource creation.
  * Any errors encountered during the creation of the stack will be listed in this tab.

The stack takes about 5 mins to create all the resources. Periodically refresh the CloudFormation stack events until you see that the **Stack Status** is in **CREATE_COMPLETE**. The stack creates the following resources:

* A new VPC, subnets, Internet Gateway, Route tables to host the workload in
* 8 EC2 instances that host the application
* An Application Load Balancer, Listener and rules, and Target Groups to route traffic
* IAM resources (roles, policies) that allow the EC2 instances to be managed by AWS Systems Manager
* An SSM Document that will be run on the instances
* CloudWatch Synthetics canaries
* IAM role and S3 bucket for the canaries

Once the stack is in **CREATE_COMPLETE**, visit the **Outputs** section for the stack and note down the **Key** and **Value** for each of the outputs. This information will be used in the lab.

### 1.3 Test the application

Now that the application has been deployed, it is time to test it to understand how it works. The sample application used in this lab is a simple web application that returns a message with the **Worker** that responded to the request. Customers pass in a query string as part of the request to identify themselves. The query string used here is **name**.

1. Visit the **Outputs** section of the CloudFormation stack created in the previous step. You will see a list of URLs next to customer names.

    ![CFNOutputs](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNOutputs.png?classes=lab_picture_auto)

1. Open one of the customer links in a new browser tab. Refresh the web browser a few times to see that responses are being returned from different EC2 instances on the back-end.
    * The list of EC2 instances in your workload can be viewed in the [AWS Console here](https://console.aws.amazon.com/ec2/v2/home?#Instances:tag:Name=Worker)

    ![RegularAlpha](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/RegularAlpha.png?classes=lab_picture_auto)

1. Open the links for a few other customers and verify that they are able to get responses from different EC2 instances. The different customers are - **Alpha**, **Bravo**, **Charlie**, **Delta**, **Echo**, **Foxtrot**, **Golf**, and **Hotel**.
    * Note that the URLs all have the same base URL but use a query string to represent different customers. The query string used is **name**.

1. Refresh the web browser multiple times to verify that _all_ customers are able to receive responses from _all_ EC2 instances (workers) in the back-end.

### 1.4 Verify workload availability

The lab uses [Amazon CloudWatch Synthetics canaries](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Synthetics_Canaries.html) to check availability of the workload for each of the customers. The results are aggregated in a [CloudWatch Dashboard](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html) so you can see the availability of the workload for every customer in a single location.

1. Visit the **Outputs** section of the CloudFormation stack created as part of this lab and open the **AvailabilityDashboard** in a new browser window.

    ![CFNOutputsDashboard](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNOutputsDashboard.png?classes=lab_picture_auto)

1. You will see individual graphs for each customer. The graphs represent successful requests made by the corresponding canary to the sample workload. Currently, the workload is available for all customers.

    ![DashboardRegular](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/DashboardRegular.png?classes=lab_picture_auto)

1. Keep the **AvailabilityDashboard** open as you will revisit it later in the lab.

{{< prev_next_button link_prev_url="../" link_next_url="../2_impact_of_failures/" />}}
