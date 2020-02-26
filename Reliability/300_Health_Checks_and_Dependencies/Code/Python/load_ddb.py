import boto3
import urllib.request
import cfnresponse
import logging
import signal
import json
import traceback

LOGGER = logging.getLogger()
LOGGER.setLevel(logging.INFO)

def populate_ddb_table():
    # Get the service resource. 
    # NOTE: when embeddded in CFN, we use ${AWS::Region}
    LOGGER.info('create client')
    client = boto3.client('dynamodb', 'us-east-2')
    
    # @TODO, make bucket/object configurable
    LOGGER.info('open file')
    file = urllib.request.urlopen("https://aws-well-architected-labs-ohio.s3.us-east-2.amazonaws.com/Healthcheck/Data/RecommendationService.json")
    LOGGER.info('read file')
    text = file.read()
    LOGGER.info(text)
    LOGGER.info('convert to JSON')
    request_items = json.loads(text)
    LOGGER.info('write to DDB')
    response = client.batch_write_item(RequestItems=request_items)
    LOGGER.info('DONE')
    
    # @TODO add error handling 
    
    # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/dynamodb.html#DynamoDB.Client.batch_write_item


def handler(event, context):
    signal.alarm(int((context.get_remaining_time_in_millis() / 1000) - 1))
    # Setup alarm for remaining runtime minus a second
    try:
        LOGGER.info('EVENT RECEIVED: %s', event)
        LOGGER.info('CONTEXT RECEIVED: %s', context)
        if event['RequestType'] == 'Create':
            LOGGER.info('CREATE')
            populate_ddb_table()
            cfnresponse.send(event, context, cfnresponse.SUCCESS,
                {'Message': 'Resource creation successful!'})
        elif event['RequestType'] == 'Update':
            LOGGER.info('UPDATE')
            populate_ddb_table()
            cfnresponse.send(event, context, cfnresponse.SUCCESS,
                {'Message': 'Resource update successful!'})
        elif event['RequestType'] == 'Delete':
            LOGGER.info('DELETE')
            # do nothing, table will be deleted anyway
            cfnresponse.send(event, context, cfnresponse.SUCCESS,
                {'Message': 'Resource deletion successful!'})
        else:
            LOGGER.info('FAILED!')
            cfnresponse.send(event, context, cfnresponse.FAILED,
                {'Message': 'Unexpected event received from CloudFormation'})
    except Exception as e:
        LOGGER.info(str(traceback.format_exception_only(e.__class__, e)))
        LOGGER.info('FAILED!')
        cfnresponse.send(event, context, cfnresponse.FAILED, {
            'Message': 'Exception during processing'})

def timeout_handler(_signal, _frame):
    raise Exception('Time exceeded')


signal.signal(signal.SIGALRM, timeout_handler)
