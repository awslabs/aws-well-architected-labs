+++
title = "Secondary (Passive) Region"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

1.1 In the top right corner, change your region to **N. California (us-west-1)**.

{{< img sr-1.png >}}

1.2 Click **Create stack**.  Select **With new resources (standard)**.

{{< img sr-2.png >}}

1.3 Specify Template.

Select **Upload a template file**

Click **Choose file** and upload the CloudFormation template file you just downloaded for the Primary Region Template - `HotStandyBy.yaml`.  

{{% notice note %}}
This is the great thing about Cloud Formation and IaC (Infrastructure As Code). Reuseable templates.
{{% /notice %}}

Click **Next**

{{< img sr-3.png >}}

1.4  Specify stack details. 

Use the following values:

* **Stack Name**: `Passive-Secondary`
* **isPrimary**: `No`

{{% notice info %}}
**Leave LatestAmiId as the default value**
{{% /notice %}}

Click **Next**

{{< img sr-4.png >}}

1.5 Leave Configure stack options page as all defaults

Click **Next**

1.7 Scroll to the bottom of the page and click the **checkbox** to acknowledge then click **Create stack**.

{{< img sr-5.png >}}

1.8 When stack status is showing **CREATE_COMPLETE**, click on the **Outputs** tab and copy and paste the values for **APIGURL, WebsiteURL** and **WebsiteBucket** into a text editor as you will need them in future steps.

{{< img sr-6.png >}}

{{% notice info %}}
**You must wait for the stack to successfully be created before moving on to the next step.**
{{% /notice %}}

We are going to configure Aurora write forwarding on our Aurora read replica.

2.1 Navigate to **RDS**.

{{< img a-1.png >}}

2.2 Click **DB Instances**.

{{< img a-2.png >}}

2.3 Select **hot-standby-passive-secondary** and click **Modify**.

{{< img a-3.png >}}

2.4 Scroll down to **Read Replica Write Forwarding** and check **Enable read replica write forwarding**.

{{< img a-4.png >}}

2.5 Scroll down to the bottom and click **Continue**.  Click **Modify Cluster**.

#### <center>Congragulations !  Your Secondary Region and Aurora Global Database is configured for Read Replica Write Forwarding !



