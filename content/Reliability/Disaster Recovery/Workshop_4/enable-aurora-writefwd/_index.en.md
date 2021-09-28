+++
title = "Enable Aurora Write Forwarding"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

Amazon Aurora Global Database is designed for globally distributed applications, allowing a single Amazon Aurora database to span multiple AWS regions. It replicates your data with no impact on database performance, enables fast local reads with low latency in each region, and provides disaster recovery from region-wide outages.

The Read-Replica Write Forwarding feature's typical latency is under one second from secondary to primary databases.  This capability enables low latency global reads across your global presence. In disaster recovery situations, you can promote a secondary region to take full read-write responsibilities in under a minute.

Now, let us configure Amazon Aurora MySQL Read-Replica Write Forwarding on our Amazon Aurora MySQL Replica instance!

{{% notice note %}}
**You must wait for the Secondary Region stack to successfully be created before moving on to this step.**
{{% /notice %}}

## Configuring Amazon Aurora Write Forwarding

1.1 Change your [console](https://us-west-1.console.aws.amazon.com/console)’s region to **N. California (us-west-1)** using the Region Selector in the upper right corner.

1.2 Navigate to **RDS** in the console.

{{< img a-1.png >}}

1.3 Next, click into **DB Instances**.

{{< img a-2.png >}}

1.4 Select **hot-standby-passive-secondary** and click the **Modify** button.

{{< img a-3.png >}}

1.5 Scroll down to **Read Replica Write Forwarding** and check the **Enable read replica write forwarding** checkbox.

{{< img a-4.png >}}

1.6 Scroll down to the page's bottom and click the **Continue** button. Finally click the **Modify Cluster** button.

## Congratulations! Your Amazon Aurora Global Database now supports Read-Replica Write Forwarding!

{{< prev_next_button link_prev_url="../dynamodb-global/" link_next_url="../configure-websites/" />}}