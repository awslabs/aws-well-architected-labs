+++
title = "DynamoDB"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

When you create a [DynamoDB global table](https://aws.amazon.com/dynamodb/global-tables/), it consists of multiple replica tables (one per AWS Region) that DynamoDB treats as a single unit. Every replica has the same table name and the same primary key schema. When an application writes data to a replica table in one AWS region, DynamoDB propagates the write to the other replica tables in the other AWS regions automatically.

#### Configure Amazon DynamoDB Global Tables

1.1 Click [DynamoDB](https://console.aws.amazon.com/dynamodbv2/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** regions.

1.2 Click the **Tables** link.

{{< img dd-2.png >}}

1.3 Click the **unishophotstandby** link.

{{< img dd-3.png >}}

1.4 Click the **Global Tables** link, click the **Create replica** button.

{{< img dd-4.png >}}

1.5 Select **US West (N. California)** as the **Available replication Regions**, then click the **Create replica** button.

{{< img dd-5.png >}}

{{% notice warning %}}
Wait for the status to show **Active** before moving on to the next step. 
{{% /notice %}}

{{< prev_next_button link_prev_url="../1-prerequisites/" link_next_url="../3-verify-websites/" />}}
