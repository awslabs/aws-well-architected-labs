+++
title = "DynamoDB Global Tables"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

When you create a DynamoDB global table, it consists of multiple replica tables (one per AWS Region) that DynamoDB treats as a single unit. Every replica has the same table name and the same primary key schema. When an application writes data to a replica table in one Region, DynamoDB propagates the write to the other replica tables in the other AWS Regions automatically.

We are going to configure DynamoDB global tables replicating from **AWS Region N. Virginia (us-east-1)** to **AWS Region N. California (us-west-1)**.

{{% notice note %}}
**You must wait for the Primary Region stack to successfully be created before moving on to this step.**
{{% /notice %}}

## Deploying Amazon DynamoDB Global Tables

1.1 Change your [console](https://us-east-1.console.aws.amazon.com/console)’s region to **N. Virginia (us-east-1)** using the Region Selector in the upper right corner.

1.2  Navigate to **DynamoDB** in the console.

{{< img dd-1.png >}}

1.3 Click on the **Tables** link on the left-hand side.

{{< img dd-2.png >}}

1.4 Find the **unishophotstandby** table, and click into the configuration settings.

{{< img dd-3.png >}}

1.5 Under the **Global Tables** table, click the **Create replica** button.

{{< img dd-4.png >}}

1.6 Select the **US West (N. California)** region under Available replication Region, and then click the **Create replica** button.

{{< img dd-5.png >}}

1.7 Wait for the **US West (N. California)** region's status to be **Active**.

{{< img dd-6.png >}}

## Congratulations! Your DynamoDB Global Tables have been created!

{{< prev_next_button link_prev_url="../prerequisites/secondary-region/" link_next_url="../enable-aurora-writefwd/" />}}