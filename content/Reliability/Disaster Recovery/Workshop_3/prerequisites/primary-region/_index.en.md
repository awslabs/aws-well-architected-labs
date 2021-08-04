+++
title = "Primary Region"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

1.1 Create application in Primary region by launching [CloudFormation Template](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?stackName=Warm-Primary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/630039b9022d4b46bb6cbad2e3899733/v1/WarmStandbyDR.yaml).

1.2  Specify stack details.

{{% notice info %}}
**Leave IsPrimary, IsPromote, and LatestAmiId as the default values**
{{% /notice %}}

1.3 Click **Next** to continue.

{{< img pr-4.png >}}

1.4 Leave the **Configure stack options** page defaults and click **Next** to continue.

1.5 Scroll to the bottom of the page and click the **checkbox** to acknowledge then click **Create stack**.

{{< img pr-5.png >}}

{{% notice info %}}
**Wait for the stack creation to complete.**
{{% /notice %}}

{{< img pr-6.png >}}
