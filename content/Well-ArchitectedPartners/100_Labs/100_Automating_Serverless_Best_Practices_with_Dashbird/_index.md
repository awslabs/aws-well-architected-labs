---
title: "Level 100: Automating Serverless Best Practices with Dashbird"
menutitle: "Level 100: Automating Serverless Best Practices with Dashbird"
date: 2021-05-31T11:16:08-04:00
chapter: false
weight: 1
---

## Authors

* **Stephen Salim**, Well-Architected Geo Solutions Architect.
* **Jang Whan Han**, Well-Architected Geo Solutions Architect.



## Introduction

Serverless architecture refers to a software design pattern where applications are broken up into individual functions. These functions are specfic in use and can be scaled individually according to architectural requirements. Serverless architecture allows developers to spend less time provisioning, scaling and managing infrastructure, freeing up time to develop value-added business logic. Customers can also benefit from cost efficiency in their architectures as they only pay for what they use.

At large scale, serverless architecture experiences exponential growth in the amount of data which must be monitored (logs, metrics, configurations etc). To efficiently utilize serverless architecture at this scale, Observerability is highly important to gather insights and discover performance and cost optimization opportunities.

[Dashbird](https://www.dashbird.io) continuously runs multiple best practice checks against their customers serverless workloads, which provides actionable advice on how to improve their applications in alignment with Well-Architected best practices.

In this lab, you will create a simple serverless web application using the following AWS services:

* [AWS Amplify](https://docs.aws.amazon.com/amplify/latest/userguide/welcome.html) - Used for Static Web Hosting.
* [AWS Cognito](https://docs.aws.amazon.com/cognito/latest/developerguide/what-is-amazon-cognito.html) - Used for authentication functions to secure the backend API.
* [Amazon API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html) - Used for securing REST API.
* [AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html) - Used to run code without provisioning.
* [Amazon DynamoDB](https://docs.aws.amazon.com/amazondynamodb/latest/developerguide/Introduction.html) - Used for a fully managed NoSQL database.

Our lab is divided into several sections as follows:

1. Deploy Blue Car application
2. Dashbird Well-Architected Insights
3. Modern Load Test
4. Tear down

We have included a single script to assist you with the application deployment. Once the application is deployed and your account is connected to the Dashbird platform, insights will be discovered based on Well-Architected best practice. You can then perform a modern load test which will trigger further insights and demonstrate the value of Observability.


## Design Principles

* Enable traceability
* Test systems at production scale
* Stop guessing capacity
* Stop spending money on undifferentiated heavy-lifting

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.

{{% notice note %}}
**NOTE:** You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

## Steps:

{{% children  %}}
