+++
title = "Readiness checks"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

In this section, we’re going to build a set of readiness checks for our application. 

We have two running stacks, our hot primary in **N. Virginia (us-east-1)** and the hot secondary in **N. California (us-west-1)**.  We’re going to set up:
* A **Recovery Group** composed of two **cells** to represent the readiness of the application components across our regions - **N. Virginia (us-east-1)** (primary) and **N. California (us-west-1)** (secondary). 
* A set of **Health Checks** - one for DynamoDB tables (in the East and West cells) and another for Website endpoints (in the East and West cells). This will allow us to check the readiness of the application for failover.

{{< img GS_ReacoveryReadinessDiagram.png >}}

Clieck **Next step** to proceed to the Recovery Group creation. 

{{< prev_next_button link_prev_url="../3-verify-websites/" link_next_url="./6.1-recovery-group/" />}}

