+++
title = "Prepare Secondary Region"
date =  2021-05-11T20:33:54-04:00
weight = 3
+++

[AWS Backup](https://aws.amazon.com/backup/) is a way to centralize and automate data protection across AWS services and hybrid workloads. AWS Backup offers a cost-effective, fully managed, policy-based service that further simplifies data protection at scale. AWS Backup also helps you support your regulatory compliance or business policies for data protection. Together with AWS Organizations, you can use AWS Backup to centrally deploy data protection policies to configure, manage, and govern your backup activity across your company’s AWS accounts and resources. 

You can find a list of AWS Backup supported resources [here](https://aws.amazon.com/backup/?whats-new-cards.sort-by=item.additionalFields.postDateTime&whats-new-cards.sort-order=desc.).

For production applications, we would create a [backup plan](https://docs.aws.amazon.com/aws-backup/latest/devguide/creating-a-backup-plan.html) schedule recurring backups to meet the target RPO. 

For our workshop, we will **manually** create backups and copy them to our secondary region.

{{% notice note %}}
If you are using your own AWS account you may want to create a non-default vault for this workshop. this will prevent commingling of workshop backups with other backups in the default vault. Instructions can be found in the [service documentation](https://docs.aws.amazon.com/aws-backup/latest/devguide/vaults.html).
{{% /notice %}}

{{< prev_next_button link_prev_url="../2-verify-primary/" link_next_url="./3.1-backup/" />}}