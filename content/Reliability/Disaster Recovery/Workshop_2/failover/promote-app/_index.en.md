+++
title = "Promote App in Secondary Region"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++


1.1 Navigate to the [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/).

1.2 Select the **Pilot-Secondary** stack and click **Update**.

{{< img da-2.png >}}

1.3 Chose **Use current template** and click **Next** to continue.

{{< img da-3.png >}}

1.4 Update the **IsPromote** parameter to `yes` and click **Next** to continue.

{{< img da-4.png >}}

1.5 Scroll to the bottom of the page, click the checkbox to acknowledge IAM role creation, and then click **Update stack**.

{{< img da-5.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../promote-aurora/" />}}

