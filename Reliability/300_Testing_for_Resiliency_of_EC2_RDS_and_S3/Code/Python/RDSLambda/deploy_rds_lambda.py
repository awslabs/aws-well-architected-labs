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
import os
import sys
import logging
import traceback
import boto3
import json


LOG_LEVELS = {'CRITICAL': 50, 'ERROR': 40, 'WARNING': 30, 'INFO': 20, 'DEBUG': 10}

AWS_REGION = 'us-east-2'

stackname = 'MySQLforResiliencyTesting'


def init_logging():
    # Setup loggin because debugging with print can get ugly.
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


def find_in_outputs(outputs, key_to_find):
    output_string = None
    for output in outputs:
        if (output['OutputKey'] == key_to_find):
            output_string = output['OutputValue']
            break
    return output_string


def deploy_rds(event):
    logger.debug("Running function deploy_rds")
    try:
        region = event['region_name']
        cfn_region = event['cfn_region']
        bucket = event['cfn_bucket']
        key_prefix = event['folder']
    except Exception:
        logger.error("Unexpected error!\n Stack Trace:", traceback.format_exc())
        region = os.environ.get('AWS_REGION', AWS_REGION)
        cfn_region = os.environ.get('AWS_REGION', AWS_REGION)
        bucket = "arc327-well-architected-for-reliability",
        key_prefix = "/"
    # Create CloudFormation client
    client = boto3.client('cloudformation', region)

    # Get the outputs of the VPC stack
    vpc_stack = event['vpc']['stackname']
    try:
        stack_response = client.describe_stacks(StackName=vpc_stack)
        stack_list = stack_response['Stacks']
        if (len(stack_list) < 1):
            logger.debug("Cannot find stack named " + vpc_stack + ", so cannot parse outputs as inputs")
            sys.exit(1)
    except Exception:
        logger.error("Unexpected error!\n Stack Trace:", traceback.format_exc())
        logger.error("Cannot find stack named " + vpc_stack + ", so cannot parse outputs as inputs")
        sys.exit(1)
    vpc_outputs = stack_list[0]['Outputs']

    # Create the list of subnets to pass
    private_subnets = find_in_outputs(vpc_outputs, 'PrivateSubnets')
    subnet_list = private_subnets.split(',')
    if (len(subnet_list) < 2):
        logger.debug("Cannot find enough subnets in " + vpc_stack + ", so cannot deploy Multi-AZ")
        sys.exit(1)
    rds_subnet_list = subnet_list[0] + ',' + subnet_list[1]

    # Create the list of security groups to pass
    rds_sg = find_in_outputs(vpc_outputs, 'MySQLSecurityGroup')

    try:
        workshop_name = event['workshop']
    except Exception:
        logger.debug("Unexpected error!\n Stack Trace:", traceback.format_exc())
        workshop_name = 'UnknownWorkshop'

    # Prepare the stack parameters
    rds_parameters = []
    rds_parameters.append({'ParameterKey': 'DBSubnetIds', 'ParameterValue': rds_subnet_list, 'UsePreviousValue': True})
    rds_parameters.append({'ParameterKey': 'DBSecurityGroups', 'ParameterValue': rds_sg, 'UsePreviousValue': True})
    rds_parameters.append({'ParameterKey': 'DBInstanceClass', 'ParameterValue': 'db.t2.xlarge', 'UsePreviousValue': True})
    rds_parameters.append({'ParameterKey': 'DBUser', 'ParameterValue': 'admin', 'UsePreviousValue': True})
    rds_parameters.append({'ParameterKey': 'WorkshopName', 'ParameterValue': workshop_name, 'UsePreviousValue': True})
    stack_tags = []

    stack_tags.append({'Key': 'Workshop', 'Value': 'AWSWellArchitectedReliability' + workshop_name})
    rds_template_s3_url = "https://s3." + cfn_region + ".amazonaws.com/" + bucket + "/" + key_prefix + "mySQL_rds.json"
    client.create_stack(
        StackName=stackname,
        TemplateURL=rds_template_s3_url,
        Parameters=rds_parameters,
        DisableRollback=False,
        TimeoutInMinutes=30,
        Tags=stack_tags
    )
    return_dict = {'stackname': stackname}
    return return_dict


def check_stack(region, stack_name):
    # Create CloudFormation client
    logger.debug("Running function check_stack in region " + region)
    client = boto3.client('cloudformation', region)

    # See if you can retrieve the stack
    try:
        stack_response = client.describe_stacks(StackName=stack_name)
        stack_list = stack_response['Stacks']
        if (len(stack_list) < 1):
            logger.debug("No Stack named " + stack_name)
            return False
        logger.debug("Found stack named " + stack_name)
        logger.debug("Status: " + stack_list[0]['StackStatus'])
        return True
    except ClientError as e:
        # If the exception is that it doesn't exist, then check the client error before returning a value
        if (e.response['Error']['Code'] == 'ValidationError'):
            return False
        else:
            logger.debug("Stack will not be created: Unexpected exception found looking for stack named " + stack_name)
            logger.debug(e.response)
            return True

    except Exception:
        logger.debug("Stack will not be created: Unexpected exception found looking for stack named " + stack_name)
        logger.debug("Stack Trace:", traceback.format_exc())
        return True


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

    # Check to see if the previous stack was actually created
    vpc_stack_status = event['vpc']['status']
    if (vpc_stack_status == 'CREATE_COMPLETE'):

        if not check_stack(event['region_name'], stackname):
            logger.debug("Stack " + stackname + " doesn't exist; creating")
            return deploy_rds(event)
        else:
            logger.debug("Stack " + stackname + " exists")
            return_dict = {'stackname': stackname}
            return return_dict
    else:
        logger.debug("Stack " + stackname + " was not completely created: status = " + vpc_stack_status)
        sys.exit(1)
    return


if __name__ == "__main__":
    logger = init_logging()
    event = {
        'log_level': 'DEBUG',
        'region_name': 'us-east-2',
        'cfn_region': 'us-east-2',
        'workshop': 're:invent ARC403',
        'cfn_bucket': 'aws-well-architected-labs-ohio',
        'folder': 'Reliability/',
        'vpc': {
            'stackname': 'ResiliencyVPC',
            'status': 'CREATE_COMPLETE'
        }
    }
    os.environ['log_level'] = os.environ.get('log_level', event['log_level'])

    logger = setup_local_logging(logger, os.environ['log_level'])

    # Add default level of debug for local execution
    lambda_handler(event, 0)
