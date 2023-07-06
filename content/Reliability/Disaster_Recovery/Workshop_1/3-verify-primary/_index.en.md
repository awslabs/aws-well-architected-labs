+++
title = "Verify Primary Region"
date =  2021-05-11T11:33:17-04:00
weight = 3
+++

#### Verify Primary Region Website 

Let's verify that everything is working as expected in our primary region **N. Virginia (us-east-1)**. 

1.1 Click [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Select **backupandrestore-primary** under **Stacks**.

1.3 Click on the **Outputs** link and open in a new browser tab or window.

{{< img vf-1.png >}}

1.4 Click on the **WebsiteURL** link.  You will see **The Unicorn Shop - us-east-1**.

{{< img vf-2.png >}}


{{< prev_next_button link_prev_url="../2-s3-crr/" link_next_url="../4-prepare-secondary" />}}