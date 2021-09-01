+++
title = "Prerequisites"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

Our application employs AWS Simple Storage Service (S3) Static website hosting. To make the application available to Internet users, we must disable the AWS account policy that blocks public access.

{{% notice note %}}
If you are using a personal AWS account, be aware that you will incur costs for the resources deployed in this workshop. Complete the cleanup steps at the end to minimize those costs.

If you are running this at a group event - please log in via Event Engine. The event host will provide the Instructions.{{% /notice %}}

1.1 Login to your [AWS console](https://console.aws.amazon.com/console/home#). Go to the Amazon S3 console and **Deactivate Block Public Access**. Consider referencing [this page](https://aws.amazon.com/s3/features/block-public-access/) or this [video](https://youtu.be/kMi5PSyFu8s) to find out more about this setting.

1.2 Open S3, and on the left, click on "Block Public Access settings for this account."

{{< img S3-public-1.png >}}

1.3 If you see that "Block all public access" is "On," then click on the "Edit" button to get to the next screen.
{{< img S3-public-2.png >}}

1.4 Uncheck "Block all public access," including any child selections. Click "Save Changes." You will be required to confirm the changes.
{{< img S3-public-3.png >}}
{{< img S3-public-4.png >}}