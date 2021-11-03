import json
import urllib3
import boto3
def lambda_handler(event, context):
    print('REQUEST BODY:n' + str(event))
    if event['RequestType'] == 'Delete':
        print("delete")
    elif event['RequestType'] == 'Create':
        print("create")
        client = boto3.client('stepfunctions')

        statemachineARN = event['ResourceProperties']['StateMachineARN']
        multiRegion = event['ResourceProperties']['MultiRegion']== "true"

        if multiRegion:
            statemachineInput = '{"region1": { "log_level": "DEBUG", "region_name": "us-east-2", "secondary_region_name": "us-west-2", "cfn_region": "us-east-2", "cfn_bucket": "aws-well-architected-labs-ohio", "folder": "Reliability/", "workshop": "300-ResiliencyofEC2RDSandS3", "boot_bucket": "aws-well-architected-labs-ohio", "boot_prefix": "Reliability/", "websiteimage" : "https://aws-well-architected-labs-ohio.s3.us-east-2.amazonaws.com/images/Cirque_of_the_Towers.jpg" }, "region2": { "log_level": "DEBUG", "region_name": "us-west-2", "secondary_region_name": "us-east-2", "cfn_region": "us-east-2", "cfn_bucket": "aws-well-architected-labs-ohio", "folder": "Reliability/", "workshop": "300-ResiliencyofEC2RDSandS3", "boot_bucket": "aws-well-architected-labs-ohio", "boot_prefix": "Reliability/", "websiteimage" : "https://aws-well-architected-labs-ohio.s3.us-east-2.amazonaws.com/images/Cirque_of_the_Towers.jpg" } }'
        else:
            statemachineInput = '{"log_level": "DEBUG","region_name": "us-east-2","cfn_region": "us-east-2","cfn_bucket": "aws-well-architected-labs-ohio","folder": "Reliability/","workshop": "300-ResiliencyofEC2RDSandS3","boot_bucket": "aws-well-architected-labs-ohio","boot_prefix": "Reliability/","websiteimage" : "https://aws-well-architected-labs-ohio.s3.us-east-2.amazonaws.com/images/Cirque_of_the_Towers.jpg"}'

        response = client.start_execution(
            stateMachineArn=statemachineARN,
            name='BuildResiliency',
            input=statemachineInput
        )

    responseStatus = 'SUCCESS'
    responseData = {'Success': 'Everything worked.'}

    sendResponse(event, context, responseStatus, responseData)

def sendResponse(event, context, responseStatus, responseData, reason=None, physical_resource_id=None):
    responseBody = {'Status': responseStatus,
                    'Reason': 'See the details in CloudWatch Log Stream: ' + context.log_stream_name,
                    'PhysicalResourceId': physical_resource_id or context.log_stream_name,
                    'StackId': event['StackId'],
                    'RequestId': event['RequestId'],
                    'LogicalResourceId': event['LogicalResourceId'],
                    'Data': responseData}
    print('RESPONSE BODY:n' + json.dumps(responseBody))
    responseUrl = event['ResponseURL']
    json_responseBody = json.dumps(responseBody)
    headers = {
        'content-type' : '',
        'content-length' : str(len(json_responseBody))
    }

    http = urllib3.PoolManager()

    try:
        response = http.request('PUT', responseUrl, headers=headers, body=json_responseBody)
        print("Status code:", response.status)
    except Exception as e:
        print("send(..) failed executing requests.put(..): " + str(e))
