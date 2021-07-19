+++
title = "Enable Aurora Write Forwarding"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

Amazon Aurora Global Database is designed for globally distributed applications, allowing a single Amazon Aurora database to span multiple AWS regions. It replicates your data with no impact on database performance, enables fast local reads with low latency in each region, and provides disaster recovery from region-wide outages.

The Read-Replica Write Forwarding feature's typical latency is under one second from secondary to primary databases.  This capability enables low latency global reads across your global presence. In disaster recovery situations, you can promote a secondary region to take full read-write responsibilities in under a minute.

Now, let us configure Amazon Aurora MySQL Read-Replica Write Forwarding on our Amazon Aurora MySQL Replica instance!

1.1 Change your [console](https://us-west-1.console.aws.amazon.com/console)’s region to us-west-1 using the Region Selector in the upper right corner.

1.2 Navigate to **RDS** in the console.

{{< img a-1.png >}}

1.3 Nex, click into **DB Instances**.

{{< img a-2.png >}}

1.4 Select **dr-immersionday-secondary-warm** and click **Modify**.

{{< img a-3.png >}}

1.5 Scroll down to **Read Replica Write Forwarding** and check the **Enable read replica write forwarding** checkbox.

{{< img a-4.png >}}

1.6 Scroll down to the bottom of the page and click **Continue**.  

1.7 Finally, chose **Apply immediately** and click **Modify Cluster** to confirm.

{{< img a-5.png >}}

## Congratulations! Your Amazon Aurora Global Database now supports Read-Replica Write Forwarding!
