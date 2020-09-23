---
title: "Teardown"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

The follwoing resources were created during this lab and can be deleted:

 - S3 bucket, name starting with **costefficiency**
 - Glue Classifier **WebLogs**
 - Glue Crawler **ApplicationLogs**
 - IAM Role & Policy **AWSGlueServiceRole-CostWebLogs**
 - Glue Database **webserverlogs**
 - Crawler **CostUsage**
 - IAM Role & Policy **AWSGlueServiceRole-Costusage**
 - Glue Database **CostUsage**
 - Athena table **costusagefiles_workshop.hourlycost**
 - Athena table **costusagefiles_workshop.efficiency**
 - QuickSight dataset **efficiency**
 - QuickSight Analysis **efficiency analysis**



{{< prev_next_button link_prev_url="../3_visualizations/"  title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST 3 - "How do you monitor usage and cost? "](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-expenditure-and-usage-awareness.html)
{{< /prev_next_button >}}

