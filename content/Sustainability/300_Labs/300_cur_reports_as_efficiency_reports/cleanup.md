---
title: "Cleanup"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 8
---

To cleanup the resources created by this lab, please follow these steps:

1. Delete the AWS Cost & Usage Report in the billing console if you have created one for [Lab 1.1]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/1-1_prepare_cur_data.md" >}}).
1. Empty and delete the Amazon S3 bucket if you have created one to store the sample CUR data for [Lab 1.1]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/1-1_prepare_cur_data.md" >}}).
1. Go to the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation/home) in the region in which you deployed the AWS Serverless Application Repository application in [Lab 1.4]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/1-4_queries_from_sar.md" >}}). **Delete** the stack called `serverlessrepo-aws-usage-queries`.
1. For [Lab 3]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/3_add_assumptions_iac.md" >}}), run `cdk destroy` in the directory where `cdk.json` is.

{{< prev_next_button link_prev_url="../3_add_assumptions_iac"  title="Congratulations!" final_step="true" >}}
You should now have a firm understanding of using proxy metrics to inform environmental sustainability improvements.
{{< /prev_next_button >}}
