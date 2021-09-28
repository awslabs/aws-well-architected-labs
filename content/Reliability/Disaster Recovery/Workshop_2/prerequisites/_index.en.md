+++
title = "Pre-requisites"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++

## Account setup 

### Using an account provided through Event Engine

If you are running this workshop as part of an Event Engine lab, please log into the console using [this link](https://dashboard.eventengine.run/) and enter the hash provided to you as part of the workshop.

Continue to the [Verify Website](../verify-website/) section of the workshop.

### Using your own AWS account

{{% notice note %}}
If you are using a personal AWS account, be aware that you will incur costs for the resources deployed in this workshop. After completing the workshop, remember to complete the [Cleanup Resources](../wrap-up-and-clean-up/) section to remove any unnecessary AWS resources.
{{% /notice %}}

## Allow Amazon S3 Public Acess

Our application employs AWS Simple Storage Service (S3) Static website hosting. To make the application available to Internet users, we must disable the AWS account policy that blocks public access.

1.1 Login to your [AWS console](https://console.aws.amazon.com/console/home#). Go to the Amazon S3 console and **Deactivate Block Public Access**. Consider referencing [this page](https://aws.amazon.com/s3/features/block-public-access/) or this [video](https://youtu.be/kMi5PSyFu8s) to find out more about this setting.

1.2 Using the search bar at the top, navigate to **S3**.

{{< img c-8.png >}}

1.3 Click **Block Public Access settings for this account**.

{{< img pr-1.png >}}

1.4 If you see that "Block all public access" is "On," then click on the "Edit" button to get to the next screen.

{{< img pr-2.png >}}

1.5 Uncheck "Block all public access," including any child selections. Click the "Save Changes" button. You will be required to confirm the changes.

{{< img pr-3.png >}}

1.6 Type **confirm** and Click the **Confirm** button.

{{< img pr-4.png >}}

{{< img pr-5.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="./primary-region/" />}}
