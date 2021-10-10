+++
title = "Cleanup Resources"
date =  2021-05-11T11:43:28-04:00
weight = 9
+++

### Amazon S3

1.1 Click [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard.

1.2 Select **active-primary-uibucket-xxxx** and then click the **Empty** button.

{{< img cl-2.png >}}

1.3 Enter `permanently delete` into the confirmation box and then click **Empty**.

{{< img cl-3.png >}}

1.4 Wait until you see the green banner across the top of the page, indicating the bucket is empty. Then click the **Exit** button.

{{< img cl-4.png >}}

{{% notice note %}}
Please repeat steps **1.1** through **1.4** for the following buckets:</br>
**passive-secondary-uibucket-xxxx**</br>
**active-primary-assetbucket-xxxx**</br>
**passive-secondary-assetbucket-xxxx**
{{% /notice %}}

### Amazon DynamoDB 

2.1 Click [DynamoDB](https://us-east-1.console.aws.amazon.com/dynamodb/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

2.2 Click the **Tables** link.

{{< img dd-2.png >}}

2.3 Click **unishophotstandy**.

{{< img dd-3.png >}}

2.4 Click the **Global Tables** link.  Select **N. California (us-west-1)**, then click the **Delete region** button.

{{< img cl-10.png >}}

2.5 Enter `delete` then click the **Delete** button.

{{< img cl-11.png >}}

2.6 Click [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

2.7 Click the **DB Instances** link.

{{< img a-2.png >}}

2.8  Select **unishopappv1db**, then click **Delete** under the **Actions** dropdown.

{{< img cl-12.png >}}

2.9  Disable the **Create final snapshot** checkbox. Enable the **I acknowledgement ...** checkbox.  Enter `delete me` and click the **Delete** button.

{{< img cl-13.png >}}

### Amazon CloudFormation

3.1 Click [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

3.2 Select **Passive-Secondary**, then click the **Delete** button.

{{< img cl-8.png >}}

3.3 Click the **Delete stack** button.

{{< img cl-9.png >}}

3.4 Change your [console](https://us-east-1.console.aws.amazon.com/console)’s region to **N. Virginia (us-east-1)** using the Region Selector in the upper right corner.

3.5 Select **Active-Primary**, then click the **Delete** button.

{{< img cl-6.png >}}

3.6 Click the **Delete stack** button.

{{< img cl-7.png >}}

### Amazon CloudFormation

4.1 Click [CloudFront](https://console.aws.amazon.com/cloudfront/home?region=us-east-1#/) to navigate to the dashboard.

4.2 

{{< prev_next_button link_prev_url="../verify-failover/" title="Congratulations!" final_step="true" >}}
This lab specifically helps you with the best practices covered in question [REL 13  How do you plan for disaster recovery (DR)](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}

