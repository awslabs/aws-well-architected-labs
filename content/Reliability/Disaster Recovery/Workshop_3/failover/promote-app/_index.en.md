+++
title = "Scale Out"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

## Launch Instance 

1.1 Navigate to [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) in **N. California (us-west-1)** region.

1.2 Select the **Warm-Secondary** stack and click **Update**.

{{< img da-2.png >}}

1.3 Chose **Use current template** and click **Next** to continue.

{{< img da-3.png >}}

1.4 Update the **IsPromote** parameter to `yes` and click **Next** to continue.

{{< img da-4.png >}}

1.5 Scroll to the bottom of the page, click the checkbox to acknowledge IAM role creation, and then click **Update stack**.

{{< img da-5.png >}}

## Update Auto Scaling Group (ASG)

We now want to scale out our compute capacity to match that of our primary region.  This way we know when we fail over, our secondary region can handle the request traffic.

2.1 Navigate to [Auto Scaling Groups](https://us-west-1.console.aws.amazon.com/ec2/v2/home?region=us-west-1#AutoScalingGroups:) in **N. California (us-west-1)** region.

2.2 Select **Warm-Secondary-WebServerGroup-xxx**, then click the **Edit** button.

{{< img asg-1.png >}}

2.3 In the **Group size** section, increase the **Desired capacity** to **3**, then scroll to the bottom and click the **Update** button.

{{< img asg-2.png >}}

2.4 Click the **Activity** link, then scroll down to the **Activity History** section.  You should see new instances launching in response to your update desired quantity request.

{{< img asg-3.png >}}

{{< img asg-4.png >}}


{{< prev_next_button link_prev_url="../promote-aurora" link_next_url="../verify-failover/" />}}

