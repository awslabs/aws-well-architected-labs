+++
title = "Cleanup"
date =  2021-05-11T11:43:28-04:00
weight = 12
+++

{{% notice info %}}
If you are running this workshop via an instructor led training, you do **NOT** need to complete this section.
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

2.2 Click the **Tables** link and the find and click on the name of the **unishophotstandby** table in the list.

{{< img cl-ddbreplica.png >}}

2.3 Click the **Global Tables** link.  Select **US West(N. California)**, then click the **Delete replica** button.

{{< img cl-10.png >}}

2.4 Enter `delete` then click the **Delete** button.

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

4.6 Delete the remaining global database. Select **hot-global** and select **Delete** under **Actions** and then confirm deletion.

{{< img cl-15.png >}}

{{% notice warning %}}
Wait for all the databases and clusters to finish deleting before moving to the next step.
{{% /notice %}}

#### Route 53 cleanup

5.1 Delete Route 53 health checks

{{< img cl-r53-hc.png >}}

5.2 Delete Route 53 hosted zone records for `application.` and `shop.` subdomains

{{< img cl-r53-records.png >}}

5.3 Delete Route 53 hosted zone

{{< img cl-r53-zone.png >}}

#### Route 53 Application Recovery Controller cleanup

6.1 Delete the Safety Rules from the **DefaultControlPanel**:
* MaintenanceORApplication
* AtLeastOneEndpoint

{{< img rcc-1.png >}}

{{< img rcc-2.png >}}

6.2 Delete the Readiness Checks:
* DynamoDBReadinessCheck
* WebsiteEndpointReadinessCheck

{{< img rcc-3.png >}}

{{< img rcc-4.png >}}

6.3 Delete the Recovery Group **UnicornAppRecoveyGroup**

{{< img rcc-5.png >}}

6.4 Delete the Resource Sets:
* DynamoDBResourceSet
* WebsiteEndpointResourceSet

{{< img rcc-7.png >}}

{{< img rcc-6.png >}}

6.5 Delete the **UnicornCluster** recovery cluster:

{{< img rcc-8.png >}}

{{< img rcc-9.png >}}

#### CloudFormation Cleanup

7.1 Click [CloudFormation](https://us-west-1.console.aws.amazon.com/cloudformation/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

7.2 Select **hot-secondary**, then click the **Delete** button.

{{< img cl-16.png >}}

7.3 Click the **Delete stack** button.

{{< img cl-9.png >}}

7.4 Change the region to **N. Virginia (us-east-1)** using the Region Selector in the upper right corner.

7.5 Select **hot-primary**, then click the **Delete** button.

{{< img cl-6.png >}}

7.6 Click the **Delete stack** button.

{{< img cl-7.png >}}

#### Allow Amazon S3 Public Access

If you changed your account-level Block Level Public Access settings for this workshop, return them to their pre-workshop settings. For more information, see [Blocking public access to your Amazon S3 storage](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html). 

{{< prev_next_button link_prev_url="../6-verify-secondary/" title="Congratulations!" final_step="true" >}}
This lab specifically helps you with the best practices covered in question [REL 13  How do you plan for disaster recovery (DR)](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-failure-management.html)
{{< /prev_next_button >}}

