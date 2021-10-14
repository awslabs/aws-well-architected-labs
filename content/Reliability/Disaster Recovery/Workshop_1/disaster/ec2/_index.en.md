+++
title = "EC2"
date =  2021-05-11T20:35:50-04:00
weight = 1
+++

###  Launch an EC2 instance from AMI (Amazon Machine Image)

1.1 Click [EC2](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Click the **AMIs** link.

1.3 Verify the **BackupAndRestoreImage** has a status of **Available**.

{{< img BK-4.png >}}

1.4 Select **BackupAndRestoreImage**.  Click the **Launch** button.

{{< img RS-7.png >}}

1.5 Select the **t2.micro** instance type, then click the **Next: Configure Instance Details** button.

{{< img RS-8.png >}}

1.6 Select **BackupRestore-S3InstanceProfile-xxxx** as the **IAM Role**, then click the **Next: Add Storage** button.

{{< img rs-9.png >}}

1.7 Click the **Next: Add tags** button and click the **Next: Configure Security Group** button.

1.8 Select **Create a new security group** and enter `backupandrestore-us-west-ec2-SG` as the **Security group name** and **Description**.  Add the rules as shown by clicking the **Add Rule** button.  (Click on image to enlarge) Click the **Review and Launch** button.

{{< img ss-3.png >}}

1.9 Click the **Launch** button.

1.10 Select **Proceed without a key pair**, enable the **I acknowledge that without a key pair,...** checkbox, then click the **Launch Instances** button.

{{< img RS-15.png >}}

{{% notice note %}}
Copy the Public IPv4 DNS of the instance.  You will need this in a later step.
{{% /notice %}}

{{< img RS-47.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../rds/" />}}
