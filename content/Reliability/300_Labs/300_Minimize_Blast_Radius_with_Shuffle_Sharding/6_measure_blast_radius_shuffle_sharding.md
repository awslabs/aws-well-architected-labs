---
title: "Measure blast radius for workloads with shuffle-sharding"
date: 2020-11-18T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

### Break the application

We will now introduce the poison-pill into the workload by including the **bug** query-string with our requests and see how the updated the workload architectures handles it. As in our previous case, imagine that customer Alpha triggered the bug in the application again.

1. Include the query-string **bug** with a value of **true** and make a request as customer Alpha. The modified URL should look like this - http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Alpha&bug=true
1. This should result in an Internal Server Error response on the browser indicating that the application has stopped working as expected on the instance that processed this request

    ![PoisonPill](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/PoisonPill.png)

1. Just like before, customer Alpha, not aware of this bug in the application, will retry the request. Refresh the page to simulate this as you did before. This request is routed to the other healthy instance in the shard for customer Alpha. The bug is triggered again and the other instance goes down as well. The entire shard is now affected.
1. All requests to this shard will now fail because there are no healthy instances in the shard. No matter how many times the page is refreshed, you will see a 502 Bad Gateway for customer Alpha showing that customer Alpha is experiencing complete downtime. At this point, the overall capacity of the fleet has decresed from 4 EC2 instances to 2 EC2 instances.

    ![502BadGateway](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/502BadGateway.png)

1. Due to shuffle-sharding, all of the remaining customers are unaffected or have limited impact. Send requests as the following customers and refresh each request multiple times. You should notice that all customers will now receive a response, although some customers will only get responses from a single EC2 instance while others get it from 2 different EC2 instances.

    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Bravo
    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Charlie
    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Delta
    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Echo
    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Foxtrot

1. The impact is localized to a specific shard and only customer Alpha is affected. Customers that have a shared EC2 instance with customer Alpha will only have 1 EC2 instance available to respond to requests. While this might lead to some degree of degradation for those customers, it is still an improvement over complete downtime. The blast radius has now been reduced so that only 16.66% of customers are affected by the failure induced by the poison pill. With larger fleet and shard sizes, the number of combinations will increase resulting in customers having different degrees of degradation i.e. some customers will only have a fraction of their overall shard capacity available to them.

    | **Customer Name** | **Nodes**         |
    |-------------------|-------------------|
    | Alpha             | Node-1 and Node-2 |
    | Bravo             | Node-1 and Node-3 |
    | Charlie           | Node-1 and Node-4 |
    | Delta             | Node-2 and Node-3 |
    | Echo              | Node-2 and Node-4 |
    | Foxtrot           | Node-3 and Node-4 |


![ShuffleShardedFlowBrokenNodes](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/ShuffleShardedFlowBrokenNodes.png)

### Fix the application

As in the previous section, Systems Manager will be used to fix the application and return functionality to the users that are affected - Alpha, Bravo, and Charlie.

1. Go to the Outputs section of the CloudFormation stack and open the link for “SSMDocument”. This will take you to the Systems Manager console.

    ![CFNOutputsSSM](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/CFNOutputsSSM.png)

1. Click on Run command which will open a new tab on the browser

    ![SSMRunCommand](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/SSMRunCommand.png)

1. Scroll down to the **Targets** section and select **Choose instances manually**
1. In the list of instances, check the box next to the nodes that were affected. You can identify the nodes that were impacted by looking at the table above and determining the nodes mapped to the customer that introduced the “poison pill”. If you followed instructions in this guide and introduced the poison pill as customer Alpha, check the box next to the EC2 instances with the names **Node-1** and **Node-2**.

    ![SSMNode1andNode2](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/SSMNode1andNode2.png)

1. Scroll down to the **Output options** section and uncheck the box next to **Enable writing to an S3 bucket**. This will prevent Systems Manager from writing log files based on the command execution to S3.
1. Click on **Run**

    ![SSMUncheckS3andRun](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/SSMUncheckS3andRun.png)

1. You should see the command execution succeed in a few seconds

    ![SSMSuccessNode1andNode2](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/SSMSuccessNode1andNode2.png)

1. Once the command has finished execution, you can go back to the application and test it to verify it is working as expected. Make sure that the query-string **bug** is not included in the request. For example, http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Alpha should return a valid response. Refresh the page a few times to make sure responses are being received from 2 different EC2 instances. Repeat this process for the other customers and verify that each customer is getting responses from 2 different EC2 instances.
