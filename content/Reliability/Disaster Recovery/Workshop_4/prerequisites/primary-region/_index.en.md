+++
title = "Primary (Active) Region"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

1.1 In the top right corner, change your region to **N. Virginia (us-east-1)**.

1.2 Using the search bar at the top, navigate to **CloudFormation**.

{{< img pr-1.png >}}

1.3 Click **Create stack**.

{{< img pr-2.png >}}

1.4 Specify Template.

Download the CloudFormation template.

{{%attachments style="green" /%}}

Select **Upload a template file**

Click **Choose file** and upload the CloudFormation template file you just downloaded. 

Click **Next**

{{< img pr-3.png >}}

1.5  Specify stack details. 

* **Stack Name**: `Active-Primary`
* **isPrimary**: `Yes`

{{% notice info %}}
**Leave LatestAmiId as the default value**
{{% /notice %}}

Click **Next**

{{< img pr-4.png >}}

1.6 Leave Configure stack options page as all defaults

Click **Next**

1.7 Scroll to the bottom of the page and click the **checkbox** to acknowledge then click **Create stack**.

{{< img pr-5.png >}}

1.8 When stack status is showing **CREATE_COMPLETE**, click on the **Outputs** tab and copy and paste the values for **APIGURL, WebsiteURL** and **WebsiteBucket** into a text editor as you will need them in future steps.

{{< img pr-6.png >}}

{{% notice info %}}
**You must wait for the stack to successfully be created before moving on to the next step.**
{{% /notice %}}

We are going to configure DynamoDB global tables replicating from **AWS Region N. Virginia (us-east-1)** to **AWS Region N. California (us-west-1)**.


2.1  Navigate to **DynamoDB**.

{{< img dd-1.png >}}

2.2 Click **Tables**.

{{< img dd-2.png >}}

2.3 Click **unishophotstandby** link.

{{< img dd-3.png >}}

2.4 Click **Global Tables**.

Click **Enable streams**.

When the popup comes up click **Enable**.

{{< img dd-4.png >}}

{{< img dd-5.png >}}

2.5 Click **Add region**.

{{< img dd-6.png >}}

2.6 When the popup comes up select **US West (N. California)** as the Region and click **Create replica**.

{{< img dd-7.png >}}

2.7 Verify **US EAST (N. Virginia)** and **US WEST (N. California)** are both showing status of **Active**.

{{< img dd-8.png >}}

#### <center>Congragulations !  Your Primary Region and DynamoDB Global Tables are working !





