+++
title = "S3"
date =  2021-05-11T20:33:54-04:00
weight = 1
+++

### Backup S3 bucket

1.1 Click [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Click the **Protected resources** link, then click the **Create an on-demand backup** button.

{{< img BK-22.png >}}

1.3 Select **S3** as the **Resource type**, then select **backupandrestore-uibucket-xxxx** as the **Bucket name**. Select **Choose an IAM role**, then select **Team Role** as the **Role name**. Click the **Create on-demand backup** button.

{{< img BK-34.png >}}

1.4 This will create a **Backup job**.

{{< img BK-35.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../rds/" />}}
