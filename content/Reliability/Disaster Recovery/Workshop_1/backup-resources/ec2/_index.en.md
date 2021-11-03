+++
title = "EC2"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

### Create an AMI (Amazon Machine Image)

If our EC2 instance contained application data, it would be necessary to schedule recurring backups to meet the target RPO. [AWS Backup](https://aws.amazon.com/backup) provides this functionality through a dashboard that makes it simple to audit backup and restores activity across AWS services. Since our instance contains no data, only code, we will create a one-time backup. Reoccuring backups are necessary for a production application every time a change occurs to the EC2 instance.

1.1 Click [EC2](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Click the **Instances (running)** link.

{{< img BK-4.png >}}

1.2 Select **UniShopAppV1EC2BackupAndRestore**.  Click **Create image** under the **Actions -> Images and Templates** dropdown.

{{< img BK-2.png >}}

1.3 Enter `BackupAndRestoreImage` as the **Image name**, then click the **Create Image** button.

{{< img BK-3.png >}}

{{< prev_next_button link_prev_url="../rds" link_next_url="../s3/" />}}
