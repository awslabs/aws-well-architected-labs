+++
title = "Secondary (Passive) Region"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

## Deploying the Amazon CloudFormation Template

1.1 Change your [console](https://us-west-1.console.aws.amazon.com/console)’s region to **N. California (us-west-1)** using the Region Selector in the upper right corner.

{{< img sr-1.png >}}

1.2 Navigate to **CloudFormation** in the console. Click on the **Create stack** dropdown and select the **With new resources (standard)** link.

{{< img sr-2.png >}}

1.3 Next, select **Upload a template file** and click the **Choose file** button to upload the the CloudFormation Template downloaded in previous step.  Finally, click the **Next** button to continue.

{{% notice note %}}
Reusable templates are one of the great things about Amazon CloudForamtion and Infrastructure As Code (IaC).
{{% /notice %}}

Click **Next**

{{< img sr-3.png >}}

1.4  On the Specify stack details page, set the **Stack Name** to `Passive-Secondary`.  Next, set the **IsPrimary** parameter to `no`.  Finally, click the **Next** button to continue.

{{% notice info %}}
Leave the **LatestAmiId** parameter as the default value.
{{% /notice %}}

{{< img sr-4.png >}}

1.5 Scroll to the bottom of  the Configure stack options page.  Then check the **I acknowledge that AWS CloudFormation might create IAM resources with custom names** checkbox.  Finally, click the **Create stack** button to deploy the website.

{{< img sr-5.png >}}

1.8 Wait until the stack's status reports **CREATE_COMPLETE**.  Then navigate to the **Outputs** tab and record the values of the **APIGURL**, **WebsiteURL**, and **WebsiteBucket** outputs.  You will need them to complete future steps.

{{< img sr-6.png >}}

{{% notice info %}}
**You must wait for the stack to successfully be created before moving on to the next step.**
{{% /notice %}}

## Configuring Amazon Aurora Write Forwarding

Amazon Aurora Global Database is designed for globally distributed applications, allowing a single Amazon Aurora database to span multiple AWS regions. It replicates your data with no impact on database performance, enables fast local reads with low latency in each region, and provides disaster recovery from region-wide outages.

The Read-Replica Write Forwarding feature's typical latency is under one second from secondary to primary databases.  This capability enables low latency global reads across your global presence. In disaster recovery situations, you can promote a secondary region to take full read-write responsibilities in under a minute.

Now, let us configure Amazon Aurora MySQL Read-Replica Write Forwarding on our Amazon Aurora MySQL Replica instance!

2.1 Navigate to **RDS** in the console.

{{< img a-1.png >}}

2.2 Next, click into **DB Instances**.

{{< img a-2.png >}}

2.3 Select **hot-standby-passive-secondary** and click the **Modify** button.

{{< img a-3.png >}}

2.4 Scroll down to **Read Replica Write Forwarding** and check the **Enable read replica write forwarding** checkbox.

{{< img a-4.png >}}

2.5 Scroll down to the page's bottom and click the **Continue** button. Finally click the **Modify Cluster** button.

## Congratulations! Your Amazon Aurora Global Database now supports Read-Replica Write Forwarding!
