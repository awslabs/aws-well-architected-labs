+++
title = "EC2"
date =  2021-05-11T20:35:50-04:00
weight = 1
+++

## Launch an EC2 instance from AMI (Amazon Machine Image)

1.1 Navigate to [EC2](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#/) in the **N. California (us-west-1)** region.

1.2 Click **AMIs** (Amazon Machine Images) under **Images** on the left menu. 

1.3 Verify that the AMI you created in the previous step has a status of **Available**.

{{< img BK-4.png >}}

1.4 Select the AMI and select **Actions**, then select **Launch**.

{{< img RS-7.png >}}

1.5 Select the `t3.micro` instance type and click **Next: Configure Instance Details**.

{{< img RS-8.png >}}

1.6 Set the IAM role to `BackupRestore-S3InstanceProfile` and leave everything else as default. Click **Next: Add Storage**.

{{< img rs-9.png >}}

1.7 Click through the next two screens leaving default values. Click **Next: Add tags** and **Next: Configure Security Group**.

1.8 Select **Create a new security group** and add the rules as shown.  Click **Review and Launch**. 

{{% notice note %}}
Copy the name of the security group.  You will need this in a later step.
{{% /notice %}}

{{< img ss-3.png >}}

1.9 Click **Launch**.

1.10 Select **Proceed without a key pair**, check the acknowledgment and then click **Launch Instances**.

{{< img RS-15.png >}}

{{% notice note %}}
Copy the Public IPv4 DNS of the instance.  You will need this in a later step.
{{% /notice %}}

{{< img RS-47.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../rds/" />}}
