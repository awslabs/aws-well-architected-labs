+++
title = "Promote Aurora"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

Amazon Aurora Global Database is designed for globally distributed applications, allowing a single Amazon Aurora database to span multiple AWS regions. It replicates your data with no impact on database performance, enables fast local reads with low latency in each region, and provides disaster recovery from region-wide outages. In disaster recovery situations, you can promote a secondary region to take full read-write responsibilities in _under a minute_!

## We are going to promote Aurora secondary database

1.1 Change your [console](https://us-west-1.console.aws.amazon.com/console)’s region to us-west-1 using the Region Selector in the upper right corner.

1.2 Navigate to **RDS** in the console

{{< img a-1.png >}}

1.3 Click on **DB Instances**.

{{< img a-2.png >}}

1.4 Select **dr-immersionday-secondary-pilot** and click **Actions**. Click **Remove from global database** from the dropdown list.

{{< img a-3.png >}}

1.5 Click **Remove and Promote**.

{{< img a-4.png >}}

1.6 It takes few minutes to complete  the operation.

## Congratulations! Your Aurora Secondary Database is promoted to a stand-alone database and can now become the Primary database!
