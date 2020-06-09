---
title: "Level 200: Basic EC2 Web Application Firewall Protection"
menutitle: "Basic EC2 WAF Protection"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 7
---
## Authors

- Ben Potter, Security Lead, Well-Architected

## Introduction

This hands-on lab will guide you through the introductory steps to protect an Amazon EC2 workload from network based attacks.
You will use the AWS Management Console and AWS CloudFormation to guide you through how to secure an Amazon EC2 based web application with defense in depth methods. Skills learned will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

## Goals

* Protecting network and host-level boundaries
* System security configuration and maintenance
* Enforcing service-level protection

## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.  
NOTE: You will be billed for any applicable AWS resources used if you complete this lab.
* Select region with support for AWS WAF for Application Load Balancers from list: [AWS Regions and Endpoints](https://docs.aws.amazon.com/general/latest/gr/rande.html).

## Steps:

{{% children  %}}


## References & useful resources

[Amazon Elastic Compute Cloud User Guide for Linux Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)
[Tutorial: Configure Apache Web Server on Amazon Linux 2 to Use SSL/TLS](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/SSL-on-an-instance.html)
[AWS WAF, AWS Firewall Manager, and AWS Shield Advanced Developer Guide](https://docs.aws.amazon.com/waf/latest/developerguide/waf-chapter.html)
