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

        if hri_count == 0 and mri_count == 0:
            print('No risks identified for workload: ' + workload_name)
            continue

        # Get a list of improvements for workload
        improvements = list_improvements(workload, workload_details['Workload']["Lenses"])
        
        # Get the list of best practices missing from the workload
        for improv in improvements:
            improve_lens = improv['lens']
            improve_summaries = improv['improvements']
            for improvement,val in enumerate(improve_summaries):
                question_id = improve_summaries[improvement]['QuestionId']
                question_title = improve_summaries[improvement]['QuestionTitle']
                pillar = improve_summaries[improvement]['PillarId']
                risk = improve_summaries[improvement]['Risk']
                improvement_plan = improve_summaries[improvement]['ImprovementPlanUrl']
                missing_bps = get_current_state(workload, question_id)

                if risk == 'HIGH' or risk == 'MEDIUM':
                    get_answer_response = wa.get_answer(
                        WorkloadId=workload,
                        LensAlias= improve_lens,
                        QuestionId=question_id
                    )
                                        
                    if improvement_plan != '' and improvement_plan is not None:
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
                    
                    none_of_these = None
                    # Get choice ID for option 'None of these'
                    for bp_choice in get_answer_response['Answer']['Choices']:
                        if bp_choice['Title'] == 'None of these':
                            none_of_these = bp_choice['ChoiceId']
                            
                    if none_of_these is not None:
                        # No best practices selected if 'None of these' is selected
                        for choice_id in selected_choices:
                            if choice_id == none_of_these:
                                selected_choices = []

                    for choice in get_answer_response['Answer']['Choices']:
                        if ((choice['ChoiceId'] not in selected_choices) and (choice['Title'] != 'None of these') and (choice['ChoiceId'] not in missing_bps)):
                            missing_bps.append(choice['ChoiceId'])
                            
                            if improvement_plan != '' and improvement_plan is not None:
                                improvement_plan_url = improvement_plan

                                for line in htmlSplit:
                                    if choice['Title'] in line:
                                        parsed = BeautifulSoup(line,features="html.parser")
                                        improvement_plan_url = str(parsed.a['href'])
                            else:
                                improvement_plan_url = ''

                            risk_title = choice['Title'].replace('\n','').strip()
                            
                            if risk == 'HIGH':
                                opsitem_description='High Risk Issue(HRI) identified'
                                opsitem_title='High Risk' + ' - ' + workload_name + ' - ' + risk_title
                                severity='2'
                            elif risk == 'MEDIUM':
                                opsitem_description='Medium Risk Issue(MRI) identified'
                                opsitem_title='Medium Risk' + ' - ' + workload_name + ' - ' + risk_title
                                severity='3'
                                                            
                            operational_data = {
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
                              },
                              'Lens': {
                                  'Value': improve_lens,
                                  'Type': 'SearchableString'
                              }
                            }
                            
                            if improvement_plan != '' and improvement_plan is not None:
                                operational_data['Improvement Plan'] = {
                                        'Value': improvement_plan_url,
                                        'Type': 'SearchableString'
                                    }

                            # Create an OpsItem for missing Best practice
                            create_opsitem = ssm.create_ops_item(
                                      Description=opsitem_description,
                                      OperationalData=operational_data,
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
                        },
                        'question_id' : {
                            'S' : question_id
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

def list_improvements(workload, lenses):
    improvements = []
    for lens in lenses:
        list_improvements_response = wa.list_lens_review_improvements(
            WorkloadId=workload,
            LensAlias=lens
        )

        improvements.append({'lens' : lens, 'improvements' : list_improvements_response['ImprovementSummaries'] })

        while 'NextToken' in list_improvements_response:
            list_improvements_response = wa.list_lens_review_improvements(
            WorkloadId=workload,
            LensAlias=lens,
            NextToken = list_improvements_response['NextToken']
            )
            next_improvement = {'lens' : lens, 'improvements' : list_improvements_response['ImprovementSummaries'] }
            improvements.append(next_improvement)

    return(improvements)

def get_current_state(workload, question_id):
    try:
        workload_current_state = dynamodb.get_item(
            TableName='wa_workload_data',
            Key={
                'workload_id': {
                    'S': workload
                },
                'question_id': {
                    'S': question_id
                }
            }
        )
        missing_bps = workload_current_state['Item']['missing_bps']['SS']
    except:
        missing_bps = []
    return(missing_bps)
