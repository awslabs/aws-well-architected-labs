+++
title = "US-East-1 Deployment"
date =  2021-05-11T11:33:17-04:00
weight = 5
+++

**IMPORTANT:** If you are running this workshop via an AWS or AWS Partner-managed event, confirm this step is required. Check with your event host. If confirmed, skip to the [Verify Backend](#VerifyBackend) below because the backend is already available.

 If you are running this workshop via an AWS or AWS Partner managed event, the environment might be already deployed for you. Check with your event host. If confirmed, skip to the  below, because the backend has been deployed already.

1.1 Download the CloudFormation template.

{{%attachments style="green" /%}}

Save file name: `BackupandRestore.yaml`

1.2 Navigate to **CloudFormation**.

{{< img CF-1.png >}}

1.3 In the upper right corner of the [console](https://us-east-1.console.aws.amazon.com/console), set your region to us-east-1.

{{< img RE-1.png >}}

1.4 Click **Create Stack** to start the deployment process.

{{< img CF-2.png >}}

1.5 Select Upload a template file and click **Choose File** to upload the file from step 1.1. Finally, click Next.

{{< img CF-3.png >}}

1.6 Enter a name for the stack and click **Next**

Stack Name: `BackupandRestore`
{{< img CF-4.png >}}

1.7 Click **Next** to skip the stack configuration options, as we will use defaults in this section
{{< img CF-5.png >}}

1.8 Review the details for creating the stack, check the **I acknowledge that AWS CloudFormation might create the IAM resources** checkbox, and click **Create Stack**.
{{< img CF-6.png >}}

1.9 Once the stack creation process completes, you should see the following **CREATE_COMPLETE** message.

You need to wait for the CloudFormation deployment to complete before you progress to the next step.

Take a coffee break! It may take around 15 minutes for the CloudFormation template to complete!

## Verify Website

2.0 On the CloudFormation Output tab, click on the Website URL.

{{< img FE-3.png >}}

Our application is now up and running in the primary region.
