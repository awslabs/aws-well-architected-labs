+++
title = "US-East-1 Deployment"
date =  2021-05-11T11:33:17-04:00
weight = 5
+++

**IMPORTANT:** If you are running this workshop via an AWS or AWS Partner-managed event, confirm this step is required. Check with your event host. If confirmed, skip to the [Verify Backend](#VerifyBackend) below because the backend is already available.

 If you are running this workshop via an AWS or AWS Partner managed event, the environment might be already deployed for you. Check with your event host. If confirmed, skip to the  below, because the backend has been deployed already.

1.1 Deploy the application to the primary region (us-east-1) by launching this [CloudFormation Template](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?stackName=Pilot-Primary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/630039b9022d4b46bb6cbad2e3899733/v1/BackupAndRestore.yaml).

1.2  Specify the stack name.

1.3 Click **Next**

{{< img CF-4.png >}}

1.4 Leave Configure stack options page as all defaults

1.5 Click **Next**

1.6 Scroll to the bottom of the page, click the checkbox to acknowledge IAM role creation, and then click **Create stack**.

{{< img CF-6.png >}}

{{% notice info %}}
**You must wait for the stack to successfully be created before moving on to the next step.**
{{% /notice %}}

{{< img CF-8.png >}}

## Verify Website

2.0 On the **CloudFormation Outputs** tab, click on the **Website URL**.

{{< img CF-9.png >}}

Our application is now up and running in the primary region.

{{< img FE-1.png >}}