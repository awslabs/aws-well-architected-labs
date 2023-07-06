+++
title = "EC2"
date =  2021-05-11T20:33:54-04:00
weight = 1
+++

#### Create the EC2 Amazon Machine Image (AMI)

1.1 Click [EC2](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:instanceState=running) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Select **pilot-primary**.  Click **Create image** under the **Actions -> Images and Templates** dropdown.

{{< img BK-2.png >}}

1.3 Enter `pilotAMI` as the **Image name**, then click the **Create Image** button.

{{< img BK-3.png >}}

#### Copy the EC2 Amazon Machine Image (AMI)

2.1 Click [AMIs](https://us-east-1.console.aws.amazon.com/ec2/v2/home?region=us-east-1#Images:visibility=owned-by-me) to navigate to the dashboard.

{{% notice warning %}}
You will need to wait for the AMI status to be **Available** before moving on to the next step.  This can take several minutes.
{{% /notice %}}

2.2 Select **pilotAMI**. Click **Copy AMI** under the **Actions** dropdown.

{{< img BK-5.png >}}

2.3 Select **US West (N. California)** as the **Destination Region**.

{{< img BK-6.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../../4-failover/" />}}
