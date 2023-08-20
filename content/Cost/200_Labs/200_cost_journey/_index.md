---
title: "Level 200: Cost Journey"
menutitle: "Level 200: Cost Journey"
date: 2021-03-01T26:16:08-04:00
chapter: false
weight: 13
hidden: false
---
{{< rawhtml >}}
<video width="640" height="360" controls>
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Cost/Videos/CostJourney.mp4" type="video/mp4">
  Your browser doesn't support video, or if you're on GitHub head to https://wellarchitectedlabs.com to watch the video.
</video>
{{< /rawhtml >}}

## Last Updated
March 2021

## Authors
- Nathan Besh, Cost Lead Well-Architected (AWS)
- Tom McMeekin, Solutions Architect (AWS)

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
In this lab you will create your organizations cost optimization journey.  It will show you where your workload and organization is currently
at, in terms of capability, and what lies ahead - so you can plan and resource accordingly.

The lab will create a lambda function, which reads all the AWS Well-Architected reviews in the account, and produce a webpage with an image showing your journey, as below.

![Images/journey.png](/Cost/200_cost_journey/Images/journey.png)

## Goals
- Create a cost optimization journey for each workload with a Well-Architected review

## Prerequisites
- Performed at least one AWS Well-Architected review on a workload

## Permissions required
- Create and manage an S3 bucket
- Create an IAM role to run a lambda function
- Create and run a lambda function
- Access to the Well-Architected service

## Costs
- Estimated costs are <$5 for an average customer (lambda execution, s3 storage)

## Time to complete
- 15minutes

## Steps:
{{% children  /%}}

{{< prev_next_button link_next_url="./1_configure_services/" button_next_text="Start Lab" first_step="true" />}}
