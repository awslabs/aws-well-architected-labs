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
