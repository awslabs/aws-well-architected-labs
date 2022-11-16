+++
title = "Routing Controls"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

Now that we have a readiness check for the application, we’re going to build the routing controls to manage the traffic to avoid cells that are not ready. To do this we’ll need to create a cluster. A cluster is a highly available set of 5 redundant regional end points hosting your routing controls. All the routing controls for the application will be hosted on one cluster. For disaster recovery, you can use a retry mechanism to cycle through each available regional endpoint to update the routing controls for your application.

1. Click [Route 53 Application Recovery Controller](https://us-west-2.console.aws.amazon.com/route53recovery/home#/recovery-control/clusters) to navigate to the Amazon Route 53 Recovery Controller cluster console.

Get started by creating a cluster, and giving it a meaningful name (e.g. `UnicornCluster`):

{{< img step-1a.png >}}
{{< img step-1b.png >}}


{{< img step-2a.png >}}
{{< img step-2b.png >}}
{{< img step-2c.png >}}
{{< img step-2d.png >}}
{{< img step-2e.png >}}
{{< img step-2f.png >}}


{{< img step-3a.png >}}
{{< img step-3b.png >}}
{{< img step-3c.png >}}
{{< img step-3d.png >}}



{{< prev_next_button link_prev_url="../6-r53arc-readiness/" link_next_url="../8-r53-zone/" />}}

