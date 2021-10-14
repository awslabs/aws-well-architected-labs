+++
title = "Failover to Secondary"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

When a regional service event affects the Unicorn application in the primary region **N. Virginia (us-east-1)**, you want to fail-over to the secondary region **N. California (us-west-1)**.

We assume a regional service event has occurred. In this section, we will manually fail over the application to the secondary region, **N. California (us-west-1)**. You can consider using Amazon Route53 or other DNS (Domain Name Services) fail-over routing in a real-world scenario. You can further automate by subscribing to application notifications.

{{< prev_next_button link_prev_url="../verify-websites/" link_next_url="./promote-app/" />}}
