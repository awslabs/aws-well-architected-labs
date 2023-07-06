+++
title = "Primary Region"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

#### Deploying the Amazon CloudFormation Template

1.1 Create application in primary region **N. Virginia (us-east-1)** by launching this [CloudFormation Template](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/create/template?stackName=backupandrestore-primary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/7ebe40ac15b94a1e815828a877bde9b3/v10/BackupAndRestore.yaml).

1.2 Click the **Next** button.

{{< img CF-1.png >}}

1.3 Click the **Next** button.

{{% notice info %}}
**Leave LatestAmiId as the default values**
{{% /notice %}}

{{< img CF-2.png >}}

1.4 Click the **Next** button.

{{< img CF-3.png >}}

1.5 Scroll to the bottom of the page and **enable** the **I acknowledge that AWS CloudFormation might create IAM resources with custom names** checkbox, then click the **Create stack** button.

{{< img pr-5.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../1.1.2-secondary-region/" />}}
