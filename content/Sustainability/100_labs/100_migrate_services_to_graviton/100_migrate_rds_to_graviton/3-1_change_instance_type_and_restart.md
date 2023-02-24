---
title: "Lab 1 - Change Database Instance Type"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 4
pre: "<b>3.1 </b>"
---
---
- [x] [Migration Methodologies]({{< ref "./1_migration_methodologies.md" >}})
- [x] [Preparation]({{< ref "./2_preparation.md" >}})
- [x] [Lab 1 - Change Database Instance Type]({{< ref "./3-1_change_instance_type_and_restart.md" >}})
- [ ] [Lab 2 - Promote Read Replica]({{< ref "./3-2_promote_read_replica.md" >}})
- [ ] [Lab 3 - Failover to Read Replica]({{< ref "./3-3_failover_to_read_replica.md" >}})
- [ ] [Lab 4 - Restore from snapshot]({{< ref "./3-4_restore_from_snapshot.md" >}})
- [ ] [Cleanup]({{< ref "./cleanup.md" >}})

## Overview

In this lab you will take the RDS MySQL database that was created in the [Preparation]({{< ref "./2_preparation.md" >}}) step, and migrate it from the x86-64 instance it was built on, to a Graviton based instance.

This migration method works for all RDS databases that support AWS Graviton, including Amazon Aurora.

With this migration type, applications can continue to use the existing endpoints.

## Check the database is fully created

1. From the RDS dashboard, go to databases in the side menu.
![Lab 1 Databases console](/Sustainability/100_migrate_rds_to_graviton/lab-1/lab-1_databases.png)
2. Check the `mysql-lab1` database is in an Available state (click refresh to update the current state).
![Lab 1 Database status](/Sustainability/100_migrate_rds_to_graviton/lab-1/lab-1_database_status.png)

## Change the instance type from x86-64 to Graviton

1. Once the database is in the available state, select the database radio button and click **Modify**.
![Lab 1 select modify](/Sustainability/100_migrate_rds_to_graviton/lab-1/lab-1_select-modify.png)
2. On the Modify DB Instance page, change the instance type to **db.t4g.micro**.
![Lab 1 instance configuration](/Sustainability/100_migrate_rds_to_graviton/lab-1/lab-1_instance-configuration.png)
3. Leave all other settings as they are and scroll all the way down and click **Continue**
4. In *Schedule modifications*, select **Apply Immediately**
5. Click **Modify DB Instance**
![Lab 1 Database Creation](/Sustainability/100_migrate_rds_to_graviton/lab-1/lab-1_modify_instance.png)

6. The database will be modified and then restart on the graviton instance type, clicking refresh on the console will show the status of the change.



When the database is in Available status and running on Graviton you have successfully completed this lab.

![Lab 1 Database Creation](/Sustainability/100_migrate_rds_to_graviton/lab-1/lab-1_final_status.png)

{{< prev_next_button link_prev_url="../2_preparation" link_next_url="../3-2_promote_read_replica" />}}
