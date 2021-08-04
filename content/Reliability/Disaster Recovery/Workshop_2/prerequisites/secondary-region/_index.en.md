+++
title = "Secondary Region"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

1.1 Deploy the application to the secondary region (us-west-1) by launching this [CloudFormation Template](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/create/template?stackName=Pilot-Secondary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/630039b9022d4b46bb6cbad2e3899733/v1/PilotLightDR.yaml).

1.2  Modify the stack details.

- Change the **IsPrimary** parameter to `no`

{{% notice info %}}
**Leave isPromote and LatestAmiId as the default values**
{{% /notice %}}

1.3 Click **Next**

{{< img sr-4.png >}}

1.4 Leave Configure stack options page as all defaults

1.5 Click **Next**

1.6 Scroll to the bottom of the page, click the checkbox to acknowledge IAM role creation, and then click **Create stack**.

{{< img sr-5.png >}}

{{% notice info %}}
**Wait for the stack creation to complete**
{{% /notice %}}
{{< img sr-6.png >}}
