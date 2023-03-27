import json
import boto3
import os

#Initialize boto client for AWS Systems Manager
ssm = boto3.client('ssm')
wa = boto3.client('wellarchitected')
dynamodb = boto3.client('dynamodb')

def lambda_handler(event, context):

    #Print the incoming event
    print('Incoming Event:' + json.dumps(event))

    #Get OpsItem ID from incoming event
    opsItem_id = event['Records'][0]['Sns']['Subject']
    print(opsItem_id)

    #Get OpsItem status
    opsItem = ssm.get_ops_item(
        OpsItemId=opsItem_id
    )

    opsItem_status = opsItem['OpsItem']['Status']
    print(opsItem_status)

    if opsItem_status == 'Resolved':
        workload = opsItem['OpsItem']['OperationalData']['/aws/resources']['Value'].split('"')[3].split('/')[1]
        lens = opsItem['OpsItem']['OperationalData']['Lens']['Value']
        question_id = opsItem['OpsItem']['OperationalData']['QuestionId']['Value']
        new_bp = opsItem['OpsItem']['OperationalData']['ChoiceId']['Value']

        #Get current answer for the question
        current_answer = wa.get_answer(
            WorkloadId=workload,
            LensAlias=lens,
            QuestionId=question_id
        )

        selected_choices = current_answer['Answer']['SelectedChoices']

        #Check if workload has been updated manually
        if new_bp in selected_choices:
            print('Workload already up to date, no action needed')
        else:
            #Check if none of these is a selected option 
            none_of_these = None
            for bp_choice in current_answer['Answer']['Choices']:
                if bp_choice['Title'] == 'None of these':
                    none_of_these = bp_choice['ChoiceId']

            if none_of_these is not None:
                #If none of these is selected, no best practices applied for this question
                for choice_id in selected_choices:
                    if choice_id == none_of_these:
                        selected_choices = []

            selected_choices.append(new_bp)

            print('update answer: ', selected_choices)

            #Update the answers for the question on the AWS WA Tool
            updated_answer = wa.update_answer(
                WorkloadId=workload,
                LensAlias=lens,
                QuestionId=question_id,
                SelectedChoices=selected_choices
            )

        #Get current state for the workload that is tracked in DynamoDB
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

        current_state = workload_current_state['Item']['missing_bps']['SS']

        #Get current HRI and MRI count for the workload from DynamoDB
        workload_details = wa.get_workload(
            WorkloadId=workload 
        )

        hri_count = workload_details['Workload']['RiskCounts']['HIGH'] 
        mri_count = workload_details['Workload']['RiskCounts']['MEDIUM']

        #If risk count is 0, remove workload entry from DynamoDB, else update state for the workload on DynamoDB
        try:
            if hri_count == 0 and mri_count == 0:
                delete_workload_state = dynamodb.delete_item(
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
            else:
                current_state.remove(new_bp)
                workload_updated_state = dynamodb.put_item(
                TableName='wa_workload_data',
                Item={
                    'workload_id': {
                        'S': workload #add questionId
                    },
                    'question_id': {
                        'S': question_id
                    },
                    'missing_bps': {
                        'SS': current_state
                    }
                }
            )
        except Exception as e:
            print(e)
