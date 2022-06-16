+++
title = "Failover to Secondary"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

When a regional service event affects the Unishop application in the primary region **N. Virginia (us-east-1)**, we want to fail over to the secondary region **N. California (us-west-1)**.

{{% notice note %}}
For production workloads, these steps would be automated as part of your failover process. You may also be using Amazon Route53 or other DNS (Domain Name Services) to handle routing for a fail over event.
{{% /notice %}}

{{< prev_next_button link_prev_url="../verify-websites/" link_next_url="./promote-aurora/" />}}
