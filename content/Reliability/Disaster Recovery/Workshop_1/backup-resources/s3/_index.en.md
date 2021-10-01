+++
title = "S3"
date =  2021-05-11T20:33:54-04:00
weight = 3
+++

## Create the S3 UI bucket

1.1 Navigate to [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/).

1.2 Copy the name of the UI bucket that is in **N.Virginia (us-east-1)** region.  It will be similar to `backupandrestore-uibucket-xxxx`.

{{< img RS-48.png >}}

1.3  Click the **Create bucket** button.

{{< img BK-29.png >}}

1.4 Use the same bucket name as the primary bucket and append a **“-dr”** at the end. 

1.5  Select **N. California (us-west-1)** region.

{{< img BK-30.png >}}

1.6 Under the **Block Public Access settings for this bucket** secion.  Disable the **Block *all* public access** checkbox and verifying all underlying checkboxes are **disabled**.  Enable the **I acknowledge that the current settings....** checkbox. 

{{< img BK-31.png >}}

1.7 Click **Create Bucket**.

{{< img BK-32.png >}}

{{< prev_next_button link_prev_url="../ec2" link_next_url="../../copy-to-secondary/" />}}
