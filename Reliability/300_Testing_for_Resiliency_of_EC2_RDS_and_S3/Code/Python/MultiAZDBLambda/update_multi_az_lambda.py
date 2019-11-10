#
# MIT No Attribution
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this
# software and associated documentation files (the "Software"), to deal in the Software
# without restriction, including without limitation the rights to use, copy, modify,
# merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
# INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
# PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
# HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

from __future__ import print_function
from botocore.exceptions import ClientError
from time import sleep
import os
import sys
import logging
import traceback
import boto3
import json


LOG_LEVELS = {'CRITICAL': 50, 'ERROR': 40, 'WARNING': 30, 'INFO': 20, 'DEBUG': 10}

AWS_REGION = 'us-east-2'

# Must be same as stack name already created for RDS by deploy_rds_lambda.py
stackname = 'MySQLforResiliencyTesting'


def init_logging():
    # Setup logging
    logger = logging.getLogger()
    logger.setLevel(logging.DEBUG)
    logging.getLogger("boto3").setLevel(logging.WARNING)
    logging.getLogger('botocore').setLevel(logging.WARNING)
    logging.getLogger('nose').setLevel(logging.WARNING)

    return logger


def setup_local_logging(logger, log_level='INFO'):
    # Set the Logger so if running locally, it will print out to the main screen.
    handler = logging.StreamHandler()
    formatter = logging.Formatter(
        '%(asctime)s %(name)-12s %(levelname)-8s %(message)s'
    )
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    if log_level in LOG_LEVELS:
        logger.setLevel(LOG_LEVELS[log_level])
    else:
        logger.setLevel(LOG_LEVELS['INFO'])

    return logger


def set_log_level(logger, log_level='INFO'):
    # There is some stuff that needs to go here.
    if log_level in LOG_LEVELS:
        logger.setLevel(LOG_LEVELS[log_level])
    else:
        logger.setLevel(LOG_LEVELS['INFO'])

    return logger


def process_global_vars():
    logger.info("Processing variables from environment.")
    try:
        global stackname
        stackname = 'MySQLforResiliencyTesting'
    except SystemExit:
        sys.exit(1)
    except Exception:
        logger.error("Unexpected error!\n Stack Trace:", traceback.format_exc())


def find_in_parameters(parameters, key_to_find):
    parameters_string = None
    for parameter in parameters:
        if (parameter['ParameterKey'] == key_to_find):
            parameters_string = parameter['ParameterValue']
            break
    return parameters_string


def update_rds(event):
    logger.debug("Running function update_rds")
    try:
        region = event['region_name']
    except Exception:
        logger.error("Unexpected error!\n Stack Trace:", traceback.format_exc())
        region = os.environ.get('AWS_REGION', AWS_REGION)
    # Create CloudFormation client
    client = boto3.client('cloudformation', region)

    # Prepare the stack parameters
    rds_parameters = []

    # We are now setting DBMultiAZ = "true" to update the stack
    rds_parameters.append({'ParameterKey': 'DBMultiAZ', 'ParameterValue': "true"})

    # Every other parameter will use its previous value
    rds_parameters.append({'ParameterKey': 'DBSubnetIds', 'UsePreviousValue': True})
    rds_parameters.append({'ParameterKey': 'DBSecurityGroups', 'UsePreviousValue': True})
    rds_parameters.append({'ParameterKey': 'DBUser', 'UsePreviousValue': True})
    rds_parameters.append({'ParameterKey': 'WorkshopName', 'UsePreviousValue': True})
    rds_parameters.append({'ParameterKey': 'DBInstanceClass', 'UsePreviousValue': True})

    # for the update we use the SAME template as we used to create the RDS
    client.update_stack(
        StackName=stackname,
        UsePreviousTemplate=True,
        Parameters=rds_parameters
    )
    return_dict = {'stackname': stackname}
    return return_dict


def get_stack(client, stack_name):
    stack_response = client.describe_stacks(StackName=stack_name)
    logger.debug("stack_response: \n" + str(stack_response))

    try:
        stack = stack_response['Stacks'][0]
        #logger.debug("stack: " + str(stack))
        return stack
    except Exception:
        logger.error("Expected Stack, but none found " + stack_name)
        logger.error("Stack Trace:", traceback.format_exc())
        sys.exit(1)

