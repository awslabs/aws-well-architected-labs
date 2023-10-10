---
title: "Teardown"
date: 2020-08-30T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---


The following resources were created in this lab:

1. Remove Athena **before** and **after** tables:

        drop table costmaster.before
        drop table costmaster.after

2. Delete the **before** and **after** folders from S3.

3. Delete s3 folder starting with the name **cost-**, ensure you select the correct folder.

4. Additional user permissions in SSO (if configured):
    - ec2:DescribeImages
    - ec2:DescribeVpcs
    - ec2:DescribeSubnets

{{< prev_next_button link_prev_url="../2_analyze_understand/"  title="Congratulations!" final_step="true"  />}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST 5 - "How do you evaluate cost when you select services?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-cost-effective-resources.html)
{{< prev_next_button />}}

