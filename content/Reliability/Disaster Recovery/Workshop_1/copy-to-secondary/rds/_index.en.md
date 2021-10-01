+++
title = "RDS"
date =  2021-05-11T20:33:54-04:00
weight = 1
+++

## Copy RDS Backup

1.1 Navigate to [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) in **N. Vriginia (us-east-1)** region.

1.2 Click **Backup Vaults** and select **Default**.

{{< img BK-24.png >}}

{{% notice note %}}
If you are using your own AWS account you may want to create a non-default vault for this workshop. this will prevent commingling of workshop backups with other backups in the default vault. Instructions can be found in the [service documentation](https://docs.aws.amazon.com/aws-backup/latest/devguide/vaults.html).
{{% /notice %}}

{{% notice warning %}}
Backups will only appear when Backup Job has status of **Completed**.  To check the status of Backup Job, click **Jobs** on the left menu and then select **Backup jobs** tab.
{{% /notice %}}

{{< img BK-26.png >}}

1.3 Select the backup and select **Actions**, then select **Copy**.

{{< img BK-27.png >}}

1.4 Select the **US West (N. California)** region and click the **Copy** button.

{{< img BK-28.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../ec2/" />}}
