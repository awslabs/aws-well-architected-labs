+++
title = "Cleanup"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

{{% notice info %}}
If you are running this workshop via an instructor led training OR if you continue to [Module 5: Multi-Region Resiliency with Route 53 ARC](/reliability/disaster-recovery/workshop_5/) of the lab, please do **NOT** complete this section and move on to the Module 5 straight away. This way, all resources will be ready for you to complete the module. 
Continue to [Module 5: Multi-Region Resiliency with Route 53 ARC](/reliability/disaster-recovery/workshop_5/) 
{{% /notice %}}

#### S3 Cleanup

1.1 Click [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard.

1.2 Select **hot-primary-uibucket-xxxx** and then click the **Empty** button.

{{< img cl-2.png >}}

1.3 Enter `permanently delete` into the confirmation box and then click **Empty**.

{{< img cl-3.png >}}

1.4 Wait until you see the green banner across the top of the page, indicating the bucket is empty. Then click the **Exit** button.

{{< img cl-4.png >}}

{{% notice note %}}
Please repeat steps **1.1** through **1.4** for the following buckets:

- **hot-secondary-uibucket-xxxx**
- **hot-primary-assetbucket-xxxx**
- **hot-secondary-assetbucket-xxxx**

{{% /notice %}}

#### DynamoDB Cleanup

2.1 Click [DynamoDB](https://us-east-1.console.aws.amazon.com/dynamodb/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

2.2 Click the **Tables** link.

{{< img dd-2.png >}}

2.3 Click **unishophotstandby**.

{{< img dd-3.png >}}

2.4 Click the **Global Tables** link.  Select **US West(N. California)**, then click the **Delete replica** button.

{{< img cl-10.png >}}

2.5 Enter `delete` then click the **Delete** button.

{{< img cl-11.png >}}

#### CloudFront Cleanup

3.1 Click [CloudFront](https://us-east-1.console.aws.amazon.com/cloudfront/v3/home?region=us-east-1#/distributions) to navigate to the dashboard.

3.2 Select the CloudFront distribution, then click the **Disable** button and confirm disable.

{{< img cl-17.png >}}

3.3 Wait for the CloudFront distribution to have a status of **Disabled**, then select the CloudFront distribution and click the **Delete** button and confirm deletion.

{{< img cl-18.png >}}

#### Database Cleanup

{{% notice info %}}
This step is required as we did manual promotion for the Aurora Database.
{{% /notice %}}

4.1 Click [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#databases:) to navigate to the dashboard in the **N. California (us-west-1)** region.

4.2 Select **unishop-hot** database under **hot-secondary** cluster and select **Delete** under **Actions**.

{{< img cl-11.png >}}

4.3 De-select **Create final snapshot**, select **I acknowledge...**, enter `delete me` then click **Delete** button.

{{< img cl-12.png >}}

4.4 Change the region to **N. Virginia** using the Region Selector in the upper right corner, then select **unishop-hot** database under **hot-primary** cluster and select **Delete** under **Actions**.

{{< img cl-14.png >}}

4.5 De-select **Create final snapshot**, select **I acknowledge...**, enter `delete me` then click **Delete** button.

{{< img cl-12.png >}}

4.6 Select **hot-global** and select **Delete** under **Actions** and then confirm deletion.

{{< img cl-15.png >}}

{{% notice warning %}}
Wait for all the databases and clusters to finish deleting before moving to the next step.
{{% /notice %}}

#### CloudFormation Cleanup

5.1 Click [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

5.2 Select **hot-secondary**, then click the **Delete** button.

{{< img cl-16.png >}}

5.3 Click the **Delete stack** button.

{{< img cl-9.png >}}

5.4 Change the region to **N. Virginia (us-east-1)** using the Region Selector in the upper right corner.

5.5 Select **hot-primary**, then click the **Delete** button.

{{< img cl-6.png >}}

5.6 Click the **Delete stack** button.

{{< img cl-7.png >}}

#### Allow Amazon S3 Public Access

If you changed your account-level Block Level Public Access settings for this workshop, return them to their pre-workshop settings. For more information, see [Blocking public access to your Amazon S3 storage](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html). 

{{< prev_next_button link_prev_url="../6-verify-secondary/" title="Congratulations!" final_step="true" >}}
This lab specifically helps you with the best practices covered in question [REL 13  How do you plan for disaster recovery (DR)](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}

