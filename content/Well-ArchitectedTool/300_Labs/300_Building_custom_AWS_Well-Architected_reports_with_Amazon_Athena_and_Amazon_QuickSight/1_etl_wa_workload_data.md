---
title: "Extract workload data"
date: 2021-03-24T15:16:08+10:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
To extract the Well-Architected workload data, we'll create an AWS Lambda function to query the Well-Architected API.  AWS Lambda makes three calls to the Well-Architected Tool API to obtain workload, lens, and milestone information. It performs some minor transformation of the data to normalize the JSON structure and stores the data in an S3 bucket.

#### Create Lambda function

1.  Begin by navigating to the Lambda console and choosing the **Create function**
2.  Choose the option to **Author from scratch** and then fill in `extract-war-reports` as the function name, "Python 3.6" as the runtime.
3.  Under **Permissions**, select the option to "Create new role from template(s)", assigning a role name of `extract-war-reports_role`.
4.  Then, choose **Create function**. Lambda will then create a new function along with a role for executing the function.

![Image of creating Lambda function showing data inputs provided in above text.](/Well-ArchitectedTool/300_Labs/300_Building_custom_AWS_Well-Architected_reports_with_Amazon_Athena_and_Amazon_QuickSight/Images/fig-2-lambda_config.png)

Now, go ahead and paste the following code into the function editor. This code handles calls to obtain the workload data and storing in Amazon S3.  Select **Deploy** to commit the code changes.

```
import boto3
import json
import os
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

s3_bucket = os.environ['S3_BUCKET']
s3_key = os.environ['S3_KEY']

#################
# Boto3 Clients #
#################
wa_client = boto3.client('wellarchitected')
s3_client = boto3.client('s3')

##############
# Parameters #
##############
# The maximum number of results the API can return in a list workloads call.
list_workloads_max_results_maximum = 50
# The maximum number of results the API can return in a list answers call.
list_answers_max_results_maximum = 50
# The maximum number of results the API can return in a list milestones call.
list_milestone_max_results_maximum = 50

def get_all_workloads():
    # Get a list of all workloads
    list_workloads_result = wa_client.list_workloads(MaxResults=list_workloads_max_results_maximum)
    logger.info(f'Found {len(list_workloads_result)} Well-Archtected workloads.')
    workloads_all = list_workloads_result['WorkloadSummaries']
    while 'NextToken' in list_workloads_result:
        next_token = list_workloads_result['NextToken']
        list_workloads_result = wa_client.list_workloads(
            MaxResults=list_workloads_max_results_maximum, NextToken=next_token
        )
        workloads_all += list_workloads_result['WorkloadSummaries']
    return (workloads_all)

def get_milestones(workload_id):
    # # Get latest milestone review date
    milestones = wa_client.list_milestones(
        WorkloadId=workload_id, MaxResults=list_milestone_max_results_maximum
    )['MilestoneSummaries']

    # If workload has milestone get them.
    logger.info(f'Workload {workload_id} has {len(milestones)} milestones.')
    if milestones:
        for milestone in milestones:
            milestone['RecordedAt'] = milestone['RecordedAt'].isoformat()
    return milestones

def get_lens(workload_id):
    # Which lenses have been activated for this workload
    # print(workload_id)
    lens_reviews_result = wa_client.list_lens_reviews(
        WorkloadId=workload_id
    )['LensReviewSummaries']
    logger.info(f'Workload {workload_id} has used {len(lens_reviews_result)} lens')
    return lens_reviews_result

def get_lens_answers(workload_id, lens_reviews):
    # Loop through each activated lens
    # TODO - List Answers for each milestone
    list_answers_result = []
    for lens in lens_reviews:
        lens_name = lens['LensName']
        logger.info(f'Looking at {lens_name} answers for Workload {workload_id}')

        # Get All answers for the lens
        list_answers_reponse = wa_client.list_answers(
            WorkloadId=workload_id, LensAlias=lens['LensAlias'], MaxResults=list_answers_max_results_maximum
        )

        # Flatten the answer result to include LensAlias and Milestone Number
        for answer_result in list_answers_reponse['AnswerSummaries']:
            answer_result['LensAlias'] = list_answers_reponse['LensAlias']

            # if 'MilestoneNumber' in list_answers_reponse:
            #     print("MILSTONE_DETECTED")
            #     answer_result['MilestoneNumber'] = list_answers_reponse['MilestoneNumber']

            # Append Answers from each lens.  For reporting.
        list_answers_result.extend(list_answers_reponse['AnswerSummaries'])

    return  list_answers_result

def get_lens_summary(workload_id, lens_reviews):
    # Loop through each activated lens
    list_lens_review_summary = []
    for lens in lens_reviews:
        lens_name = lens['LensName']
        logger.info(f'Looking at {lens_name} Summary for Workload {workload_id}')
        list_lens_review_reponse = wa_client.get_lens_review(
            WorkloadId=workload_id, LensAlias=lens['LensAlias']
        )
        list_lens_review_reponse['LensReview']['UpdatedAt'] = list_lens_review_reponse['LensReview']['UpdatedAt'].isoformat()
        list_lens_review_summary.append(list_lens_review_reponse['LensReview'])
    return list_lens_review_summary

def lambda_handler(event, context):
    workloads_all = get_all_workloads()
    # Generate workload JSON file
    logger.info(f'Generate JSON object for each workload.')

    # print (workloads_all)

    for workload in workloads_all:
        # Get workload info from WAR Tool API,
        workload_id = workload['WorkloadId']

        milestones = get_milestones(workload_id)

        lens_reviews = get_lens(workload_id)
        lens_summary_result = get_lens_summary(workload_id, lens_reviews)
        list_answers_result = get_lens_answers(workload_id, lens_reviews)

        # Build JSON of workload data
        workload_report_data = {}
        workload_report_data['workload_id'] = workload['WorkloadId']
        workload_report_data['workload_name'] = workload['WorkloadName']
        workload_report_data['workload_owner'] = workload['Owner']

        workload_report_data['workload_lastupdated'] = workload['UpdatedAt'].isoformat()
        workload_report_data['lens_summary'] = lens_summary_result
        workload_report_data['milestones'] = milestones
        # workload_report_data['report_answers'] = list_answers_result['AnswerSummaries']
        workload_report_data['report_answers'] = list_answers_result
        logger.debug(workload_report_data)
        print(workload_report_data)

        # Write to S3
        file_name = workload_id + '.json'
        logger.info(f'Writing JSON object to s3://{s3_bucket}/{s3_key}{file_name}.')
        s3_client.put_object(
            Body=str(json.dumps(workload_report_data)),
            Bucket=s3_bucket,
            Key=f'{s3_key}{file_name}'
        )
```

