+++
title = "Verify Failover"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

## Secondary Region

1.1 Navigate to the [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/).

1.2 Choose the **Pilot-Secondary** stack.

1.3 Then navigate to the **Outputs** tab.

{{< img vf-2.png >}}

1.4 Click on the **WebsiteURL** output link.

## Verify the Website

2.1 Log in to the application. You need to provide the registered email from the **Pre-requisites > Primary Region** section.

2.2 You should see items in your shopping cart that you added from the primary region **N. Virginia (us-east-1)**.

{{< img vf-1.png >}}

{{< prev_next_button link_prev_url="../failover/promote-aurora/" link_next_url="../cleanup" />}}