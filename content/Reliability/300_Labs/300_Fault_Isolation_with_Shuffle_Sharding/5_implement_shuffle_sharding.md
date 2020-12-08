---
title: "Implement shuffle sharding"
menutitle: "Implement shuffle sharding"
date: 2020-12-07T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

In this section we will update the architectural design of the workload and implement shuffle sharding. Shuffle sharding is a combinatorial implementation of a sharded architecture. With shuffle sharding we create virtual shards with a subset of the capacity of the workload ensuring that the virtual shards are mapped to a unique subset of customers with no overlap. By minimizing the number of Workers a single customer is able to interact with within the workload, and spreading resources in a combinatorial way, we will be able to further reduce the impact of a potential posion pill. In a shuffle sharded system, the scope of impact of failures can be calculated using the following formula:

![ScopeShuffleSharding-1](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/ScopeShuffleSharding-1.png?classes=lab_picture_small)

The formula can be expanded to calculate the number of unique combinations that can exist given the number of workers and the number of workers per shard, also referred to as shard size. The calculation is performed using factorials.

![ScopeShuffleSharding-2](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/ScopeShuffleSharding-2.png?classes=lab_picture_small)

![ScopeShuffleSharding-3](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/ScopeShuffleSharding-3.png?classes=lab_picture_small)

For example if there were 100 workers, and we assign a unique combination of 5 workers to a shard, then the failure of any 1 shard will only impact 0.0000013% of customers.

![ScopeShuffleSharding-4](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/ScopeShuffleSharding-4.png?classes=lab_picture_small)

![ScopeShuffleSharding-5](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/ScopeShuffleSharding-5.png?classes=lab_picture_small)

![ArchitectureShuffleSharding](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/Architecture-shuffle-sharding.png?classes=lab_picture_small)

### Update the workload architecture

1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation> and select the stack that was created as part of this lab - `Shuffle-sharding-lab`
1. Click on **Update**

    ![CFNUpdateStack](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNUpdateStack.png?classes=lab_picture_small)

1. Under **Prerequisite - Prepare template**, select **Replace current template**

    * For **Template source** select **Amazon S3 URL**
    * In the text box under **Amazon S3 URL** specify `https://aws-well-architected-labs-virginia.s3.amazonaws.com/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/shuffle-sharding.yaml`

    ![CFNReplaceTemplateShuffleSharding](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNReplaceTemplateShuffleSharding.png?classes=lab_picture_small)

1. Click **Next**
1. No changes are required for **Parameters**. Click **Next**
1. For **Configure stack options** click **Next**
1. On the **Review** page:
    * Scroll to the end of the page and select **I acknowledge that AWS CloudFormation might create IAM resources with custom names.** This ensures CloudFormation has permission to create resources related to IAM. Additional information can be found [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html).

    **Note:** The template creates an IAM role and Instance Profile for EC2. These are the minimum permissions necessary for the instances to be managed by AWS Systems Manager. These permissions can be reviewed in the CloudFormation template under the "Resources" section - *InstanceRole*.

    * Click **Update stack**

    ![CFNIamCapabilities](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNIamCapabilities.png?classes=lab_picture_small)

This will take you to the CloudFormation stack status page, showing the stack update in progress. The stack takes about 1 minute to go through all the updates. Periodically refresh the page until you see that the **Stack Status** is in **UPDATE_COMPLETE**.

With this stack update, the architecture of the workload has been updated by introducing 6 Application Load Balancer listener rules and Target Groups. These listener rules have been configured to inspect the incoming request for a query-string **name**. Depending on the value provided, the request is routed to one of six target groups where each target group consists of 2 EC2 instances.

### Test the shuffle sharded application

Now that the application has been deployed, it is time to test it to understand how it works. The sample application used in this lab is the same as before, a simple web application that returns a message with the Worker that responded to the request. Customers pass in a query string with the request to identify themselves. The query string used here is **name**.

1. Copy the URL provided in the **Outputs** section of the CloudFormation stack created in the previous string. Append the query string `/?name=Alpha` to the URL and paste it into a web browser. The full string should look similar to this - http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Alpha

    ![CFNOutputs](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNOutputs.png?classes=lab_picture_small)

1. Refresh the web browser a few times to see that responses are being returned from different EC2 instances on the back-end. Notice that after implementing shuffle sharding, you are seeing responses being returned from only 2 instances for customer Alpha's requests. No matter how many times you refresh the page or try a different browser, customer Alpha will only receive responses from 2 EC2 instances. This is because we have created Application Load Balancer listener rules that divert traffic to a specific subset of the overall capacity of the workload, also known as a shard. Each customer has a unique combination of EC2 instances that will respond to requests with no 2 customers having the same combination. The following diagram provides a breakdown of how customers are mapped to EC2 instances.

    ![ShuffleShardedFlow](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/ShuffleShardedFlow.png?classes=lab_picture_small)

1. Update the value for the query string to one of the other customers, the possible values are - Alpha, Bravo, Charlie, Delta, Echo, and Foxtrot

    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Alpha
    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Bravo
    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Charlie
    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Delta
    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Echo
    * http://shuffle-alb-8vonmf2ywl5z-682850122.us-east-1.elb.amazonaws.com/?name=Foxtrot

1. Refresh the web browser multiple times to verify that customers are receiving responses only from EC2 instances in the shard they are mapped to

    | **Customer Name** | **Workers**         |
    |-------------------|-------------------|
    | Alpha             | Worker-1 and Worker-2 |
    | Bravo             | Worker-1 and Worker-3 |
    | Charlie           | Worker-1 and Worker-4 |
    | Delta             | Worker-2 and Worker-3 |
    | Echo              | Worker-2 and Worker-4 |
    | Foxtrot           | Worker-3 and Worker-4 |

{{< prev_next_button link_prev_url="../4_impact_of_failures_sharding" link_next_url="../6_impact_of_failures_shuffle_sharding/" />}}
