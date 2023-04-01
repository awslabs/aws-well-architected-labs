+++
title = "Readiness checks - website"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

Next, we’re going to create readiness checks for the website ALB endpoints in **N. Virginia (us-east-1)** and **N. California (us-west-1)**. These are available in the [Load Balancers section](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#LoadBalancers:) in the primary and secondary regions. 

1. First, we’re going to need to create Route 53 health checks for the website ALB endpoints. The Route 53 Application Recovery Controller will monitor the status of these health checks to determine readiness.

Click [Health Checks](https://us-east-1.console.aws.amazon.com/route53/healthchecks/home#/create) to navigate to the Route 53 health check page. 

Create two health checks for the website endpoints in **N. Virginia (us-east-1)** and **N. California (us-west-1)**, giving them a meaningful name (e.g. `WebsiteEndpointEast` and `WebsiteEndpointWest`). Don’t create an alarm for either of them:

{{< img step-4a.png >}}

For **Domain name** use the Application Load Balancers' (ALB) DNS name from the [Load Balancers section](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#LoadBalancers:).

{{< img alb-1.png >}}

When you have created both health checks, copy down the IDs. We’ll need them to construct the health check ARNs.

{{< img step-4b.png >}}

2. When done, return to the [Application Recovery Controller readiness check page](https://us-west-2.console.aws.amazon.com/route53recovery/home#/readiness/home), and click **Create** and select **Readiness Check** to get started.

{{< img step-5a.png >}}

Give it a name (e.g. `WebsiteEndpointReadinessCheck`) and choose resource type as "Route 53 health check".

{{< img step-5b.png >}}

3. Next, we’ll create a resource set (name it e.g. `WebsiteEndpointResourceSet`) and add the Route 53 health checks ARNs. You’ll need to construct the ARNs as per [this reference](https://docs.aws.amazon.com/r53recovery/latest/dg/recovery-readiness.resource-types-arns.html).

{{% notice note %}}

A Route 53 health check **ARN** format is: **arn:aws:route53:::healthcheck/YOUR_HEALTH_CHECK_ID**

{{% /notice %}}

{{% notice warning %}}

IMPORTANT: Please make sure that there are no space symbols at the end of your health check id left when copied via a clipboard. If an invisible space left, it's not detected as an invalid resource name, but the readines  check will remain in the "Unknown" state. If this does happen, return to your resource set and delete the extra spaces or other invisible characters. 

{{% /notice %}}

Construct the ARNs with the health check IDs that you created in Step 3 above, substituting the IDs from your health checks for **YOUR_HEALTH_CHECK_ID**:

{{< img step-5c.png >}}

4. Then, ensure you associate the Route 53 health checks in each region with the correct cells, and create the readiness check:

{{< img step-5d.png >}}

Click **Next** to complete the creation of the readiness check. 

5. You now have a set of readiness checks. You can view the health and readiness status of each recovery group, and then drill down into the status of each cell as well:

{{< img step-6a.png >}}

Ensure that you can see the Route 53 website endpoint readiness check and the DynamoDB readiness check in each cell. If you can’t see them, double check your actions from Step 3 or Step 4 above, as you may have missed assigning a resource to a cell:

{{< img step-6b.png >}}

{{% notice warning %}}
It may take up to 5 mins for the readiness checks status to become **Ready**. If it takes any longer, return to your resource set and check if there are any extra spaces or other invisible characters in the resource names and delete those. 
{{% /notice %}}

(If you don’t see the resources, you can navigate to the Resource sets by clicking [Route 53 ARC resource sets](https://us-west-2.console.aws.amazon.com/route53recovery/home#/readiness/resource-sets), and then update the **Readiness scope** of the resource sets to assign them to the correct cells.) 

{{< prev_next_button link_prev_url="../6.2-readiness-check-dynamo-db/" link_next_url="../../7-r53arc-routing/" />}}

