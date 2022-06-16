+++
title = "EC2"
date =  2021-05-11T20:33:54-04:00
weight = 1
+++

### Create the EC2 Amazon Machine Image (AMI)

{{% notice note %}}
For production workloads, these steps would be automated as part of your CI/CD pipeline. You want to ensure that your primary region and your secondary region are configured the same and with the same artifacts to ensure if you need to failover to your secondary region, your workload will work as it does in your primary region. You should also be validating your disaster recovery mechanisms and scenarios with Game Days as an ongoing exercise.
{{% /notice %}}

1.1 Click [EC2](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Click the **Instances (running)** link.

{{< img BK-4.png >}}

1.2 Select **UniShopAppV1EC2Pilot**.  Click **Create image** under the **Actions -> Images and Templates** dropdown.

{{< img BK-2.png >}}

1.3 Enter `UniShopAppV1EC2PilotAMI` as the **Image name**, then click the **Create Image** button.

{{< img BK-3.png >}}

### Copy the EC2 Amazon Machine Image (AMI)

2.1 Select **UnishopPilotLightEC2AMI**. Click **Copy AMI** under the **Actions** dropdown.

{{< img BK-5.png >}}

2.2 Select **US West (N. California)** as the **Destination Region**.

{{< img BK-6.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../../verify-primary-website/" />}}
