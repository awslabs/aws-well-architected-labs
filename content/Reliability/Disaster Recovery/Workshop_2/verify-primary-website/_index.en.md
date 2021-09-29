+++
title = "Verify Website"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

## Primary Region

1.1 Navigate to  [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/) in **N. Virginia (us-east-1)** region.

1.2 Choose the **Pilot-Primary** stack.

1.3 Navigate to the **Outputs** tab.

{{< img vw-1.png >}}

1.4 Click on the **WebsiteURL** output link.

{{< img vw-2.png >}}

## Play with the Primary application

2.1 Register yourself into the application. You need to provide an e-mail address, which does not need to be valid. However, _be sure to remember this value_ to verify the data replication later.

{{< img vw-3.png >}}

2.2 You will see a confirmation message saying **Successfully Signed Up. You may now Login**.

2.3 Log in to the application using your e-mail address from the previous step.

{{< img vw-4.png >}}

2.4 Add/remove items to your shopping cart by clicking on a Unicorn, followed by clicking the **Add to cart** button.

{{< img vw-5.png >}}

{{< prev_next_button link_prev_url="../prerequisites/" link_next_url="../failover/" />}}
