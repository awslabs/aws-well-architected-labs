+++
title = "S3"
date =  2021-05-11T20:33:54-04:00
weight = 3
+++

### Create the S3 UI bucket in the secondary N. California (us-west-1) region.

1.1 Click [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard.

1.2 Copy the name of the UI bucket that is in **N.Virginia (us-east-1)** region.  It will be similar to `backupandrestore-uibucket-xxxx`.

{{< img RS-48.png >}}

1.3  Click the **Create bucket** button.

{{< img BK-29.png >}}

1.4 Enter the bucket name using the **UI bucket** that you copied in **Step 1.2** and append **“-dr”**. 

1.5  Select **N. California (us-west-1)** as the **AWS Region**.

{{< img BK-30.png >}}

1.6 In the **Block Public Access settings for this bucket** secion.  Disable the **Block *all* public access** checkbox including all chidren.  Enable the **I acknowledge that the current settings....** checkbox. 

{{< img BK-31.png >}}

1.7 Click the **Create Bucket** button.

{{< img BK-32.png >}}

{{< prev_next_button link_prev_url="../ec2" link_next_url="../../copy-to-secondary/" />}}
