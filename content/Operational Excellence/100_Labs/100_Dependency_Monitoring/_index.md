---
title: "100 - Dependency Monitoring"
menutitle: "100 - Dependency Monitoring"
date: 2020-09-15T11:16:08-04:00
chapter: false
weight: 2
hidden: false
---

**Author:** Mahanth Jayadeva, Solutions Architect, Well-Architected

## Introduction

In this lab, you will become familiar with dependency monitoring and how to apply it to gain insights on resources that your workload depends on. You will learn how to create alarms and notifications to determine when a response is required.

It is important to design and configure your workload to emit information about the status (for example, reachability or response time) of resources it depends on. Examples of external dependencies can include, external databases, DNS, and network connectivity. By monitoring resources that your workload is dependent on, you will be able to quickly take action and ensure business continuity even when the dependent service is experiencing issues or downtime.

In this lab, you will create a CloudWatch alarm to monitor a dependency for a workload, and automate notifications so that your teams are aware of a potential impact to your workload due to a failing/degraded external dependency.

The skills you learn will help you define a dependency monitoring strategy in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/)

## Goals:

* Create alarms to monitor external dependencies
* Alert relevant stakeholders when outcomes are at risk due to a failed external dependency
* Learn how to automate this process

## Best Practices Covered:

**Implement dependency telemetry:** Design and configure your workload to emit information about the status of resources it depends on. Examples of these are external databases, DNS, and network connectivity. Use this information to determine when a response is required.

**Alert when workload outcomes are at risk:** Raise an alert when workload outcomes are at risk so that you can respond appropriately if required.

**Enable push notifications:** Communicate directly with your users (for example, with email or SMS) when the services they use are impacted, and when the services return to normal operating conditions, to enable users to take appropriate action.

## Requirements

* An [AWS Account](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for testing, that is not used for production or other purposes.
* An IAM user or role in your AWS account that has Administrator privileges.

## Costs
{{% notice note %}}
NOTE: You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
{{% /notice %}}

{{< prev_next_button link_next_url="./1_deploy_infrastructure/" button_next_text="Start Lab" first_step="true" />}}

## Steps
{{% children  /%}}
