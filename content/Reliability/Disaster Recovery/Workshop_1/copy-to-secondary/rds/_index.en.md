+++
title = "RDS"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

###  Copy RDS Backup

1.1 Click [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Click the **Backup Vaults** link, then click the **Default** link.

{{< img BK-24.png >}}

1.3 In the **Backups** section. Select the RDS backup. Click **Copy** under the **Actions** dropdown.

{{< img BK-27.png >}}

{{% notice warning %}}
If you don't see your backup, check the status of the **Backup Job**.  Click the **Jobs** link, then click the **Backup jobs** link.  Verify the **Status** of your RDS backup is **Completed**.
{{% /notice %}}

1.4 Select **US West (N. California)** as the **Copy to destination**, then select **Choose an IAM Role** and select **Team Role** as the **Role name**. Click the **Copy** button.

{{< img BK-28.png >}}

{{< prev_next_button link_prev_url="../s3//" link_next_url="../ec2/" />}}
