---
title: "Clean Up"
date: 2023-02-17T20:33:27.634Z
chapter: false
weight: 8
pre: "<b>4 </b>"
---

- [x] [Migration Methodologies]({{< ref "./1_migration_methodologies.md" >}})
- [x] [Preparation]({{< ref "./2_preparation.md" >}})
- [x] [Lab 1 - Change Database Instance Type]({{< ref "./3-1_change_instance_type_and_restart.md" >}})
- [x] [Lab 2 - Promote Read Replica]({{< ref "./3-2_promote_read_replica.md" >}})
- [x] [Lab 3 - Failover to Read Replica]({{< ref "./3-3_failover_to_read_replica.md" >}})
- [x] [Lab 4 - Restore from snapshot]({{< ref "./3-4_restore_from_snapshot.md" >}})
- [x] [Cleanup]({{< ref "./cleanup.md" >}})


## In the RDS Console delete all the created databases

{{% notice note %}}
**NOTE:** Because these are lab databases we will delete all the databases with their associated backups and will not create a final snapshot.
Normally it would be highly recommended to create a final snapshot.
{{% /notice %}}

To cleanup and to avoid any additional charges, the database instances created as part of the lab need to be deleted from the RDS console. The steps to delete a DB instance can be found in the [docs](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_DeleteInstance.html).

### Delete the Lab 1 RDS MySQL database

![Delete MySQL](/Sustainability/100_migrate_rds_to_graviton/clean-up/clean-up_delete_mysql.png)

### Delete the Lab 2 x86-64 database

![Delete Postgres x86-64](/Sustainability/100_migrate_rds_to_graviton/clean-up/clean-up_delete_postgres.png)

### Delete the Lab 2 Graviton Database

![Delete Postgres Graviton](/Sustainability/100_migrate_rds_to_graviton/clean-up/clean-up_delete_pg_graviton.png)


### Delete the Lab 3 Aurora Postgres x86-64 database

![Delete Aurora x86-64](/Sustainability/100_migrate_rds_to_graviton/clean-up/clean-up_delete_aurora_x86.png)

### Delete the Lab 3 Aurora Graviton database

![Delete Aurora Graviton](/Sustainability/100_migrate_rds_to_graviton/clean-up/clean-up_delete_aurora_graviton.png)

### Delete the Lab 4 MariaDB Database

![Delete Aurora Graviton](/Sustainability/100_migrate_rds_to_graviton/clean-up/clean-up_delete_mariadb.png)

If you took any manual snapshots, they should also be deleted by following the steps in the [docs](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_DeleteSnapshot.html).

{{< prev_next_button link_prev_url="../3-4_restore_from_snapshot" final_step="true" />}}
