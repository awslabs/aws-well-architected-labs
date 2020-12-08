---
title: "Impact of failures with sharding"
menutitle: "Impact of failures - Sharding"
date: 2020-12-07T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

### Break the application

We will now introduce the poison pill into the workload by including the **bug** query-string with our requests and see how the updated the workload architectures handles it. As in our previous case, imagine that customer Alpha triggered the bug in the application again.

1. Include the query-string **bug** with a value of **true** and make a request as customer Alpha. The modified URL should look like this - http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Alpha&bug=true
1. This should result in an Internal Server Error response on the browser indicating that the application has stopped working as expected on the instance that processed this request

    ![PoisonPill](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/PoisonPill.png?classes=lab_picture_small)

1. At this point, there is one healthy instance still available on the shard so other customers mapped to that shard are not impacted. You can verify this by opening another browser tab and specifying the URL with customer name Bravo or Charlie and without the **bug** query string such as:

    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Bravo
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Charlie

1. Just like before, customer Alpha, not aware of this bug in the application, will retry the request. Refresh the page to simulate this as you did before. This request is routed to the other healthy instance in the shard. The bug is triggered again and the other instance goes down as well. The entire shard is now affected.
1. All requests to this shard will now fail because there are no healthy instances in the shard. You can verify this by sending requests for customers Alpha, Bravo, or Charlie. No matter how many times the page is refreshed, you will see a 502 Bad Gateway.

    ![502BadGateway](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/502BadGateway.png?classes=lab_picture_small)

1. Since customers can only make requests to the shard they are assigned to, customers Delta, Echo, and Foxtrot are not affected by customer Alpha’s actions. You can verify this by making the following requests:
    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Delta
    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Echo
    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Foxtrot

1. The impact is localized to a specific shard, shard 1 in this case, and only customers Alpha, Bravo, and Charlie are affected. The scope of impact has now been reduced so that only 50% of customers are affected by the failure induced by the poison pill.

    ![ShardedFlowBrokenShard](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/ShardedFlowBrokenShard.png?classes=lab_picture_small)

> **With this sharded architecture, the scope of impact is reduced by the number of shards. Here with two shards, if a customer experiences a problem, then the shard hosting them might be impacted, as well as all of the other customers on that shard. However, that shard represents only one half of the overall service. Since this is just a lab we kept it simple with only two shards, but with more shards, the scope of impact decreases further. Adding more shards requires adding more capacity (more workers). But in the next steps of this lab you will learn how with shuffle sharding, we can do exponentially better again without adding capacity.**

### Fix the application

As in the previous section, Systems Manager will be used to fix the application and return functionality to the users that are affected - Alpha, Bravo, and Charlie.

1. Go to the Outputs section of the CloudFormation stack and open the link for “SSMDocument”. This will take you to the Systems Manager console.

    ![CFNOutputsSSM](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNOutputsSSM.png?classes=lab_picture_small)

1. Click on Run command which will open a new tab on the browser

    ![SSMRunCommand](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/SSMRunCommand.png?classes=lab_picture_small)

1. Scroll down to the **Targets** section and select **Choose instances manually**
1. Check the box next to the EC2 instances with the names **Worker-1** and **Worker-2**.

    ![SSMNode1andNode2](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/SSMWorker1andWorker2.png?classes=lab_picture_small)

1. Scroll down to the **Output options** section and uncheck the box next to **Enable an S3 bucket**. This will prevent Systems Manager from writing log files based on the command execution to S3.
1. Click on **Run**

    ![SSMUncheckS3andRun](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/SSMUncheckS3andRun.png?classes=lab_picture_small)

1. You should see the command execution succeed in a few seconds

    ![SSMSuccessNode1andNode2](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/SSMSuccessWorker1andWorker2.png?classes=lab_picture_small)

1. Once the command has finished execution, you can go back to the application and test it to verify it is working as expected. Make sure that the query-string **bug** is not included in the request. For example, http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Alpha should return a valid response. Refresh the page a few times to make sure responses are being received from 2 different EC2 instances. Repeat this process for the other customers that were affected - Bravo and Charlie.

{{< prev_next_button link_prev_url="../3_implement_sharding" link_next_url="../5_implement_shuffle_sharding/" />}}