#### Environment variables

Let's add some environment variables to pass environment-specific settings to the code.

Select Edit under Environment variables, and add the following environment variables and select Save:

| Key | Value |
| --- | ----- |
| `S3_BUCKET` | S3 bucket name, where you will store the extracted AWS Well-Architected data, e.g. "well-architected-reporting-blog" |
| `S3_KEY` | path in which you want the extracted Well-Architected workload data to be stored, e.g. "WorkloadReports/" |

Your environment variables should now look like this:

![Image of creating environment variables showing data inputs provided in above text.](/Well-ArchitectedTool/300_Labs/300_Building_custom_AWS_Well-Architected_reports_with_Amazon_Athena_and_Amazon_QuickSight/Images/fig-3-env-variable-config.png)

#### Trigger configuration

Let's configure an Amazon Eventbridge ([Amazon CloudWatch Events](https://aws.amazon.com/cloudwatch/)) schedule to have AWS Lambda poll the Well-Architected Tool API to extract all shared workloads to the AWS WA Tool in your AWS management account.  Expand the **Designer** drop-down list and then select **EventBridge (CloudWatch Events)** as a trigger.  Fill in `LambdaExtractWARReportsSchedule` as the Rule name.  Select Schedule expression, and fill in a suitable expression that meets your requirements, e.g. `rate(1 hour)` will configure the Lambda function once every hour.

![Image of Lambda trigger configuration, showing data inputs provided in above text.](/Well-ArchitectedTool/300_Labs/300_Building_custom_AWS_Well-Architected_reports_with_Amazon_Athena_and_Amazon_QuickSight/Images/fig-4-lambda-trigger-config.png)

#### Lambda timeout

You should also increase the function timeout to 3 minute to ensure that the function always has time to finish reading all the defined workload data.

#### IAM role configuration

Finally, navigate to the IAM console and open role "[extract-war-reports_role](https://console.aws.amazon.com/iam/home#/roles/extract-war-reports_role?section=permissions)".  Attach policy "[WellArchitectedConsoleReadOnlyAccess](https://console.aws.amazon.com/iam/home#/policies/arn%3Aaws%3Aiam%3A%3Aaws%3Apolicy%2FWellArchitectedConsoleReadOnlyAccess) " in order to grant the permissions necessary for calling Well-Architected APIs. Also attach the following policy to the role, replacing `<S3_BUCKET_NAME>` with the name of your S3 bucket where you will store the extracted AWS Well-Architected data.  This is the same bucket configured as an environment variable.

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "s3:GetObject",
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::<S3_BUCKET_NAME>*",
            "Effect": "Allow"
        }
    ]
}
```


{{< prev_next_button link_prev_url="../" link_next_url="../2_catalog_data/" />}}
