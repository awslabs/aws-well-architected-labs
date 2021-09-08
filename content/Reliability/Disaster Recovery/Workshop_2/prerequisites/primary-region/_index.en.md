+++
title = "Primary Region"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

1.1 Deploy the application to the primary region (us-east-1) by launching this [CloudFormation Template](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?stackName=Pilot-Primary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/630039b9022d4b46bb6cbad2e3899733/v1/PilotLightDR.yaml).

1.2  Specify the stack parameters.

{{% notice info %}}
**Leave isPrimary, isPromote, and LatestAmiId as the default values**
{{% /notice %}}

1.3 Click **Next**

{{< img pr-4.png >}}

1.4 Leave Configure stack options page as all defaults

1.5 Click **Next**

1.6 Scroll to the bottom of the page, click the checkbox to acknowledge IAM role creation, and then click **Create stack**.

{{< img pr-5.png >}}

{{% notice info %}}
**Wait for the stack creation to complete**
{{% /notice %}}

{{< img pr-6.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../secondary-region/" />}}

