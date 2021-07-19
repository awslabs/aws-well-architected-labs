+++
title = "What We'll Build"
weight = 1
+++

### Architecture Overview

In this lab, we will learn how to set up and test Disaster Recovery for a sample 2-tier web application running in AWS. The following diagram depicts the high level architecture.

The Source Environment will be hosted in us-east-1 region. It consists of a webserver running Amazon with Apache, PHP, Wordpress, WooCommerce and a database server running Ubuntu with MySQL version 5.7. The Target Environment will be hosted in eu-west-1.

![Architecture](/lab1/DR_Architecture_Cross_Region.png?classes=shadow,border)

Given below the high-level steps we will be performing in this lab:

##### Setup:
- Setup a 2-tier sample application by using AWS CloudFormation Template.
- Install the CloudEndure Agent on the Source machine.
- Configure the Target machine Blueprint for each machine.
- Wait until all machines enter Continuous Data Protection.
##### Failover:
- Test the Failover by creating one or more Target machines. 
- Initiate a Failover.

#### Failback:
- To recover your data, initiate a Failback. This step terminates Data Replication.
- Return to normal operations.

The lab itself is estimated to take 1-2 hours to complete and expect to cost you less than 5$. Below are the main components of the costs.

|   Component       | 
|----------|
| CloudEndure License subscription (hourly rate per source server) | 
| EC2 Servers (t3.large) | 
| EBS SSD Disks |
| EBS Snapshot  |