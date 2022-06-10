+++
title = "RDS"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

### Backup the RDS database

Creating a backup of the database will allow us to copy the backup to another region and restore the database in that region in case of a disaster event.  

{{% notice note %}}
Backups can also protect against corruption or accidental deletion of data.
{{% /notice %}}

1.1 Click [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Click the **Protected resources** link, then click the **Create an on-demand backup** button.

{{< img BK-22.png >}}

1.3 Select **RDS** as the **Resource type**, then select **unishopappv1dbbackupandrestore** as the **Database name**. Select **Choose an IAM role**, then select **Team Role** as the **Role name**. Click the **Create on-demand backup** button.

{{< img BK-23.png >}}

1.4 This will create a **Backup job**.

{{< img BK-27.png >}}

{{< prev_next_button link_prev_url="../s3" link_next_url="../ec2/" />}}
