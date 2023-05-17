---
title: "Migrating AWS RDS Databases to Graviton"
menutitle: "Migrating AWS RDS Databases to Graviton"
date: 2020-11-18T09:00:08-04:00
chapter: false
weight: 1
hidden: false
---

## Introduction
[AWS Graviton processors](https://aws.amazon.com/ec2/graviton/) are custom custom built by Amazon Web Services using 64-bit Arm Neoverse cores.

AWS Graviton CPUs have excellent energy efficiency, switching to Graviton EC2 instances can reduce energy usage by as much as 60% for the same performance as comparable x86-64 instances.

AWS control the end to end lifecycle of the chip, from design to consumption, enhancing overall efficiency. [Read more here](https://aws.amazon.com/ec2/graviton/).

## Well-Architected Best Practices
This lab helps you to exercise the following AWS Well-Architected Best Practices for Sustainability:

* [SUS05-BP02](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/sus_sus_hardware_a3.html) - **Use instance types with the least impact**

## RDS on Graviton
* Up to 35% faster than non-Graviton.
* Up to 53% better price/performance than non-Graviton.
* Almost zero effort migration from x86-64.
* Supported for RDS databases MySQL, PostgreSQL, MariaDB and for Amazon Aurora.
* Not currently supported for commercial databases Oracle and SQL Server.

Running your database on AWS Graviton is only one way of improving sustainability for RDS, for other options see [this blog post](https://aws.amazon.com/blogs/architecture/optimizing-your-aws-infrastructure-for-sustainability-part-iv-databases/).

## Goals
At the end of this lab you will:

* Understand which RDS databases can be migrated from x86-64 to Graviton.
* Understand the different migration options and how they apply to each database type.
* Have practical hands on experience migrating RDS databases from x86-64 to Graviton.

## [Start the lab](https://catalog.us-east-1.prod.workshops.aws/workshops/34f8e4fb-14de-4b10-8dee-d9e2b8db9eb2/en-US/4-hardware-and-services/migrate-rds-to-graviton)
