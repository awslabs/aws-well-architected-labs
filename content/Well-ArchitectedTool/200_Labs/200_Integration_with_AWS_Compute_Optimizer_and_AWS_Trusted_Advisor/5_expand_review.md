---
title: "(Optional Step) Integrate AWS Compute Optimizer and Trusted Advisor to Another Question"
date: 2020-12-17T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

Now we understand how to integrate AWS Compute Optimizer and AWS Trusted Advisor checks to review the question [COST 6](https://wa.aws.amazon.com/wat.question.COST_6.en.html). 
In this section, we will learn how to add trusted advisor check to provide data for [COST 7](https://wa.aws.amazon.com/wat.question.COST_7.en.html).
 
## Find QuestionID using your WorkloadID
1. You can navigate to the Well-Architected Tool and select the workload created previously to retrieve the WorkloadId. WorkloadID can be found in the **Properties** Tab as part of the ARN.
![WorkloadId](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section5/workloadID.png)
As an example, you can see that the WorkloadID for the workload called **wademo** is **46ff48ca1be93355e799201469dee0fd**.
 
2. With the workloadID, we can now retrieve the QuestionID using the [ListAnswers API](https://docs.aws.amazon.com/wellarchitected/latest/APIReference/API_ListAnswers.html). Replace **Workload_ID** with your workload id.
    ```
    aws wellarchitected list-answers --workload-id {Workload_ID} --lens-alias "wellarchitected" --pillar-id "costOptimization" --query 'AnswerSummaries[?starts_with(QuestionTitle, `How do you use pricing models to reduce cost`) == `true`].QuestionId'
    ```
![QuestionId](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section5/questionID.png)

3. Get AWS Trusted Advisor check ID that provides pricing model recommendations from [here](https://docs.aws.amazon.com/awssupport/latest/user/cost-optimization-checks.html#amazon-ec2-reserved-instances-optimization). **cX3c2R1chu** covers recommendations based on Standard Reserved Instances with the partial upfront payment option.
![TACheckId](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section5/TACheckId.png)
 
## Update DynamoDB Mapping Table
1. The next step is to update the mapping table with the QuestionID we've just retrieved and the Trusted Advisor Check ID that we would like to include in this question note. In this example, I'm going to include the **Amazon EC2 Reserved Instance Optimization** check, this has check ID value as **cX3c2R1chu**
You can find more about the other Trusted Advisor checks [here](https://docs.aws.amazon.com/awssupport/latest/user/trusted-advisor-check-reference.html)
With that, I will navigate to **wa-mapping-new-question.json** and update the mapping table as follows:
```
{
    "tableName": "wa-mapping",
    "mappings": [
        {            
            "PillarNumber": "COST-7",
            "PillarId": "costOptimization",
            "QuestionTitle": "How do you use pricing models to reduce cost?",
            "QuestionId": "pricing-model",
            "ChoiceTitle": "Perform pricing model analysis at the master account level",
            "ChoiceId": "cost_pricing_model_master_analysis",
            "TACheckId": "cX3c2R1chu"
        }
    ]
}
```
Now we are going to update AWS DynamoDB table with the updated json file through API Gateway provision in the the [previous step](../2_configure_env/).
* Replace **APIGWUrl** with your APIGWUrl that you deployed previously.
```
curl --header "Content-Type: application/json" -d @mappings/wa-mapping-new-question.json -v POST {APIGWUrl} 
 
```
Confirm that **UnprocessedItems** appear to be empty, which means you successfully put items into AWS DynamoDB. 
![Section2 Confirm](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/Confirm.png)
In AWS DynamoDB console, click **wa-mapping** you just deployed and click **Explore table items**. 
![Section2 Table](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/Table.png)
![Section2 Explore](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/Explore.png)
There are 2 Question IDs of Well-Architected questions and 2 AWS Trusted Advisor checks.
![Section2 Items](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section5/Items.png)
 
## Create a Well-Architected Workload with Tags
Refer to the [previous section](../3_create_workload/) to create new Well-Architected Workload With Tags
 
## Perform Review
I created workload called **demo3** and when i clicked on **Continue reviewing**, choose  **Cost Optimization** pillar. I can see that both **COST 6. How do you meet cost targets when you select resource type, size and number?** and **COST 7. How do you use pricing models to reduce cost?** have been updated with the checks from AWS Compute Optimizer and AWS Trusted Advisor
 
1. With the mapping table updated, we can create a new review click **Continue reviewing** and select **AWS Well-Architected Framework Lens**.
![Section5 COST6](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section5/COST6.png)
![Section5 COST7](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section5/COST7.png)
 
2. Throughout this lab, you have learned how to include AWS Compute Optimizer and AWS Trusted Advisor to prepare data before the review. This can be expanded further to prepare data for more questions and from more data sources 
 
{{< prev_next_button link_prev_url="../4_perform_review/" link_next_url="../6_cleanup/" />}}
