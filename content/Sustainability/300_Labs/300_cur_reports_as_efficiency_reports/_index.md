---
title: "Level 300: Turning Cost & Usage Reports into Efficiency Reports"
menutitle: "Turning Cost & Usage Reports into Efficiency Reports"
date: 2020-11-18T09:00:08-04:00
chapter: false
weight: 1
hidden: false
---
## Authors

- **Steffen Grunwald**, Principal Solutions Architect.
- **Thomas Attree**, Solutions Architect.

## Introduction

{{< rawhtml >}}
<video width="696" height="392" controls>
  <source src="https://d3h9zoi3eqyz7s.cloudfront.net/Sustainability/Videos/cur-reports-as-efficiency-reports.mp4" type="video/mp4">
  Your browser doesn't support video, or if you're on GitHub head to https://wellarchitectedlabs.com to watch the video.
</video>
{{< /rawhtml >}}

{{%expand "Video transcript"%}}
Hello and welcome to this Well Architected Lab, my name is Thomas and I’m a Solutions Architect, here at AWS.

The outcomes of this lab are to give you an overview of what proxy metrics are and what you need to think about when selecting them.

Identifying proxy metrics and using them from your AWS cost and usage report.

Preparing this data in a way that can be queried for dashboarding later.
And learning how to bring your own data in the form of assumptions.

Now, you may have seen the shared responsibility for security as part of the Well Architected labs on security. Well, AWS also has a shared responsibility with our customers for sustainability.

We think about this responsibility in two ways, sustainability of the cloud, which is the responsibility of AWS and this covers our own operational responsibilities.
AWS designs buildings, rooms, servers and takes care of it from construction to recycling
AWS purchases the energy and ensure that energy and other resources such as water for cooling are used efficiently.
And lastly, AWS Service Teams run managed services and optimise them for sustainability

Then we have sustainability in the cloud, and this is the customer responsibility. This responsibility is what this lab and others within the well architected labs site will focus on. Sustainability in the cloud pertains to how you design and run your software, architect your infrastructure and maximise utilisation.

So how can you optimise for sustainability?

The answer is the same as you always have with, especially with the cost and performance efficiency pillars.

The well architected pillar outlines an iterative process, similar to how customers have improving for e.g. for cost or performance for decades.

You need to be aware of your goals (or set them) and your current performance against your KPIs.

First, you set a goal for your company, then you look at all of the workloads you can optimise,

Then you prioritise by the workloads which will have the biggest impact, for which you will need data and metrics, and are a good investment in terms of time for optimisation.
Next you hypothesise what can you optimise for the workload, can I change the processor to Graviton or can I implement autoscaling? Does this instance need to be on all of the time or can I perform the work as a batch? Or can I re-write components in a more efficient language such as rust?

These hypotheses then need to be qualified and prioritised by how long will it take, how much will it cost, what risks are associated with it?

Then experiment, measure the impact, rollback if the outcome is not desirable or deploy the change to production.

Then move onto the next hypothesis by iterating through the flywheel again.

Through working with customers, we’ve found that they are very good at optimisation.
They’ve been optimising inside and outside of the cloud for decades and as long as you can provide a metric to an engineer, they can optimise towards that metric.

But what could be a good metric to optimise for sustainability?

There are a few that are useful for optimisations and we call those proxy metrics

They are aligned broadly around utilisation of storage, network and compute.

Cost can also be considered but can sometimes be a poor proxy metric for sustainability because of differing pricing structures across regions, and doesn’t discriminate between a heavily utilised EC2 instance and an idle EC2 instance for example.

When you select a metric to optimise for, you’ll actually be selecting many as they compete with each other.

Think about a use case for generating thumbnails for uploaded user content, maybe you could generate this thumbnail at upload time, but it never requested, optimising storage by using less. Or you could generate the thumbnails when requested, duplicating compute work but minimising storage.

Optimising for these metrics also competes with traditional non-functional requirements, such as availability or data retention policies.

An example being using an application deployed on EC2 servers across two availability zones. If one instance were to fail, your application can be served by the EC2 instance in the second AZ, keeping availability high. This however trades off utilisation as the two instances are unlikely to be running at a high load whilst still having capacity to absorb the additional load of the failed instance.

When selecting metrics to optimise for sustainability, you also need to be aware of your non-functional requirements and determine where you can make a trade off.

We see customers making architectural changes to optimise for sustainability and considering the tradeoffs I just mentioned.

Another example is making use of service features you might not be making use of today, such as using colder tiers of S3 storage.

For example, can can you trade off availability, in the case of one zone IA, or trade off object retrieval time with with even colder storage tiers in the glacier family.

Using one zone IA optimises for storage and data transfer, as AWS does not need to duplicate the object across availability zones, eliminating the cross AZ traffic, and removing the need to store the object on hardware in additional AZ’s.

Or you might simply determine that you don’t need that data anymore and you implement mechanisms to either lifecycle data through these tiers, or delete it completely.

Remember, the greenest energy is the energy you don’t use.

In these labs, you will use Amazon Athena to discover proxy metrics from your cost and usage reports.

You will then in part 2 add your own assumptions to these metrics, with examples including a preference for a region you determine to have a cleaner energy grid.

You’ll then learn in part 3 how to add these assumptions as IaC with the AWS CDK.

Now it’s time to get started! Enjoy the labs and have fun!

{{% /expand%}}

## Goals
At the end of this lab you will:

* Understand the need for proxy metrics for sustainability and identify candidates
* Draw these proxy metrics from your AWS Cost & Usage Report (or sample data) and prepare the data ready for dashboarding with e.g. Amazon QuickSight
* Learn how you can add your own data and combine it with the AWS Cost & Usage Reports

## Prerequisites

The lab is designed to run in your account. You can pick a region in which you run the lab. If you have existing AWS Cost & Usage Report (CUR) data in a bucket, you should run the lab in the region of this bucket. [Pick a region where Amazon Athena is available](https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/).

{{% notice note %}}
**NOTE:** You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
When you decide to stop the lab at any point in time, please revisit the [clean up]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/cleanup.md" >}}) instructions at the end so you stop incuring cost (e.g. for storage in Amazon S3).
{{% /notice %}}

{{< prev_next_button link_next_url="./1-1_prepare_cur_data/" button_next_text="Start Lab" first_step="true" />}}

## Steps:
{{% children  %}}
