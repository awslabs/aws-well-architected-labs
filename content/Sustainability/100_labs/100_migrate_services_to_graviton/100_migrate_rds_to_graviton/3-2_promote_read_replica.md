---
title: "Lab 2 - Promote Read Replica"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 5
pre: "<b>3.2 </b>"
---

- [x] [Migration Methodologies]({{< ref "./1_migration_methodologies.md" >}})
- [x] [Preparation]({{< ref "./2_preparation.md" >}})
- [x] [Lab 1 - Change Database Instance Type]({{< ref "./3-1_change_instance_type_and_restart.md" >}})
- [x] [Lab 2 - Promote Read Replica]({{< ref "./3-2_promote_read_replica.md" >}})
- [ ] [Lab 3 - Failover to Read Replica]({{< ref "./3-3_failover_to_read_replica.md" >}})
- [ ] [Lab 4 - Restore from snapshot]({{< ref "./3-4_restore_from_snapshot.md" >}})
- [ ] [Cleanup]({{< ref "./cleanup.md" >}})

## Overview

In this lab you will take the RDS PostgreSQL database that was created in the [Preparation]({{< ref "./2_preparation.md" >}}) step, and create a replica of it on a Graviton instance. The replica can then be promoted from a read replica of the initial database to a new independent database.

This works for non-Aurora databases, Lab 3 will cover how to migrate Aurora databases.

This migration method will create a new database with different endpoints. Any database connections will need to be modified to use the new endpoints. The existing database is not affected.
Note that is possible to run database instances on multiple different server types and sizes.


## Create a Graviton read replica

1. Check that the `postgresql-lab2` database is in the **Available** status
![Lab 2 Instance Available](/Sustainability/100_migrate_rds_to_graviton/lab-2/lab-2_instance-available.png)
2. In the RDS database console click on the radio button next to `postgresl-lab2`
3. From the actions menu select Create Read Replica
![Lab 2 Instance Available](/Sustainability/100_migrate_rds_to_graviton/lab-2/lab-2_actions-menu.png)
4. In **Instance Specifications** select a graviton instance type (e.g. **db.t4g.micro**)
![Lab 2 Instance Available](/Sustainability/100_migrate_rds_to_graviton/lab-2/lab-2_instance-specifications.png)
5. Scroll down to **Settings** and enter a DB Instance Identifier (e.g. `lab2-graviton`)
![Lab 2 Instance Available](/Sustainability/100_migrate_rds_to_graviton/lab-2/lab-2_db-identifier.png)
6. Leave other settings at default, scroll down and click **Create read replica**
7. Wait for the new replica instance to reach the Available status in the Databases console, this will take a few minutes. Click the refresh button to update the status.


## Promote the Graviton replica to a new database instance

1. When its status is Available, click on the radio button next to the lab2-graviton instance
2. From the actions menu select **Promote**
![Lab 2 Database Promotion](/Sustainability/100_migrate_rds_to_graviton/lab-2/lab-2_promote_action.png)
3. Disable the automatic backups and click **Promote Read Replica**
![Lab 2 Database Promotion](/Sustainability/100_migrate_rds_to_graviton/lab-2/lab-2_promote_database.png)
4. The replica will now restart as a separate standalone instance. While it maintains its original endpoint name it is no longer linked to the original database, they are independent
5. You will notice in the console, the promoted instance will leave the postgresql-lab2 cluster and become a standalone instance. When the lab2-graviton database has reached Available status the lab is complete.
![Lab 2 Database Promotion](/Sustainability/100_migrate_rds_to_graviton/lab-2/lab-2_complete.png)

{{< prev_next_button link_prev_url="../3-1_change_instance_type_and_restart" link_next_url="../3-3_failover_to_read_replica" />}}
