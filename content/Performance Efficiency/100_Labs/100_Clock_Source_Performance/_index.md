---
title: "Level 100: Calculating differences in Linux clock source changes to application performance"
menutitle: "Calculating differences in clock source"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 2
description: "How various linux clock sources can affect the performance of your application on EC2"
---
## Authors
- Eric Pullen, Performance Efficiency Lead Well-Architected

## Introduction

This hands-on lab will teach you the fundamentals of how various linux clock sources can affect the performance of your application on EC2. AWS has introduced new capabilities within our Nitro system on certain instance types, which takes advantage of better clock timing as well as offloading many other hypervisor related tasks.

In this lab, you will deploy three distinct EC2 instances running Amazon Linux, each configured with a different instance type and all with SSM enabled.  You will also deploy a set of SSM documents, which will be used to enable and disable various clock timing changes to the machines. Lastly, a set of test scripts will be deployed which allow you to see the differences as the clock changes are made.

The skills you learn will help you learn the various clock sources available in EC2, as well as ways to test those changes for your applications in alignment with the AWS Well-Architected Framework.

For a list of Nitro-based instances currently available, head to https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-types.html#ec2-nitro-instances for the latest list.


## Goals

* Deploy EC2 instances on both Nitro and non-nitro backed hypervisors
* Deploy SSM documents to allow for modifications to the Linux clock source
* Learn how SSM documents can be used to apply configuration changes to your Linux instances, such as changing the clock source
* Learn how to use SSM session manager to gain shell access to run your own test against the various instance types


## Prerequisites

* An [AWS account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.  
* An Identity and Access Management (IAM) user or federated credentials into that account that has permissions to create an IAM Role, instance profiles, and EC2 instances.
* An IAM user or federated credentials into that account that has permissions to access AWS System Manager

{{% notice note %}}
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

## Steps:
{{% children  %}}
