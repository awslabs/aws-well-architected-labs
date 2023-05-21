---
title: "Level 300: Multilayered API Security with Cognito and WAF"
menutitle: "Multilayered API Security with Cognito and WAF"
date: 2021-05-30T11:16:08-04:00
chapter: false
weight: 1
---

## Authors

* **Jang Whan Han**, Well-Architected Geo Solutions Architect.
* **Tim Robinson**, Well-Architected Geo Solutions Architect.


## Introduction

APIs are used for integration between applications and assist our customers in delivering new digital businesses as public APIs in partner ecosystems. Due to the public nature of these APIs, security is a top concern for all organizations who seek to develop APIs to augment their existing business models. Although API security now benefits from increased awareness and product feature coverage, application leaders must create and implement an effective API security strategy which aligns with their business needs. An example of an effective approach to secure an API is to adopt a [Zero Trust](https://aws.amazon.com/blogs/publicsector/how-to-think-about-zero-trust-architectures-on-aws/) strategy which ensures only authorized requests are permitted to access the business layer of your application. Additionally, evaluating trust at multiple layers of the architecture allows multiple checks to be performed as the API data transits through the workload.

Through the use of [AWS Cognito](https://aws.amazon.com/cognito/), it is possible to create user pools which work with your API to obtain an identity access token for the user, which can then be used to enforce authorization controls in your API layer. However, not only can legitimate users potentially expose your organization to high risk, but also attacks can come with valid credential or token. To mitigate this risk, AWS Cognito enables you to configure how long your access token will be valid and the integration of Amazon WAF in conjunction with CloudFront will allow you to add another layer of API security to achieve a strong level of protection.

In this lab we will walk you through an example scenario of securing your API at multiple layers. We will gradually tighten the security at each layer, using the following services:

* [Amazon API Gateway](https://docs.aws.amazon.com/apigateway/latest/developerguide/welcome.html) - Used for securing REST API.
* [AWS Secrets Manager](https://docs.aws.amazon.com/secretsmanager/latest/userguide/intro.html) - Used to securely store secrets.
* [Amazon CloudFront](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html) - Used to prevent direct access to API as well as to enforce encrypted end-to-end connections to origin.
* [AWS WAF](https://docs.aws.amazon.com/waf/latest/developerguide/waf-chapter.html) - Used to protect our API by filtering, monitoring, and blocking malicious traffic.
* [Amazon Cognito](https://docs.aws.amazon.com/cognito/latest/developerguide/what-is-amazon-cognito.html) - Used to enable access control for API

Our lab is divided into several sections as follows:

1. Deploy the lab base infrastructure.
2. Use secrets securely.
3. Prevent requests from accessing API directly.
4. Application layer defense.
5. Contol access to API.

We have included CloudFormation templates for the first few steps to get your started and build out the base lab infrstructure. For the remainder of the lab we will use further templates what will deploy addtional services such as CloudFront, WAF and Cognito to further enhance the security of the workload. The remainder of the lab will then focus on the configuration of these services to create an example API environment which is secured at multiple layers.

{{% notice note %}}
**Note:** For simplicity, we have used North Virginia **'us-east-1'** as the default region for this lab. Please ensure all lab interaction is completed from this region.
{{% /notice %}}

## Goals

* Store and use secrets securely
* Control traffic at all layers
* Enforce encryption in transit
* Reduce attack surface
* Controlling and managing access to your API

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.

{{% notice note %}}
**NOTE:** You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

## Steps:

{{< children  />}}
