+++
title = "Aurora"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++

[Amazon Aurora Global Database](https://aws.amazon.com/rds/aurora/global-database) is designed for globally distributed applications, allowing a single Amazon Aurora database to span multiple AWS regions. It replicates your data with no impact on database performance, enables fast local reads with low latency in each region, and provides disaster recovery from region-wide outages. In disaster recovery situations, you can promote a secondary region to take full read-write responsibilities in under a minute.

With an Aurora global database, there are two different approaches to failover depending on the scenario.  

**Failover** – Use this approach to recover from an unplanned outage. With this approach, you perform a cross-Region failover to one of the secondary DB clusters in your Aurora global database. The RPO for this approach is typically a non-zero value measured in seconds. The amount of data loss depends on the Aurora global database replication lag across the AWS Regions at the time of the failure. To learn more, see [Recovering an Amazon Aurora global database from an unplanned outage](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html#aurora-global-database-failover).

**Switchover** – This operation was previously called "managed planned failover." Use this approach for controlled scenarios, such as operational maintenance and other planned operational procedures. Because this feature synchronizes secondary DB clusters with the primary before making any other changes, RPO is 0 (no data loss). To learn more, see [Performing switchovers for Amazon Aurora global databases](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html#aurora-global-database-disaster-recovery.managed-failover).

**Switchover**, is showcased in **Module 3: Warm Standby**. 

For this workshop we will be doing a **Failover**.

#### Promote Aurora

1.1 Click [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#databases:) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Look at the **pilot-global** Global database. Notice how we have **pilot-primary** a **Primary cluster** in **us-east-1** which has our **Writer instance** and **pilot-secondary** a **Secondary cluster** in **us-west-1** which has our **Reader instance**.

{{< img a-5.png >}}

1.3 Select **pilot-global** cluster and select **Switch over or fail over global database** from **Actions**. 

{{< img a-3.png >}}

1.4 Choose **Failover (allow data loss)**, select **pilot-secondary** as **New primary cluster**, enter **confirm** to confirm the failover then click **Confirm**.

{{< img a-4.png >}}

{{% notice warning %}}
You will need to wait for the **pilot-secondary** to become **Available** before moving on to the next step.  This can take several minutes.
{{% /notice %}}

1.5 Notice the changes. The **Primary cluster** is now in **us-west-1** which has our **Writer instance** and the **Secondary Cluster** is now in **us-east-1** which has our **Reader instance**.

{{< img a-6.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../4.2-ec2/" />}}