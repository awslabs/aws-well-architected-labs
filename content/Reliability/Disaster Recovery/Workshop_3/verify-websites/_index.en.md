+++
title = "Verify Websites"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

1.1 Go to [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/)
Click on the CloudFormation stack "Warm-Primary". Fetch the website URL from the Outputs tab.

{{< img vw-1.png >}}

1.2 Click on the WebsiteURL output link.

{{< img vw-2.png >}}

## Play with the Primary application

1.3 Register yourself into the application. You need to provide an e-mail address, which does not need to be valid. However, _be sure to remember this value_ to verify the data replication later.

{{< img vw-3.png >}}

1.4 You will see a confirmation message saying **Successfully Signed Up. You may now Login**.

1.5 Log in to the application using your e-mail address from the previous step.

{{< img vw-4.png >}}

1.6 Add/remove items to your shopping cart by clicking on a Unicorn, followed by clicking the **Add to cart** button.

{{< img vw-5.png >}}

2.1 Go to [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/)
Click on the CloudFormation stack "Warm-Secondary". Fetch the website URL from the Outputs tab.

{{< img vw-6.png >}}

2.2 Click on the WebsiteURL output link.

{{< img vw-7.png >}}

## Play with the Secondary application

3.1 Log in to the application using your e-mail address from the previous step.

3.2 1.Try adding a new item to the cart. The web app should increase the total cart items count shown at the top of the page.

{{< prev_next_button link_prev_url="../prerequisites/enable-aurora-writefwd/" link_next_url="../failover/" />}}

