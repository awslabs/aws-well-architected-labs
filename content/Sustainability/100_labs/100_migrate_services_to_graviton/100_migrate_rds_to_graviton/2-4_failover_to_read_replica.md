---
title: "Lab 3 - Failover to read Replica"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 6
pre: "<b>2.4 </b>"
---

- [ ] [Migration Methodologies]({{< ref "./1_migration_methodologies.md" >}})
- [ ] [Preparation]({{< ref "./2-1_preparation.md" >}})
- [ ] [Lab 1 - Change Database Instance Type]({{< ref "./2-2_change_instance_type_and_restart.md" >}})
- [ ] [Lab 2 - Promote Read Replica]({{< ref "./2-3_promote_read_replica.md" >}})
- [x] [Lab 3 - Failover to Read Replica]({{< ref "./2-4_failover_to_read_replica.md" >}})
- [ ] [Lab 4 - Restore from snapshot]({{< ref "./2-5_restore_from_snapshot.md" >}})
- [ ] [Cleanup]({{< ref "./cleanup.md" >}})

## Overview

In this lab you will take the Amazon Aurora database created in the [Preparation]({{< ref "./2-1_preparation.md" >}}) step, add a read replica, and then failover to the replica

This method works for Aurora only (Postgres and MySQL)

This is a fast way to migrate, and applications can continue to use the existing database endpoints


## Add a read replica and failover

1. Click on the aurora database name, **aurora-lab3** to go to the detail screen for the database
2. From the Actions menu select **Add Reader**
3. Enter a DB Instance Identifier (e.g. aurora-graviton)
4. Select a graviton instance type e.g. db.t4g.medium from burstable classes
5. Scroll to the bottom of the page and click **Add reader**

![Lab 3 Database Creation 2](/Sustainability/100_migrate_rds_to_graviton/lab-3/lab-3_aurora_add_reader.png)

6. Once the graviton instance is in the Available state, there should be an X86 writer and a graviton reader

![Lab 3 Database Creation 2](/Sustainability/100_migrate_rds_to_graviton/lab-3/lab-3_aurora_before_failover.png)


## Failover to the Graviton Instance

1. Select the radio button next to the newly created Graviton instance, choose actions and then **Failover**


![Lab 3 Database Failover](/Sustainability/100_migrate_rds_to_graviton/lab-3/lab-3_aurora_failover.png)

2. Note that the graviton instance now becomes the writer and the x86 instance is demoted to a reader node
3. Notice how quickly the failover happens compared to changing the instance type.
4. The lab is now complete and you can move on to the next one.

{{< prev_next_button link_prev_url="../2-3_promote_read_replica" link_next_url="../2-5_restore_from_snapshot" />}}
