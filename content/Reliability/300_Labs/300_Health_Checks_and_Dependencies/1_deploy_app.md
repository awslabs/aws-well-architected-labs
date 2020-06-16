---
title: "Deploy the Infrastructure and Application"
menutitle: "Deploy Application"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

You will create a multi-tier architecture using AWS and run a simple service on it. The service is a web server running on Amazon EC2 fronted by an Elastic Load Balancer reverse-proxy, with a dependency on Amazon DynamoDB.

**Note**: The concepts covered by this lab apply whether your service dependency is an AWS resource like Amazon DynamoDB, or an external service called via API. The DynamoDB dependency here acts as a _mock_ for an external service called **RecommendationService**. The **getRecommendation** API on this service is a dependency for the web service used in this lab.  **getRecommendation** is actually a `get_item` call to a DynamoDB table.

![ArchitectureOverview](/Reliability/300_Health_Checks_and_Dependencies/Images/ArchitectureOverview.png)

### 1.1 Log into the AWS console {#awslogin}

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

{{% expand "Click here for instructions to access your assigned AWS account:" %}} {{% common/Workshop_AWS_Account %}} {{% /expand %}}

**If you are using your own AWS account**:
{{% expand "Click here for instructions to use your own AWS account:" %}}
* Sign in to the AWS Management Console as an IAM user who has PowerUserAccess or AdministratorAccess permissions, to ensure successful execution of this lab.
{{% /expand %}}

### 1.2 Deploy the application using an AWS CloudFormation template

You will deploy the service infrastructure including simple service code and some sample data.

1. It is recommended that you use the **Ohio** region.  This region is also known as **us-east-2**, which you will see referenced throughout this lab.
![SelectOhio](/Reliability/300_Health_Checks_and_Dependencies/Images/SelectOhio.png)
      * If you choose to use a different region, you will need to ensure future steps are consistent with your region choice.

#### 1.2.1 Deploy the VPC infrastructure

* If you are comfortable deploying a CloudFormation stack, then use the **Express Steps**
* If you require detailed guidance in how to deploy a CloudFormation stack, then use the **Guided Steps**

{{% notice note %}}
Choose either the Express Steps _or_ Guided Steps
{{% /notice %}}

##### Express Steps (Deploy the VPC infrastructure)

1. Download the [vpc-alb-app-db.yaml](/Security/200_Automated_Deployment_of_VPC/Code/vpc-alb-app-db.yaml) CloudFormation template
1. Make sure you are in AWS region: **us-east-2 (Ohio)**
1. Deploy the CloudFormation template
    * Name the stack **`WebApp1-VPC`** (case sensitive)
    * Leave all CloudFormation Parameters at their default values
1. When the stack status is _CREATE_COMPLETE_, you can continue to the next step

##### Guided Steps (Deploy the VPC infrastructure)
{{%expand "Click here for detailed instructions to deploy the VPC:" %}}
{{% common/Create_VPC_Stack  stackname="WebApp1-VPC"%}}
1. When the stack status is _CREATE_COMPLETE_, you can continue to the next step
{{% /expand%}}

#### 1.2.2 Deploy the web app infrastructure and service

Wait until the VPC CloudFormation stack **status** is _CREATE_COMPLETE_, then continue. This will take about four minutes.

{{% notice note %}}
Choose either the Express Steps _or_ Guided Steps
{{% /notice %}}

#### Express Steps (Deploy the EC2s and Static WebApp infrastructure)

1. Download the [staticwebapp.yaml](/Reliability/Common/Code/CloudFormation/staticwebapp.yaml) CloudFormation template
1. Make sure you are in AWS region: **us-east-2 (Ohio)**
1. Deploy the CloudFormation template
    * Name the stack **`HealthCheckLab`** (case sensitive)
    * Leave all CloudFormation Parameters at their default values
1. When the stack status is _CREATE_COMPLETE_, you can continue to the next step

#### Guided Steps (Deploy the EC2s and Static WebApp infrastructure)
{{%expand "Click here for detailed instructions to deploy the WebApp:" %}}
1. Download the latest version of the CloudFormation template here: [staticwebapp.yaml](/Reliability/300_Health_Checks_and_Dependencies/Code/CloudFormation/staticwebapp.yaml)
{{% common/CreateNewCloudFormationStack templatename="staticwebapp.yaml" stackname="HealthCheckLab"/%}}
{{% /expand%}}

### 1.3 View the website for web service {#website}

1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation>.
      * Wait until **HealthCheckLab** stack **status** is _CREATE_COMPLETE_ before proceeding. This should take about four minutes
      * Click on the **HealthCheckLab** stack
      * Click on the **Outputs** tab
      * For the Key **WebsiteURL** copy the value.  This is the URL of your test web service
          * _Hint_: it will start with _`http://healt-alb`_ and end in _`<aws region>.elb.amazonaws.com`_

1. Click the URL and it will bring up the website:  
      ![DemoWebsite](/Reliability/300_Health_Checks_and_Dependencies/Images/DemoWebsite.png)

1. The website simulates a recommendation engine making personalized suggestions for classic television shows. You should note the following features:
      * Area A shows the personalized recommendation
          * It shows first name of the user and the show that was recommended
          * The workshop simulation is simple. On every request it chooses a user at random, and shows a recommendation statically mapped to that user. The user names, television show names, and this mapping are in a DynamoDB table, which is simulating the **RecommendationService**
      * Area B shows metadata which is useful to you during the lab
          * The **instance_id** and **availability_zone** enable you to see which EC2 server and Availability Zone were used for each request
          * There is one EC2 instance deployed per Availability Zone
          * Refresh the website several times, note that the EC2 instance and Availability Zone change from among the three available
          * This is Elastic Load Balancing (ELB) distributing these stateless requests among the available EC2 server instances across Availability Zones

    |Well-Architected for Reliability: Best practices|
    |:--:|
    |**Use highly available network connectivity for your workload public endpoints**: Elastic Load Balancing provides load balancing across Availability Zones, performs Layer 4 (TCP) or Layer 7 (http/https) routing, integrates with AWS WAF, and integrates with AWS Auto Scaling to help create a self-healing infrastructure and absorb increases in traffic while releasing resources when traffic decreases.|
    |**Implement loosely coupled dependencies**: Dependencies such as queuing systems, streaming systems, workflows, and load balancers are loosely coupled. Loose coupling helps isolate behavior of a component from other components that depend on it, increasing resiliency and agility.|
    |**Deploy the workload to multiple locations**: Distribute workload data and resources across multiple Availability Zones or, where necessary, across AWS Regions. These locations can be as diverse as required.|
