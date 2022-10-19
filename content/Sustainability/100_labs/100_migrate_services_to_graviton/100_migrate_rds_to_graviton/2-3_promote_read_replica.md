---
title: "Lab 2 - Promote Read Replica"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 5
pre: "<b>2.3 </b>"
---

- [ ] [Migration Methodologies]({{< ref "./1_migration_methodologies.md" >}})
- [ ] [Preparation]({{< ref "./2-1_preparation.md" >}})
- [ ] [Lab 1 - Change Database Instance Type]({{< ref "./2-2_change_instance_type_and_restart.md" >}})
- [x] [Lab 2 - Promote Read Replica]({{< ref "./2-3_promote_read_replica.md" >}})
- [ ] [Lab 3 - Failover to Read Replica]({{< ref "./2-4_failover_to_read_replica.md" >}})
- [ ] [Lab 4 - Restore from snapshot]({{< ref "./2-5_restore_from_snapshot.md" >}})
- [ ] [Cleanup]({{< ref "./cleanup.md" >}})

## Overview

In this lab you will take the RDS postgresql database that was created in the [Preparation]({{< ref "./2-1_preparation.md" >}}) step, and create a replica of it on a Graviton instance. That replica can then be promoted from a read replica of the initial database to a new independent database

This works for non-Aurora databases, see Lab 3 for Aurora

This migration method will create a new database with different endpoints, so any database connections will need to be modified to use the new endpoints. The existing database is not affected.
Note that is possible to run database instances on multiple different server types and sizes. 


## Create a Graviton read replica

1. Check that the postgresql-lab2 database is in the **Available** status
2. In the RDS database console click on the radio button next to postgresl-lab2
2. From the actions menu select Create Read Replica
3. In **Instance Specifications** select a graviton instance type (e.g. db.t4g.micro)
4. Scroll down to **Settings** and enter a DB Instance Identifier (e.g. lab2-graviton)
5. Leave other settings at default, scroll down and click **Create read replica**
6. Wait for the new replica instance to reach the Available status, this may take a few minutes. Click the refresh button to update the status.



## Promote the Graviton replica to a new database instance

1. When its status is Available, click on the radio button next to the lab2-graviton instance
2. From the actions menu select **Promote**
3. Disable the automatic backups and click **Promote Read Replica**
4. The replica will now restart as a separate standalone instance. While it maintains its original endpoint name it is no longer linked to the original database, they are independent

![Lab 2 Database Promotion](/Sustainability/100_migrate_rds_to_graviton/lab-2/lab-2_promote_database.png)

5. When the lab2-graviton database has reached Available status the lab is complete and you can move on to the next one.

{{< prev_next_button link_prev_url="../2-2_change_instance_type_and_restart" link_next_url="../2-4_failover_to_read_replica" />}}