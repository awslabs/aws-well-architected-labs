---
title: "Implement sharding"
menutitle: "Implement sharding"
date: 2020-12-07T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

In this section you will update the architectural design of the workload and implement sharding. Similar to sharding a database where a large database or table is broken up into smaller chunks distributed across multiple servers, you will shard the overall capacity of the workload and segment it so that each shard is responsible for handling a subset of customers. By minimizing the number of "components" a single customer is able to interact with within the workload, we will be able to reduce the impact of a potential posion pill. This will result in a much smaller scope of impact depending on the number of shards within the workload.

The following diagram shows the updated architecture you will deploy. This architecture implements _sharding_ (but not shuffle sharding):
![ArchitectureSharding](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/Architecture-sharding.png?classes=lab_picture_auto)

### Update the workload architecture

1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation> and select the stack that was created as part of this lab - `Shuffle-sharding-lab`
1. Click on **Update**

    ![CFNUpdateStack](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNUpdateStack.png?classes=lab_picture_auto)

1. Under **Prerequisite - Prepare template**, select **Replace current template**

    * For **Template source** select **Amazon S3 URL**
    * In the text box under **Amazon S3 URL** specify `https://aws-well-architected-labs-virginia.s3.amazonaws.com/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/sharding.yaml`

    ![CFNReplaceTemplateSharding](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNReplaceTemplateSharding.png?classes=lab_picture_auto)

1. Click **Next**
1. No changes are required for **Parameters**. Click **Next**
1. For **Configure stack options** click **Next**
1. On the **Review** page:
    * Scroll to the end of the page and select **I acknowledge that AWS CloudFormation might create IAM resources with custom names.** This ensures CloudFormation has permission to create resources related to IAM. Additional information can be found [here](https://docs.aws.amazon.com/AWSCloudFormation/latest/APIReference/API_CreateStack.html).

    **Note:** The template creates an IAM role and Instance Profile for EC2. These are the minimum permissions necessary for the instances to be managed by AWS Systems Manager. These permissions can be reviewed in the CloudFormation template under the "Resources" section - *InstanceRole*.

    * Click **Update stack**

    ![CFNIamCapabilitiesUpdateStack](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNIamCapabilitiesUpdateStack.png?classes=lab_picture_auto)

This will take you to the CloudFormation stack status page, showing the stack update in progress. The stack takes about 1 minute to go through all the updates. Periodically refresh the CloudFormation stack events until you see that the **Stack Status** is in **UPDATE_COMPLETE**.

With this stack update, the architecture of the workload has been updated by introducing **4 Application Load Balancer listener rules and Target Groups**. These listener rules have been configured to inspect the incoming request for the query-string **name**. Depending on the value provided, the request is routed to one of **four target groups** where each target group consists of 2 EC2 instances.

### Test the sharded application

Now that the application has been deployed, it is time to test it to understand how it works. The sample application used in this lab is the same as before, a simple web application that returns a message with the Worker that responded to the request. Customers pass in a query string as part of the request to identify themselves. The query string used here is **name**.

1. Visit the **Outputs** section of the CloudFormation stack created in the previous step. You will see a list of URLs next to customer names.

    ![CFNOutputs](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNOutputs.png?classes=lab_picture_auto)

1. Open the link for customer **Alpha** in a new browser tab. Refresh the web browser a few times to see that responses are being returned from different EC2 instances on the back-end.
    * The list of EC2 instances in your workload can be viewed in the [AWS Console here](https://console.aws.amazon.com/ec2/v2/home?#Instances:tag:Name=Worker)

    ![RegularAlpha](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/RegularAlpha.png?classes=lab_picture_auto)

1. Refresh the web browser a few times to see that responses are being returned from different EC2 instances on the back-end.
    * Notice that after implementing sharding, you are seeing responses being returned from only 2 instances for customer **Alpha**'s requests. No matter how many times you refresh the page or try a different browser, customer **Alpha** will only receive responses from 2 EC2 instances. This is because you have created **Application Load Balancer listener rules** that divert traffic to a specific subset of the overall capacity of the workload, also known as a shard.
    * In this case, customers **Alpha** and **Bravo** are mapped to Shard 1 containing Worker 1 and Worker 2.
    * Customers **Charlie** and **Delta** are mapped to Shard 2 containing Worker 3 and Worker 4.
    * Customers **Echo** and **Foxtrot** are mapped to Shard 3 containing Worker 5 and Worker 6.
    * Customers **Golf** and **Hotel** are mapped to Shard 4 containing Worker 7 and Worker 8.

    ![ShardedFlow](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/ShardedFlow.png?classes=lab_picture_auto)

1. Open the links for a few other customers and verify that they are able to get responses from only 2 EC2 instances. The different customers are - **Alpha**, **Bravo**, **Charlie**, **Delta**, **Echo**, **Foxtrot**, **Golf**, and **Hotel** and their corresponding URLs can be obtained from the CloudFormation stack Outputs.

1. Refresh the web browser multiple times to verify that customers are only receiving responses from EC2 instances in the shard they are mapped to.

{{< prev_next_button link_prev_url="../2_impact_of_failures" link_next_url="../4_impact_of_failures_sharding/" />}}
