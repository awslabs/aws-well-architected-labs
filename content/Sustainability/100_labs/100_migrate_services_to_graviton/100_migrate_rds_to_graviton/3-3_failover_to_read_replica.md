---
title: "Lab 3 - Failover to read Replica"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 6
pre: "<b>3.3 </b>"
---

- [x] [Migration Methodologies]({{< ref "./1_migration_methodologies.md" >}})
- [x] [Preparation]({{< ref "./2_preparation.md" >}})
- [x] [Lab 1 - Change Database Instance Type]({{< ref "./3-1_change_instance_type_and_restart.md" >}})
- [x] [Lab 2 - Promote Read Replica]({{< ref "./3-2_promote_read_replica.md" >}})
- [x] [Lab 3 - Failover to Read Replica]({{< ref "./3-3_failover_to_read_replica.md" >}})
- [ ] [Lab 4 - Restore from snapshot]({{< ref "./3-4_restore_from_snapshot.md" >}})
- [ ] [Cleanup]({{< ref "./cleanup.md" >}})

## Overview

In this lab you will take the Amazon Aurora database created in the [Preparation]({{< ref "./2_preparation.md" >}}) step, add a read replica, and then failover to the replica.

This method works for Amazon Aurora only (Postgres and MySQL).

This is a fast way to migrate, and applications can continue to use the existing database endpoints.


## Add a read replica and failover

1. In the RDS Databases console, click on the Aurora cluster name, **aurora-lab3** to go to the detail screen for the database
2. From the Actions menu select **Add reader**
![Lab 3 Database Creation 2](/Sustainability/100_migrate_rds_to_graviton/lab-3/lab-3_aurora_add_reader_action.png)
3. Enter a DB Instance Identifier (e.g. `aurora-graviton`)
4. Select a graviton instance type e.g. **db.t4g.medium** from burstable classes
![Lab 3 Database Creation 2](/Sustainability/100_migrate_rds_to_graviton/lab-3/lab-3_aurora_add_reader.png)
5. Leave all other settings as default, scroll to the bottom of the page and click **Add reader**
6. Once the graviton instance is in the Available state (this may take a few minutes), there should be an x86-64 writer and a Graviton reader

![Lab 3 Database Creation 2](/Sustainability/100_migrate_rds_to_graviton/lab-3/lab-3_aurora_before_failover.png)


## Failover to the Graviton Instance

1. Select the radio button next to the newly created Graviton instance named **aurora-graviton**, choose actions and then **Failover**


![Lab 3 Database Failover](/Sustainability/100_migrate_rds_to_graviton/lab-3/lab-3_aurora_failover.png)

2. Note that the graviton instance now becomes the writer and the x86-64 instance is demoted to a reader node
3. Notice how quickly the failover happens compared to changing the instance type.
4. The lab is now complete and you can move on to the next one.

{{< prev_next_button link_prev_url="../3-2_promote_read_replica" link_next_url="../3-4_restore_from_snapshot" />}}
