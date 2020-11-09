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

stackname = 'ResiliencyVPC'

AWS_REGION = 'us-east-2'


def init_logging():
    # Setup logging because debugging with print can get ugly.
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
        stackname = 'ResiliencyVPC'
    except SystemExit:
        sys.exit(1)
    except Exception:
        logger.debug("Unexpected error!\n Stack Trace:", traceback.format_exc())

def deploy_vpc(event):
    logger.debug("Running function deploy_vpc")
    try:
        region = event['region_name']
        cfn_region = event['cfn_region']
        bucket = event['cfn_bucket']
        key_prefix = event['folder']
    except Exception:
        logger.debug("Unexpected error!\n Stack Trace:", traceback.format_exc())
        region = os.environ.get('AWS_REGION', AWS_REGION)
        cfn_region = os.environ.get('AWS_REGION', AWS_REGION)
        bucket = "aws-well-architected-labs-ohio",
        key_prefix = "/"

    try:
        workshop_name = event['workshop']
    except Exception:
        logger.error("Unexpected error!\n Stack Trace:", traceback.format_exc())
        workshop_name = 'UnknownWorkshop'

    vpc_parameters = []
    vpc_parameters.append({'ParameterKey': 'BastionCidrIp', 'ParameterValue': '0.0.0.0/0', 'UsePreviousValue': True})
    vpc_parameters.append({'ParameterKey': 'VPCCidrBlock', 'ParameterValue': '10.0.0.0/16', 'UsePreviousValue': True})
    vpc_parameters.append({'ParameterKey': 'IGWCidrBlock1', 'ParameterValue': '10.0.0.0/20', 'UsePreviousValue': True})
    vpc_parameters.append({'ParameterKey': 'IGWCidrBlock2', 'ParameterValue': '10.0.16.0/20', 'UsePreviousValue': True})
    vpc_parameters.append({'ParameterKey': 'IGWCidrBlock3', 'ParameterValue': '10.0.32.0/20', 'UsePreviousValue': True})
    vpc_parameters.append({'ParameterKey': 'PrivateCidrBlock1', 'ParameterValue': '10.0.48.0/20', 'UsePreviousValue': True})
    vpc_parameters.append({'ParameterKey': 'PrivateCidrBlock2', 'ParameterValue': '10.0.64.0/20', 'UsePreviousValue': True})
    vpc_parameters.append({'ParameterKey': 'PrivateCidrBlock3', 'ParameterValue': '10.0.80.0/20', 'UsePreviousValue': True})
    vpc_parameters.append({'ParameterKey': 'AvailabilityZone1', 'ParameterValue': region + 'a', 'UsePreviousValue': True})
    vpc_parameters.append({'ParameterKey': 'AvailabilityZone2', 'ParameterValue': region + 'b', 'UsePreviousValue': True})
    vpc_parameters.append({'ParameterKey': 'AvailabilityZone3', 'ParameterValue': region + 'c', 'UsePreviousValue': True})
    vpc_parameters.append({'ParameterKey': 'WorkshopName', 'ParameterValue': workshop_name, 'UsePreviousValue': True})
    print(vpc_parameters)
    stack_tags = []

    vpc_template_s3_url = "https://s3." + cfn_region + ".amazonaws.com/" + bucket + "/" + key_prefix + "three_az_vpc_sg_nat.json"
    print(vpc_template_s3_url)
    stack_tags = []
    stack_tags.append({'Key': 'Workshop', 'Value': 'AWSWellArchitectedReliability' + workshop_name})

    # Create CloudFormation client
    cf_client = boto3.client('cloudformation', region_name=region)
    cf_client.create_stack(
        StackName=stackname,
        TemplateURL=vpc_template_s3_url,
        Parameters=vpc_parameters,
        DisableRollback=False,
        TimeoutInMinutes=10,
        Tags=stack_tags,
        Capabilities=[
            'CAPABILITY_NAMED_IAM'
        ]
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
        #  If the exception is that it doesn't exist, then check the client error before returning a value
        if(e.response['Error']['Code'] == 'ValidationError'):
            return False
        else:
            logger.debug("Stack will not be created: Unexpected exception found looking for stack named " + stack_name)
            logger.debug("Client error:" + str(e.response))
            return True
    except Exception:
        logger.debug("Stack will not be created: Unexpected exception found looking for stack named " + stack_name)
        logger.debug("Stack Trace:", traceback.format_exc())
        return True


def lambda_handler(event, context):
    # try:
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

    if not check_stack(event['region_name'], stackname):
        logger.debug("Stack " + stackname + " doesn't exist; creating")
        return deploy_vpc(event)
    else:
        logger.debug("Stack " + stackname + " exists")
        return_dict = {'stackname': stackname}
        return return_dict

    # except SystemExit:
    #     logger.error("Exiting")
    #     sys.exit(1)
    # except ValueError:
    #     exit(1)
    # except Exception:
    #     logger.debug("Unexpected error!\n Stack Trace:", traceback.format_exc())
    # exit(0)


if __name__ == "__main__":
    logger = init_logging()
    event = {
        'log_level': 'DEBUG',
        'region_name': 'us-west-2',
        'cfn_region': 'us-east-2',
        'workshop': 'LondonSummit',
        'cfn_bucket': 'aws-well-architected-labs-ohio',
        'folder': 'Reliability/'
    }
    os.environ['log_level'] = os.environ.get('log_level', event['log_level'])

    logger = setup_local_logging(logger, os.environ['log_level'])

    os.environ['AWS_REGION'] = os.environ.get('AWS_REGION', event['region_name'])

    # Add default level of debug for local execution
    lambda_handler(event, 0)
