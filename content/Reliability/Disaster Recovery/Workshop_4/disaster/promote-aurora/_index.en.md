+++
title = "Promote Aurora"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

Amazon Aurora Global Database is designed for globally distributed applications, allowing a single Amazon Aurora database to span multiple AWS regions. It replicates your data with no impact on database performance, enables fast local reads with low latency in each region, and provides disaster recovery from region-wide outages.  With Read Replica Write Forwarding feature, Aurora Global Database replicates writes in the primary region with typical latency of <1 second to secondary regions, for low latency global reads. In disaster recovery situations, you can promote a secondary region to take full read-write responsibilities in under a minute.

We are going to promote Aurora secondary database.

1.1 In the top right corner, change your region to **N. California (us-west-1)**.

1.2 Navigate to **RDS**.

{{< img a-1.png >}}

1.3 Click **DB Instances**.

{{< img a-2.png >}}

1.4 Select **hot-standby-passive-secondary** and click **Actions**. Select **Remove from global database** from list.

{{< img a-3.png >}}

1.5 Click **Remove and Promote**.

{{< img a-4.png >}}

1.6 It takes few minutes to complete  the operation.

#### <center>Congragulations !  Your Aurora Secondary Database has been promoted to a standalone database and can now be configured as the Primary database!
