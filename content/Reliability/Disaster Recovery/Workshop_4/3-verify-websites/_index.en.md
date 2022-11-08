+++
title = "Verify Websites"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

### Primary Region

1.1 Click [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Choose the **hot-primary** stack.

1.3 Click the **Outputs** link.

{{< img vw-1.png >}}

1.4 Copy and paste the **WebsiteURL** value to your clipboard you will need it in the CloudFront section. Click on the **WebsiteURL** output link and open in a new browser tab or window.

{{< img vw-2.png >}}

#### Signup

2.1 Register yourself into the application using the **Signup** link in the top menu. You need to provide an email address, which does not need to be valid. However, **be sure to remember it** as you will need it to verify the data replication later.

{{< img vw-3.png >}}

2.2 You will see a confirmation message saying **Successfully Signed Up. You may now Login**.

{{< img vw-4.png >}}

2.3 Log in to the application using the **Login** link in the top menu, use your email address from the previous step.  Also notice how the website is being hosted from your primary region **N. Virginia (us-east-1)**.

{{< img vw-6.png >}}

2.4 Add items to your shopping cart, verifying that the total cart items count shown at the top of the page are being increased.

{{< img vw-5.png >}}

### Secondary Region

We are taking advantage of Amazon Aurora read replica [write forwarding](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/aurora-global-database-write-forwarding.html). With this feature enabled, writes can be sent to a read replica in a secondary region, and will be seamlessly forwarded to the writer in the primary region over a secure communication channel. It is considered a best practice to enable write forwarding in your secondary region for Warm Standby disaster recovery strategy for testing purposes.

3.1 Click [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) to navigate to the dashboard in the **N. California (us-west-1)** region.

3.2 Choose the **hot-secondary** stack.

3.3 Click the **Outputs** link.

{{< img vw-6.png >}}

3.4 Copy and paste the **WebsiteURL** value to your clipboard you will need it in the CloudFront section. Click on the **WebsiteURL** output link and open in a new browser tab or window.

{{< img vw-7.png >}}

3.5 Log in to the application using the **Login** link in the top menu, use your email from **Step 2.1** above.

3.6 You should see the same number of items in your cart that you added in **Step 2.4** above. Also notice the website is being hosted from your secondary region **N. California (us-west-1)**

{{< img vw-8.png >}}

3.7 Add additional items to your cart and see the increased total cart items shown at the top of the page.

{{< img vw-9.png >}}

3.8 Return to your primary region website. If you already have it open, refresh your browser window, otherwise follow steps above in **Primary Region** section. You should see the increased cart total in your primary region **N. Virginia (us-east-1)**.

{{< img vw-10.png >}}

{{< prev_next_button link_prev_url="../2-dynamodb/" link_next_url="../4-cloudfront/" />}}

