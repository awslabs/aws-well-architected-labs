---
title: "Lab 1 - Change Database Instance Type"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 3
pre: "<b>2.1 </b>"
---
---
- [ ] [Migration Methodologies]({{< ref "content/Sustainability/100_Labs/100_migrate_rds_to_graviton/1_migration_methodologies.md" >}})
- [x] [Lab 1 - Change Database Instance Type]({{< ref "content/Sustainability/100_Labs/100_migrate_rds_to_graviton/2-1_change_instance_type_and_restart.md" >}})
- [ ] [Lab 2 - Promote Read Replica]({{< ref "content/Sustainability/100_Labs/100_migrate_rds_to_graviton/2-2_promote_read_replica.md" >}})
- [ ] [Lab 3 - Failover to Read Replica]({{< ref "content/Sustainability/100_Labs/100_migrate_rds_to_graviton/2-3_failover_to_read_replica.md" >}})
- [ ] [Cleanup]({{< ref "content/Sustainability/100_Labs/100_migrate_rds_to_graviton/cleanup.md" >}})

## Overview

In this lab you will create an RDS MySQL database on an X86 instance, and then migrate it to a Graviton instance.

This migration method works for all RDS databases that support Graviton.

With this migration type applications can continue to use the existing endpoints




## Create an RDS MySQL instance on X86

Go to the [RDS Console](https://console.aws.amazon.com/rds/) and create a MySQL Database on the free tier:

1. Select Easy Create
2. Select MySQL
3. Select Free Tier (instance type db.t3.micro)
4. Enter a database ID (e.g. mysql-lab1)
5. Select Auto Generate a password
6. Leave everything else at defaults and click **create database**

It will take a few minutes to create the database and for it to become available, click the refresh button in the AWS RDS console to get the latest status.

![Lab 1 Database Creation](/Sustainability/100_migrate_rds_to_graviton/lab-1/lab-1_create_database.png)


## Change the instance type from X86 to Graviton

1. Once the database is in the available state, select the database and click “Modify”
2. Change the instance type to db.t4g.micro 
3. Click Continue
4. Select Apply Immediately
5. Click **Modify DB Instance**
6. The database will restart on the graviton instance type, clicking refresh on the console will show the status of the change.

![Lab 1 Database Creation](/Sustainability/100_migrate_rds_to_graviton/lab-1/lab-1_modify_instance.png)

When the database is in the Available status and running on Graviton you have successfully completed this lab.

![Lab 1 Database Creation](/Sustainability/100_migrate_rds_to_graviton/lab-1/lab-1_final_status.png)

{{< prev_next_button link_prev_url="../" link_next_url="../2-2_promote_read_replica" />}}