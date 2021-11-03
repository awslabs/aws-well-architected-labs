---
title: "Preparation for Failure Injection"
menutitle: "Failure Injection Prep"
date: 2021-09-14T11:16:08-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

**Failure injection** is the means by which we will simulate disruptive real-world events that affect production environments. Such events are used in **chaos engineering** to validate and understand the resiliency of your workload. **Chaos engineering** is a recommended practice of the [AWS Well-Architected Reliability Pillar](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/test-reliability.html). Here you will initiate various failure scenarios and assess how your workload reacts.

Before testing, please prepare the following:



### 3.1 Region must be **Ohio**
* We will be using the AWS Console to assess the impact of our testing
* Throughout this lab, make sure you are in the **Ohio** region

![SelectOhio](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/SelectOhio.png)

### 3.2 Get VPC ID
* A VPC (Amazon Virtual Private Cloud) is a logically isolated section of the AWS Cloud where you have deployed the resources for your service
* For these tests you will need to know the **VPC ID** of the VPC you created as part of deploying the service
1. Navigate to the VPC management console: <https://console.aws.amazon.com/vpc>
1. In the left pane, click **Your VPCs**
    * 1 - Tick the checkbox next to **ResiliencyVPC**
    * 2 - Copy the **VPC ID**

    ![GetVpcId](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/GetVpcId.png)

1. Save the VPC ID - you will use later whenever `<vpc-id>` is indicated in a command

### 3.3 View the website used for the test application for this lab {#website}

1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation>.
      * click on the `WebServersforResiliencyTesting` stack
      * click on the "Outputs" tab
      * For the Key `WebSiteURL` copy the value.  This is the URL of your test web service.
      ![CFNComplete](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CFNComplete.png)

1. Click the URL and it will bring up the website:  
    ![DemoWebsite](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/DemoWebsite.png)

    (image will vary depending on what you supplied for `websiteimage`)

1. Get familiar with the service website
      1. Note the **availability_zone** and **instance_id**
      1. Refresh this website several times watching these values
      1. Note the values change. You have deployed one web server per each of three Availability Zones.
         * The AWS Elastic Load Balancer (ELB) sends your request to any of these three healthy instances.
         * Refer to the diagram at the start of [Step 1](../1_deploy_infra/) to review your deployed system architecture.

    | |
    |:---:|
    |**Availability Zones** (**AZ**s) are isolated sets of resources within a region, each with redundant power, networking, and connectivity, housed in separate facilities. Each Availability Zone is isolated, but the Availability Zones in a Region are connected through low-latency links. AWS provides you with the flexibility to place instances and store data across multiple Availability Zones within each AWS Region for high resiliency.|
    |*__Learn more__: After the lab learn more about  [Regions and Availability Zones here](https://aws.amazon.com/about-aws/global-infrastructure/regions_az/)*|

{{< prev_next_button link_prev_url="../2_configure_env" link_next_url="../4_failure_injection_ec2/" />}}
