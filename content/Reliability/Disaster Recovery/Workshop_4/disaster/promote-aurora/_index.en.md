+++
title = "Promote Aurora"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

Amazon Aurora Global Database is designed for globally distributed applications, allowing a single Amazon Aurora database to span multiple AWS regions. It replicates your data with no impact on database performance, enables fast local reads with low latency in each region, and provides disaster recovery from region-wide outages. In disaster recovery situations, you can promote a secondary region to take full read-write responsibilities in under a minute.

Now let us promote the Amazon Aurora MySQL Secondary instance to a standalone instance.

### Promote Aurora secondary database

1.1 Click [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Click the **DB Instances** link.

{{< img a-2.png >}}

1.3 Select **hot-standby-passive-secondary** then click **Remove from global database** in the **Actions** dropdown.

{{< img a-3.png >}}

1.4 Click the **Remove and Promote** button.

{{< img a-4.png >}}

#### Congratulations! Your Amazon Aurora Secondary Database is now a standalone database and can become a primary database!

{{< prev_next_button link_prev_url="../" link_next_url="../ec2-instance/" />}}

