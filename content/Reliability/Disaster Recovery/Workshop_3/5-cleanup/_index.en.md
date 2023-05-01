+++
title = "Cleanup"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

{{% notice info %}}
If you are running this workshop via an instructor led training, you do **NOT** need to complete this section.
{{% /notice %}}

#### S3 Cleanup

1.1 Click [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard.

1.2 Select the **warm-primary-uibucket-xxxx** and click **Empty**.

{{< img cl-2.png >}}

1.3 Enter `permanently delete` into the confirmation box and then click **Empty**.

{{< img cl-3.png >}}

1.4 When you see the green banner at the top stating the bucket has is empty, click **Exit**.

{{% notice note %}}
Please repeat steps **1.1** through **1.4** for the following buckets:

- `warm-secondary-uibucket-xxxx`

{{% /notice %}}

#### Database Cleanup

{{% notice info %}}
This step is required as we did manual promotion for the Aurora Database.
{{% /notice %}}

2.1 Click [RDS](https://us-east-1.console.aws.amazon.com/rds/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

2.2 Select **unishop-warm** database under **warm-primary** cluster and select **Delete** under **Actions**.

{{< img cl-11.png >}}

2.3 De-select **Create final snapshot**, select **I acknowledge...**, enter `delete me` then click **Delete** button.

{{< img cl-12.png >}}

2.4 Select **warm-primary** cluster and select **Remove from global database** under **Actions** and then confirm promotion.

{{< img cl-14.png >}}

2.5 Select **warm-primary** cluster and select **Delete** under **Actions**.  **(You must wait for the unishop-warm database to delete before deleting the cluster)**.

{{< img cl-16.png >}}

2.6 Select **No** for **Create final snapshot?**, select **I acknowledge...**, then click **Delete DB cluster**.

{{< img cl-17.png >}}

{{% notice note %}}
Please repeat steps **2.2** through **2.4** for the following:  **(You must wait for the primary database to finish deleting before you do this)**
- `warm-secondary cluster`
{{% /notice %}}

2.7 Select **warm-global** and select **Delete** under **Actions** and then confirm deletion.

{{< img cl-15.png >}}

{{% notice warning %}}
Wait for all the databases and clusters to finish deleting before moving to the next step.
{{% /notice %}}

#### CloudFormation Secondary Region Cleanup

3.1 Click [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

3.2 Select the **warm-secondary** stack then click the **Delete** button.

{{< img cl-8.png >}}

3.3 Click **Delete stack** button.

{{< img cl-9.png >}}

{{% notice warning %}}
Wait for the stack deletion to complete before moving to the next step.
{{% /notice %}}

#### CloudFormation Primary Region Cleanup

4.1 Click [CloudFormation](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

4.2 Select **warm-primary** stack then click the **Delete** button.

{{< img cl-6.png >}}

3.3 Click **Delete stack** button.

{{< img cl-7.png >}}

#### Allow Amazon S3 Public Access

If you changed your account-level Block Level Public Access settings for this workshop, return them to their pre-workshop settings. For more information, see [Blocking public access to your Amazon S3 storage](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html). 

{{< prev_next_button link_prev_url="../4-verify-secondary/" title="Congratulations!" final_step="true" >}}
This lab specifically helps you with the best practices covered in question [REL 13  How do you plan for disaster recovery (DR)](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}
