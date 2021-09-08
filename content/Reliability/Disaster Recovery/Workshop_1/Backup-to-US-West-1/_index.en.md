+++
title = "Backup to US-west-1"
date =  2021-05-11T20:33:54-04:00
weight = 6
+++

We will now back up our application to the DR region us-west-1. We will perform the following steps:
- Backup the EC2 instance
- Backup the RDS database
- Backup the S3 UI bucket

## Backup the EC2 instance

If our EC2 instance contained application data, it would be necessary to schedule recurring backups to meet the target RPO. [AWS Backup](https://aws.amazon.com/backup) provides this functionality through a dashboard that makes it simple to audit backup and restores activity across AWS services. Since our instance contains no data, only code, we will create a one-time backup. Reoccuring backups are necessary for a production application every time a change occurs to the EC2 instance.

1.1 Login to the AWS [Console](https://us-east-1.console.aws.amazon.com/console) and navigate to **EC2** by searching for it.

{{< img BK-1.png >}}

1.2 Select the newly created EC2 instance ( Name: UniShopApp..EC2 ) and use the **Actions** menu to choose **Actions**, **Images and Templates**, then **Create Image**.

{{< img BK-2.png >}}

1.3 Enter a name for the image and click the **Create Image** button.

{{< img BK-3.png >}}

1.4 Navigate to **AMIs** (Amazon Machine Images) under **Images** on the left menu. Wait for the deployment status to change to **Available**.

**Tip:** It may take several minutes for this step to complete. While waiting, you can open a new browser tab and start the [RDS database backup](#rds-backup).

{{< img BK-4.png >}}
{{< img BK-5.png >}}

1.5 Select the new **AMI** and use the **Actions** menu to choose **Copy AMI**.

{{< img BK-6.png >}}

1.6 Select the US-West (N. California) region and click the **Copy AMI** button.

**Tip:** If you're not using us-east-1 and us-west-1 regions for this workshop then choose a different region from the original one in which the application is currently deployed.

{{< img BK-7.png >}}

<a id="rds-backup"></a> 
## Backup the RDS database 

We would create a [backup plan](https://docs.aws.amazon.com/aws-backup/latest/devguide/creating-a-backup-plan.html) for a production application and schedule recurring backups to meet the target RPO. For the workshop, we will create a manual backup.

2.1 Navigate to **AWS Backup** by searching for **AWS Backup** on the AWS [Console](https://us-east-1.console.aws.amazon.com/console) and selecting it.

{{< img BK-10.png >}}

2.2 Navigate to the AWS backup **Protected resources** page and click the **Create an on-demand backup** button.

{{< img BK-22.png >}}

2.3 Select **RDS** from the **Resource type** pull-down menu, then search and select the RDS database. Click the **Create on-demand backup** button.

{{< img BK-23.png >}}

When the Status changes to **Completed**, we will copy the backup to the DR region.

{{< img BK-24.png >}}

Grab a snack! This step takes about 10 minutes to complete.

{{< img BK-25.png >}}

2.4 Locate the backup in the Backup Vault by clicking **Backup Vaults** and select **default**.

{{% notice note %}}
If you are using your own AWS account you may want to create a non-default vault for this workshop. this will prevent commingling of workshop backups with other backups in the default vault. Instructions can be found in the [service documentation](https://docs.aws.amazon.com/aws-backup/latest/devguide/vaults.html).
{{% /notice %}}

**Tip:** Backups will not appear until the previous step completes successfully.

{{< img BK-26.png >}}

Use the **Actions** menu to select **Copy**.

{{< img BK-27.png >}}

Select the US West (N. California) region and click the **Copy** button.

{{< img BK-28.png >}}

## Backup the S3 UI bucket

3.1 Navigate to S3

{{< img BK-35.png >}}

3.2 Note the names of the primary region bucket.

{{< img RS-48.png >}}

Click the **Create bucket** button.

{{< img BK-29.png >}}

Use the same bucket name as the primary bucket and append a “-dr” at the end. Next, select the US West (N. California) us-west-1 region. Finally, save this bucket name as we will need it for our DR runbook.

{{< img BK-30.png >}}

Disable Block all public Access by disabling the root checkbox (and underlying checkboxes as well). Check the acknowledgment box.

{{< img BK-31.png >}}

Leave the rest default and click **Create Bucket**.

{{< img BK-32.png >}}

## We are ready for a disaster!
