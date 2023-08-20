+++
title = "Secondary Region"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

#### Deploying the Amazon CloudFormation Template

1.1 Create the application in the secondary region **N. California (us-west-1)** by launching this  [CloudFormation Template](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/create/template?stackName=hot-secondary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/7ebe40ac15b94a1e815828a877bde9b3/v10/HotStandby.yaml).

1.2  Specify stack parameters.

Change the **IsPrimary** parameter to value `no`.

{{% notice info %}}
**Leave LatestAmiId as the default values**
{{% /notice %}}

1.3 Click **Next** to continue.

{{< img sr-4.png >}}

1.4 Leave the **Configure stack options** page defaults and click **Next** to continue.

1.5 Scroll to the bottom of the page and click the **checkbox** to acknowledge IAM role creation, then click **Create stack**.

{{< img sr-5.png >}}

{{% notice warning %}}
You will need to wait for the **Hot Secondary Region** stack to have a status of **Completed** before moving on to the next step. This will take approximately 15 minutes.
{{% /notice %}}

{{< prev_next_button link_prev_url="../1.1.1-primary-region/" link_next_url="../../../2-dynamodb/" />}}