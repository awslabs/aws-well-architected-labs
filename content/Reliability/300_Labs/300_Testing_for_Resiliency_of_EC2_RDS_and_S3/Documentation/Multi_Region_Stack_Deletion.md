---
title: "Delete workshop CloudFormation stacks - Multi region deployment"
date: 2020-04-24T11:16:09-04:00
chapter: false
hidden: true
---

* Since AWS resources deployed by AWS CloudFormation stacks may have dependencies on the stacks that were created before, then deletion must occur in the opposite order they were created
* Stacks with the same ordinal can be deleted at the same time. _All_ stacks for a given ordinal must be **DELETE_COMPLETE** before moving on to the next ordinal
* The AWS Console does not let you select multiple stacks for deletion. To simultaneously delete stacks, individually select one stack at a time and click the **Delete** button.
* Helpful hint: have the AWS CloudFormation console for each region open in separate tabs
  * [CloudFormation console for Ohio](https://us-east-2.console.aws.amazon.com/cloudformation/home?region=us-east-2)
  * [CloudFormation console for Oregon](https://us-west-2.console.aws.amazon.com/cloudformation/home?region=us-west-2)

|Order|CloudFormation stack|Region|
|:---:|:---|:---|
|1|DMSforResiliencyTesting|Oregon|
|1|MySQLReadReplicaResiliencyTesting|Oregon|
|1|MySQLReadReplicaResiliencyTesting|Ohio|
|  |  |
|2|WebServersforResiliencyTesting|Ohio|
|2|MySQLforResiliencyTesting|Ohio|
|2|WebServersforResiliencyTesting|Oregon|
|2|MySQLforResiliencyTesting|Oregon|
|  |  |
|3|ResiliencyVPC|Ohio|
|3|ResiliencyVPC|Oregon|
|3|DeployResiliencyWorkshop|Ohio|

---
