+++
title = "Create Backup Resources"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

[AWS Backup](https://aws.amazon.com/backup/) is a way to centralize and automate data protection across AWS services and hybrid workloads. AWS Backup offers a cost-effective, fully managed, policy-based service that further simplifies data protection at scale. AWS Backup also helps you support your regulatory compliance or business policies for data protection. Together with AWS Organizations, you can use AWS Backup to centrally deploy data protection policies to configure, manage, and govern your backup activity across your company’s AWS accounts and resources. 

You can find a list of AWS Backup supported resources [here](https://aws.amazon.com/backup/?whats-new-cards.sort-by=item.additionalFields.postDateTime&whats-new-cards.sort-order=desc.).

For production applications, we would create a [backup plan](https://docs.aws.amazon.com/aws-backup/latest/devguide/creating-a-backup-plan.html) schedule recurring backups to meet the target RPO. 

For our workshop, we will create **manual backups**.

{{< prev_next_button link_prev_url="../prerequisites/" link_next_url="./s3/" />}}