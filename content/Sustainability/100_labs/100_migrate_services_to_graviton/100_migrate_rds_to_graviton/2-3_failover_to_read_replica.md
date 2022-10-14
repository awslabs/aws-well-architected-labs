---
title: "Lab 3 - Failover to read Replica"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 5
pre: "<b>2.3 </b>"
---

- [ ] [Migration Methodologies]({{< ref "./1_migration_methodologies.md" >}})
- [ ] [Lab 1 - Change Database Instance Type]({{< ref "./2-1_change_instance_type_and_restart.md" >}})
- [ ] [Lab 2 - Promote Read Replica]({{< ref "./2-2_promote_read_replica.md" >}})
- [x] [Lab 3 - Failover to Read Replica]({{< ref "./2-3_failover_to_read_replica.md" >}})
- [ ] [Cleanup]({{< ref "./cleanup.md" >}})

## Overview

In this lab you will create an Amazon Aurora database with a read replica, and then failover to the replica

This method works for Aurora only (Postgres and MySQL)

This is a fast way to migrate and applications can continue to use the existing database endpoints


### Create an Aurora instance

1. Go to the RDS Console
2. Create an Aurora PostgreSQL Database

![Lab 3 Database Creation 1](./lab-3/lab-3_aurora_create_1.png)

3. Enter a database identifier (e.g. aurora-lab3)
4. In the instance configuration, select the radio button for burstable classes (includes T classes)
5. Select db.t3.small as the instance type
6. Choose Auto Generate a password

![Lab 3 Database Creation 2](./lab-3/lab-3_aurora_create_2.png)

7. Leave everything else at defaults
8. Click **Create Database**

It will take a few minutes to create the database and for it to become available, click the refresh button in the AWS RDS console to get the latest status.

### Add a read replica and failover

1. Click on the aurora database name to go to the detail screen for the database
2. From the Actions menu select **Add Reader**
3. Enter a DB Instance Identifier (e.g. aurora-graviton)
4. Select a graviton instance type e.g. db.t4g.medium from burstable classes

![Lab 3 Database Creation 2](./lab-3/lab-3_aurora_add_reader.png)

5. Once the graviton instance is in the Available state, there should be an X86 writer and a graviton reader

![Lab 3 Database Creation 2](/Sustainability/100_migrate_rds_to_graviton/lab-3/lab-3_aurora_before_failover.png)


## Failover to the Graviton Instance

1. Select the radio button next to the newly created Graviton instance, choose actions and then **Failover**
2. Note that the graviton instance now becomes the writer and the x86 instance is demoted to a reader node

![Lab 3 Database Failover](./lab-3/lab-3_aurora_failover.png)

3. Notice how quickly the failover happens compared to changing the instance type.

The lab is now complete.

{{< prev_next_button link_prev_url="../" link_next_url="../cleanup" />}}![Lab 3 Database Creation 2](./lab-3/lab-3_aurora_add_reader.png)
