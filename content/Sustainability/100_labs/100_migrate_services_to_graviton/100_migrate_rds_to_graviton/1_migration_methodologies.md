---
title: "Migration Methodologies"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 2
pre: "<b>1 </b>"
---
- [x] [Migration Methodologies]({{< ref "./1_migration_methodologies.md" >}})
- [ ] [Preparation]({{< ref "./2_preparation.md" >}})
- [ ] [Lab 1 - Change Database Instance Type]({{< ref "./3-1_change_instance_type_and_restart.md" >}})
- [ ] [Lab 2 - Promote Read Replica]({{< ref "./3-2_promote_read_replica.md" >}})
- [ ] [Lab 3 - Failover to Read Replica]({{< ref "./3-3_failover_to_read_replica.md" >}})
- [ ] [Lab 4 - Restore from snapshot]({{< ref "./3-4_restore_from_snapshot.md" >}})
- [ ] [Cleanup]({{< ref "./cleanup.md" >}})

## Migration Methods

There are four options to migrate RDS instances from x86-64 to Graviton which we will cover in this lab.

### 1. Change instance type and restart the database

This is the simplest type of migration. The database endpoints are not changed, and it is as simple as shutting down the database and restarting it on an appropriate Graviton based instance.

### 2. Create a read replica and promote it to a separate new database

In this migration, a new database instance is created from a database replica. Any database connections will need to be pointed to the endpoints of the new database. The existing database is not affected. This can be a good option for testing.

### 3. Create a read replica and failover to it

In [Amazon Aurora](https://aws.amazon.com/rds/aurora/) databases, a read replica can be promoted to a writer. By creating a Graviton read replica and promoting it to a writer, a change between x86-64 and Graviton can be made with minimal downtime.

### 4. Restore a database snapshot

Database snapshots are independent of the CPU type, so a snapshot taken on an x86-64 instance can be restored to a Graviton instance.


## Database Support for Migration Methods

|	|Change instance type and restart	|Create new database by promoting read replica	|Failover existing database to read replica	| Restore database snapshot |
|---	| :---:	| :---:	| :---:	| :---:	|
|RDS: MySQL, Postgres, MariaDB	|Yes|Yes|No|Yes|
|Aurora: MySQL, Postgres	|Yes|No|Yes|Yes|

{{< prev_next_button link_prev_url="../" link_next_url="../2_preparation" />}}
