+++
title = "Aurora"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

Amazon Aurora Global Database is designed for globally distributed applications, allowing a single Amazon Aurora database to span multiple AWS regions. It replicates your data with no impact on database performance, enables fast local reads with low latency in each region, and provides disaster recovery from region-wide outages. In disaster recovery situations, you can promote a secondary region to take full read-write responsibilities in under a minute.

With an Aurora global database, there are two different approaches to failover depending on the scenario.  

For this workshop we will be doing a [Managed Unplanned Failover](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-disaster-recovery.html).

#### Promote Aurora secondary database

1.1 Click [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#databases:) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Look at the **hot-global** Global database. Notice how we have **hot-primary** a **Primary cluster** in **us-east-1** which has our **Writer instance** and **hot-secondary** a **Secondary cluster** in **us-west-1** which has our **Reader instance**.

{{< img a-5.png >}}

1.3 Select **hot-secondary** instance and click **Actions**. Next click the **Remove from global database** option to promote the instance to a standalone database.

{{< img a-3.png >}}

1.4 Click **Remove and Promote** to confirm the database promotion.

{{< img a-4.png >}}

{{% notice warning %}}
You will need to wait for the database to be successfully promoted before moving on to the next step.  This can take several minutes.
{{% /notice %}}

1.5 Notice the changes. **Hot-secondary** has been removed from the **Global database** and is now a **Regional cluster** with its own **Writer instance**. You may need to click the **Refresh** button to see the changes.

{{< img a-6.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../5.2-ec2/" />}}
