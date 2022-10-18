---
title: "Impact of failures with sharding"
menutitle: "Impact of failures - Sharding"
date: 2020-12-07T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

### Break the application

You will now introduce the poison pill into the workload by including the **bug** query-string with your requests and see how the updated workload architecture handles it. As in the previous case, imagine that customer **Alpha** triggered the bug in the application again.

1. Include the query-string **bug** with a value of **true** and make a request as customer **Alpha**. The modified URL should look like this - http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Alpha&bug=true (but using your own URL from the CloudFormation stack Outputs)
1. This should result in an Internal Server Error response on the browser indicating that the application has stopped working as expected on the instance that processed this request

    ![PoisonPill](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/PoisonPill.png?classes=lab_picture_auto)

1. At this point, there is one healthy instance still available on the shard so other customers mapped to that shard are not impacted. You can verify this by opening another browser tab and using the URL for customer **Bravo** and **without the bug query string**.

1. Just like before, customer **Alpha**, not aware of this bug in the application, will retry the request.
    * Refresh the page to simulate this as you did before.
    * This request is routed to the other healthy instance in the shard.
    * The bug is triggered again and the other instance goes down as well.
    * The entire shard is now affected.
1. All requests to this shard will now fail because there are no healthy instances in the shard. You can verify this by sending requests for customers **Alpha** or **Bravo**. No matter how many times the page is refreshed, you will see a 502 Bad Gateway.

    ![502BadGateway](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/502BadGateway.png?classes=lab_picture_auto)

1. Since customers can only make requests to the shard they are assigned to, customers **Charlie**, **Delta**, **Echo**, **Foxtrot**, **Golf**, and **Hotel** are not affected by customer **Alpha**’s actions.
    * Verify this by making requests using the URLs for these customers (obtained from the CloudFormation stack Outputs).

1. The impact is localized to a specific shard, **shard 1** in this case, and only customers **Alpha** and **Bravo** are affected. The scope of impact has now been reduced so that only **25%** of customers are affected by the failure induced by the poison pill.

    ![ShardedFlowBrokenShard](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/ShardedFlowBrokenShard.png?classes=lab_picture_auto)

    In a sharded system, the scope of impact of failures can be calculated using the following formula:

    ![ScopeSharding](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/ScopeSharding.png?classes=lab_picture_auto)

    For example if there were 100 customers, and the workload was divided into 10 shards, then the failure of any 1 shard will only impact 10% of customers.

> **With this sharded architecture, the scope of impact is reduced by the number of shards. Here with four shards, if a customer experiences a problem, then the shard hosting them might be impacted, as well as all of the other customers on that shard. However, that shard represents only one fourth of the overall service. Since this is just a lab we kept it simple with only four shards, but with more shards, the scope of impact decreases further. Adding more shards requires adding more capacity (more workers). But in the next steps of this lab you will learn how with shuffle sharding, we can do exponentially better without adding extra capacity.**

### Verify workload availability

You can look at the **AvailabilityDashboard** to see the impact of the failure introduced by customer **Alpha** across all customers.

1. Switch to the tab that the **AvailabilityDashboard** opened. (You can also retrieve the URL from the CloudFormation stack Outputs).

1. You can see that the introduction of the poison-pill and subsequent retries by customer **Alpha** has only impacted customer **Bravo** as the canaries for these two customers are unable to make successful requests to the workload.
    * Notice that the impact is localized to a specific shard and the other customers are not impacted by this.
    * With sharding, only **25%** of customers are impacted.
    * **NOTE:** You might have to wait a few minutes for the dashboard to get updated.

  ![ImpactDashboardSharded](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/ImpactDashboardSharded.png?classes=lab_picture_auto)

### Fix the application

As in the previous section, Systems Manager will be used to fix the application and return functionality to the users that are affected - **Alpha** and **Bravo**. The Systems Manager Document restarts the application on the selected instances.

1. Go to the Outputs section of the CloudFormation stack and open the link for “SSMDocument”. This will take you to the Systems Manager console.

    ![CFNOutputsSSM](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNOutputsSSM.png?classes=lab_picture_auto)

1. Click on Run command which will open a new tab on the browser

    ![SSMRunCommand](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/SSMRunCommand.png?classes=lab_picture_auto)

1. Scroll down to the **Targets** section and select **Specify instance tags**
1. Enter `Workload` for the tag key and `WALab-shuffle-sharding` for the tag value. Click **Add**.

    ![RegularSSMSelectInstances](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/RegularSSMSelectInstances.png?classes=lab_picture_auto)

1. Scroll down to the **Output options** section and uncheck the box next to **Enable an S3 bucket**. This will prevent Systems Manager from writing log files based on the command execution to S3.
1. Click on **Run**

    ![SSMUncheckS3andRun](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/SSMUncheckS3andRun.png?classes=lab_picture_auto)

1. You should see the command execution succeed in a few seconds

    ![SSMSuccess](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/SSMSuccess.png?classes=lab_picture_auto)

1. Once the command has finished execution, you can go back to the application and test it to verify it is working as expected.
    * Use the URL for customer **Alpha** (obtained from the CloudFormation stack Outputs) and make sure that the query-string **bug** is **not included** in the request.
    * Refresh the page a few times to make sure responses are being received from 2 different EC2 instances.
    * Repeat this process for the other customer that was affected - **Bravo**.

1. Review the **AvailabilityDashboard** to make sure canary requests are succeeding and normal functionality has returned to customers **Alpha** and **Bravo**. You should see that **SuccessPercent** has returned to **100** for both customers.
    * **NOTE:** You might have to wait a few minutes for the dashboard to get updated.

    ![FixedDashboardSharded](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/FixedDashboardSharded.png?classes=lab_picture_auto)

{{< prev_next_button link_prev_url="../3_implement_sharding" link_next_url="../5_implement_shuffle_sharding/" />}}
