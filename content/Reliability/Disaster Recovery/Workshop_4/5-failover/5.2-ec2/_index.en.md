+++
title = "EC2"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

### Launch EC2 Instance 

1.1 Navigate to [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) in **N. California (us-west-1)** region.

1.2 Select the **hot-secondary** stack and click **Update**.

{{< img da-2.png >}}

1.3 Chose **Use current template** and click **Next** to continue.

{{< img da-3.png >}}

1.4 Update the **IsPromote** parameter to `yes` and click **Next** to continue.

{{< img da-4.png >}}

1.5 Scroll to the bottom of the page, click the checkbox to acknowledge IAM role creation, and then click **Update stack**.

{{< img da-5.png >}}

{{< prev_next_button link_prev_url="../5.1-aurora/" link_next_url="../../6-verify-secondary/" />}}

