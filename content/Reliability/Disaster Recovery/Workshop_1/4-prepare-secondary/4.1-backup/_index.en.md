+++
title = "Backup"
date =  2021-05-11T20:33:54-04:00
weight = 1
+++

We are going to backup the resources in our primary region **N. Virginia (us-east-1)**.

### Backup the RDS database

1.1 Click [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Click the **Protected resources** link, then click the **Create an on-demand backup** button.

{{< img bk-1.png >}}

1.3 Select **RDS** as the **Resource type**, then select **unishopappv1dbbackupandrestore** as the **Database name**. Select **Choose an IAM role**, then select **Team Role** as the **Role name**. Click the **Create on-demand backup** button.

{{< img bk-5.png >}}

1.4 This will create a **Backup job**.

### Backup the EC2 instance

2.1 Click the **Protected resources** link, then click the **Create an on-demand backup** button.

2.2 Select **EC2** as the **Resource type**, then select **UniShopAppV1EC2BackupAndRestore** as the **Instance ID**.  Select **Choose an IAM role**, then select **Team Role** as the **Role name**. Click the **Create on-demand backup** button.

{{< img bk-8.png >}}

2.3 This will create a **Backup job**.

{{% notice note %}}
Backups can also protect against corruption or accidental deletion of data.
{{% /notice %}}

You should see your two backup jobs.  

{{< img bk-10.png >}}

{{% notice warning %}}
As each job moves into a status of **Completed**, you can move onto **Copy**. This may take approximately **5** minutes.
{{% /notice %}}

{{< prev_next_button link_prev_url="../" link_next_url="../4.2-copy/" />}}