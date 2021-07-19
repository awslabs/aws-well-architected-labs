+++
title = "Disaster!"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

We are going to browse to The Unicorn - us-east-1 website via the Cloud Distribution url.  Then we are going to signup for an account and login.  Once we are logged in we will add some products to our cart.  Then we will simulate a region failure in N. Virginia (us-east-1) at the S3 static website level.  This will cause the CloudFront Origin Failover feature to kick in and CloudFront will redirect us to The Unicorn Shop - us-west-1 website.  As a user, this redirection should be seamless.  You should still be logged into your session and the products in your cart will remain there.

1.1 Using your newly deployed CloudFront website.

{{% notice info %}}
If you don't have your **CloudFront Domain Name**, you can retrieve it via **Step 1.11** in **Setup CloudFront**
{{% /notice %}}

1.2 Click **Signup**

{{< img d-1.png >}}

1.3 Fill out Signup Form

{{< img d-2.png >}}

1.4 Click **Login**

{{< img d-3.png >}}

1.5 After login, add **Products** to your **Cart**.

1.6 We will now simulate a regional service event that is affecting the S3 static website in N. Virginia (us-east-1) that is serving The Unicorn Shop website.

1.7  Navigate to **S3**.

{{< img d-4.png >}}

1.8 Click **active-primary-uibucket-xxxx**.

{{< img d-5.png >}}

1.9 Click **Permissions**.

Scroll to **Block public access (bucket settings)**

Click **Edit**

{{< img d-6.png >}}

1.10 Check **Block all public access** and click **Save**.

{{< img d-7.png >}}

{{% notice info %}}
**Your S3 active-primary-uibucket-xxxs bucket that is hosting the static website is now un-accessible.  When CloudFront sends a request, the API call will return a 403 error.  CloudFront will failover to the secondary origin and redirect to the S3 passive-secondary-uibucket-xxxx bucket that is hosting the static website in N. California us-west-1.**
{{% /notice %}}


