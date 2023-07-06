+++
title = "Verify Failover"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

#### Secondary Region

1.1 Click [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Choose the **warm-secondary** stack.

1.3 Click the **Outputs** link.

{{< img vw-6.png >}}

1.4 Click on the **WebsiteURL** output link and open in a new browser tab or window.

{{% notice warning %}}
If you still have the website opened from a previous step you will need to **Logout** before performing the next steps.
{{% /notice %}}

#### Verify the Website

2.1 Log in to the application. You need to provide the registered email from the **Pre-requisites > Primary Region** section.

2.2 You should see items in your shopping cart that you added from the primary region **N. Virginia (us-east-1)**.

{{< img vf-1.png >}}

{{< prev_next_button link_prev_url="../3-failover/3.2-ec2/" link_next_url="../5-cleanup" />}}

