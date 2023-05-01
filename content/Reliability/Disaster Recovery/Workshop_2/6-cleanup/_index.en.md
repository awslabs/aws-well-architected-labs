+++
title = "Cleanup"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

{{% notice info %}}
If you are running this workshop via an instructor led training, you do **NOT** need to complete this section.
{{% /notice %}}

#### S3 Cleanup

1.1 CLick [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard..

1.2 Select the **pilot-primary-uibucket-xxxx** and click **Empty**.

{{< img cl-2.png >}}

1.3 Enter `permanently delete` into the confirmation box and then click **Empty**.

{{< img cl-3.png >}}

1.4 When you see the green banner at the top stating the bucket has is empty, click **Exit**.

{{% notice note %}}
Please repeat steps **1.1** through **1.4** for the following buckets:

- `pilot-secondary-uibucket-xxxx`

{{% /notice %}}

#### Database Cleanup

{{% notice info %}}
This step is required as we did manual promotion for the Aurora Database.
{{% /notice %}}

2.1 Click [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#databases:) to navigate to the dashboard in **N. California (us-west-1)** region.

2.2 Select **unishop** database under **pilot-secondary** cluster and select **Delete** under **Actions**.

{{< img cl-11.png >}}

2.3 De-select **Create final snapshot**, select **I acknowledge...**, enter `delete me` then click **Delete** button.

{{< img cl-12.png >}}

2.4 Change the region to **N. Virginia** using  the Region Selector in the upper right corner, then select **unishop** database under **pilot-primary** cluster and select **Delete** under **Actions**.

{{< img cl-14.png >}}

2.5 De-select **Create final snapshot**, select **I acknowledge...**, enter `delete me` then click **Delete** button.

{{< img cl-12.png >}}

2.6 Select **pilot-global** and select **Delete** under **Actions** and then confirm deletion.

{{< img cl-15.png >}}

{{% notice warning %}}
Wait for all the databases and clusters to finish deleting before moving to the next step.
{{% /notice %}}

#### EC2 Cleanup

3.1 Click [EC2](https://us-west-1.console.aws.amazon.com/ec2/v2/home?region=us-west-1#Instances:instanceState=running) to navigate to the dashboard in the **N. California (us-west-1)** region.

3.2 Select the **pilot-secondary** instance and click **Terminate instance** under **Instance State**.

{{< img cl-16.png >}}

#### CloudFormation Secondary Region Cleanup

4.1 Click [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

4.2 Select the **pilot-secondary** stack and click **Delete**.

{{< img cl-8.png >}}

4.3 Click **Delete stack** to confirm the removal.

{{< img cl-9.png >}}

#### CloudFormation Primary Region Cleanup

5.1 Click [CloudFormation](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

5.2 Select **pilot-primary** stack.  Next click the **Delete** button to remove it.

{{< img cl-6.png >}}

5.3 Click **Delete stack** to confirm the deletion.

{{< img cl-7.png >}}

#### Allow Amazon S3 Public Access

If you changed your account-level Block Level Public Access settings for this workshop, return them to their pre-workshop settings. For more information, see [Blocking public access to your Amazon S3 storage](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html). 

{{< prev_next_button link_prev_url="../5-verify-secondary/" title="Congratulations!" final_step="true" >}}
This lab specifically helps you with the best practices covered in question [REL 13  How do you plan for disaster recovery (DR)](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}
