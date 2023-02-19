---
title: "Lab 4 - Restore from Snapshot"
date: 2023-02-17T20:33:27.634Z
chapter: false
weight: 7
pre: "<b>3.4 </b>"
---

- [x] [Migration Methodologies]({{< ref "./1_migration_methodologies.md" >}})
- [x] [Preparation]({{< ref "./2_preparation.md" >}})
- [x] [Lab 1 - Change Database Instance Type]({{< ref "./3-1_change_instance_type_and_restart.md" >}})
- [x] [Lab 2 - Promote Read Replica]({{< ref "./3-2_promote_read_replica.md" >}})
- [x] [Lab 3 - Failover to Read Replica]({{< ref "./3-3_failover_to_read_replica.md" >}})
- [x] [Lab 4 - Restore from snapshot]({{< ref "./3-4_restore_from_snapshot.md" >}})
- [ ] [Cleanup]({{< ref "./cleanup.md" >}})

## Overview

The last option to migrate a database from x86-64 to Graviton is to restore a database snapshot to a Graviton instance, creating a new database, and leaving the existing database in place.

An alternative lab to this one exists [here](https://graviton2-workshop.workshop.aws/en/amazonrds.html).

### Check for an existing snapshot or create a new one

1. The default settings should have created a snapshot at DB creation time. Select Snapshot from the RDS menu on the left, and click on the **Automated** tab to see which snaphots are available.
![Lab 4 Snapshots](/Sustainability/100_migrate_rds_to_graviton/lab-4/lab4-snapshots.png)
2. You also have an option to create a snapshot manually with the **Take Snapshot** button. Refer to the [RDS documentation](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_CreateSnapshot.html) to take a manual snapshot if required.

### Use the snapshot to create a new database running on Graviton

1. Select the checkbox next to the snapshot you want to restore, for this lab we are going to use the mariaDB instance created in the [preparation]({{< ref "./2_preparation.md" >}}) step. The snapshot should follow the format `rds:mariadb-lab4-YYYY-MM-DD-HH-mm`
2. From the actions dropdown menu, choose **Restore**
![Lab 4 Database Name](/Sustainability/100_migrate_rds_to_graviton/lab-4/lab4-locate-snapshot.png)
3. Enter a new name for the database instance identifier, e.g. `lab4-maria-graviton`

![Lab 4 Database Name](/Sustainability/100_migrate_rds_to_graviton/lab-4/lab4-db-name.png)

4. Under Instance configuration select the radio button **Burstable classes (includes t classes)**
5. Select **db.t4g.micro**

![Lab 4 Instance Select](/Sustainability/100_migrate_rds_to_graviton/lab-4/lab4-instance-select.png)

6. Leave other settings at defaults and click the **Restore DB Instance** button

![Lab 4 Database Creating 2](/Sustainability/100_migrate_rds_to_graviton/lab-4/lab4-restore-db-instance.png)

7. The database will now be created from the snapshot

![Lab 4 Database Creating 2](/Sustainability/100_migrate_rds_to_graviton/lab-4/lab4-db-creating.png)

8. Once the database is in **Available** status the lab is complete and you can move to cleanup.

{{< prev_next_button link_prev_url="../3-3_failover_to_read_replica" link_next_url="../cleanup" />}}
