---
title: "Fail open when appropriate"
menutitle: "Fail open"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

### 4.1 Disable RecommendationService again

1. Confirm the service is healthy
      * Refresh the web service multiple times and note that personalized recommendations are being served from all three servers
1. You will now simulate another complete failure of the **RecommendationService**. Every request will fail for every request on every server
      * Return to the **AWS Systems Manager** > **Parameter Store** on the AWS Management Console
      * Set the value of **RecommendationServiceEnabled** once again to **false** and **Save changes**

What is the expected behavior? The previous time you simulated a complete failure of the **RecommendationService**

* The web service failed with a http 502 error
* Then you implemented error handling and the following were observed
    * The service returned a static response (as per the error handling code)
    * Since the healthcheck code at that time was configured to only return http 200, it reported _healthy_ status for all servers

Now, with the new deep health check in place...

* What status do you expect the elastic load balancer to report for the servers?
* How will the AWS Elastic Load Balancer handle traffic routing to the servers?

### 4.2 Observe fail-open behavior

1. Refresh the web service multiple times
      * Look at which servers (and Availability Zones) are serving requests
      * Note that the service does not fail
      * But as expected (without access to **RecommendationServiceEnabled**) it always serves static responses
1. Refresh the health check URL multiple times
      * The deep health detects that **RecommendationServiceEnabled** is not available and returns a failure code for all servers
1. From the **Target Groups** console **Targets** tab note the health check status of all the servers (you may need ot refresh)
      * They all report _unhealthy_ with http code 503. This is the code the deep health check is configured to return when the dependency is not available
      * Note the message at the top of the tab (if you do not see a message, try refreshing the entire page using the _browser_ refresh function)

          ![AllUnhealthy503](/Reliability/300_Health_Checks_and_Dependencies/Images/AllUnhealthy503.png)

          |The Amazon Builders' Library: Implementing health checks|
          |:---:|
          |When an individual server fails a health check, the load balancer stops sending it traffic. But when all servers fail health checks at the same time, the load balancer fails open, allowing traffic to all servers.|
          |When we rely on fail-open behavior, we make sure to test the failure modes of the dependency heath check.|

      A system set to _fail-open_ does not shut down when failure conditions are present. Instead, the system remains “open” and operations continue. The AWS Application Load Balancer here exhibits this fail-open behavior and the service continues to serve requests sent to it by the load balancer.

* Reset the value of **RecommendationServiceEnabled**  to **true** and observe that the service resumes serving personalized recommendations.
    * The **RecommendationServiceEnabled** parameter was initially intended  to  simulate the failure of **RecommendationService** for this lab
    * But now that we have implemented _fail-open_ behavior and _graceful degradation_ we could use the **RecommendationServiceEnabled** parameter as an _emergency lever_ to cuto-off traffic to **RecommendationService** if there was a serious problem with it.
---


|Well-Architected for Reliability: Best practice|
|:---:|
|**Implement emergency levers**: These are rapid processes that may mitigate availability impact on your workload. They can be operated in the absence of a root cause. An ideal emergency lever reduces the cognitive burden on the resolvers to zero by providing fully deterministic activation and deactivation criteria. Example levers include blocking all robot traffic or serving a static response. Levers are often manual, but they can also be automated.|
