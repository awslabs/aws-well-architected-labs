+++
title = "Secondary Region"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

#### Creating the Default VPC Parameter

The secondary region CloudFormation Template is utilizing the default VPC. We need to create a parameter with that default VPC ID before we deploy the CloudFormation template.

1.1 Click [AWS Cloudshell](https://us-east-1.console.aws.amazon.com/cloudshell/home?region=us-east-1) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 If you have never used CloudShell you will be prompted with a **Welcome to AWS CloudShell** message, click the **Close** button.

1.3 Once you see the prompt, paste the following AWS CLI commands. You will be prompted with a **Safe Paste for multiline text** message, click the **Paste** button.

```sh
export DEFAULT_VPC=$(aws ec2 describe-vpcs --filters Name=isDefault,Values=true --query "Vpcs[].VpcId" --region us-west-1 --output text) 
```
```sh
aws ssm put-parameter --name "/deployer/backupandrestore-secondary/default-vpc" --value $DEFAULT_VPC --type "String"  --overwrite --region us-west-1
```

#### Deploying the Amazon CloudFormation Template

2.1 Create the application in the secondary region **N. California (us-west-1)** by launching [CloudFormation Template](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/create/template?stackName=backupandrestore-secondary&templateURL=https://ee-assets-prod-us-east-1.s3.amazonaws.com/modules/7ebe40ac15b94a1e815828a877bde9b3/v10/BackupAndRestoreDB.yaml).

2.2 Click the **Next** button.

{{< img sr-1.png >}}

2.3 Click the **Next** button.

{{% notice info %}}
**Leave LatestAmiId as the default values**
{{% /notice %}}

{{< img sr-2.png >}}

2.4 Click the **Next** button.

{{< img cf-3.png >}}

2.5 Scroll to the bottom of the page and **enable** the **I acknowledge that AWS CloudFormation might create IAM resources with custom names** checkbox, then click the **Create stack** button.

{{< img pr-5.png >}}

{{% notice warning %}}
You will need to wait for the **BackupAndRestore Primary Region** stack to have a status of **Completed** before moving on to the next step. This will take approximately 15 minutes.
{{% /notice %}}

{{< prev_next_button link_prev_url="../1.1.1-primary-region/" link_next_url="../1.1.3-iam-role/" />}}