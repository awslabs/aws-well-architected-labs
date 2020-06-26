---
title: "Quest: Quick Steps to Security Success"
menutitle: "Quick Steps to Security Success"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 2
description: "In just one day (or an hour a day for a week!) implement some foundational security controls to immediately improve your security posture."
---
## Authors
* Byron Pogson, Solutions Architect

## About this Guide

This quest is for you to improve your security posture. Every stakeholder involved in your organization and product or service is entitled to make use of a secure platform. Security is important to earn the trust with your customers and your providers. A secure environment also helps to protect your intellectual property. Each set of activities can be done in one day or split over a week in your lunch break. Further discussion can be found in [best practices for your AWS environment](https://aws.amazon.com/organizations/getting-started/best-practices/)

For more context on this quest see [Essential Security Patterns](https://www.youtube.com/watch?v=ScwoR73yr_c) from Public Sector Summit Canberra 2019 and the associated [slide deck on SlideShare](https://www.slideshare.net/AmazonWebServices/essential-security-patterns)

Implementing multiple AWS accounts for your workload improves your security by isolating parts of your workload to limit the blast radius. Understanding cross account access ensures that common resources can continue to be shared among separate workloads. This quest will guide you to setting up a foundational multi-account environment which allows you to implement appropriate controls on top of it while still maintaining a centralized view and flexibility to adapt to your business processes.

This quest leverages [AWS Control Tower](https://aws.amazon.com/controltower/) to implement your best practice landing zone. AWS Control Tower is a managed service to setup up and govern secure multi-account AWS environment. Control Tower is not currently [available in all regions](https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/) so instructions are also provided for an alternate approach too. It is **strongly recommend** that you set up your account landing zone with Control Tower as it is a managed service supported directly by AWS and includes many best practices and guardrails.


## Steps:
{{% children  %}}
