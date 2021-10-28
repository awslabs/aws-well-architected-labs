+++
title = "DynamoDB Global Tables"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

When you create a DynamoDB global table, it consists of multiple replica tables (one per AWS Region) that DynamoDB treats as a single unit. Every replica has the same table name and the same primary key schema. When an application writes data to a replica table in one Region, DynamoDB propagates the write to the other replica tables in the other AWS Regions automatically.

We are going to configure DynamoDB global tables replicating from **AWS Region N. Virginia (us-east-1)** to **AWS Region N. California (us-west-1)**.

{{% notice note %}}
**If you are using your own AWS Account, you must wait for the Primary Region stack to successfully be created before moving on to this step.**
{{% /notice %}}

### Deploying Amazon DynamoDB Global Tables

1.1 Click [DynamoDB](https://console.aws.amazon.com/dynamodbv2/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** regions.

1.2 Click the **Tables** link.

{{< img dd-2.png >}}

1.3 Click the **unishophotstandby** link.

{{< img dd-3.png >}}

1.4 Click the **Global Tables** link, click the **Create replica** button.

{{< img dd-4.png >}}

1.5 Select **US West (N. California)** as the **Available replication Regions**, then click the **Create replica** button.

{{< img dd-5.png >}}

{{% notice note %}}
This might take a few minutes, feel free to move onto the next step.  Just ensure the status is showing **Active** before **Verify Websites** step.
{{% /notice %}}

{{< img dd-6.png >}}

#### Congratulations! Your DynamoDB Global Tables have been created!

{{< prev_next_button link_prev_url="../prerequisites/cfn-outputs/" link_next_url="../enable-aurora-writefwd/" />}}
