---
title: "Teardown"
date: 2020-10-26T11:10:08-04:00
chapter: false
weight: 6
pre: "<b>6. </b>"
---

The following resources were created in this lab:

- CloudFormation stack in the Cost account - OptimizationDataCollectionStack
- CloudFormation stack in the Management account - OptimizationManagementDataRoleStack
- CloudFormation stackset in the Management account - OptimizationDataRoleStack

Before deleting Stacks and StackSet please make sure all related buckets are empty.

When deleting the OptimizationDataRoleStack stackset, if you deployed to all accounts in your organization then add your AWS Organization id where it asks for **AWS OU ID**. Please make sure you empty s3 buckets before deletion of OptimizationDataCollectionStack. 

{{< prev_next_button link_prev_url="../5_utilize_data/"  title="Congratulations!" final_step="true" >}}


Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with

Or if you would like to contribute a module please see our contribution page or email costoptimization@amazon.com
[COST3 - "How do you monitor usage and cost?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-expenditure-and-usage-awareness.html)



