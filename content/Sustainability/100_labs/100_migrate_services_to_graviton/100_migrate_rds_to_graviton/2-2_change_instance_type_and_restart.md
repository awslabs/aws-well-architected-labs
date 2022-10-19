---
title: "Lab 1 - Change Database Instance Type"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 4
pre: "<b>2.2 </b>"
---
---
- [ ] [Migration Methodologies]({{< ref "./1_migration_methodologies.md" >}})
- [ ] [Preparation]({{< ref "./2-1_preparation.md" >}})
- [x] [Lab 1 - Change Database Instance Type]({{< ref "./2-2_change_instance_type_and_restart.md" >}})
- [ ] [Lab 2 - Promote Read Replica]({{< ref "./2-3_promote_read_replica.md" >}})
- [ ] [Lab 3 - Failover to Read Replica]({{< ref "./2-4_failover_to_read_replica.md" >}})
- [ ] [Lab 4 - Restore from snapshot]({{< ref "./2-5_restore_from_snapshot.md" >}})
- [ ] [Cleanup]({{< ref "./cleanup.md" >}})

## Overview

In this lab you will take the RDS MySQL database that was created in the [Preparation]({{< ref "./2-1_preparation.md" >}}) step, and migrate it from the X86 instance it was built on, to a Graviton instance.

This migration method works for all RDS databases that support Graviton, including Aurora.

With this migration type applications can continue to use the existing endpoints

## Check the database has fully

1. Check the mysql-lab1 database is in an Available state (click refresh to update the current state)


## Change the instance type from X86 to Graviton

1. Once the database is in the available state, select the database and click “Modify”
2. Change the instance type to db.t4g.micro 
3. Scroll all the way down and click **Continue**
4. Select **Apply Immediately**
5. Click **Modify DB Instance**
6. The database will be modified and then restart on the graviton instance type, clicking refresh on the console will show the status of the change.

![Lab 1 Database Creation](/Sustainability/100_migrate_rds_to_graviton/lab-1/lab-1_modify_instance.png)

When the database is in Available status and running on Graviton you have successfully completed this lab.

![Lab 1 Database Creation](/Sustainability/100_migrate_rds_to_graviton/lab-1/lab-1_final_status.png)

{{< prev_next_button link_prev_url="../2-1_preparation" link_next_url="../2-3_promote_read_replica" />}}