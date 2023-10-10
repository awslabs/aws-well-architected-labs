---
title: "Teardown"
date: 2021-02-21T11:16:08-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

The following instructions will remove the resources that you have created in this lab.

#### Cleaning up AWS Backup Resources

1.  Sign in to the AWS Management Console and navigate to the AWS Backup console - <https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#home>
1.  Click on **BACKUP VAULTS** from the menu on the left side, and select **BACKUP-LAB-VAULT**.
1.  Under the section **BACKUPS**, delete all the **RECOVERY POINTS**.
1.  Once all the **RECOVERY POINTS** have been deleted, delete the **Backup Vault** by clicking on **DELETE** on the top right hand corner.
1.  Click on **BACKUP PLANS** from the menu on the left side, and select **BACKUP-LAB**.
1.  Scroll down to the section **RESOURCE ASSIGNMENTS**, and delete the resource assignment.
1.  Delete the **BACKUP PLAN** by clicking on **DELETE** on the upper right corner of the screen.

#### Cleaning up the CloudFormation Stack

1.  Sign in to the AWS Management Console and navigate to the AWS CloudFormation console - <https://console.aws.amazon.com/cloudformation/>
1.  Select the stack **WA-Backup-Lab**, and delete the stack.

#### Cleaning up the CloudWatch Logs

1. Sign in to the AWS Management Console, and open the CloudWatch console at [https://console.aws.amazon.com/cloudwatch/](https://console.aws.amazon.com/cloudwatch/).
1. Click **Logs** in the left navigation.
1. Click the radio button on the left of the **/aws/lambda/RestoreTestFunction**.
1. Click the **Actions Button** then click **Delete Log Group**.
1. Verify the log group name then click **Yes, Delete**.

### Thank you for using this lab

{{< prev_next_button link_prev_url="../4_test_restore/" title="Congratulations!" final_step="true"  />}}
Now that you have completed the lab, if you have implemented this knowledge in your environment, you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with [REL 9  How do you back up data?](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< prev_next_button />}}
