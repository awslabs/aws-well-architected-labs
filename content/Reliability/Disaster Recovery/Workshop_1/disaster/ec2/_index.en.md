+++
title = "EC2"
date =  2021-05-11T20:35:50-04:00
weight = 2
+++

### Restore EC2

We will now launch an EC2 instance from AWS Backup into our secondary region **N. California (us-west-1)**.

1.1 Click [AWS Backup](https://us-west-1.console.aws.amazon.com/backup/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Click the **Backup Vaults** link, then click the **Default** link.

{{< img BK-24.png >}}

1.3 In the **Backups** section. Select the EC2 backup. Click **Restore** under the **Actions** dropdown.

{{< img BK-1.png >}}

{{% notice warning %}}
If you don't see your backup, check the status of the **Copy Job**. Click [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) to navigate to the dashboard in **N. Virginia (us-east-1)** region. Click the **Jobs** link, then click the **Copy jobs** link.  Verify the **Status** of your EC2 copy job is **Completed**.
{{% /notice %}}

1.4 In the **Network settings** section, select **BackupAndRestoreDB-EC2SecurityGroup-xxxx** as the **Security groups**.

{{< img BK-2.png >}}

1.5 Select **Choose an IAM Role** and select **Team Role** as the **Role name**. Click the **Restore backup** button.

{{< img BK-4.png >}}

{{% notice note %}}
Copy the portion of the **Resource ID** that starts with **i-**. You will need this in a later step.
{{% /notice %}}

{{< img bk-3.png >}}

{{< prev_next_button link_prev_url="../rds" link_next_url="../modify-application/" />}}
