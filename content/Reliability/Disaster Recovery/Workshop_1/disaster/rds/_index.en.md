+++
title = "RDS"
date =  2021-05-11T20:35:50-04:00
weight = 2
+++

### Restore RDS Database

1.1 Click [AWS Backup](https://us-west-1.console.aws.amazon.com/backup/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Click the **Backup Vaults** link, then click the **Default** link.

{{< img BK-24.png >}}

1.3 In the **Backups** section. Select the backup. Click **Restore** under the **Actions** dropdown.

{{< img BK-27.png >}}

{{% notice warning %}}
If you don't see your backup, check the status of the **Copy Job**. Click [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) to navigate to the dashboard in **N. Virginia (us-east-1)** region. Click the **Jobs** link, then click the **Copy jobs** link.  Verify the **Status** of your backup is **Completed**.
{{% /notice %}}

{{< img BK-26.png >}}

1.4 In the **Settings** section, enter `backupandrestore-secondary-region` as the **DB Instance Identifier**. Under **Network & Security** section, select **us-west-1a** as the **Availability zone**.

{{< img RS-18.png >}}

1.5 Click the **Restore backup** button.

{{< img RS-20.png >}}

### Configure Security Group

2.1 Click [VPC](https://us-west-1.console.aws.amazon.com/vpc/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

2.2 Click the **Security Groups** link, then click the **Create security group** button.

{{< img RS-23.png >}}

2.3 In the **Basic details** section, enter `backupandrestore-us-west-rds-SG` as the **Security group name** and **Description**.

{{< img RS-24.png >}}

2.4 in the **Inbound Rules** section, click the **Add rule** button.  Select **MYSQL/Aurora** as the **Type**.  Select **Customer** as the **Source** and choose **backupandrestore-us-west-ec2-SG**.  This will allow the communication between your EC2 instance and your RDS instance. Click the **Create security group** button.

{{< img RS-40.png >}}

### Modify RDS Security Group

3.1 Click [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

3.2 Click the **DB Instances** link.

{{< img BK-1.png >}}

3.3 Select **backupandrestore-secondary-region**, then click the **Modify** button.

{{% notice note %}}
The database must have a **Status** of **Available**.
{{% /notice %}}

{{< img RS-25.png >}}

3.4 In the **Connectivity** section, select **backupandrestore-us-west-rds-SG** as the **Security group**. Click the **Continue** button.

{{< img RS-27.png >}}

3.5 Select **Apply immediately** and then click the **Modify DB instance** button..

{{< img RS-43.png >}}

3.6 Click the **backupandrestore-secondary-region** link.

{{< img RS-26.png >}}

{{% notice note %}}
Copy the name of the endpoint and port.  You will need this in a later step.
{{% /notice %}}

{{< img RS-46.png >}}

{{< prev_next_button link_prev_url="../ec2/" link_next_url="../modify-application/" />}}
