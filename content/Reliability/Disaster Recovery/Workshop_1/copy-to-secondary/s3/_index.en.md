+++
title = "S3"
date =  2021-05-11T20:33:54-04:00
weight = 1
+++

### Restore the S3 backup

1.1 Click [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Click the **Backup Vaults** link, then click the **Default** link.

{{< img BK-24.png >}}

{{% notice note %}}
If you are using your own AWS account you may want to create a non-default vault for this workshop. this will prevent commingling of workshop backups with other backups in the default vault. Instructions can be found in the [service documentation](https://docs.aws.amazon.com/aws-backup/latest/devguide/vaults.html).
{{% /notice %}}

1.3 In the **Backups** section. Select the S3 backup. Click **Restore** under the **Actions** dropdown.

{{< img BK-1.png >}}

{{% notice warning %}}
If you don't see your backup, check the status of the **Backup Job**.  Click the **Jobs** link, then click the **Backup jobs** link.  Verify the **Status** of your S3 backup is **Completed**.
{{% /notice %}}

1.4 In the **Settings** section. Select **Create new bucket** as the **Restore destination**.

1.5 Copy the **Resource ID** and paste it into the **New bucket name** adding in `-secondary` to the end.

{{< img BK-2.png >}}

1.6 Select **Choose an IAM role**, then select **Team Role** as the **Role name**. Click **Restore backup** button.

{{< img BK-3.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../rds/" />}}
