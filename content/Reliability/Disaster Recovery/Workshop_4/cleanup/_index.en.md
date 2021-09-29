+++
title = "Cleanup Resources"
date =  2021-05-11T11:43:28-04:00
weight = 9
+++

## Cleanup Amazon S3

1.1 Navigate to [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/).

1.2 Find the bucket with prefix **active-primary-uibucket-xxxx** and click the **Empty** button.

{{< img cl-2.png >}}

1.3 Type `permanently delete` into the confirmation box and then click **Empty**.

{{< img cl-3.png >}}

1.4 Wait until you see the green banner across the top of the page, indicating the bucket is empty. Then click the **Exit** button.

{{< img cl-4.png >}}

{{% notice note %}}
Please repeat steps **1.1** through **1.4** for the following buckets:</br>
`passive-secondary-uibucket-xxxx`</br>
`active-primary-assetbucket-xxxx`</br>
`passive-secondary-assetbucket-xxxx`
{{% /notice %}}

## Cleanup Amazon DynamoDB Global Tables

2.1 Navigate to [DynamoDB](https://us-east-1.console.aws.amazon.com/dynamodb/home?region=us-east-1#/) in the **N. Virginia (us-east-1)** region.

2.2 Navigate into the **Tables** subpage.

{{< img dd-2.png >}}

2.3 Click into the `unishophotstandy` table properties.

{{< img dd-3.png >}}

2.4 Under the **Global Tables** tab, use the **Delete Region** button to remove the **N. California (us-west-1)** replica.

{{< img cl-10.png >}}

2.5 Type `delete` into the confirmation box, and then click the **Delete** button.

{{< img cl-11.png >}}

2.6 Navigate to [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) in the **N. California (us-west-1)** region.

2.7 Click **DB Instances**.

{{< img a-2.png >}}

2.8  Choose the `unishopappv1db` database, then click the **Delete** menu item under the **Actions** dropdown.

{{< img cl-12.png >}}

2.9  Uncheck the **Create final snapshot** checkbox. Next, enable the **I acknowledgement ...** checkbox.  Then type `delete me` into the confirmation box. Finally, click the **Delete** button.

{{< img cl-13.png >}}

## Cleanup Amazon CloudFormation

3.1 Navigate to [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) in the **N. California (us-west-1)** region.

3.2 Select the **Passive-Secondary** stack and click the **Delete** button.

{{< img cl-8.png >}}

3.3 Click the **Delete stack** button to confirm the removal.

{{< img cl-9.png >}}

3.4 Change your [console](https://us-east-1.console.aws.amazon.com/console)’s region to **N. Virginia (us-east-1)** using the Region Selector in the upper right corner.

3.5 Select the **Active-Primary** stack and click the **Delete** button.

{{< img cl-6.png >}}

3.6 Click **Delete stack** button to confirm the removal.

{{< img cl-7.png >}}

{{< prev_next_button link_prev_url="../verify-failover/" title="Congratulations!" final_step="true" >}}
This lab specifically helps you with the best practices covered in question [REL 13  How do you plan for disaster recovery (DR)](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}

