+++
title = "Aurora"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++

Amazon Aurora Global Database is designed for globally distributed applications, allowing a single Amazon Aurora database to span multiple AWS regions. It replicates your data with no impact on database performance, enables fast local reads with low latency in each region, and provides disaster recovery from region-wide outages. In disaster recovery situations, you can promote a secondary region to take full read-write responsibilities in under a minute.

With an Aurora global database, there are two different approaches to failover depending on the scenario.  

For this workshop we will be doing a [Managed Planned Failover](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html).

### Promote Aurora

1.1 Navigate to [RDS](https://us-east-1.console.aws.amazon.com/rds/home?region=us-east-1#databases:) in **N. Virginia (us-east-1)** region.

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

