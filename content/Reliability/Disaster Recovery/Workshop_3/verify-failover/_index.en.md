+++
title = "Verify Failover"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

1.1 Go to [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) in the Secondary region (us-west-1). Click on the **Warm-Secondary** stack and drill into the **Outputs** tab.

1.2 Find the **WebSiteURL** parameter and click on its value to launch the website.

{{< img vf-2.png >}}

## Verify the Website

2.1 Log in to the application. You need to provide the registered email from the **Pre-requisites > Primary Region** section.
2.2 You should see items in your shopping cart that you added from the Primary region.

{{< img vf-1.png >}}

{{< prev_next_button link_prev_url="../failover/promote-aurora/" link_next_url="../cleanup" />}}

