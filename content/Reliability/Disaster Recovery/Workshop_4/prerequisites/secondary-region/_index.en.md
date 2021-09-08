+++
title = "Secondary (Passive) Region"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

## Deploying the Amazon CloudFormation Template

1.1 Create the application in the Secondary region (us-west-1) by launching this  [CloudFormation Template](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/create/template?stackName=Passive-Secondary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/630039b9022d4b46bb6cbad2e3899733/v1/HotStandby.yaml).

1.2  Specify stack details.

Change the **IsPrimary** parameter to value `no`.

{{% notice info %}}
**Leave LatestAmiId as the default values**
{{% /notice %}}

1.3 Click **Next** to continue.

{{< img sr-4.png >}}

1.4 Leave the **Configure stack options** page defaults and click **Next** to continue.

1.5 Scroll to the bottom of the page and click the **checkbox** to acknowledge IAM role creation, then click **Create stack**.

{{< img sr-5.png >}}

1.6 Wait until the stack's status reports **CREATE_COMPLETE**.  Then navigate to the **Outputs** tab and record the values of the **APIGURL**, **WebsiteURL**, and **WebsiteBucket** outputs.  You will need these to complete future steps.

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
