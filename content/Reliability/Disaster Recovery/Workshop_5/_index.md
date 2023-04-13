+++
title = "Module 5: Multi-Region Resiliency with Route 53 ARC"
date = 2021-05-06T09:52:56-04:00
weight = 140
chapter = false
pre = ""
+++


In this module, you will extend the [Hot Standby disaster recovery strategy](/reliability/disaster-recovery/workshop_4/), centrally coordinate failover, and readiness for our application. To learn more about how Amazon Route 53 Application Recovery Controller (Route 53 ARC) can help you build highly resilient applications, you can review this [blog](https://aws.amazon.com/blogs/networking-and-content-delivery/building-highly-resilient-applications-using-amazon-route-53-application-recovery-controller-part-1-single-region-stack/).

[Application Recovery Controller cells](https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.html) are instantiations of a service that are isolated from each other. To maximize resiliency, you should [partition your application into isolated cells](https://aws.amazon.com/solutions/guidance/cell-based-architecture-on-aws/), so that when one cell fails, that failure can’t affect the other cells. Route 53 ARC's  features enable you to continually monitor your application’s ability to recover from failures, and to control application recovery across multiple AWS Regions, AZs, and on premises. Route 53 ARC’s capabilities make application recovery simpler and more reliable by eliminating manual steps required by traditional tools and processes.

Our application is currently deployed in our primary region **N. Virginia (us-east-1)** and we will use **N. California (us-west-1)** as our secondary region.

Our test application is Unishop. It is a Spring Boot Java application deployed on a single [Amazon Elastic Compute Cloud (EC2)](https://aws.amazon.com/ec2) instance using a public subnet. Our datastore is an [Amazon Aurora](https://aws.amazon.com/rds/aurora/) MySQL database which has user data. Our test application is also deployed using [Amazon API Gateway](https://aws.amazon.com/api-gateway/) and [AWS Lambda](https://aws.amazon.com/lambda/). Our datastore is [Amazon DynamoDB](https://aws.amazon.com/dynamodb) which has shopping cart data. The frontend is written using bootstrap and hosted in [Amazon Simple Storage Service (S3)](https://aws.amazon.com/pm/serv-s3).

This is the same application you would have used in Module 4 of this lab. You may use the same architecture that you deployed in Module 4, as we will now extend the solution to simulate cells in our primary region **N. Virginia (us-east-1)** and our secondary region, **N. California (us-west-1)**. 
* If you have **not** completed Module 4 - don't worry! All the resources needed are included in this module are available. Just click **Start Lab** and follow the instructions. 
* If you did complete Module 4, again, just follow the instructions on the next page (you will be required to make the S3 buckets public again). Also you will notice that in this Module we will use a slightly different approach and replace the Unicorn Shop website access points from a Cloudfront distribution to a Application Load Balancer. 

We will simulate our cell endpoints with an [Application Load Balancer](https://aws.amazon.com/elasticloadbalancing/application-load-balancer/)(ALB). The ALBs will route requests to an Nginx reverse proxy running on each of our EC2 instances, which will forward the requests to our S3 buckets in region. We will be using [Amazon Route 53 Application Recovery Controller](https://aws.amazon.com/route53/application-recovery-controller/) to manage the configuration of an [Amazon Route 53](https://aws.amazon.com/route53/) private hosted zone.  

Our test application is using two datastores, Amazon Aurora and DynamoDB to showcase the Disaster Recovery features of each. For your workloads, you would choose the right datastore for your use case.

This module takes advantage of [Amazon Route 53 Application Recovery Controller](https://aws.amazon.com/route53/application-recovery-controller/) to monitor readiness and control application recovery across our primary and secondary regions. Take a look at the [Route 53 ARC components](https://docs.aws.amazon.com/r53recovery/latest/dg/introduction-components.html) to familiarize yourself with them before starting this lab.

We are also taking advantage of [Amazon Aurora Global Database](https://aws.amazon.com/rds/aurora/global-database/) to replicate our Amazon Aurora MySQL data to our secondary region and [Amazon DynamoDB Global Tables](https://aws.amazon.com/dynamodb/global-tables/) to replicate our DynamoDB data to our secondary region. 

[CloudFormation](https://aws.amazon.com/cloudformation/) will be used to configure the infrastructure and deploy the application. Provisioning your infrastructure with [infrastructure as code (IaC) methodologies](https://docs.aws.amazon.com/whitepapers/latest/introduction-devops-aws/infrastructure-as-code.html) is a best practice. CloudFormation is an easy way to speed up cloud provisioning with infrastructure as code.

Prior experience with the AWS Console and Linux command line are helpful but not required.


{{< img HotStandbyMRRARC.png >}}

#### Author

* **Richard Wilmot**, Senior Partner Solutions Architect

#### Contributors

* **Jesus Rodriguez**, Partner Solutions Architect
* **Simon Lovering**, Partner Solutions Architect
* **Andrew Grischenko**, Partner Sales Solutions Architect

{{< prev_next_button link_next_url="./1-prerequisites/" button_next_text="Start Lab" first_step="true" />}}
