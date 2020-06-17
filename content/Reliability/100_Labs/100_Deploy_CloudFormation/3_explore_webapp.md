---
title: "Explore the Web Application"
menutitle: "Explore Web Application"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation>.
    * Wait until **CloudFormationLab** stack **status** is _CREATE_COMPLETE_ before proceeding. This should take about four minutes
    * Click on the **CloudFormationLab** stack
    * Click on the **Outputs** tab
    * For the Key **WebsiteURL** copy the value.  This is the URL of your test web service
      * _Hint_: it will start with _`http://healt-alb`_ and end in _`<aws region>.elb.amazonaws.com`_
    

1. Click the URL and it will bring up the website: 
    * _Troubleshooting_: if you see an error such as _502 Bad Gateway_, then wait 60 seconds and try again. It takes some time for the servers to initialize.
      ![DemoWebsite](/Reliability/300_Health_Checks_and_Dependencies/Images/DemoWebsite.png)

1. The website simulates a recommendation engine making personalized suggestions for classic television shows. You should note the following features:
      * Area A shows the personalized recommendation
          * It shows first name of the user and the show that was recommended
          * The workshop simulation is simple. On every request it chooses a user at random, and shows a recommendation statically mapped to that user. The user names, television show names, and this mapping are in a DynamoDB table, which is simulating the **RecommendationService**
      * Area B shows metadata which is useful to you during the lab
          * The **instance_id** and **availability_zone** enable you to see which EC2 server and Availability Zone were used for each request

1. Use the following architectural diagram as you explore the site
    ![ArchitectureOverviewAnnotated](/Reliability/100_Deploy_CloudFormation/Images/ArchitectureOverviewAnnotated.png)
    * **A** - There is one EC2 instance deployed per Availability Zone
    * **B** - Refresh the website several times, note that the EC2 instance and Availability Zone change from among the three available
    * **C** - Elastic Load Balancing (ELB) is used here.  An Application Load Balancer receives each request and distributes it among the available EC2 server instances across Availability Zones.
        * The requests are stateless, and therefore can be routed to any of the available EC2 instances
    * **D** - The EC2 instances are in an [Amazon EC2 Auto Scaling Group](http://aws.amazon.com/ec2/autoscaling). This Auto Scaling Group was configured to maintain three instances, therefore if one instance is detected as _unhealthy_ it will be replaced to maintain three _healthy_ instances.
        * AWS Auto Scaling can also be configured to scale up/down dynamically in response to workload consitions such as CPU utilization or request count.

|Well-Architected for Reliability: Best practices|
|:--|
|**Use highly available network connectivity for your workload public endpoints**: These endpoints and the routing to them must be highly available. You used Elastic Load Balancing which provides load balancing across Availability Zones, performs Layer 4 (TCP) or Layer 7 (http/https) routing, integrates with AWS WAF, and integrates with AWS Auto Scaling to help create a self-healing infrastructure and absorb increases in traffic while releasing resources when traffic decreases.|
|**Implement loosely coupled dependencies**: Dependencies such as... load balancers are loosely coupled. Loose coupling helps isolate behavior of a component from other components that depend on it, increasing resiliency and agility.|
|**Deploy the workload to multiple locations**: Distribute workload data and resources across multiple Availability Zones or, where necessary, across AWS Regions. These locations can be as diverse as required.|
|**Automate healing on all layers**: Upon detection of a failure, use automated capabilities to perform actions to remediate it|

**You have deployed the cloud infrastructure architecture that can support a high reliability workload**

* This an example architecture of the cloud infrastructure necessary for reliable workloads
* Addition of dynamic auto scaling would further improve reliability
* Reliability also depends on software architecture, network configuration, operational excellence, and testing (especially [Chaos Engineering]({{<ref "300_Testing_for_Resiliency_of_EC2_RDS_and_S3" >}}) which tests resilience), which are outside the scope of this lab. 
  * Without best practices for all of these, which can be found in the Reliability pillar of the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/), the workload will not achieve high reliability goals.