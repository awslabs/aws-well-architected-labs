---
title: "Clean up the deployment"
date: 2021-03-24T15:16:08+10:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

This lab presented a simple approach for aggregating the data of the workload reviews into a central data lake repository. It helps teams to analyze their organization’s Well-Architected maturity across multiple AWS accounts and workloads and perform centralized reporting on high-risk issues (HRIs).

To clean up from this lab, manually delete the:
-   S3 bucket and the data stored in the bucket,
-   Lambda function,
-   Glue crawler and database,
-   Athena views, and the
-   QuickSight resources.

#### Other custom integrations

It's exciting to see the custom integrations with the AWS Well-Architected Tool made possible with the Well-Architected APIs.  Here are a few more examples of the functionality available with the new AWS Well-Architected Tool APIs:

-   Integrate AWS Well-Architected data into centralized reporting tools, or integrate with ticketing and management solutions.
-   Automation of best practice detection.
-   Provide insights to AWS customers based on their [AWS Well-Architected Review](https://aws.amazon.com/architecture/well-architected/), and recommend remediation steps and guidance.
-   Pre-populate information in the Well-Architected Tool for customers based on information that's already known about them---streamlining the review process.

By leveraging the Well-Architected Tool APIs, companies can effectively govern workloads across many AWS accounts, stay up-to-date on the latest best practices, and scale Well-Architected principles across teams and systems.

{{< prev_next_button link_prev_url="../4_visualize/"  title="Congratulations!" final_step="true" >}}
It's exciting to see the custom integrations with the AWS Well-Architected Tool made possible with the Well-Architected APIs.  Let's us know what other integrations you build.
{{< /prev_next_button >}}

