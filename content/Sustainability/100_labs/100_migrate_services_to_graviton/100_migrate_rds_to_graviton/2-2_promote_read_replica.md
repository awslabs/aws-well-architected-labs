---
title: "Lab 2 - Promote Read Replica"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 4
pre: "<b>2.2 </b>"
---

- [ ] [Migration Methodologies]({{< ref "./1_migration_methodologies.md" >}})
- [ ] [Lab 1 - Change Database Instance Type]({{< ref "./2-1_change_instance_type_and_restart.md" >}})
- [x] [Lab 2 - Promote Read Replica]({{< ref "./2-2_promote_read_replica.md" >}})
- [ ] [Lab 3 - Failover to Read Replica]({{< ref "./2-3_failover_to_read_replica.md" >}})
- [ ] [Cleanup]({{< ref "./cleanup.md" >}})

## Overview

This works for non-Aurora databases, see Lab 3 for Aurora

This migration method will create new database endpoints, so any database connections will need to be modified to use the new endpoints.

## Create an RDS PostgreSQL Instance on X86

Go to the [RDS Console](https://console.aws.amazon.com/rds/) and create a PostgreSQL database on the free tier

1. Select Easy Create
2. Select PostgreSQL
3. Select Free Tier (Instance type db.t3.micro)
4. Enter a database ID (e.g. PostgreSQL-lab2)
5. Choose Auto Generate a password
6. Leave everything else at defaults and click **create database**
7. Wait for the database to reach the available state

![Lab 2 Database Creation](./lab-2/lab-2_create_database.png)

## Create a Graviton read replica

1. In the RDS database console click on the DB Identifier to go into the details screen for the database
2. From the actions menu select Create Read Replica
3. Enter a DB Instance Identifier (e.g. lab2-graviton), select a graviton instance type (e.g. db.t4g.micro), 4. leave other settings at default, scroll down and click **Create Read Replica**
5. Wait for the new replica instance to reach the Available state, this may take a few minutes.

## Promote the Graviton replica to a new database instance

1. Click on the name of the replica instance to go to the details screen
2. From the actions menu select **Promote**
3. Disable the automatic backups and click **Promote Read Replica**
5. The replica will now restart as a separate standalone instance. While it maintains its original endpoint name it is no longer linked to the original database, they are independent

![Lab 2 Database Promotion](./lab-2/lab-2_promote_database.png)


{{< prev_next_button link_prev_url="../" link_next_url="../2-3_failover_to_read_replica" />}}