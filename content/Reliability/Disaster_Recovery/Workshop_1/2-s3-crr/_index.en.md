+++
title = "S3 Cross-Region Replication"
date =  2021-05-11T20:33:54-04:00
weight = 2
+++

#### Verify S3 buckets

{{% notice info %}}
As part of the CloudFormation Template, the primary region and secondary region Amazon S3 buckets were created.
{{% /notice %}}

1.1 Click [Amazon S3](https://s3.console.aws.amazon.com/s3/home) to navigate to the dashboard. 

1.2 The two S3 buckets begin with `backupandrestore-`. Note the regions for the two S3 buckets.

{{< img crr-1.png >}}

#### Create Replication rule

2.1 Click the link for **backupandrestore-primary-uibucket-xxxx**.

{{< img crr-2.png >}}

2.2 Click the **Management** link. In the **Replication rule** section, click the **Create replication rule** button.

{{< img crr-3.png >}}

2.3 Enter `PrimaryToSecondary` as the **Replication rule name** and select **Apply to all objects in the bucket**.

{{< img crr-4.png >}}

2.4 Select **Choose a bucket in this account** and then select **backupandrestore-secondary-uibucket-xxxx** as the **Bucket name**. Select **Team Role** as the **IAM role**.

{{< img crr-5.png >}}

2.5 Enable the **Replication Time Control (RTC)** checkbox, then click the **Save** button.

{{< img crr-6.png >}}

2.6 Our bucket is (almost) empty and we don't want to replicate the existing objects, click the **Submit** button.

{{< img crr-7.png >}}

#### Replicate S3 bucket

{{% notice info %}}
We will **manually** copy objects into our **backupandrestore-primary-uibucket-xxxx** in our **primary region** so we can observe the replication into our **backupandrestore-secondary-uibucket-xxxx** bucket in our **secondary region**.
In a production environment, we would **automate** these steps as part of our CI/CD pipeline.
{{% /notice %}}

3.1 Click [AWS Cloudshell](https://us-east-1.console.aws.amazon.com/cloudshell/home?region=us-east-1) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

3.2 If you have never used CloudShell you will be prompted with a **Welcome to AWS CloudShell** message, click the **Close** button.

3.3 Once you see the prompt, paste the following AWS CLI command. You will be prompted with a **Safe Paste for multiline text** message, click the **Paste** button.

```sh
export S3_BUCKET=$(aws s3api list-buckets --region us-east-1 --output text --query 'Buckets[?starts_with(Name, `backupandrestore-primary-uibucket`) == `true`]'.Name)
aws s3 cp s3://ee-assets-prod-us-east-1/modules/630039b9022d4b46bb6cbad2e3899733/v1/UniShopUI/ s3://$S3_BUCKET/ --exclude "config.json" --recursive 
```

#### Verify Replication

4.1 Click [Amazon S3](https://s3.console.aws.amazon.com/s3/home) to navigate back to the dashboard. 

4.2 Click the link for **backupandrestore-secondary-uibucket-xxxx**.

{{< img crr-8.png >}}

4.3 You should see the replicated objects.

{{< img crr-9.png >}}

{{% notice info %}}
It might take a couple of minutes to replicate objects.
{{% /notice %}}

{{< prev_next_button link_prev_url="../1-prerequisites/" link_next_url="../3-verify-primary/" />}}