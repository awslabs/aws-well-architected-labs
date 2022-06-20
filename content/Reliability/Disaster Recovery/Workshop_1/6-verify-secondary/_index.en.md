+++
title = "Verify Secondary Region"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

### Verify Secondary Region Website

1.1 Click [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard.

1.2 Click the link for **backupandrestore-uibucket-xxxx-secondary**

{{< img vf-1.png >}}

1.3 Click the **Properties** link.  

{{< img vf-2.png >}}

1.4 In the **Static website hosting** section.  Click on the **Bucket website endpoint** link.

{{< img vf-3.png >}}

1.5 Log in to the application. You need to provide the registered email from the **Verify Primary Region** section.

1.6 You should see items in your shopping cart that you added from the primary region **N. Virginia (us-east-1)**.

{{< img vf-4.png >}}

{{% notice warning %}}
If you are running this workshop as part of an instructor led workshop, the RDS was restored before you started this workshop. This means that you will not be able to verify your cart items that you added in the Verify Primary Region section were successfully restored to the secondary region.
{{% /notice  %}}

#### Congratulations !  You should see your application The Unicorn Shop in the **us-west-1** region.

{{< prev_next_button link_prev_url="../5-failover/5.1-restore/" link_next_url="../7-cleanup/" />}}

