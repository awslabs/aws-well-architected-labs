+++
title = "Copy"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

We are going to **copy** the resources to our secondary region **N. California (us-west-1)**.

####  Copy EC2 Backup

1.1 Click the **Backup Vaults** link, then click the **Default** link.

{{< img cp-1.png >}}

1.2 In the **Backups** section. Select the EC2 backup. Click **Copy** under the **Actions** dropdown.

{{% notice warning %}}
If you don't see your backup, check the status of the **Backup Job**.  Click the **Jobs** link, then click the **Backup jobs** link.  Verify the **Status** of your EC2 backup is **Completed**.
{{% /notice %}}

{{< img cp-4.png >}}

1.3 Select **US West (N. California)** as the **Copy to destination**, then select **Choose an IAM Role** and select **Team Role** as the **Role name**. Click the **Copy** button.

{{< img cp-5.png >}}

1.4 This will create a **Copy job**.

#### Copy the RDS backup

2.1 Click the **Backup Vaults** link, then click the **Default** link.

{{< img cp-1.png >}}

2.2 In the **Backups** section. Select the RDS backup. Click **Copy** under the **Actions** dropdown.

{{% notice warning %}}
If you don't see your backup, check the status of the **Backup Job**.  Click the **Jobs** link, then click the **Backup jobs** link.  Verify the **Status** of your RDS backup is **Completed**.
{{% /notice %}}

{{< img cp-2.png >}}

2.3 Select **US West (N. California)** as the **Copy to destination**, then select **Choose an IAM Role** and select **Team Role** as the **Role name**. Click the **Copy** button.

{{< img cp-3.png >}}

2.4 This will create a **Copy job**.

You should see your two copy jobs.  

{{< img cp-6.png >}}

{{< prev_next_button link_prev_url="../4.1-backup/" link_next_url="../../5-failover/" />}}
