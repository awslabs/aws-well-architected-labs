---
title: "Level 100: Migrating AWS RDS Databases to Graviton"
menutitle: "Migrating AWS RDS Databases to Graviton"
date: 2020-11-18T09:00:08-04:00
chapter: false
weight: 1
hidden: false
---
## Authors

- **Jeff Forrest**, Senior Solutions Architect.

## Introduction
AWS Graviton is a custom CPU with 64-bit ARM processor cores

Graviton CPUs have excellent energy efficiency, switching to Graviton EC2 instances can reduce energy usage by as much as 60% for the same performance as x86 instances.

Amazon control the end to end lifecycle of the chip from design to consumption enhancing efficiency

[Read more here](https://aws.amazon.com/ec2/graviton/)

## RDS on Graviton
* Up to 35% faster than non-Graviton
* Up to 53% better price/performance than non-Graviton
* Almost zero effort migration from X86
* Supported for RDS databases MySQL, PostgreSQL, MariaDB and for Amazon Aurora
* Not currently supported for commercial databases Oracle and SQL Server

## Goals
At the end of this lab you will:

* Understand which RDS databases can be migrated from X86 to Graviton
* Understand the different migration options and how they apply to each database type
* Have practical hands on experience migrating RDS databases from X86 to Graviton

## Prerequisites

* This lab is designed to run in your own AWS account.
* It can be run in any region that supports RDS and Graviton but us-east-1 is recommended.


{{% notice note %}}
**NOTE:** You will be billed for any applicable AWS resources used if you complete this lab that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).
When you decide to stop the lab at any point in time, please revisit the [clean up]({{< ref "content/Sustainability/100_Labs/100_migrate_rds_to_graviton/cleanup.md" >}}) instructions at the end so you stop incurring costs.
{{% /notice %}}

{{< prev_next_button link_next_url="./1_migration_methodologies/"  first_step="true" />}}

## Steps:
{{% children  %}}
