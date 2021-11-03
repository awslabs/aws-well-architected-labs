+++
title = "Setup for CloudFront"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

You can improve resiliency and increase availability for specific scenarios by setting up CloudFront with origin failover. To get started, you create an origin group in which you designate a primary origin for CloudFront plus a second origin. CloudFront automatically switches to the second origin when the primary origin returns specific HTTP status code failure responses.  

We are going to configure CloudFront with origin failover in the below steps using our **active-primary-uibucket-xxx** S3 static website as our primary origin and our **passive-secondary-uibucket-xxxx** S3 static website as our failover origin.

{{% notice note %}}
You will need the Amazon CloudFormation output parameter values from the **Primary-Active** and **Passive-Secondary** stacks to complete this section. For help, refer to the [CloudFormation Outputs](../prerequisites/cfn-outputs/) section of the workshop.
{{% /notice %}}

### Create the Amazon CloudFront Distribution

1.1 Click [CloudFront](https://console.aws.amazon.com/cloudfront/home?region=us-east-1#/) to navigate to the dashboard.

1.2 Click the **Create a CloudFront Distribution** button.

{{< img cf-16.png >}}

{{% notice warning %}}
In Step 1.3, **DO NOT** choose the Amazon S3 **active-primary-uibucket-xxxx** bucket in the dropdown for the **Origin Domain**.  The Cloudfront distribution will not work if you do this.
{{% /notice %}}

1.3 Enter the **WebsiteURL** value from the **Active-Primary** output values as the **Origin Domain**.

{{< img cf-17.png >}}

One of the purposes of using CloudFront is to reduce the number of requests that your origin server must respond to directly. With CloudFront caching, more objects are served from CloudFront edge locations, which are closer to your users. This reduces the load on your origin server and reduces latency.  _However, that behavior masks our mechanism (disabling the UI bucket) from properly simulating an outage_. For more information, see [Amazon CloudFront Optimizing caching and availability](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/ConfiguringCaching.html). In production, customers typically want to use the default value **CachingOptimized**.  

{{% notice warning %}}
The next section **Failover to Secondary**, will not work without completing Step 1.4.
{{% /notice %}}

1.4 In the **Cache key and origin requests** section, select **CachingDisabled** for the **Cache Policy** to disable CloudFront caching. 

{{< img cf-18.png >}}

1.5 Click the **Create Distribution** button.  

{{< img cf-27.png >}}

### Configure an Additional Origin 

We will now add an additional **Origin** and use our **secondary-passive-uibucket-xxxx**.

2.1 Click the **Origins** link, then click the **Create origin** button.

{{< img cf-19.png >}}

{{% notice warning %}}
In Step 2.2,  **DO NOT** choose the Amazon S3 **passive-secondary-uibucket-xxxx** bucket in the dropdown for the **Origin Domain**.  The Cloudfront distribution will not work if you do this.
{{% /notice %}}

2.2 Enter the **WebsiteURL** value from the **Passive-Secondary** output values as the **Origin Domain**.  Click the **Create origin** button.

{{< img cf-20.png >}}

### Configure the Origin Group 

3.1 Click the **Create Origin Group** link.

{{< img cf-21.png >}}

3.2 Select **active-primary-uibucket-xxxx** as the **Origins**, then click the **Add** button.

{{< img cf-28.png >}}

3.3 Select **passive-secondary-uibucket-xxxx** as the **Origins**, then click the **Add** button.

{{< img cf-29.png >}}

3.4 Enter `hot-standby-origin-group` as the **Name**.  Enable all checkboxes for **Failover criteria**, then click the **Create origin group**.

{{< img cf-30.png >}}

### Configure Behaviors

4.1 Click the **Behaviors** link.  Select **Default (*)**, then click the **Edit** button.

{{< img cf-23.png >}}

4.2 Select **hot-standby-origin-group** as the **Origin and Origin Groups**.

{{< img cf-24.png >}}

4.3 Click the **Save changes** button.

{{< img cf-31.png >}}

4.4 Click the **Distributions** link.

4.5 Wait for **Status** to be **Enabled** and for **Last Modified** to have a date.

{{< img cf-25.png >}}

### Verify the Distribution

5.1 Copy the CloudFront Distribution's **Domain Name** into a new browser window.

{{< img cf-26.png >}}

5.2 Confirm that the website's header says **The Unicorn Shop - us-east-1**.

{{< img cf-14.png >}}

#### Congragulations!  Your CloudFront distribution is working!

{{< prev_next_button link_prev_url="../verify-websites/" link_next_url="../disaster/" />}}

