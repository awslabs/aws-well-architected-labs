+++
title = "Primary (Active) Region"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

## Deploying the Amazon CloudFormation Template

1.1 Change your [console](https://us-east-1.console.aws.amazon.com/console)’s region to **US East (N. Virginia) us-east-1 using the Region Selector in the upper right corner

1.2 Navigate to **CloudFormation** in the console.

{{< img pr-1.png >}}

1.3 Click the **Create stack** button.

{{< img pr-2.png >}}

1.4 Download the CloudFormation Template from this workshop.  Next, select **Upload a template file** and click the **Choose file** button to upload the file.  Finally, click the **Next** button to continue.

{{%attachments style="green" /%}}

{{< img pr-3.png >}}

1.5  On the Specify stack details page, set the **Stack Name** to `Active-Primary`.  Next, set the **IsPrimary** parameter to `yes`.  Finally, click the **Next** button to continue.

{{% notice info %}}
Leave the **LatestAmiId** parameter as the default value.
{{% /notice %}}

{{< img pr-4.png >}}

1.6 Scroll to the bottom of  the Configure stack options page.  Then check the **I acknowledge that AWS CloudFormation might create IAM resources with custom names** checkbox.  Finally, click the **Create stack** button to deploy the website.

{{< img pr-5.png >}}

1.8 Wait until the stack's status reports **CREATE_COMPLETE**.  Then navigate to the **Outputs** tab and record the values of the **APIGURL**, **WebsiteURL**, and **WebsiteBucket** outputs.  You will need them to complete future steps.

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

2.4 Under the **Global Tables** table, click the **Enable streams** button.

{{< img dd-4.png >}}

2.5 On the **Manage Stream** dialog, click the **Enable** button.

{{< img dd-5.png >}}

2.5 Next, click the **Add region** button.

{{< img dd-6.png >}}

2.6 On the **Add replica to global table** dialog, select the **US West (N. California)** region, and then click the **Create replica** button.

{{< img dd-7.png >}}

2.7 Wait for the **US EAST (N. Virginia)** and **US WEST (N. California)** region's status to be **Active**.

{{< img dd-8.png >}}

## Congragulations!  Your Primary Region and DynamoDB Global Tables are working!
