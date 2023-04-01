+++
title = "Routing Controls"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

Now that we have a readiness check for the application, we’re going to build the routing controls to manage the traffic to avoid cells that are not ready. To do this we’ll need to create a cluster. A cluster is a highly available set of 5 redundant regional end points hosting your routing controls. All the routing controls for the application will be hosted on one cluster. For disaster recovery, you can use a retry mechanism to cycle through each available regional endpoint to update the routing controls for your application.

1. Click [Route 53 Application Recovery Controller](https://us-west-2.console.aws.amazon.com/route53recovery/home#/recovery-control/clusters) to navigate to the Amazon Route 53 Recovery Controller cluster console.

Get started by creating a cluster, and giving it a meaningful name (e.g. `UnicornCluster`), and accept the **"Confirm pricing changes"**, then click **Create cluster**:

{{< img step-1a.png >}}

Once created, you can see the 5 regional API endpoints (see the image below). In a DR scenario, you would use the [Routing Control API](https://docs.aws.amazon.com/routing-control/latest/APIReference/API_Operations.html), rather than the console, and ensure that your recovery logic retries all available endpoints. You also should ensure that your actions are restricted to the Route 53 Application Recovery data plane only. 

Read more about [Control planes and data planes in the documentation](https://docs.aws.amazon.com/whitepapers/latest/aws-fault-isolation-boundaries/control-planes-and-data-planes.html) and this blog: [Building highly resilient applications using Amazon Route 53 Application Recovery Controller](https://aws.amazon.com/blogs/networking-and-content-delivery/building-highly-resilient-applications-using-amazon-route-53-application-recovery-controller-part-1-single-region-stack/)

{{< img step-1b.png >}}

2. Having created a cluster, we now need to create the routing controls for the cluster. We’re going to set up a total of 4 routing controls. These will relate to entries in the Route 53 hosted zone that we’ll create later. We will set up routing control for a maintenance page, another for our unicorn shop application, and then a routing control for each of our cells in **N. Virginia (us-east-1)** and **N. California (us-west-1)**.

This will allow us to easily configure how traffic flows, either to our application or to a maintenance page, and then within the application, whether we’re routing traffic to both cells or diverting traffic away from a cell that’s not ready.

Using routing controls means we won’t be updating DNS records directly, which reduces the propensity for error, and ensures we’re using data plane rather than control plane functionality in a DR scenario.

Navigate to the DefaultControlPanel in your cluster, and click Add routing control:

{{< img step-2a.png >}}

Create 4 routing controls, with meaningful names (e.g. `Maintenance`, `Application`, `CellEast`, and `CellWest`), adding them to the existing control panel:

{{< img step-2b.png >}}

You should have 4 routing controls deployed before proceeding:

{{< img step-2c.png >}}

Route 53 Application Recovery Controller routes traffic using routing control health checks. For each routing control, create a health check by clicking on each routing control and clicking **Create health check**:

{{< img step-2d.png >}}

And then, give each a meaningful name (e.g. `MaintenanceRoutingControl`, `ApplicationRoutingControl`, `CellEastRoutingControl`, and `CellWestRoutingControl`). Leave the **Invert health check** tickbox un-checked, and click **Create**:

{{< img step-2e.png >}}

Repeat the process for all remaining routing controls.

If you click the Route 53 Health checks page in the navigation pane, you’ll see the states of these health checks. The ones we have just created will be in the Unhealthy state, as they have not been enabled:

{{< img step-2f.png >}}

3. Now, return to the cluster DefaultControlPanel, and we’ll create some safety rules. 

When you work with several routing controls at the same time, you might want some safeguards in place when you enable and disable them. These help you to avoid initiating a failover when a replica is not ready, or unintended consequences like turning both routing controls off and stopping all traffic flow. 

To create these safeguards, you create safety rules. For more information about safety rules, including usage examples, take a look at the documentation for [Creating safety rules in Route 53 ARC](https://docs.aws.amazon.com/r53recovery/latest/dg/routing-control.safety-rules.html).

For our application, we’re going to set up two simple safety rules. For the first, we’re going to assert that the **ApplicationRoutingControl** or the **MaintenanceRoutingControl** is active. This will ensure that we don’t inadvertently turn both off, leaving no route for our traffic. 

Secondly, we’re going to assert that at least one of the **MaintenanceRoutingControl**, the **CellEastRoutingControl**, or the **CellWestRoutingControl** are active. This means that there will always be an endpoint active to receive the traffic. 

*(You will have noticed that this is not an exhaustive set of controls, because we have no assertion that the **CellEastRoutingControl** or **CellWestRoutingControl** is active when the **ApplicationRoutingControl** is active. You can extend the safety rules to cover these scenarios as a further exercise.)*

In the **Safety rules** section of the **DefaultControlPanel**, click **Add safety rule**:

{{< img step-3a.png >}}

Click the **Assertion rule** radio button. An assertion rule enforces the criteria you set, or else does not allow the routing control states to be changed. A typical use for this type of rule is to prevent a fail-open scenario, which is what we’ll be configuring. 

The first safety rule we will create asserts that either the **Maintenance** routing control or the **Application** routing control must be enabled. This is the first part of the fail-open prevention, ensuring that users will either be routed to the unicorn shop application, or otherwise the maintenance page, preventing both controls from being disabled at the same time.

Give your routing control a meaningful name (e.g. `MaintenanceORApplication`), leave the **Wait period** at the default to prevent overly frequent state changes. Then, in the **Routing control configuration section**, select the **Maintenance** and **Application** routing controls. This sets the scope our safety rule to just these two routing controls:

{{< img step-3b.png >}}

Next, we’re going to configure the rule itself. In the **Rule configuration** section, click the **Type** pulldown and select **Or**. Enter **1** in the **Threshold** field, and click **Create**: 

{{< img step-3c.png >}}

Then, we’re going to create a second safety rule to ensure that at least one endpoint is enabled. This will supplement the safety rule above to prevent a fail-open scenario where the **East** or **West** cells are offline as well as the **Maintenance** routing control. 

We’ll create another assertion safety rule, but this time we’ll configure the rule as an **At least** assertion for the three endpoint controls. Go ahead and create another safety rule, ensure the **Assertion rule** radio button is selected, give it a meaningful name (e.g. `AtLeastOneEndpoint`), and select the **Maintenance**, **CellEast** and **CellWest** routing controls. Select the **At least** option in the **Type** pulldown for the **Rule configuration**, and set the **Threshold** to **1**, and click **Create**:

{{< img step-3d.png >}}

You should now have 4 routing controls and 2 safety rules set up for the **DefaultControlPanel**. The routing control state for all routing controls will be **Off**, which is a violation of the safety rule assertions. However, safety rules are evaluated on the future state of the routing controls when you attempt to update them.

{{< prev_next_button link_prev_url="../6-r53arc-readiness/6.3-readiness-check-websites/" link_next_url="../8-r53-zone/" />}}

