+++
title = "Prerequisites"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

## Account setup 

### Using an account provided through Event Engine

If you are running this workshop as part of an Event Engine lab, please log into the console using [this link](https://dashboard.eventengine.run/) and enter the hash provided to you as part of the workshop.

Continue to the [Verify Website](../verify-website/) section of the workshop.

### Using your own AWS account

{{% notice note %}}
If you are using a personal AWS account, be aware that you will incur costs for the resources deployed in this workshop. After completing the workshop, remember to complete the [Cleanup Resources](../wrap-up-and-clean-up/) section to remove any unnecessary AWS resources.
{{% /notice %}}

## Allow S3 Public Access

Our application employs AWS Simple Storage Service (S3) Static website hosting. To make the application available to Internet users, we must disable the AWS account policy that blocks public access.

1.1 Login to your [AWS console](https://console.aws.amazon.com/console/home#). Go to the Amazon S3 console and **Deactivate Block Public Access**. Consider referencing [this page](https://aws.amazon.com/s3/features/block-public-access/) or this [video](https://youtu.be/kMi5PSyFu8s) to find out more about this setting.

1.2 Open S3, and on the left, click on "Block Public Access settings for this account."

{{< img S3-public-1.png >}}

1.3 If you see that "Block all public access" is "On," then click on the "Edit" button to get to the next screen.
{{< img S3-public-2.png >}}

1.4 Uncheck "Block all public access," including any child selections. Click "Save Changes." You will be required to confirm the changes.
{{< img S3-public-3.png >}}
{{< img S3-public-4.png >}}

## Deploy CloudFormation

2.1 Deploy the application to the primary region (us-east-1) by launching this [CloudFormation Template](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?stackName=BackupAndRestore&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/630039b9022d4b46bb6cbad2e3899733/v1/BackupAndRestore.yaml).

2.2 Click **Next**

{{< img CF-4.png >}}

2.3 Leave Specify stack details as all defaults

2.4 Click **Next**

2.5 Leave Configure stack options page as all defaults

2.6 Click **Next**

2.7 Scroll to the bottom of the page, click the checkbox to acknowledge IAM role creation, and then click **Create stack**.

{{< img CF-6.png >}}

{{% notice info %}}
**You must wait for the stack to successfully be created before moving on to the next step.**
{{% /notice %}}

{{< img CF-8.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../verify-website/" />}}

