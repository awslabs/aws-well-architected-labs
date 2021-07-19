+++
title = "Setup for CloudFront"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

You can improve resiliency and increase availability for specific scenarios by setting up CloudFront with origin failover. To get started, you create an origin group in which you designate a primary origin for CloudFront plus a second origin. CloudFront automatically switches to the second origin when the primary origin returns specific HTTP status code failure responses.  

We are going to configure CloudFront with origin failover in the below steps using our **active-primary-uibucket-xxx** S3 static website as our primary origin and our **passive-secondary-uibucket-xxxx** S3 static website as our failover origin.

1.1 Navigate to **CloudFront**.

{{< img cf-1.png >}}

1.2 Click **Creat Distribution**.

{{< img cf-2.png >}}

1.3 Click **Get Started**.

{{< img cf-3.png >}}

1.4 Create Distribution

{{% notice note %}}
This is where you are going to need the values that you copied from your CloudFormation Outputs Tab from your `Active-Primary` Stack Creation.
{{% /notice %}}

* **Origin Domain Name** `WebsiteURL` </br>
(Do not choose the S3 bucket in the drop-down - copy and paste the `WebsiteURL` from the CloudFormation Stack Creation Output Tab)

{{< img cf-4.png >}}

Scroll to the bottom and click **Create Distribution**.


1.5 Click the **checkbox** to select the newly created distribution and then click **Distribution Settings**.

{{< img cf-6.png >}}

1.5 Click **Origins and Origin Groups** and then click **Create Origin**

{{< img cf-7.png >}}

1.6 Create Origin

{{% notice note %}}
This is where you are going to need the values that you copied from your CloudFormation Outputs Tab from your `Passive-Secondary` Stack Creation.
{{% /notice %}}

* **Origin Domain Name** `WebsiteURL` </br>
(Do not choose the S3 bucket in the drop-down - copy and paste the `WebsiteURL` from the CloudFormation Stack Creation Output Tab)

Click **Create**

{{< img cf-8.png >}}

1.7 Click **Create Origin Group**

{{< img cf-9.png >}}

1.8 Create Origin Group

Click **Add** to add **both** origins to the group.

Make sure that **1 (Primary)** has the **Origin ID** of the `Active-Primary WebsiteURL`.

Check all **checkboxes** for **Failover Criteria**.

Click **Create**.

{{< img cf-10.png >}}

1.9 Click **Behaviors**.

Click the **checkbox** to select the existig behavior.

Click **Edit**.

{{< img cf-11.png >}}

1.10 Select the newly created Origin Group for the **Origin or Origin Group**

Scroll to the bottom and click **Yes, Edit**.

{{< img cf-12.png >}}

1.11 Click **Distributions**

Wait for Distribution **Status** to show **Deployed**.

{{< img cf-5.png >}}

Copy the **Domain Name** into a new browser window and you should see **The Unicorn Shop - us-east-1** website.

{{< img cf-13.png >}}

{{< img cf-14.png >}}

#### <center>Congragulations !  Your CloudFront distribution is working !


