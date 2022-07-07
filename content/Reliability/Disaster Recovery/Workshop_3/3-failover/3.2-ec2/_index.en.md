+++
title = "EC2"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

#### Launch EC2 Instance 

1.1 Click [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Select the **warm-secondary** stack and click **Update**.

{{< img da-2.png >}}

1.3 Chose **Use current template** and click **Next** to continue.

{{< img da-3.png >}}

1.4 Update the **IsPromote** parameter to **yes** and click **Next** to continue.

{{< img da-4.png >}}

1.5 Scroll to the bottom of the page, click the checkbox to acknowledge IAM role creation, and then click **Update stack**.

{{< img da-5.png >}}

#### Auto Scaling Group (ASG)

The update to the CloudFormation template was to change the Auto Scaling Group in the secondary region **N. California (us-west-1)** to **scale out** our EC2 capacity to match our primary region **N. Virginia (us-east-1)**. This way we know when we fail over, our secondary region can handle the request traffic.

2.1 CLick [Auto Scaling Groups](https://us-west-1.console.aws.amazon.com/ec2/v2/home?region=us-west-1#AutoScalingGroups:) to navigate to the dashboard in the **N. California (us-west-1)** region.

2.2 Click on the **warm-secondary-WebServerGroup-xxx** link.

{{< img asg-1.png >}}

2.3 Click the **Activity** link, then scroll down to the **Activity History** section.  You should see new instances launching in response to your CloudFormation update.

{{< img asg-3.png >}}

{{< img asg-4.png >}}


{{< prev_next_button link_prev_url="../3.1-aurora" link_next_url="../../4-verify-secondary/" />}}

