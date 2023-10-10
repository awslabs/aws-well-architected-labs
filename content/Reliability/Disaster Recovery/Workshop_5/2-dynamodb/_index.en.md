+++
title = "DynamoDB"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

{{% notice info %}}
Skip this step if you are doing the lab using resources created by [Module 4: Hot Standby](/reliability/disaster-recovery/workshop_4/) as Dynamo DB Global Table replica was created as part of that lab. 
{{% /notice %}}


When you create a [DynamoDB global table](https://aws.amazon.com/dynamodb/global-tables/), it consists of multiple replica tables (one per AWS Region) that DynamoDB treats as a single unit. Every replica has the same table name and the same primary key schema. When an application writes data to a replica table in one AWS region, DynamoDB propagates the write to the other replica tables in the other AWS regions automatically.

(If you are using the same architecture that you have deployed from the [Module 4: Hot Standby](../../workshop_4/) lab, and you have not yet cleaned it up, you will find that an Amazon DynamoDB global table is already configured as described below. Verify that your configuration matches the steps below, and if so, **continue to the [Verify Websites](../3-verify-websites/) section of the workshop.**

#### Configure Amazon DynamoDB Global Tables

1.1 Click [DynamoDB](https://console.aws.amazon.com/dynamodbv2/home?region=us-east-1#/) to navigate to the dashboard in the **N. Virginia (us-east-1)** regions.

1.2 Click the **Tables** link.

{{< img dd-2.png >}}

1.3 Click the **unishophotstandby** link.

{{< img dd-3.png >}}

1.4 Click the **Global Tables** link, click the **Create replica** button.

{{< img dd-4.png >}}

{{% notice note %}}

You may be prompted with a message about the global tables versions. Please disregard this message as we will not need to worry about the backward compartibility of the DynamoDB global tables in this lab.

{{% /notice %}}

1.5 Select **US West (N. California)** as the **Available replication Regions**, then click the **Create replica** button.

{{< img dd-5.png >}}

{{% notice warning %}}
Wait for the status to show **Active** before moving on to the next step. 
{{% /notice %}}

{{< prev_next_button link_prev_url="../1-prerequisites/" link_next_url="../3-verify-websites/" />}}