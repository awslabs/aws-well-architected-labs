+++
title = "Readiness checks - DynamoDB"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

Now we need to create readiness checks for our cells. For our application, we’re going to set up readiness checks for the DynamoDB tables, and the website endpoints. These are two examples of resources that we will be monitoring for our sample application. 

1. We’ll start with a readiness check for DynamoDB. Click **“Create a new readiness check”** to start:

{{< img step-3a.png >}}

2. Give your readiness check a meaningful name (e.g. `DynamoDBReadinessCheck`), select **“DynamoDB table”** from the **Resource type pulldown**, and click Next:

{{< img step-3b.png >}}

3. Next we need to create a **Resource set** which contains the DynamoDB tables that the we’re monitoring. Select the **“Create a new resource set”** radio button, and give your resource set a meaningful name (e.g. `DynamoDBResourceSet`):

{{< img step-3c.png >}}

Open another browser another tab, and navigate to the DynamoDB console in **N. Virginia (us-east-1)** and **N. California (us-west-1)**. Select the **“unishophotstandby”** table in each region, and copy down the **ARN** of each table. You'll find the **ARN** in the **“Overview”** tab for your table, and click **“Additional info”** to expand the **“General information”** section:

{{< img step-3d.png >}}

Return to your Route 53 ARC browser tab, and add both DynamoDB ARNs to the **Resource ARNs** section, and click Next:

{{< img step-3e.png >}}

The readiness rules are applied based on the resource types selected. Take a look at them to see what readiness rules will be in effect. A key part of any readiness check is that data in primary and secondary locations are synced, and also that the configurations match. The pre-configured DynamoDB readiness rules inspect tables in the resource set and ensures that the configurations match across the readiness set. 

You can read more about readiness rules, and their descriptions in the [documentation here](https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.rules-resources.html).

When ready, click Next:

{{< img step-3f.png >}}

4. Next, we’ll associate the resources in the resource set with either the East or West cells. Select the **“Associate with an existing recovery group”** radio button, select the recovery group you created in Step 2 above, and assign each DynamoDB table to the correct cell, **N. Virginia (us-east-1)** with **UnicornAppRecoveryGroup-East**, etc. and then click Next. 

The DynamoDB table ARN contains the region, use this to help you:

{{< img step-3g.png >}}

6. Review your configuration and click Create readiness check when ready:

{{< img step-3h.png >}}

You have now created readiness checks for the DynamoDB tables in our application. Congratulations!

At the next steps, we will create readiness check for the website endpoints. 

{{< prev_next_button link_prev_url="../6.1-recovery-group/" link_next_url="../6.3-readiness-check-websites/" />}}

