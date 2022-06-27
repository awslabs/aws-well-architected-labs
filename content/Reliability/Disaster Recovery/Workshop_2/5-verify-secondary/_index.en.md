+++
title = "Verify Failover"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

## Secondary Region

1.1 Navigate to [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) in **N. California (us-west-1)** region.

1.2 Choose the **pilot-secondary** stack.

1.3 Then navigate to the **Outputs** tab.

{{< img vf-2.png >}}

1.4 Click on the **WebsiteURL** output link.

{{% notice warning %}}
You will have to wait a few minutes while the EC2 instance is launched and bootstrapped.  EC2 instance is running when you see the Unishop webpage with all the products.
{{% /notice %}}

## Verify the Website

2.1 Log in to the application. You need to provide the registered email from the **Pre-requisites > Primary Region** section.

2.2 You should see items in your shopping cart that you added from the primary region **N. Virginia (us-east-1)**.

{{< img vf-1.png >}}

{{< prev_next_button link_prev_url="../4-failover/4.2-ec2/" link_next_url="../6-cleanup" />}}