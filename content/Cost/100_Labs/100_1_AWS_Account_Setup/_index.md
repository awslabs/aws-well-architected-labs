---
title: "Level 100: AWS Account Setup: Lab Guide"
#menutitle: "Lab #1"
date: 2020-04-24T11:16:08-04:00
chapter: false
weight: 1
hidden: false
---
{{< rawhtml >}}
<video width="640" height="360" controls>
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Cost/Videos/100AccountSetup.mp4" type="video/mp4">
  Your browser doesn't support video, or if you're on GitHub head to https://wellarchitectedlabs.com to watch the video.
</video>
{{< /rawhtml >}}

## Last Updated
May 2020

## Authors
- Nathan Besh, Cost Lead Well-Architected


## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com

## Introduction
 This hands-on lab will guide you through the steps to configure your accounts and get them prepared for Cost Optimization work. It will create and setup an initial account structure, enable access to billing information and create a cost optimization team. This will ensure that you can complete the Well-Architected Cost workshops, and enable you to optimize your workloads inline with the Well-Architected Framework.


## Goals
- Implement an account structure
- Configure billing services
- Enable detailed cost and usage information
- Create a cost optimization team


## Prerequisites
- Multiple AWS accounts already created (at least three)


## Permissions required
- Root user and administrator access to the master and member accounts


## Costs
- https://aws.amazon.com/aws-cost-management/pricing/
- Variable costs will be incurred
- Cost Explorer: $0.01 per 1,000 usage records
- S3: Storage of CUR file, refer to S3 pricing https://aws.amazon.com/s3/pricing/
- Estimated costs should be <$5 a month for small accounts

## Time to complete
- The lab should take approximately 30 minutes to complete

## Steps:
{{% children  %}}

