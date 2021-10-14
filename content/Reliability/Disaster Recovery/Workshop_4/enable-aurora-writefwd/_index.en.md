+++
title = "Enable Aurora Write Forwarding"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

Amazon Aurora Global Database is designed for globally distributed applications, allowing a single Amazon Aurora database to span multiple AWS regions. It replicates your data with no impact on database performance, enables fast local reads with low latency in each region, and provides disaster recovery from region-wide outages.

The Read-Replica Write Forwarding feature's typical latency is under one second from secondary to primary databases.  This capability enables low latency global reads across your global presence. In disaster recovery situations, you can promote a secondary region to take full read-write responsibilities in under a minute.

Now, let us configure Amazon Aurora MySQL Read-Replica Write Forwarding on our Amazon Aurora MySQL Replica instance!

{{% notice note %}}
**If you are using your own AWS Account, you must wait for the Secondary Region stack to successfully be created before moving on to this step.**
{{% /notice %}}

### Configuring Amazon Aurora Write Forwarding

1.1 Click [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Click **DB Instances** link.

{{< img a-2.png >}}

1.3 Select **hot-standby-passive-secondary** and click the **Modify** button.

{{< img a-3.png >}}

1.4 Scroll down to **Read Replica Write Forwarding** and check the **Enable read replica write forwarding** checkbox.

{{< img a-4.png >}}

1.5 Scroll down to the page's bottom and click the **Continue** button. 

1.6 Select **Apply immediatley** and click the **Modify Cluster** button.

{{< img a-5.png >}}

{{% notice note %}}
This might take a few minutes, feel free to move onto the next step.  Just make sure the hot-standby-passive-secondary cluster status is showing **Available** before **Verify Websites** step.
{{% /notice %}}

#### Congratulations! Your Amazon Aurora Global Database now supports Read-Replica Write Forwarding!

{{< prev_next_button link_prev_url="../dynamodb-global/" link_next_url="../configure-websites/" />}}