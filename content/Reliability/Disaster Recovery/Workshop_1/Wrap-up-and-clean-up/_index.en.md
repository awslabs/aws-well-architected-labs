+++
title = "Wrap Up and Clean Up"
date =  2021-05-11T20:41:47-04:00
weight = 150
+++

{{% notice Warning %}}
Suppose you are running this workshop in your account. In that case, you should clean up all the resources we created to avoid incurring unnecessary charges.
{{% /notice %}}

### Delete contents of the S3 buckets

1.1 Navigate to S3 in the console.

{{< img BK-35.png >}}

1.2 Select each of the two buckets created for this workshop and click the **Empty** button.

{{< img CL-32.png >}}

1.3 Next, enter the text `permanently delete` in the text input field and then click the **Empty** button.

{{< img CL-33.png >}}

1.4 Click into each bucket and confirm that all the objects have been deleted, then click **Exit**.

{{< img CL-34.png >}}

1.6 Repeat this object deletion process for the remaining three buckets.

### Delete the Cloudformation stack

2.2 Change your [console](https://us-east-1.console.aws.amazon.com/console)’s region to us-east-1 using the Region Selector in the upper right corner.

{{< img RE-1.png >}}

2.3 Navigate to **CloudFormation** in the console.

{{< img CF-1.png >}}

2.4 Select the stack created during the [US-East-1 Deployment section](us-east-1-deployment.html) of this workshop, then click the **Delete** button.

{{< img CL-8.png >}}

2.5 Click the **Delete stack** button to confirm.

{{< img CL-9.png >}}

Take a break as the stack will take several minutes to delete, releasing any resources associated with it. When the operation completes, the stack will no longer appear in the list. If there are any issues, click on the stack’s name and navigate the Events tab for more information.

{{< img CL-10.png >}}

### Delete the contents of the backup vaults

3.1  Navigate to **AWS Backup** in the console.

{{< img BK-10.png >}}

3.2 Navigate to the default backup vault. Click the check box to select all recovery points, then click **Actions** followed by **Delete**.

{{< img CL-11.png >}}

3.3 Enter `delete` in the field and click the **Delete recovery points** button.

{{< img CL-12.png >}}

3.4 Confirm deletion.

{{< img CL-13.png >}}

3.5 Repeat the backup removal process for the US-West-1 region.

### Delete the DR RDS instance

4.1 Change your [console](https://us-west-1.console.aws.amazon.com/console)’s region to us-west-1 using the Region Selector in the upper right corner.

{{< img CL-19.png >}}

4.2 Navigate to RDS in the console.

{{< img CL-20.png >}}

4.3 Use the radio button to select the database. Under the **Action** menu, click **Delete**.

{{< img CL-21.png >}}

4.4 Type `delete me` in the field and click the **Delete** button.

{{< img CL-22.png >}}

The database will no longer appear in the list after deletion.

{{< img CL-23.png >}}

## Delete the DR, EC2 instances, AMIs, and security groups

5.1 Navigate to EC2 in the console.

{{< img CL-24.png >}}

5.2 Navigate to **Instances**, select the instance, then use the **Instance state** menu to select **Terminate instance**.

{{< img CL-25.png >}}

The instance will now show as terminated.

{{< img CL-26.png >}}

5.3 Navigate to **Security groups**. Click on one of the security groups created durng the workshop.

{{< img CL-28.png >}}

5.4 From the **Actions** menu and select **Delete security groups**.

{{< img CL-29.png >}}

5.5 Click the **Delete** button to confirm.

{{< img CL-30.png >}}

Repeat for any other security groups created during the workshop.

5.6 Navigate to AMIs, select the AMI, then use the Actions menu and click Deregister.

{{< img CL-31.png >}}

Repeat the AMI deletion in US-East-1.

### Delete the S3 buckets

6.1 Navigate to S3 in the console.

{{< img BK-35.png >}}

6.2 Use the radio button to select one of the buckets created for this workshop and click the **Delete** button.

{{< img CL-35.png >}}

6.3 Enter the bucket name in the text input field and click the **Delete bucket** button.

{{< img CL-36.png >}}

6.4 Repeat the process for the remaining bucket.

{{< img CL-37.png >}}

{{< prev_next_button link_prev_url="../restore-to-us-west-1/" title="Congratulations!" final_step="true" >}}
{{< /prev_next_button >}}
