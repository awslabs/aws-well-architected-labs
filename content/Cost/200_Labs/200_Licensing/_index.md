---
title: "Level 200: Licensing"
#menutitle: "Lab #1"
date: 2020-08-30T11:16:09-04:00
chapter: false
weight: 12
hidden: false
---
{{< rawhtml >}}
<video width="600" height="450" controls>
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Cost/Videos/200Licensing.mp4" type="video/mp4">
  Your browser doesn't support video, or if you're on GitHub head to https://wellarchitectedlabs.com to watch the video.
</video>
{{< /rawhtml >}}

## Authors
- Nathan Besh, Cost Lead, Well-Architected (AWS)


## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
This hands-on lab will guide you through analyzing your cost and usage for licensing costs, and the cost of licensing in your workloads. You will then be shown
how to analyze the data and decide if it is beneficial to change to non-licensed software. In this lab we show the techniques using Operating System licences, but
these techniques can be applied to any licensed software.

You will first setup a data source (if required) using the sample provided. This is a Cost and Usage report that contains licensed usage. You may use your own
cost and usage report, however you need to ensure there is licensed usage and modify the examples in the lab.

You analyze the CUR to discover the costs of operating system licenses, and also the cost of running licensed operating systems. With this data you will make an analysis of the cost savings by switching to an unlicensed operating system.
We have also provided an additional data set with the changes applied, to simulate this change and verify the savings.

![Images/AWSCostReadme.png](/Cost/200_Licensing/Images/AWSCostReadme.png)

## Goals
- Discover the cost of licensed software in your cost and usage
- Analyze and understand the benefit of moving to unlicensed software


## Prerequisites
- An AWS Account
- (Optional) Your own Cost and Usage Report with licensed software (RHEL - RedHat linux) usage
- Completed the [AWS Account Setup lab]({{< ref "/Cost/100_labs/100_1_aws_account_setup">}})
- Completed the [Cost and Usage Analysis lab]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}})


## Permissions required
- Log in as the Cost Optimization team, created in [AWS Account Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}})
- The following additional permissions: **ec2:DescribeImages, ec2:DescribeVpcs, ec2:DescribeSubnets** are optional, as you can complete the lab without them - however you will not be able to access pages in the EC2 console 


## Costs
- Approximately <$5

## Time to complete
- The lab should take approximately 15-20 minutes to complete

## Steps:
{{% children  /%}}

{{< prev_next_button link_next_url="./1_pricing_sources/" button_next_text="Start Lab" first_step="true" />}}
