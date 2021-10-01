+++
title = "RDS"
date =  2021-05-11T20:35:50-04:00
weight = 2
+++

## Restore RDS Database

1.1 Navigate to [AWS Backup](https://us-west-1.console.aws.amazon.com/backup/home?region=us-west-1#/) in **N. California (us-west-1)** region.

1.2 Click **Backup Vaults** and select **Default**.

{{< img BK-24.png >}}

{{% notice warning %}}
Backups will only appear when Copy Job has status of **Completed**.  To check the status of Copy Job, navigate to [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) in **N. Virginia (us-east-1)** region. Click **Jobs** on the left menu and then select **Copy jobs** tab.
{{% /notice %}}

{{< img BK-26.png >}}

1.3 Select the backup and select **Actions**, then select **Restore**.

{{< img BK-27.png >}}

1.4 Under Settings section, enter `backupandrestore-secondary-region` for DB Instance Identifier.
Under Network & Security section, select an Availability Zone.  

{{< img RS-18.png >}}

1.5 Leave all other values as default. Click **Restore backup**.

{{< img RS-20.png >}}

## Configure Security Group

2.1 Navigate to [VPC](https://us-west-1.console.aws.amazon.com/vpc/home?region=us-west-1#/) in **N. California (us-west-1)** region.

2.2 Click **Security Groups**, then click **Create Security Group**.

{{< img RS-23.png >}}

2.3 Under Basic details section, enter `rds-secondary-sg` for **Security group name** and **Description**.

{{< img RS-24.png >}}

2.4 Under Inbound Rules section, click **Add rule** and configure rule to allow MYSQL/Aurora TCP inbound port 3306 from the EC2 security group attached to the newly launched instance in the previous section.  Click **Create security group**.

{{% notice note %}}
The security group is from [EC2](../ec2/) instructions 1.8.
{{% /notice %}}

{{< img RS-40.png >}}

## Modify RDS Security Group

3.1 Navigate to [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) in **N. California (us-west-1)** region.

3.2 Select the 'backupandrestore-secondary-region', click **Modify**.

{{< img RS-25.png >}}

3.3 Under the Connectivity section, change the **Security group** to `rds-secondary-sg`.  Click **Continue**.

{{< img RS-27.png >}}

3.4 Select **Apply immediately** and click **Modify DB instance**.

{{< img RS-43.png >}}

3.5 Click on the `backupandrestore-secondary-region`.

{{< img RS-26.png >}}

{{% notice note %}}
Copy the name of the endpoint and port.  You will need this in a later step.
{{% /notice %}}

{{< img RS-46.png >}}

{{< prev_next_button link_prev_url="../ec2/" link_next_url="../modify-application/" />}}
