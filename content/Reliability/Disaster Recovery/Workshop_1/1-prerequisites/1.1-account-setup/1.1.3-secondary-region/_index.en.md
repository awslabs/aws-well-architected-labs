+++
title = "Secondary Region"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

## Deploying the Amazon CloudFormation Template

1.1 Create the application in the secondary region **N. California (us-west-1)** by launching [CloudFormation Template](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/create/template?stackName=backupandrestore-secondary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/630039b9022d4b46bb6cbad2e3899733/v1/BackupAndRestoreDB.yaml).

1.2 Click the **Next** button.

{{< img sr-1.png >}}

1.3 Click the **Next** button.

{{% notice info %}}
**Leave LatestAmiId as the default values**
{{% /notice %}}

{{< img sr-2.png >}}

1.4 Click the **Next** button.

{{< img cf-3.png >}}

1.5 Scroll to the bottom of the page and **enable** the **I acknowledge that AWS CloudFormation might create IAM resources with custom names** checkbox, then click the **Create stack** button.

{{< img pr-5.png >}}

{{% notice warning %}}
You will need to wait for the **BackupAndRestore Primary Region** stack to have a status of **Completed** before moving on to the next step. This will take approximately 15 minutes.
{{% /notice %}}

{{< prev_next_button link_prev_url="../1.1.2-s3/" link_next_url="../../../2-s3-crr/" />}}