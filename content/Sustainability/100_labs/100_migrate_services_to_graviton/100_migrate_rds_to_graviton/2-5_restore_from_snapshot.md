---
title: "Lab 4 - Restore from Snapshot"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 7
pre: "<b>2.5 </b>"
---

- [ ] [Migration Methodologies]({{< ref "./1_migration_methodologies.md" >}})
- [ ] [Preparation]({{< ref "./2-1_preparation.md" >}})
- [ ] [Lab 1 - Change Database Instance Type]({{< ref "./2-2_change_instance_type_and_restart.md" >}})
- [ ] [Lab 2 - Promote Read Replica]({{< ref "./2-3_promote_read_replica.md" >}})
- [ ] [Lab 3 - Failover to Read Replica]({{< ref "./2-4_failover_to_read_replica.md" >}})
- [x] [Lab 4 - Restore from snapshot]({{< ref "./2-5_restore_from_snapshot.md" >}})
- [ ] [Cleanup]({{< ref "./cleanup.md" >}})

## Overview

The last option to migrate a database from x86 to Graviton is to restore a database snapshot to a Graviton instance, creating a new database, and leaving the existing database in place.

An alternative lab to this one exists [here](https://graviton2-workshop.workshop.aws/en/amazonrds.html).

### Check for an existing snapshot or create a new one

1. The default settings should have created a snapshot at DB creation time. Select Snapshot from the RDS menu on the left, and click on the **Automated** tab to see which snaphots are available.
2. You also have an option to create a snapshot manually with the **Take Snapshot** button.

### Use the snapshot to create a new database running on Graviton

1. Select the checkbox next to the snapshot you want to restore
2. From the actions dropdown menu, choose **Restore**
3. Enter a new name for the database, e.g. **lab4-maria-graviton**

![Lab 4 Database Name](/Sustainability/100_migrate_rds_to_graviton/lab-4/lab4-db-name.png)

4. Under Instance configuration select the radio button **Burstable classes (includes t classes)**
5. Select **db.t4g.micro**

![Lab 4 Instance Select](/Sustainability/100_migrate_rds_to_graviton/lab-4/lab4-instance-select.png)

6. Leave other settings at defaults and click the **Restore DB Instance** button

![Lab 4 Database Creating 2](/Sustainability/100_migrate_rds_to_graviton/lab-4/lab4-restore-db-instance.png)

7. The database will now be created from the snapshot

![Lab 4 Database Creating 2](/Sustainability/100_migrate_rds_to_graviton/lab-4/lab4-db-creating.png)

8. Once the database is in **Available** status the lab is complete and you can move to cleanup.

{{< prev_next_button link_prev_url="../2-4_failover_to_read_replica" link_next_url="../cleanup" />}}