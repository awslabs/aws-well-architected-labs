+++
title = "Create Hosted Zone"
date =  2021-05-11T11:43:28-04:00
weight = 8
+++

Having configured the safety rules and routing controls, we’re going to tie it all together with a Route 53 private hosted zone. We’re using a private hosted zone for this lab to avoid provisioning a public domain name, however the steps for setting up a public hosted zone for Route 53 are similar, but do check the [Route53 Developer Guide documentation](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html). There are specific considerations you need to take into account when working with public hosted zones and private hosted zones on Route 53, and you can learn more about them in the documentation for [Working with hosted zones](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/hosted-zones-working-with.html).

1. To get started, we’re going to set up a Route53 private hosted zone for our unicorn shop page application. This hosted zone will resolve DNS names for the unicorn shop VPCs, and allow us to see the Route 53 Application Recovery Controller functionality in action. As this is a private hosted zone, it won’t be accessible from the internet.

First, click [Route 53 Hosted zones](https://us-east-1.console.aws.amazon.com/route53/v2/hostedzones?region=us-east-1#) to 
Click “Create hosted zone” to get started:

{{< img step-1a.png >}}

Next, give your private hosted zone a name (e.g. `unicorns.magic` because unicorns are, of course, magical), add an optional description, and ensure that for **Type**, you select the **Private hosted zone** radio button:

{{< img step-1b.png >}}

Then, we’ll need to associate our private hosted zone with the unicorn VPCs in **N. Virginia (us-east-1)** and **N. California (us-west-1)**. First select the **N. Virginia (us-east-1)** region in the **Region** pulldown, and select the VPC labelled **hot-primary** (the lab VPCs have been configured to enable DNS hostnames and DNS support already):

{{< img step-1c.png >}}

Then, click **Add VPC**, and select the **hot-secondary** VPC in **N. California (us-west-1)**, and click **Create hosted zone** to complete:

{{< img step-1d.png >}}

2. Next, we’re going to start adding zone records. We’re going to do this in two stages. First, we’re going to create a set of failover records for the application. We’re going to associate these with the health checks that we created for each of our routing controls. In this way, the DNS behaviour can be updated through the routing controls, instead of updating DNS records directly.

Click Create record to get started:


{{< img step-2a.png >}}

We’ll start by creating the primary record for the application. Give the record the name `application` and:
* Select **Record type** of **“A- Routes traffic to an IPV4 address and some AWS resources”** from the pulldown. 
* Click the toggle to select **Alias**
* Under **“Route traffic to”**, select **“Alias to Application and Classic Load Balancer”**. 
* Select **N. Virginia (us-east-1)** as the region. 
* Select the ALB from the next pulldown, which should begin with **“dualstack.PrimaryALB-”**.
* For **Routing policy**, select **Failover**
* For **Failover record type**, select **Primary**. 
* Next, you’ll select the **Health check ID**. This will be the health check we created the **CellEast** routing control. Select **CellEastRoutingControl** and ensure **Evaluate target health** is set to **Yes**. 
* Give your record a meaningful ID, such as `us-east-1-ALB`. 

Now let's add another record for the secondary endpoint - click **“Add another record”**:

{{< img step-2b.png >}}

We’ll now repeat the process to set up the entry for the ALB in **N. California (us-west-1)**. For the second record, use the same record name, `application`, for the subdomain. The following steps will be similar to what we did for the previous record:
* Select **Record type** of **“A- Routes traffic to an IPV4 address and some AWS resources”** from the pulldown. 
* Click the toggle to select **Alias**
* Under **“Route traffic to”**, select **“Alias to Application and Classic Load Balancer”**. 
* Select **N. California (us-west-1)** as the region this time. 
* Select the ALB from the next pulldown, which should begin with **“dualstack.SecondaryALB-”**.
* For **Routing policy**, select **Failover**
* For **Failover record type**, select **Secondary**. 
* Next, you’ll select the **Health check ID**. This will be the health check we created the **CellWest** routing control. Select **CellWestRoutingControl** and ensure **Evaluate target health** is set to **Yes**. 
* Give your record a meaningful ID, such as `us-west-1-ALB` and click **Create records**. 

{{< img step-2c.png >}}

Once complete, you should see the two new zone records for **application.unicorns.magic** in the Route 53 private hosted zone. This record aggregates the application entry points, represented by the Application Load Balancers in each region, and we will be able to route traffic to our **East** and **West** cells, or both, using our routing controls:

{{< img step-2d.png >}}

3. Now, having set up the zone records for the application, we’re going to set up the application “front-door”. In the event that the application is not healthy, and we don’t want to route traffic to it at all, we’ll need to set up some sort of maintenance site so that our traffic is handled, and we don’t “fail-open”. To represent this, we’re going to create another set of records that will route traffic to the application endpoint at **application.unicorns.magic**, and our simulated maintenance page. We’ll use **www.example.com** to simulate our maintenance page. 

We’re going to call our “front-door” domain name **shop.unicorns.magic**. We’ll create the maintenance record first. Create a hosted zone record with `shop` as the subdomain name:
* Select record type CNAME.
* Enter `www.example.com` into the **Value** section 
* Leave **Alias** de-selected.
* Set the **TTL** to **60**
* Set **Routing policy** to **Failover**, and **Failover record type** to **Secondary**. 
* Then select the **MaintenanceRoutingControl** Health check ID
* Set the **Record ID** to `Maintenance`.

Please note, Route 53 requires that records in a zone with the same subdomain are of the same type. This will cause two DNS queries from a client, so for a production deployment, you may wish to route your traffic to an AWS Alias or A record, or a AAAA IP address record, instead. The CNAME is used for this example for illustrative purposes.

Once complete, click **Add another record**:

{{< img step-3a.png >}}

Then, configure another `shop` subdomain for the application endpoint:
* Select record type CNAME.
* Enter `application.unicorns.magic` into the **Value** section.
* Leave **Alias** de-selected.
* Set the **TTL** to **60**
* Set **Routing policy** to **Failover** and  **Failover record type** to **Primary**
* Set the **Health Check ID** to **ApplicationRoutingControl**
* Set the **Record ID** to `Application`.

Again, please note that for production purposes, using a CNAME record like this will result in two DNS queries for the client. For more information on how Route 53 is configured to return records in the same hosted zone, please see the [Route 53 documentation here](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-values-alias-common.html#rrsets-values-alias-common-target).

Once complete, click **Create records**:

{{< img step-3b.png >}}

You now should have all the Route 53 private hosted zone records configured, and can move on and activate the routing for the application:

{{< img step-3c.png >}}


{{< prev_next_button link_prev_url="../7-r53arc-routing/" link_next_url="../9-r53-using/" />}}

