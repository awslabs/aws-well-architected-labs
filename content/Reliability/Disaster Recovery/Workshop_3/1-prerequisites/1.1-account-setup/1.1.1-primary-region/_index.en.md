+++
title = "Primary Region"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

#### Deploying the Amazon CloudFormation Template

1.1 Create application in primary region **N. Virginia (us-east-1)** by launching [CloudFormation Template](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?stackName=warm-primary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/7ebe40ac15b94a1e815828a877bde9b3/v10/WarmStandbyDR.yaml).

1.2  Specify stack details.

{{% notice info %}}
**Leave IsPrimary, IsPromote, and LatestAmiId as the default values**
{{% /notice %}}

1.3 Click **Next** to continue.

{{< img pr-4.png >}}

1.4 Leave the **Configure stack options** page defaults and click **Next** to continue.

1.5 Scroll to the bottom of the page and click the **checkbox** to acknowledge then click **Create stack**.

{{< img pr-5.png >}}

{{% notice warning %}}
You will need to wait for the **Warm Primary Region** stack to have a status of **Completed** before moving on to this section. This will take approximately 15 minutes.
{{% /notice %}}

{{< prev_next_button link_prev_url="../" link_next_url="../1.1.2-secondary-region" />}}

