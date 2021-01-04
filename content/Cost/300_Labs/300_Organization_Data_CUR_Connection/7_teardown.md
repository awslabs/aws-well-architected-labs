---
title: "Teardown"
date: 2020-10-26T11:10:08-04:00
chapter: false
weight: 7
pre: "<b>7. </b>"
---

The following resources were created in this lab:

- Amazon QuickSight Dataset: organisation_data
- Amazon Athena Table: organisation_data
- Amazon CloudWatch Event, Rule: Lambda_Org_Data
- AWS Lambda Functions: Lambda_Org_Data
- IAM Policy: LambdaOrgPolicy
- IAM Role: LambdaOrgRole
- IAM Policy: ListOrganizations
- IAM Role: OrganizationLambdaAccessRole
- S3 Bucket: (custom name)


{{< prev_next_button link_prev_url="../6_bonus_org_tags/"  title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST3 - "How do you monitor usage and cost?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-expenditure-and-usage-awareness.html)



