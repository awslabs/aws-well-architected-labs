---
title: "Teardown"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>7. </b>"
weight: 7
---
1. Delete IAM role **Lambda_Auto_CUR_Delivery_Role** and policy **Lambda_Auto_CUR_Delivery_Access**
2. Delete Lambda function **Auto_CUR_Delivery**
3. Delete CloudWatch event **5_min_auto_cur_delivery**
4. Delete SES configuration
5. Delete S3 bucket for CUR query results storing


{{< prev_next_button link_prev_url="../6_cloudwatch_event/"  title="Congratulations!" final_step="true"  />}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST 3 - "How do you monitor usage and cost?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-expenditure-and-usage-awareness.html)
{{< prev_next_button />}}