def wait_for_stack_complete(client, stack_name):
    # check status 10 times over 5 minutes
    wait_secs = 30
    num_waits = 10

    stack = get_stack(client, stack_name)
    status = stack['StackStatus']
    logger.debug("Stack status: " + status)

    i = 0

    try:
      while (not status_complete(status)) and i<num_waits:
        logger.debug("status is " + status + ".  Waiting " + str(wait_secs) + "s")
        sleep(wait_secs)
        stack = get_stack(client, stack_name)
        status = stack['StackStatus']
        i += 1
    except Exception:
      logger.error("Failed while waiting for stack to complete.  stackname: " + stack_name + ";  status: " + status)

    if status_complete(status):
        return stack
    else:
        logger.error ("Cannot update RDS stack to multi-AZ because status is: " + status)
        sys.exit(1)


def status_complete(status):
    return status == 'UPDATE_COMPLETE' or status == 'CREATE_COMPLETE' or status == 'UPDATE_ROLLBACK_COMPLETE'

# This function checks the CloudFormation Parameter to determine if 
# single or multi AZ RDS has been deployed.
# It may be more precise to check RDS itself, but this saves the round-trip
def is_single_az(region, stack_name):
    # Create CloudFormation client
    logger.debug("Running function is_single_az in region " + region)
    client = boto3.client('cloudformation', region)

    # See if we can retrieve the stack
    try:

        stack = get_stack(client, stack_name)
        
        logger.debug("Stack Name: " + stack_name)
        logger.debug("Stack Status: " + stack['StackStatus'])

        if not status_complete(stack['StackStatus']):
            stack = wait_for_stack_complete(client, stack_name)

        rds_parameters = stack['Parameters']
        logger.debug("rds_parameters: \n" + str(rds_parameters))

        is_multi_az = find_in_parameters(rds_parameters, 'DBMultiAZ')

        if is_multi_az is None:
          logger.error("Unable to find parameter DBMultiAZ in stack " + stack_name)
          return False

        logger.debug("is_multi_az: " + is_multi_az)

        # Single AZ is boolean opposite if multi AZ
        return is_multi_az == "false"

    except ClientError as e:
        logger.debug("Stack will not be updated: Unexpected exception found looking for stack named " + stack_name)
        logger.debug("Client error:" + str(e.response))
        return False

    except Exception:
        logger.debug("Stack will not be updated: Unexpected exception found looking for stack named " + stack_name)
        logger.debug("Stack Trace: " + traceback.format_exc())
        return False


def lambda_handler(event, context):

    global logger
    logger = init_logging()
    logger = set_log_level(logger, os.environ.get('log_level', event['log_level']))

    logger.debug("Running function lambda_handler")
    logger.info('event:')
    logger.info(json.dumps(event))
    if (context != 0):
        logger.info('context.log_stream_name:' + context.log_stream_name)
        logger.info('context.log_group_name:' + context.log_group_name)
        logger.info('context.aws_request_id:' + context.aws_request_id)
    else:
        logger.info("No Context Object!")
    process_global_vars()

    # Check to see if the previous stacks were actually created
    vpc_stack_status = event['vpc']['status']
    if (status_complete(vpc_stack_status)):

        rds_stack_status = event['rds']['status']
        if (status_complete(rds_stack_status)):
            # If RDS is single-AZ, this update will make it multi-AZ
            if is_single_az(event['region_name'], stackname):
                logger.debug("Stack " + stackname + " is single-AZ; updating to multi-AZ")
                return update_rds(event)
            else:
                logger.debug("Stack " + stackname + " already multi-AZ")
                return_dict = {'stackname': stackname}
                return return_dict
        else:
            logger.debug("RDS Stack was not completely created: status = " + rds_stack_status)
            sys.exit(1)

    else:
        logger.debug("VPC Stack was not completely created: status = " + vpc_stack_status)
        sys.exit(1)


if __name__ == "__main__":
    logger = init_logging()
    event = {
        'log_level': 'DEBUG',
        'region_name': 'us-east-2',
        'cfn_region': 'us-east-2',
        'workshop': '300-ResiliencyofEC2RDSandS3',
        'cfn_bucket': 'aws-well-architected-labs-ohio',
        'folder': 'Reliability/',
        'vpc': {
            'stackname': 'ResiliencyVPC',
            'status': 'CREATE_COMPLETE'
        },
        'rds': {
            'stackname': 'MySQLforResiliencyTesting',
            'status': 'CREATE_COMPLETE'
        }
    }
    os.environ['log_level'] = os.environ.get('log_level', event['log_level'])

    logger = setup_local_logging(logger, os.environ['log_level'])

    # Add default level of debug for local execution
    lambda_handler(event, 0)
