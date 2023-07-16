---
title: "Teardown"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

Amazon Athena only charges when it is being used, i.e. data is being scanned - so if it is not being actively queried, there are no charges. There may be some charges from AWS Glue if it is above the free tier limit.

As it is best practice to regularly analyze your usage and cost, it is recommend to leave these resources available.

If for any reason you need to remove the resources, follow these steps:

1. To delete the Glue database, open AWS Glue and select "Databases" under "Data Catalog". Select the database name, click on the **Delete** button:
![Images/AWSMultiCUR3.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/AWSMultiCUR3.png?classes=lab_picture_small)

2. To delete the CloudFormation stack, open CloudFormation and select the stack, click on the **Delete** button:
![Images/AWSMultiCUR4.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/AWSMultiCUR4.png?classes=lab_picture_small)

{{< prev_next_button link_prev_url="../2_multiple_curs/"  title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST 3 - "How do you monitor usage and cost?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-expenditure-and-usage-awareness.html)
{{< /prev_next_button >}}

