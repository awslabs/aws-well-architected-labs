+++
title = "How CloudEndure works"
weight = 2
+++

#### How CloudEndure Disaster Recovery Works

CloudEndure Disaster Recovery continuously replicates your machines (including operating system, system state configuration, databases, applications, and files) into a low-cost staging area in your target AWS account and preferred Region. In the case of a disaster, you can instruct CloudEndure Disaster Recovery to automatically launch thousands of your machines in their fully provisioned state in minutes.

Because the staging area does not run a live version of your workloads, you do not need to pay for duplicate software licenses or high-performance compute. In the event of a disaster, click a button in the CloudEndure User Console to launch up-to-date, fully operational workloads on AWS in minutes.

[![How CloudEndure works](https://d1.awsstatic.com/products/CloudEndure/CloudEndure_Disaster_Recovery_Architecture_v2.3ae714976d6a72508467f7e40546dffd712dae9d.jpg?classes=shadow)](https://d1.awsstatic.com/products/CloudEndure/CloudEndure_Disaster_Recovery_Architecture_v2.3ae714976d6a72508467f7e40546dffd712dae9d.jpg?classes=shadow)


Lets now look at how CloudEndure can help you achieve your RPO and RTO requirements:

**RPO:** The CloudEndure Disaster Recovery agent continuously monitors the blocks written to the source server volume(s), and immediately attempts to copy the blocks across the network and into the replication Staging Area located in the customer’s target AWS account. This continuous replication approach enables an RPO of 1 second as long as the written data can be immediately copied across the network and into the replication Staging Area volumes.
 
 **RTO**: When launching a recovery job, the CloudEndure Disaster Recovery orchestration process creates cloned volumes by using the replicated volumes in the replication Staging Area. During this process, CloudEndure Disaster Recovery also initiates a process that creates AWS-compatible volumes, which are attached to EC2 instances that can boot natively on AWS. 

Typically, RTO is about 5-20 minutes depending on different environment factors such as OS Type, OS Configuration, Target Instance Performance and Target Volume Performance. Also, for Windows Operating System, pending OS updates can increase the RTO as Windows would want to automatically install those updates. 

