---
title: "Cleanup"
date: 2020-11-18T09:16:09-04:00
chapter: false
weight: 8
---

To cleanup the resources created by this lab, please follow these steps:

1. Go to the [AWS CloudFormation console](https://eu-west-1.console.aws.amazon.com/cloudformation/home) in the region in which you deployed the AWS Serverless Application Repository application. **Delete** the stack called `serverlessrepo-aws-usage-queries`.
4. For [lab 3]({{< ref "content/Sustainability/300_Labs/300_cur_reports_as_efficiency_reports/3_add_assumptions_iac.md" >}}), run `cdk destroy` in the directory where `cdk.json` is.
2. Delete the CUR if you have created one before.
3. Empty and delete the Amazon S3 bucket if you have created one before to store the sample CUR data.

{{< prev_next_button link_prev_url="../3_add_assumptions_iac"  title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment or workload,
you should complete a milestone in the Well-Architected tool.
{{< /prev_next_button >}}
