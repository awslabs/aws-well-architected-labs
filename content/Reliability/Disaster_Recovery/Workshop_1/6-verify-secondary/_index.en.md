+++
title = "Verify Secondary Region"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

#### Verify Secondary Region Website

1.1 Click [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard.

1.2 Click the link for **backupandrestore-secondary-uibucket-xxxx**

{{< img crr-8.png >}}

1.3 Click the **Properties** link.  

{{< img vf-2.png >}}

1.4 In the **Static website hosting** section.  Click on the **Bucket website endpoint** link.

{{< img vf-3.png >}}

1.5 You are pointing to the secondary region **N. California (us-west-1)** if you see **us-west-1** in the header and the unicorn products.

{{< img vf-4.png >}}

{{< prev_next_button link_prev_url="../5-failover/5.1-restore/" link_next_url="../7-cleanup/" />}}

