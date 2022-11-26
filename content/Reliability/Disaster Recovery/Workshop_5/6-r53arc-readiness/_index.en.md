+++
title = "Readiness Checks"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

Click [Route 53 Application Recovery Controller](https://us-west-2.console.aws.amazon.com/route53recovery/home#/dashboard) to navigate to the Amazon Route 53 Recovery Controller console.

We’re going to build a readiness check for our application. We have two running stacks, our hot primary in **N. Virginia (us-east-1)** and the hot secondary in **N. California (us-west-1)**.  We’re going to set up a **Recovery Group** composed of **cells** to represent the readiness of the application components across our regions. This will allow us to check the readiness of the application for failover.

Our application is relatively simple. We’ll be representing it with two cells, once in **N. Virginia (us-east-1)** and one in **N. California (us-west-1)**. It is possible to nest cells for more complex applications, as is visible in the diagram. Read through the Readiness check section, and then click **“create recovery group”** to proceed:

{{< img intro.png >}}

1. First, we're going to create a **Recovery Group** for our application. Click [Create Recovery Group](https://us-west-2.console.aws.amazon.com/route53recovery/home#/readiness/create-recovery-group) to navigate to the Amazon Route 53 Recovery Group console.  

And then give your recovery group a meaningful name (e.g. `UnicornAppRecoveryGroup`) and click Next:

{{< img step-1.png >}}

2. Now, we’re going to create the cells in our recovery group, representing the two regions where the application is deployed.

Select the **“Create cells”** radio button, and click **Add cell**:

{{< img step-2a.png >}}

Now, add two cells, the prefix may have been filled in for you, and given them meaningful names (e.g. `UnicornAppRecoveryGroup-East` and `UnicornAppRecoveryGroup-West`), and click Next to continue:

{{< img step-2b.png >}}

Review the recovery group with our two cells, and click **Create recovery group**:

{{< img step-2c.png >}}

3. Now we need to create readiness checks for our cells. Click **“Create a new readiness check”** to start:

{{< img step-3a.png >}}

For our application, we’re going to set up readiness checks for the DynamoDB tables, and the S3 website endpoints. These are two example resources that our sample application will be monitored on. We’ll start with a readiness check for DynamoDB. Give your readiness check a meaningful name (e.g. `DynamoDBReadinessCheck`), select **“DynamoDB table”** from the **Resource type pulldown**, and click Next:

{{< img step-3b.png >}}

Next we need to create a **Resource set** which contains the DynamoDB tables that the we’re monitoring. Select the **“Create a new resource set”** radio button, and give your resource set a meaningful name (e.g. `DynamoDBResourceSet`):

{{< img step-3c.png >}}

Open another browser another tab, and navigate to the DynamoDB console in **N. Virginia (us-east-1)** and **N. California (us-west-1)**. Select the **“unishophotstandby”** table in each region, and copy down the **ARN** of each table. You'll find the **ARN** in the **“Overview”** tab for your table, and click **“Additional info”** to expand the **“General information”** section:

{{< img step-3d.png >}}

Return to your Route 53 ARC browser tab, and add both DynamoDB ARNs to the **Resource ARNs** section, and click Next:

{{< img step-3e.png >}}

The readiness rules are applied based on the resource types selected. Take a look at them to see what readiness rules will be in effect. A key part of any readiness check is that data in primary and secondary locations is synced, and also the configuration match. The pre-configured DynamoDB readiness rules inspect tables in the resource set and ensures that the configurations match across the readiness set. 

You can read more about readiness rules, and their descriptions in the [documentation here](https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.rules-resources.html).

When ready, click Next:

{{< img step-3f.png >}}

Next, we’ll associate the resources in the resource set with either the East or West cells. Select the **“Associate with an existing recovery group”** radio button, select the recovery group you created in Step 2 above, and assign each DynamoDB table to the correct cell, **N. Virginia (us-east-1)** with **UnicornAppRecoveryGroup-East**, etc. and then click Next. 

The DynamoDB table ARN contains the region, use this to help you:

{{< img step-3g.png >}}

Review your configuration and click Create readiness check when ready:

{{< img step-3h.png >}}

You have now created readiness checks for the DynamoDB tables in our application. Congratulations!

4. Next, we’re going to create readiness checks for the S3 website endpoints in **N. Virginia (us-east-1)** and **N. California (us-west-1)**. These are available in the CloudFormation Outputs section for the stack that you deployed in the primary and secondary regions. 

First, we’re going to need to create Route 53 health checks for the S3 website endpoints. The Route 53 Application Recovery Controller will monitor the status of these health checks to determine readiness.

Click [Health Checks](https://us-east-1.console.aws.amazon.com/route53/healthchecks/home#/create) to navigate to the Route 53 health check page. 

Create two health checks for the S3 website endpoints in **N. Virginia (us-east-1)** and **N. California (us-west-1)**, giving them a meaningful name (e.g. `S3WebsiteEndpointEast` and `S3WebsiteEndpointWest`). Don’t create an alarm for either of them:

{{< img step-4a.png >}}

When you have created both health checks, copy down the IDs. We’ll need them to construct the health check ARNs.

{{< img step-4b.png >}}

5. When done, return to the Application Recovery Controller readiness check page, and click **Create** and select **Readiness Check** to get started.

{{< img step-5a.png >}}

Continue as per Step 3 above to create a Route 53 health check readiness check for the S3 website endpoints. 

{{< img step-5b.png >}}

Next, we’ll create a resource set and add the health checks. You’ll need to construct the ARNs as per [this reference](https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.resource-types-arns.html).

A Route 53 health check is formatted as:
**ARN format:** arn::route53:::healthcheck/YOUR_HEALTH_CHECK_ID

Construct the ARNs with the health check IDs that you created in Step 4 above, substituting the IDs from your health checks for **YOUR_HEALTH_CHECK_ID** :


{{< img step-5c.png >}}

Then, ensure you associate the Route 53 health checks in each region with the correct cells, and create the readiness check:

{{< img step-5d.png >}}

6. You now have a set of readiness checks. You can view the health and readiness status of each recovery group, and then drill down into the status of each cell as well:

{{< img step-6a.png >}}

Ensure that you can see the Route 53 S3 website endpoint readiness check and the DynamoDB readiness check in each cell. If you can’t see them, double check your actions from Step 3 or Step 4 above, as you may have missed assigning a resource to a cell:

{{< img step-6b.png >}}

(If you don’t see the resources, you can navigate to the Resource sets by clicking [here](https://us-west-2.console.aws.amazon.com/route53recovery/home#/readiness/resource-sets), and then update the **Readiness scope** of the resource sets to assign them to the correct cells.) 



{{< prev_next_button link_prev_url="../5-alb/" link_next_url="../7-r53arc-routing/" />}}

