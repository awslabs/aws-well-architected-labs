+++
title = "Cleanup Resources"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

#### S3 Cleanup

1.1 Navigate to **S3**.

{{< img cl-1.png >}}

1.2 Selet the **active-primary-uibucket-xxxx** and click **Empty**.

{{< img cl-2.png >}}

1.3 Type in **permanently delete** in the confirmation box and click **Empty**.

{{< img cl-3.png >}}

1.4 When you see the green banner at the top stating the bucket has been emptied successfully click **Exit**.

{{< img cl-4.png >}}

{{% notice note %}}
Please repeat steps **1.1** through **1.4** for the following buckets:</br>
`passive-secondary-uibucket-xxxx`</br>
`active-primary-assetbucket-xxxx`</br>
`passive-secondary-assetbucket-xxxx`
{{% /notice %}}


#### Database Cleanup

1.1 In the top right corner, change your region to **N. Virginia (us-east-1)**.

1.2  Navigate to **DynamoDB**.

{{< img dd-1.png >}}

1.3 Click **Tables**.

{{< img dd-2.png >}}

1.4 Select the `unishophotstandy` table.

{{< img dd-3.png >}}

1.5 Click on the **Global Tables** tab.  Select the **N. California (us-west-1)** region and Click **Delete Region**.

{{< img cl-10.png >}}

1.6 Type `delete` and Click the **Delete** button.

{{< img cl-11.png >}}

1.7 In the top right corner, change your region to **N. California (us-west-1)**.

1.8 Navigate to **RDS**.

{{< img a-1.png >}}

1.9 Click **DB Instances**.

{{< img a-2.png >}}

1.10  Select `unishopappv1db` and Select **Delete**

{{< img cl-12.png >}}

1.11  Uncheck **Create final snapshot**.  Check **I acknowledgement ...**.  Type `delete me` and Click the **Delete** button.

{{< img cl-13.png >}}


#### CloudFormation Cleanup

1.1 In the top right corner, change your region to **N. California (us-west-1)**.

1.2 Navigate to **CloudFormation**.

{{< img cl-5.png >}}

1.3 Select the **Passive-Secondary** stack and click **Delete**.

{{< img cl-8.png >}}

1.4 Click **Delete stack**

{{< img cl-9.png >}}

1.5 In the top right corner, change your region to **N. Virginia (us-east-1)**.

1.6 Select the **Active-Primary** stack and click **Delete**.

{{< img cl-6.png >}}

1.7 Click **Delete stack**

{{< img cl-7.png >}}


