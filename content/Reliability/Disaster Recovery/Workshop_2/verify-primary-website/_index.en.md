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

## Signup

2.1 Register yourself into the application using the **Signup** link in the top menu. You need to provide an e-mail address, which does not need to be valid. However, **be sure to remember it** as you will need it to verify the data replication later.

{{< img vw-3.png >}}

2.2 You will see a confirmation message saying **Successfully Signed Up. You may now Login**.

{{< img vw-4.png >}}

2.3 Log in to the application using the **Login** link in the top menu, use your e-mail address from the previous step.  Also notice how the website is being hosted from your primary region **N. Virginia (us-east-1)**.

{{< img vw-6.png >}}

2.4 Add items to your shopping cart, verifying that the items in your shopping cart counter are being incremented.

{{< img vw-5.png >}}

{{< prev_next_button link_prev_url="../prerequisites/" link_next_url="../failover/" />}}
