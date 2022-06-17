+++
title = "Verify Primary Region"
date =  2021-05-11T11:33:17-04:00
weight = 2
+++

### Verify Primary Region Website 

Let's verify that everything is working as expected in our primary region **N. Virginia (us-east-1)**.  Our Unishop website is being hosted as a static website from an Amazon S3 bucket.

1.1 Click [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Select **BackupAndRestore** under **Stacks**.

1.3 Click on the **Outputs** link.

{{< img vf-1.png >}}

1.4 Click on the **WebsiteURL** link.  You will see **The Unicorn Shop - us-east-1**.

{{< img vf-2.png >}}

### Signup

2.1 Register yourself into the application using the **Signup** link in the top menu. You need to provide an e-mail address, which does not need to be valid. However, **be sure to remember it** as you will need it to verify the data replication later.

{{< img vf-3.png >}}

2.2 You will see a confirmation message saying **Successfully Signed Up. You may now Login**.

{{< img vf-4.png >}}

2.3 Log in to the application using the **Login** link in the top menu, use your e-mail address from the previous step.  Also notice how the website is being hosted from your primary region **N. Virginia (us-east-1)**.

{{< img vf-5.png >}}

2.4 Add items to your shopping cart, verifying that the items in your shopping cart counter are being incremented.

{{< img vf-6.png >}}


{{< prev_next_button link_prev_url="../" link_next_url="../3-prepare-secondary" />}}