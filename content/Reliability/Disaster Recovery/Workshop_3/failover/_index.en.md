+++
title = "Failover to Secondary"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

When a regional service event affects the Unicorn application in the Primary, N. Virginia (us-east-1) region, you want to fail-over to Secondary, N. California (us-west-1) region.

We assume a regional service event has occurred. In this section, we will manually fail over the application to the Secondary region. You can consider using Amazon Route53 or other DNS (Domain Name Services) fail-over routing in a real-world scenario. You can further automate by subscribing to application notifications.

{{< prev_next_button link_prev_url="../verify-websites/" link_next_url="./promote-app/" />}}
