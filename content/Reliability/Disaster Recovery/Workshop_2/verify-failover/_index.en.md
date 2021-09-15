+++
title = "Verify Failover"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

Navigate to [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) in the Secondary region (us-west-1).

{{% notice info %}}
**You must wait for your CloudFormation Template Update to complete before moving on to this step.**
{{% /notice %}}

{{< img vf-0.png >}}

Click on the CloudFormation stack **Pilot-Secondary** and drill into the **Outputs** tab.
{{< img vf-2.png >}}


Click on **WebsiteURL** parameter value to goto website
{{< img vf-3.png >}}

## Verify the Website

1.1 Login into the application. You just need to provide the registered email.
1.2 You should see items in your shopping cart that you added in primary region.

{{< img vf-4.png >}}

{{< prev_next_button link_prev_url="../failover/promote-aurora/" link_next_url="../cleanup/" />}}
