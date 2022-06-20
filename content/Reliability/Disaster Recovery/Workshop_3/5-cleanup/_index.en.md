+++
title = "Cleanup Resources"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

## Amazon S3 Cleanup

1.1 Navigate to [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/).

1.2 Select the **warm-primary-uibucket-xxxx** and click **Empty**.

{{< img cl-2.png >}}

1.3 Enter `permanently delete` into the confirmation box and then click **Empty**.

{{< img cl-3.png >}}

1.4 When you see the green banner at the top stating the bucket has is empty, click **Exit**.

{{% notice note %}}
Please repeat steps **1.1** through **1.4** for the following buckets:

- `warm-secondary-uibucket-xxxx`

{{% /notice %}}

## Database Clean up

{{% notice note %}}
This step is required as we did manual promotion for the Aurora Database.
{{% /notice %}}

2.1 Navigate to [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) in **N. California (us-west-1)** region.

2.2 Select database under **dr-immersionday-secondary-warm** cluster and delete the instance.

{{< img cl-11.png >}}

2.3 De-select Create final snapshot option, Select "I acknowledge.." option. Click **Delete** button.

{{< img cl-12.png >}}

2.4 Wait until Amazon Aurora Database Cluster is deleted.

## CloudFormation Secondary Region Cleanup

3.1 Navigate to [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) in **N. California (us-west-1)** region.

3.2 Select the **Warm-Secondary** stack and click **Delete**.

{{< img cl-8.png >}}

3.3 Click **Delete stack** to confirm the removal.

{{< img cl-9.png >}}

{{% notice info %}}
**Wait for the stack deletion to complete**.
{{% /notice %}}

3.4 CloudFormation stack deletion fails due to the manual deletion of Aurora Database.

{{< img cl-10.png >}}

3.5 Navigate to [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) in **N. California (us-west-1)** region.

3.6 Select the **Pilot-Secondary** stack and click **Delete**.

3.7 Select all **Resources to retain** (this is OK because they were manually deleted in the prior section) and click **Delete stack**.

{{< img cl-13.png >}}

## AWS CloudFormation Primary Region Cleanup

4.1 Navigate to [CloudFormation](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/) in **N. Virginia (us-east-1)** region.

4.2 Select **Warm-Primary** stack.  Next click the **Delete** button to remove it.

{{< img cl-6.png >}}

4.3 Click **Delete stack** to confirm the deletion.

{{< img cl-7.png >}}

{{< prev_next_button link_prev_url="../4-verify-secondary/" title="Congratulations!" final_step="true" >}}
This lab specifically helps you with the best practices covered in question [REL 13  How do you plan for disaster recovery (DR)](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}
