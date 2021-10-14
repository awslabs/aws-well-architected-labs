+++
title = "Failover to Secondary"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

When a regional service event affects the Unicorn application in the Primary, N. Virginia (us-east-1) region, you want to fail-over to Secondary, N. California (us-west-1) region.

We assume a regional service event has occurred. In this section, we will manually fail over the application to the Secondary region.  The CloudFront distribution will detect the service interruption and automatically begin routing requests from the **Primary-Active** to the **Passive-Secondary** website seamlessly.

Before simulating the outage, we need to create test data through the web application. This step requires creating enrolling in the store, then adding items into the shopping cart.  After the outage, the user’s session should remain active and uninterrupted.

### Create and Populate the Shopping Cart

1.1 Navigate to the **CloudFront Domain Name** using your favorite browser.

{{% notice info %}}
If you don't have your **CloudFront Domain Name**, you can retrieve it via **Step 4.2** in **Setup CloudFront**.
{{% /notice %}}

1.2 Click the **Signup** button.

{{< img d-1.png >}}

1.3 Register yourself into the application. You need to provide an e-mail address, which does not need to be valid.

{{< img d-2.png >}}

1.4 Log in to the application using your e-mail address from the previous step.

{{< img d-3.png >}}

1.5 Add/remove items to your shopping cart by clicking on a Unicorn, followed by clicking the **Add to cart** button.

### Simulating a Regional Service Event

We will now simulate a regional service event affecting the S3 static website in **N. Virginia (us-east-1)** serving The Unicorn Shop website.

2.1 Click [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard.

2.2 Click the bucket link that begins with **active-primary-uibucket-** .

{{< img c-9.png >}}

2.3 Click the **Permissions** link. In the **Block public access (bucket settings)** section, click the **Edit** button.

{{< img d-6.png >}}

2.4 Enable the **Block all public access** checkbox, then click the **Save** button.

{{< img d-7.png >}}

2.5 Type `confirm`, then click the **Confirm** button.

{{< img d-8.png >}}

{{% notice info %}}
Your Amazon S3 bucket that hosts the Primary-Active website is now inaccessible.  When CloudFront attempts to route the user’s request to this instance, it will receive an HTTP 403 status error (Forbidden).  The Distribution will automatically handle this scenario by failing over to the Passive-Secondary instance.
{{% /notice %}}

{{< prev_next_button link_prev_url="../setup-cloudfront/" link_next_url="./promote-aurora/" />}}

