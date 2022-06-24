+++
title = "CloudFront"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

You can improve resiliency and increase availability for specific scenarios by setting up CloudFront with origin failover.

### Create the Amazon CloudFront Distribution

1.1 Click [CloudFront](https://console.aws.amazon.com/cloudfront/home?region=us-east-1#/) to navigate to the dashboard.

1.2 Click the **Create a CloudFront Distribution** button.

{{< img cf-16.png >}}

{{% notice warning %}}
In Step 1.3, **DO NOT** choose the Amazon S3 **hot-primary-uibucket-xxxx** bucket in the dropdown for the **Origin Domain**.  The Cloudfront distribution will not work if you do this.
{{% /notice %}}

1.3 Enter the [Hot-Primary CloudFormation Stack Output WebsiteURL](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/outputs?filteringStatus=active&filteringText=&viewNested=true&hideStacks=false&stackId=arn%3Aaws%3Acloudformation%3Aus-east-1%3A571676911619%3Astack%2FHot-Primary%2F00475f30-f30b-11ec-a6e2-0a1eef7faa85) value as the **Origin Domain**.

{{< img cf-17.png >}}

One of the purposes of using CloudFront is to reduce the number of requests that your origin server must respond to directly. With CloudFront caching, more objects are served from CloudFront edge locations, which are closer to your users. This reduces the load on your origin server and reduces latency.  _However, that behavior masks our mechanism (disabling the UI bucket) from properly simulating an outage_. For more information, see [Amazon CloudFront Optimizing caching and availability](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/ConfiguringCaching.html). In production, customers typically want to use the default value **CachingOptimized**.  

1.4 In the **Cache key and origin requests** section, select **CachingDisabled** for the **Cache Policy** to disable CloudFront caching. 

{{< img cf-18.png >}}

1.5 Click the **Create Distribution** button.  

{{< img cf-27.png >}}

### Configure an Additional Origin 

We will now add an additional **Origin** and use our **hot-secondary-uibucket-xxxx**.

2.1 Click the **Origins** link, then click the **Create origin** button.

{{< img cf-19.png >}}

{{% notice warning %}}
In Step 2.2,  **DO NOT** choose the Amazon S3 **hot-secondary-uibucket-xxxx** bucket in the dropdown for the **Origin Domain**.  The Cloudfront distribution will not work if you do this.
{{% /notice %}}

2.2 Enter the [Hot-Secondary CloudFormation Stack Output WebsiteURL](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/outputs?filteringStatus=active&filteringText=&viewNested=true&hideStacks=false&stackId=arn%3Aaws%3Acloudformation%3Aus-west-1%3A571676911619%3Astack%2FHot-Secondary%2F869cc1a0-f30c-11ec-847d-06ec1b07324b) value as the **Origin Domain**. Click the **Create origin** button.

{{< img cf-20.png >}}

### Configure the Origin Group 

3.1 Click the **Create Origin Group** link.

{{< img cf-21.png >}}

3.2 Select **hot-primary-uibucket-xxxx** as the **Origins**, then click the **Add** button. Select **hot-secondary-uibucket-xxxx** as the **Origins**, then click the **Add** button. Enter `hot-standby-origin-group` as the **Name**.  Enable all checkboxes for **Failover criteria**, then click the **Create origin group**.

{{< img cf-28.png >}}

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

{{< prev_next_button link_prev_url="../3-dynamodb/" link_next_url="../5-failover/" />}}

