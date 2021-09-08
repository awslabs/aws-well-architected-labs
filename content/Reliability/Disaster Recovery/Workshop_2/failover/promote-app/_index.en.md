+++
title = "Promote App in Secondary Region"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

1.1 Navigate to [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#) in the Secondary region (us-west-1).

1.2 Select the **Pilot-Secondary** stack and click **Update**.

{{< img da-2.png >}}

1.3 Choose **Use current template** and click **Next**.

{{< img da-3.png >}}

1.4 Change the **IsPromote** parameter to `yes` and click **Next**.

{{< img da-4.png >}}

1.5 Scroll to the bottom of the page and click the **checkbox** to acknowledge then click **Update stack**.

{{< img da-5.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../promote-aurora/" />}}

