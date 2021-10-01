+++
title = "RDS"
date =  2021-05-11T20:33:54-04:00
weight = 1
+++

## Backup the RDS database 

1.1 Navigate to [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) in **N. Vriginia (us-east-1)** region.

1.2 Navigate to the AWS backup **Protected resources** page and click the **Create an on-demand backup** button.

{{< img BK-22.png >}}

1.3 Select **RDS** from the **Resource type** pull-down menu, then search and select the RDS database. Click the **Create on-demand backup** button.

{{< img BK-23.png >}}

In a later step, after the Status changes to **Completed**, we will copy the backup to the secondary region **N. California (us-west-1)**.

{{< img BK-24.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../ec2/" />}}
