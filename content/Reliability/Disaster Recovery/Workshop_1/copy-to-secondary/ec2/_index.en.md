+++
title = "EC2"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

### Copy the EC2 AMI (Amazon Machine Image)

1.1 Click [EC2](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Click the **AMIs** link.

1.3 Verify the **BackupAndRestoreImage** has a status of **Available**.

{{< img BK-4.png >}}

1.4 Select **BackupAndRestoreImage**.  Click **Copy AMI** under the **Actions** dropdown.

{{< img BK-6.png >}}

1.5 Select **US-West (N. California)** as the **Destination region**, then click the **Copy AMI** button.

{{< img BK-7.png >}}

{{< prev_next_button link_prev_url="../rds/" link_next_url="../../verify-website/" />}}
