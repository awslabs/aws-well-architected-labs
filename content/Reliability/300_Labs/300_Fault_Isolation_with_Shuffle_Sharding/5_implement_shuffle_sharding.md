---
title: "Implement shuffle sharding"
menutitle: "Implement shuffle sharding"
date: 2020-12-07T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

In this section you will update the architectural design of the workload and implement shuffle sharding. Shuffle sharding is a combinatorial implementation of a sharded architecture. With shuffle sharding you create virtual shards with a subset of the capacity of the workload ensuring that the virtual shards are mapped to a unique subset of customers with no overlap. By minimizing the number of Workers a single customer is able to interact with within the workload, and spreading resources in a combinatorial way, you will be able to further reduce the impact of a potential posion pill.

The following diagram shows the updated architecture you will deploy. This architecture implements _shuffle sharding_ (**Note: There are still only eight workers. Workers are shown logically twice, once for each shard they participate in**):
![ArchitectureShuffleSharding](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/Architecture-shuffle-sharding.png?classes=lab_picture_auto)

### Update the workload architecture

1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation> and select the stack that was created as part of this lab - `Shuffle-sharding-lab`
1. Click on **Update**

    ![CFNUpdateStack](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNUpdateStack.png?classes=lab_picture_auto)

1. Under **Prerequisite - Prepare template**, select **Replace current template**

    * For **Template source** select **Amazon S3 URL**
    * In the text box under **Amazon S3 URL** specify `https://aws-well-architected-labs-virginia.s3.amazonaws.com/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/shuffle-sharding.yaml`

    ![CFNReplaceTemplateShuffleSharding](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNReplaceTemplateShuffleSharding.png?classes=lab_picture_auto)

1. Click **Next**
1. No changes are required for **Parameters**. Click **Next**
1. For **Configure stack options** click **Next**
1. On the **Review** page:
    * Scroll to the end of the page and select **I acknowledge that AWS CloudFormation might create IAM resources with custom names.** This ensures CloudFormation has permission to create resources related to IAM. Additional information can be found [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html).

    **Note:** The template creates an IAM role and Instance Profile for EC2. These are the minimum permissions necessary for the instances to be managed by AWS Systems Manager. These permissions can be reviewed in the CloudFormation template under the "Resources" section - *InstanceRole*.

    * Click **Update stack**

    ![CFNIamCapabilitiesUpdateStack](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNIamCapabilitiesUpdateStack.png?classes=lab_picture_auto)

This will take you to the CloudFormation stack status page, showing the stack update in progress. The stack takes about 1 minute to go through all the updates. Periodically refresh the CloudFormation stack events until you see that the **Stack Status** is in **UPDATE_COMPLETE**.

With this stack update, the architecture of the workload has been updated by introducing **8 Application Load Balancer listener rules and Target Groups**. These listener rules have been configured to inspect the incoming request for the query-string **name**. Depending on the value provided, the request is routed to one of **eight target groups** where each target group consists of 2 EC2 instances.

### Test the shuffle sharded application

Now that the application has been deployed, it is time to test it to understand how it works. The sample application used in this lab is the same as before, a simple web application that returns a message with the Worker that responded to the request. Customers pass in a query string as part of the request to identify themselves. The query string used here is **name**.

1. Visit the **Outputs** section of the CloudFormation stack created in the previous step. You will see a list of URLs next to customer names.

    ![CFNOutputs](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNOutputs.png?classes=lab_picture_auto)

1. Open the link for customer **Alpha** in a new browser tab. Refresh the web browser a few times to see that responses are being returned from different EC2 instances on the back-end.
    * Notice that after implementing shuffle sharding, you are seeing responses being returned from only 2 instances for customer **Alpha**'s requests.
    * No matter how many times you refresh the page or try a different browser, customer **Alpha** will only receive responses from 2 EC2 instances. This is because you have created **Application Load Balancer listener rules** that divert traffic to a specific subset of the overall capacity of the workload, also known as a shard.
    * Each customer has a ***unique combination of EC2 instances that will respond to requests with no 2 customers having the same combination***. The following diagram provides a breakdown of how customers are mapped to EC2 instances.

    ![ShuffleShardedFlow](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/ShuffleShardedFlow.png?classes=lab_picture_auto)

1. Open the links for a few other customers and verify that they are able to get responses from only 2 EC2 instances. The different customers are - **Alpha**, **Bravo**, **Charlie**, **Delta**, **Echo**, **Foxtrot**, **Golf**, and **Hotel** and their corresponding URLs can be obtained from the CloudFormation stack Outputs.

1. Refresh the web browser multiple times to verify that customers are receiving responses only from EC2 instances in the shard they are mapped to. **The customer to shard/workers mapping can be found in the table below.**

    | **Customer Name** | **Workers**         |
    |-------------------|-------------------|
    | Alpha             | Worker-1 and Worker-2 |
    | Bravo             | Worker-2 and Worker-3 |
    | Charlie           | Worker-3 and Worker-4 |
    | Delta             | Worker-4 and Worker-5 |
    | Echo              | Worker-5 and Worker-6 |
    | Foxtrot           | Worker-6 and Worker-7 |
    | Golf              | Worker-7 and Worker-8 |
    | Hotel             | Worker-8 and Worker-1 |

{{< prev_next_button link_prev_url="../4_impact_of_failures_sharding" link_next_url="../6_impact_of_failures_shuffle_sharding/" />}}
