+++
title = "Setup for CloudFront"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

You can improve resiliency and increase availability for specific scenarios by setting up CloudFront with origin failover. To get started, you create an origin group in which you designate a primary origin for CloudFront plus a second origin. CloudFront automatically switches to the second origin when the primary origin returns specific HTTP status code failure responses.  

We are going to configure CloudFront with origin failover in the below steps using our **active-primary-uibucket-xxx** S3 static website as our primary origin and our **passive-secondary-uibucket-xxxx** S3 static website as our failover origin.

{{% notice note %}}
You will need the Amazon CloudFormation output parameter values from the `Primary-Active` and `Passive-Secondary` stacks to complete this section.
{{% /notice %}}

## Create the Amazon CloudFront Distribution

1.1 Navigate to **CloudFront** in the console.

{{< img cf-1.png >}}

1.2 Click the **Creat Distribution** button.

{{< img cf-2.png >}}

1.3 Click the **Get Started** button to continue.

{{< img cf-3.png >}}

1.4 On the **Create Distribution** page, set the **Origin DomainName** equal to the **WebsiteURL** value from the `Primary-Active` stack outputs.  Do not choose the Amazon S3 bucket in the drop-down.

{{< img cf-4.png >}}

1.5 Under **Default Cache Behaivor Settings**, set the **Cache Policy** to **Managed-CachingDisabled** disable CloudFront caching.  In production, customers typically want to use the default value **Managed-CachingOptimized**.  

One of the purposes of using CloudFront is to reduce the number of requests that your origin server must respond to directly. With CloudFront caching, more objects are served from CloudFront edge locations, which are closer to your users. This reduces the load on your origin server and reduces latency.  _However, that behavior masks the mechanism (disabling the UI bucket) from properly simulating an outage_. For more information, see [Amazon CloudFront Optimizing caching and availability](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/ConfiguringCaching.html).

{{% notice warning %}}
The next module **Disaster!**, will not work without modifying this value.
{{% /notice %}}

{{< img cf-15.png >}}

## Configure the Distribution Settings

2.1 Scroll to the page's bottom and click the **Create Distribution** button.  Enable the checkbox next to the new distribution, then click the **Distribution Settings** button.

{{< img cf-6.png >}}

2.2 Under the **Origins and Origin Groups** tab, click the **Create Origin** button.

{{< img cf-7.png >}}

2.3 On the **Create Origin** page, specify the **Origin Domain Name** equal to the **WebsiteURL** value from your `Passive-Secondary` stack outputs.  Do not choose the Amazon S3 bucket in the dropdown.  Finally, click the **Create** button.

{{< img cf-8.png >}}

2.4 Under the **Origins and Origin Groups**, click the **Create Origin Group** button.

{{< img cf-9.png >}}

2.5 On the **Edit Origin Group** page, use the **Add** button to include the `Primary-Active` Origin, then the `Passive-Secondary` origin.  Confirm that the **1 (Primary)** has the **Origin ID** of the `Primary-Active` **WebsiteURL**.

2.6 Enable all **checkboxes** under the **Failover Criteria** section.  Then click the **Create** button.

{{< img cf-10.png >}}

## Configure Distribution Behaviors

3.1 Under the **Behaviors** tab, enable the checkbox next to the default behavior, and click the **Edit** button.

{{< img cf-11.png >}}

3.2 Set the **Origin or Origin Group** dropdown to the Origin Group (see section 2).

3.3 Scroll to the page's bottom and click the **Yes, Edit** button.

{{< img cf-12.png >}}

3.4 Navigate to the **Distributions** page.

3.5 Wait for Distribution's **Status** to equal **Deployed**.

{{< img cf-5.png >}}

## Verify the Distribution

4.1 Copy the CloudFront Distribution's **Domain Name** into a new browser window.

{{< img cf-13.png >}}

4.2 Confirm that the website's header says **The Unicorn Shop - us-east-1**.

{{< img cf-14.png >}}

## Congragulations!  Your CloudFront distribution is working!
