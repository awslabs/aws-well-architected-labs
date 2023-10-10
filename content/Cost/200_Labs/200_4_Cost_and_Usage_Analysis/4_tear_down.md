---
title: "Tear down"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

Amazon Athena only charges when it is being used, i.e. data is being scanned - so if it is not being actively queried, there are no charges. There may be some charges from AWS Glue if it is above the free tier limit.

As it is best practice to regularly analyze your usage and cost, so there is no teardown for this lab.


{{< prev_next_button link_prev_url="../3_cur_analysis/"  title="Congratulations!" final_step="true"  />}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST3 - "How do you monitor usage and cost?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-expenditure-and-usage-awareness.html)
{{< prev_next_button />}}
