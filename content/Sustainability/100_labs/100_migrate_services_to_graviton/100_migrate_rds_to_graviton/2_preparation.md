---
title: "Preparation"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 3
pre: "<b>2 </b>"
---
---
- [x] [Migration Methodologies]({{< ref "./1_migration_methodologies.md" >}})
- [x] [Preparation]({{< ref "./2_preparation.md" >}})
- [ ] [Lab 1 - Change Database Instance Type]({{< ref "./3-1_change_instance_type_and_restart.md" >}})
- [ ] [Lab 2 - Promote Read Replica]({{< ref "./3-2_promote_read_replica.md" >}})
- [ ] [Lab 3 - Failover to Read Replica]({{< ref "./3-3_failover_to_read_replica.md" >}})
- [ ] [Lab 4 - Restore from snapshot]({{< ref "./3-4_restore_from_snapshot.md" >}})
- [ ] [Cleanup]({{< ref "./cleanup.md" >}})

## Overview

The databases in this lab can take some time to create, by creating them all at the start of the lab some time can be saved. For a bit of variety we'll create various different database types.


## Create an RDS MySQL x86-64 instance for Lab 1

Go to the [RDS Console](https://console.aws.amazon.com/rds/) and create a MySQL Database on the free tier:

1. Click **Create Database**
2. Select **Easy create**
3. Select **MySQL** as the engine type
4. Select Free Tier (instance type db.t3.micro)
5. Enter a database ID (e.g. `mysql-lab1`)
6. Select **Auto generate a password**
7. Leave everything else at defaults and click **create database**. Your configuration should look like the image below.


{{% notice note %}}
**NOTE:** It will take a few minutes to create the database and for it to become available, while its processing you can start to create the next database.
{{% /notice %}}

![Lab 1 Database Creation](/Sustainability/100_migrate_rds_to_graviton/lab-1/lab-1_create_database.png)


## Create an RDS PostgreSQL instance on x86-64 for Lab 2

Go to the [RDS Console](https://console.aws.amazon.com/rds/) and create a PostgreSQL database on the free tier:

1. Click **Create Database**
2. Select **Easy create**
3. Select **PostgreSQL** as the engine type
4. Select Free Tier (Instance type db.t3.micro)
5. Enter a database ID (e.g. `postgresql-lab2`)
6. If the master username is set to Master, it must be changed to something else (e.g. myuser)
7. Select **Auto generate a password**
8. Leave everything else at defaults and click **create database**. Your configuration should look like the image below.

![Lab 2 Database Creation](/Sustainability/100_migrate_rds_to_graviton/lab-2/lab-2_create_database.png)


## Create an Amazon Aurora instance for Lab 3

1. Click **Create Database**
2. Select **Standard create**
3. Select **Amazon Aurora** as the engine type
4. Choose Amazon Aurora MySQL-Compatible Edition
5. For the engine version, this can remain as the default selected version. In the image below this is Aurora (MySQL 5.7) 2.10.2
6. Choose the Dev/Test template. Your configuration should look like the image below

![Lab 3 Database Creation 1](/Sustainability/100_migrate_rds_to_graviton/lab-3/lab-3_aurora_create_1.png)

7. Enter a database identifier (e.g. `aurora-lab3`)
8. Select **Auto generate a password**
9. In the instance configuration, select the radio button for **Burstable classes** (includes T classes)
10. Select db.t3.small as the instance type

![Lab 3 Database Creation 2](/Sustainability/100_migrate_rds_to_graviton/lab-3/lab-3_aurora_create_2.png)

7. Leave all other settings as default
8. Click **Create Database**

It will take a few minutes to create the database and for it to become available, continue to create the DB for lab 4 in the meantime.

## Create a MariaDB instance for Lab 4

From the Amazon RDS console:

1. Click **Create Database**
2. Select **Easy Create**
3. Choose **MariaDB** as the engine type
3. Select the radio button for **Free tier**
4. Enter a db instance identifier (e.g. `mariadb-lab4`)
5. Select db.t3.micro as the instance type
6. Choose Auto Generate a password
7. Leave everything else at defaults
8. Click **Create Database**

![Lab 4 Database Creation](/Sustainability/100_migrate_rds_to_graviton/lab-4/lab-4_mariadb_create.png)

All 4 databases should now be created or at least in the process of creating. Now you can move on to the labs themselves.

{{< prev_next_button link_prev_url="../1_migration_methodologies" link_next_url="../3-1_change_instance_type_and_restart" />}}
