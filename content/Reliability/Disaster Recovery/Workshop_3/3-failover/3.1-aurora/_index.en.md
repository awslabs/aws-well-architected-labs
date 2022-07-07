+++
title = "Aurora"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++

[Amazon Aurora Global Database](https://aws.amazon.com/rds/aurora/global-database) is designed for globally distributed applications, allowing a single Amazon Aurora database to span multiple AWS regions. It replicates your data with no impact on database performance, enables fast local reads with low latency in each region, and provides disaster recovery from region-wide outages. In disaster recovery situations, you can promote a secondary region to take full read-write responsibilities in under a minute.

With an Aurora global database, there are two different approaches to failover depending on the scenario.  

**Manual unplanned failover ("detach and promote")** – To recover from an unplanned outage or to do disaster recovery (DR) testing, perform a cross-Region failover to one of the secondaries in your Aurora global database. The RTO for this manual process depends on how quickly you can perform the tasks listed in [Recovering an Amazon Aurora global database from an unplanned outage](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html#aurora-global-database-failover). The RPO is typically measured in seconds, but this depends on the Aurora storage replication lag across the network at the time of the failure.

**Managed planned failover** – This feature is intended for controlled environments, such as operational maintenance and other planned operational procedures. By using managed planned failover, you can relocate the primary DB cluster of your Aurora global database to one of the secondary Regions. Because this feature synchronizes secondary DB clusters with the primary before making any other changes, RPO is 0 (no data loss). To learn more, see [Performing managed planned failovers for Amazon Aurora global databases](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html#aurora-global-database-disaster-recovery.managed-failover).

In a true disaster scenario you will most likely use **Managed unplanned failover**, which are showcased in **Module 2: Pilot Light** and **Module 4: Hot Standby**. 

For this workshop we will be doing a **Managed Planned Failover**.

#### Promote Aurora

1.1 Click [RDS](https://us-east-1.console.aws.amazon.com/rds/home?region=us-east-1#databases:) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Look at the **warm-global** Global database. Notice how we have a **Primary cluster** in **us-east-1** which has our **Writer instance** and a **Secondary cluster** in **us-west-1** which has our **Reader instance**.

{{< img a-8.png >}}

1.3 Select **warm-global**, then select **Fail over global database** from the **Actions** link.

{{< img a-5.png >}}

1.4 Select **warm-secondary** as the **Choose a secondary cluster to become primary cluster**, then click the **Fail over global database** button.

{{< img a-6.png >}}

{{% notice warning %}}
You will need to wait for the database to failover before moving on to the next step.  This can take several minutes.
{{% /notice %}}

1.5 Notice the changes. The **Primary cluster** is now in **us-west-1** which has our **Writer instance** and the **Secondary Cluster** is now in **us-east-1** which has our **Reader instance**.

{{< img a-7.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../3.2-ec2/" />}}

