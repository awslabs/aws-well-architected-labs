+++
title = "S3"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

### Configure S3 batch replication 

S3 Cross-Region Replication (CRR) is used to copy objects across Amazon S3 buckets in different AWS Regions. We are going to configure CRR between our primary region **N. Virginia (us-east-1)** bucket and our secondary region **N. California (us-west-1)** bucket.

1.1 Click [S3](https://s3.console.aws.amazon.com/s3/buckets/) to navigate to the dashboard.

1.2 Click the link for **pilot-primary-uibucket-xxxx**.

{{< img BK-1.png >}}

1.3 Click the **Management** link. In the **Replication rules** section, click the **Create replication rule** button.

{{< img BK-2.png >}}



{{% notice note %}}
If you are using your own AWS account you may want to create a non-default vault for this workshop. this will prevent commingling of workshop backups with other backups in the default vault. Instructions can be found in the [service documentation](https://docs.aws.amazon.com/aws-backup/latest/devguide/vaults.html).
{{% /notice %}}

1.3 In the **Backups** section. Select the S3 backup. Click **Restore** under the **Actions** dropdown.

{{< img BK-1.png >}}

{{% notice warning %}}
If you don't see your backup, check the status of the **Backup Job**.  Click the **Jobs** link, then click the **Backup jobs** link.  Verify the **Status** of your S3 backup is **Completed**.
{{% /notice %}}

1.4 In the **Settings** section. Select **Create new bucket** as the **Restore Destination**.

1.5 Enter `backupandrestore-uibucket-secondary` as the **New bucket name**.

1.6 Click **Restore backup** button.

{{< img BK-2.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../rds/" />}}
