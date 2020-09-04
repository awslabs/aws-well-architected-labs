---
title: "Lab Teardown"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 11
pre: "<b>11. </b>"
---

Deleting the QuickSight visualization

1. Visit the [QuickSight console](https://quicksight.aws.amazon.com/).
2. On the home screen, click the three dots under the analysis called `security_lab_apache_access_log...`.
3. Click **Delete**, and click **Delete** again on the screen that pops up.
4. Next, click on the **Manage data** button in the top right corner of the page.
5. Under **Your Data Sets**, click on `security_lab_apache_acc...`. Click **Delete data set** and click **Delete** on the pop up window.

Deleting Athena database/table.

1. Visit the [Athena console](https://console.aws.amazon.com/athena/).
2. In the left side menu, under **Tables**, click the three dots next to `security_lab_apache_access_logs`. Click **Delete table** in the menu that appears.
3. Click **Yes**in the pop up box
4. Create a new query. Type `DROP database security_lab_logs` in the query editor and press **Run query**.

Deleting the Systems Manager stored parameter

1. Visit the [Systems Manager console](https://console.aws.amazon.com/systems-manager).
2. In the left side menu, click on **Parameter store**.
3. Click the box next to your created parameter, likely called `AmazonCloudWatch-securitylab-cw-config`.
4. Click **Delete**. Click **Delete parameters** on the pop up that appears.

Deleting the S3 Bucket

1. Visit the [S3 console](https://console.aws.amazon.com/s3/).
2. Click the button next to your created bucket, likely called `wa-lab-<your-last-name>-<date>`.
3. Click **Delete**, follow the instructions in the pop-up to delete your bucket.

Tearing down the CloudFormation stack.

1. Visit the [CloudFormation console](https://console.aws.amazon.com/cloudformation/).
2. Click on the stack you created for this lab, likely called `security-cw-lab`.
3. Click **Delete** and then **Delete stack** on the window that pops up.

{{< prev_next_button link_prev_url="../9_create_quicksight_dashboard/" title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with [SEC4 - How do you detect and investigate security events?](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-detective-controls.html) and [SEC6 - How do you protect your compute resources?](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-infrastructure-protection.html)
{{< /prev_next_button >}}
