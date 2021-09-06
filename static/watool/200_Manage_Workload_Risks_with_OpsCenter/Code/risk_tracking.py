import boto3
import json
import os
import urllib.request
from bs4 import BeautifulSoup

# Initialize API clients
wa = boto3.client('wellarchitected')
ssm = boto3.client('ssm')
dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):
    #Print the incoming event
    print('Incoming Event:' + json.dumps(event))

    #Get a list of workloads from the WA Tool
    workloads = list_workloads()

    for workload in workloads:
        workload_details = wa.get_workload(
            WorkloadId=workload
        )

        workload_name = workload_details['Workload']['WorkloadName']
        workload_arn = workload_details['Workload']['WorkloadArn']
        hri_count = workload_details['Workload']['RiskCounts']['HIGH']
        mri_count = workload_details['Workload']['RiskCounts']['MEDIUM']

        print(workload_name, hri_count, mri_count)

        if hri_count == 0 and mri_count == 0:
            print('No risks identified for workload: ' + workload_name)
            continue

        # Get a list of improvements for workload
        improvements = list_improvements(workload)

        # Get the list of best practices missing from the workload
        missing_bps = get_current_state(workload)

        for improvement,val in enumerate(improvements):
            question_id = improvements[improvement]['QuestionId']
            question_title = improvements[improvement]['QuestionTitle']
            pillar = improvements[improvement]['PillarId']
            risk = improvements[improvement]['Risk']
            improvement_plan = improvements[improvement]['ImprovementPlanUrl']

            if risk == 'HIGH' or risk == 'MEDIUM':
                get_answer_response = wa.get_answer(
                    WorkloadId=workload,
                    LensAlias='wellarchitected',
                    QuestionId=question_id
                )

                # Get the improvement plan URL
                urlresponse = urllib.request.urlopen(improvement_plan)
                htmlBytes = urlresponse.read()
                htmlStr = htmlBytes.decode("utf8")
                htmlSplit = htmlStr.split('\n')

                # Get the best practices selected for a question
                selected_choices = []
                choice_answers = get_answer_response['Answer']['ChoiceAnswers']
                for choice_answer in choice_answers:
                    selected_choices.append(choice_answer['ChoiceId'])

                # Get choice ID for option 'None of these'
                for bp_choice in get_answer_response['Answer']['Choices']:
                    if bp_choice['Title'] == 'None of these':
                        none_of_these = bp_choice['ChoiceId']

                # No best practices selected if 'None of these' is selected
                for choice_id in selected_choices:
                    if choice_id == none_of_these:
                        selected_choices = []

                for choice in get_answer_response['Answer']['Choices']:
                    if ((choice['ChoiceId'] not in selected_choices) and (choice['Title'] != 'None of these') and (choice['ChoiceId'] not in missing_bps)):
                        missing_bps.append(choice['ChoiceId'])

                        improvement_plan_url = improvement_plan

                        for line in htmlSplit:
                            if choice['Title'] in line:
                                parsed = BeautifulSoup(line,features="html.parser")
                                improvement_plan_url = str(parsed.a['href'])

                        risk_title = choice['Title'].replace('\n','').strip()

                        if risk == 'HIGH':
                            opsitem_description='High Risk Issue(HRI) identified'
                            opsitem_title='High Risk' + ' - ' + workload_name + ' - ' + risk_title
                            severity='2'
                        elif risk == 'MEDIUM':
                            opsitem_description='Medium Risk Issue(MRI) identified'
                            opsitem_title='Medium Risk' + ' - ' + workload_name + ' - ' + risk_title
                            severity='3'

                        # Create an OpsItem for missing Best practice
                        create_opsitem = ssm.create_ops_item(
                                  Description=opsitem_description,
                                  OperationalData={
                                      '/aws/resources': {
                                          'Value': '[{\"arn\":\"' + workload_arn + '\"}]',
                                          'Type': 'SearchableString'
                                      },
                                      'WorkloadName': {
                                          'Value': workload_name,
                                          'Type': 'SearchableString'
                                      },
                                      'Best practices missing': {
                                          'Value': risk_title,
                                          'Type': 'SearchableString'
                                      },
                                      'Improvement Plan': {
                                          'Value': improvement_plan_url,
                                          'Type': 'SearchableString'
                                      },
                                      'Pillar': {
                                          'Value': pillar,
                                          'Type': 'SearchableString'
                                      },
                                      'Question': {
                                          'Value': question_title,
                                          'Type': 'SearchableString'
                                      },
                                      'Risk level': {
                                          'Value': risk,
                                          'Type': 'SearchableString'
                                      },
                                      'QuestionId': {
                                          'Value': question_id,
                                          'Type': 'SearchableString'
                                      },
                                      'ChoiceId': {
                                          'Value': choice['ChoiceId'],
                                          'Type': 'SearchableString'
                                      }
                                  },
                                  Source='Well-Architected',
                                  Notifications=[
                                    {
                                        'Arn': os.environ['sns_topic_arn']
                                    }
                                  ],
                                  Title=opsitem_title,
                                  Severity=severity
                                )

                        print(create_opsitem)

        # Update the workload state on dynamo
        update_workload_state = dynamodb.put_item(
            TableName='wa_workload_data',
            Item={
                'workload_id': {
                    'S': workload
                },
                'missing_bps': {
                    'SS': missing_bps
                }
            }
        )

        print(update_workload_state)

def list_workloads():
    list_workloads_response = wa.list_workloads()

    workloads = [workload['WorkloadId'] for workload in list_workloads_response['WorkloadSummaries']]

    while 'NextToken' in list_workloads_response:
        list_workloads_response = wa.list_workloads(
        NextToken = list_workloads_response['NextToken']
        )
        workloads.extend(workload['WorkloadId'] for workload in list_workloads_response['WorkloadSummaries'])

    return(workloads)

def list_improvements(workload):
    list_improvements_response = wa.list_lens_review_improvements(
        WorkloadId=workload,
        LensAlias='wellarchitected'
    )

    improvements = list_improvements_response['ImprovementSummaries']

    while 'NextToken' in list_improvements_response:
        list_improvements_response = wa.list_lens_review_improvements(
        WorkloadId=workload,
        LensAlias='wellarchitected',
        NextToken = list_improvements_response['NextToken']
        )
        improvements.extend(list_improvements_response['ImprovementSummaries'])

    return(improvements)

def get_current_state(workload):
    try:
        workload_current_state = dynamodb.get_item(
            TableName='wa_workload_data',
            Key={
                'workload_id': {
                    'S': workload
                }
            }
        )
        missing_bps = workload_current_state['Item']['missing_bps']['SS']
    except:
        missing_bps = []
    return(missing_bps)
