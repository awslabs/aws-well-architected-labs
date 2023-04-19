+++
title = "IAM Role"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

#### Creating the IAM Role

We need to create an IAM role that has access to perform the functions in this lab.

1.1 Click [IAM](https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/roles) to navigate to the IAM Roles dashboard.

1.2 Click the **Create Role** button.

{{< img ir-1.png >}}

1.3 Choose **AWS service** and under **Use case** select **AWS Backup**, then click the **Next** button.

{{< img ir-2.png >}}

1.4 Search for **AWSBackupServiceRolePolicyForBackup** and then select as the **Policy Name**, then click the **Next** button.

{{< img ir-3.png >}}

1.5 1.3 Enter `Team-Role` as the **Role name**, then scroll down and click the **Create role** button.

{{< img ir-4.png >}}

{{< prev_next_button link_prev_url="../1.1.3-secondary-region/" link_next_url="../../../2-s3-crr/" />}}
