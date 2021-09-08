+++
title = "Primary (Active) Region"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

## Deploying the Amazon CloudFormation Template

1.1 Deploy the application to the primary region (us-east-1) by launching this [CloudFormation Template](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?stackName=Active-Primary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/630039b9022d4b46bb6cbad2e3899733/v1/HotStandby.yaml).

1.2  Specify the stack parameters.

{{% notice info %}}
**Leave isPrimary and LatestAmiId as the default values**
{{% /notice %}}

1.3 Click **Next**

{{< img pr-4.png >}}

1.4 Leave Configure stack options page as all defaults

1.5 Click **Next**

1.6 Scroll to the bottom of the page, click the checkbox to acknowledge IAM role creation, and then click **Create stack**.

{{< img pr-5.png >}}

1.7 Wait until the stack's status reports **CREATE_COMPLETE**.  Then navigate to the **Outputs** tab and record the values of the **APIGURL**, **WebsiteURL**, and **WebsiteBucket** outputs.  You will need these to complete future steps.

{{< img pr-6.png >}}

{{% notice info %}}
**You must wait for the stack to successfully be created before moving on to the next step.**
{{% /notice %}}

We are going to configure DynamoDB global tables replicating from **AWS Region N. Virginia (us-east-1)** to **AWS Region N. California (us-west-1)**.

## Deploying Amazon DynamoDB Global Tables

2.1  Navigate to **DynamoDB** in the console.

{{< img dd-1.png >}}

2.2 Click on the **Tables** link on the left-hand side.

{{< img dd-2.png >}}

2.3 Find the **unishophotstandby** table, and click into the configuration settings.

{{< img dd-3.png >}}

2.4 Under the **Global Tables** table, click the **Create replica** button.

{{< img dd-4.png >}}

2.5 Select the **US West (N. California)** region under Available replication Region, and then click the **Create replica** button.

{{< img dd-5.png >}}

2.5 Wait for the **US WEST (N. California)** region's status to be **Active**.

{{< img dd-6.png >}}

## Congragulations!  Your Primary Region and DynamoDB Global Tables are working!
