+++
title = "Verify Aurora Write Forwarding"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

Amazon Aurora Global Database is designed for globally distributed applications, allowing a single Amazon Aurora database to span multiple AWS regions. It replicates your data with no impact on database performance, enables fast local reads with low latency in each region, and provides disaster recovery from region-wide outages.

The **Read-Replica Write Forwarding** feature's typical latency is under one second from secondary to primary databases.  This capability enables low latency global reads across your global presence. In disaster recovery situations, you can promote a secondary region to take full read-write responsibilities in under a minute.

Now, let us verify Amazon Aurora MySQL Read-Replica Write Forwarding on our Amazon Aurora MySQL Replica instance!

### Verifying Amazon Aurora Write Forwarding

1.1 Click [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Click **DB Instances** link.

{{< img a-2.png >}}

1.3 Click the **hot-standby-passive-secondary** link.

{{< img a-3.png >}}

1.4 Click the **Configuration** link and verify **Read replica write forwarding** is **Enabled**.

{{< img a-4.png >}}

{{< prev_next_button link_prev_url="../dynamodb-global/" link_next_url="../configure-websites/" />}}