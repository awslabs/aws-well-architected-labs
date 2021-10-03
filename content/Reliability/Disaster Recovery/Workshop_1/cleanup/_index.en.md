+++
title = "Cleanup Resources"
date =  2021-05-11T20:41:47-04:00
weight = 6
+++

## Cleanup Amazon S3

1.1 Navigate to [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/).

1.2 Select the bucket with prefix **backupandrestore-uibucket-xxxx** and click the **Empty** button.

{{< img cl-1.png >}}

1.3 Enter `permanently delete` into the confirmation box and then click **Empty**.

{{< img cl-3.png >}}

1.4 Wait until you see the green banner across the top of the page, indicating the bucket is empty. Then click the **Exit** button.

{{< img cl-4.png >}}

{{% notice note %}}
Please repeat steps **1.1** through **1.4** for the following buckets:</br>
`backupandrestore-uibucket-xxxx-dr`
{{% /notice %}}

## Cleanup Amazon CloudFormation

2.1 Navigate to [CloudFormation](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/) in the **N. Virginia (us-east-1)** region.

2.2 Select the **BackupAndRestore** stack and click the **Delete** button.

{{< img cl-8.png >}}

2.3 Click the **Delete stack** button to confirm the removal.

{{< img cl-9.png >}}

## Delete the contents of the backup vaults

3.1 Navigate to [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) in the **N. Virginia (us-east-1)** region.

3.2 Click **Backup Vaults** and select **Default**.

{{< img BK-24.png >}}

3.3 Select all the backups and select **Actions**, then select **Delete**.

{{< img BK-27.png >}}

3.4 Click the **Delete** button.

{{< img BK-28.png >}}

{{% notice note %}}
Please repeat steps **3.1** through **3.3** for [AWS Backup](https://us-west-1.console.aws.amazon.com/backup/home?region=us-west-1#/) in the **N. California (us-west-1)** region.
{{% /notice %}}

### Delete the RDS instance

4.1 Navigate to [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) in the **N. California (us-west-1)** region.

4.2 Select the **backupandrestore-secondary-region** database.  Select **Actions**, then select **Delete**.

{{< img CL-21.png >}}

4.3  Uncheck the **Create final snapshot** and **Retain automated backups** checkboxes. Next, enable the **I acknowledgement ...** checkbox.  Enter `delete me` into the confirmation box. Click the **Delete** button.

{{< img cl-13.png >}}

## Delete EC2 Instance, AMI (Amazon Machine Image) and Security Group

5.1 Navigate to [EC2](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#/) in the **N. California (us-west-1)** region.

5.2 Select the instance and click **Instance State**, then click **Terminate instance**.

{{% notice note %}}
If you have more than one instance running you can verify you are selecting the correct one by checking **Security group name**.
{{% /notice %}}

{{< img CL-26.png >}}

5.3 Navigate to **AMIs** and select the AMI.  Click **Actions**, then click **Deregister**.

{{< img CL-27.png >}}

5.4 Click the **Confirm** button.

{{< img CL-28.png >}}

5.5 Navigate to **Security groups**. Select all security groups created **launch-wizard-1** and **rds-secondary-sg**. Click **Actions**, then click **Delete security groups**.

{{< img CL-29.png >}}

5.6 Click the **Delete** button.

{{% notice info %}}
You must repeat steps 5.3 and 5.4 for **AMI Deregistration** in [EC2](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#/) in the **N. Virginia (us-east-1)** region.  You must repeat steps 5.5 and 5.6 for **Security groups deletion** in [EC2](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#/) in the **N. Virginia (us-east-1)** region.
{{% /notice %}}

{{< prev_next_button link_prev_url="../disaster/modify-application/" title="Congratulations!" final_step="true" >}}
This lab specifically helps you with the best practices covered in question [REL 13  How do you plan for disaster recovery (DR)](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}
