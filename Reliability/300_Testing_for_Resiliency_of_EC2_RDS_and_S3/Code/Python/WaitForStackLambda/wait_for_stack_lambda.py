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
from time import sleep
import os
import sys
import logging
import traceback
import boto3
import json

LOG_LEVELS = {'CRITICAL': 50, 'ERROR': 40, 'WARNING': 30, 'INFO': 20, 'DEBUG': 10}


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
#    try:
#        global something
#        something = this
#    except SystemExit:
#        sys.exit(1)
#    except:
#        logger.error("Unexpected error!\n Stack Trace:", traceback.format_exc())

# CloudFormation status: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/using-cfn-describing-stacks.html
def stack_status_in_progress(status):
  return status.endswith('IN_PROGRESS') and not (status == 'UPDATE_COMPLETE_CLEANUP_IN_PROGRESS')

def wait_for_stack(region, stack_id, context):

    # Create CloudFormation client
    logger.debug("Running function wait_for_stack")
    client = boto3.client('cloudformation', region)

    stack_building = True
    stack_status = 'CREATE_FAILED'
    while stack_building is True:
        try:
            stack_response = client.describe_stacks(StackName=stack_id)
            stack_list = stack_response['Stacks']
            if (len(stack_list) < 1):
                logger.debug("No Stack named " + stack_id)
                break
            logger.debug("Found stack named " + stack_id)
            stack_status = stack_list[0]['StackStatus']
            logger.debug("Status: " + stack_status)
            stack_building = stack_status_in_progress(stack_status)
            if not stack_building:
                break
            if (context != 0):
                time_remaining = context.get_remaining_time_in_millis()
            else:
                time_remaining = 50000
            if (time_remaining > 40000):
                logger.debug("still waiting: time (MS) left to execute: {}".format(time_remaining))
                sleep(30)
            # timeout and return stack status to state machine for it to deal with it.
            else:
                logger.debug("TIMED OUT waiting on stack: " + stack_id)
                logger.debug("status: " + stack_status)
                logger.debug("region: " + region)
                break
        except:
            logger.debug("Unexpected error!\n Stack Trace:", traceback.format_exc())
            logger.debug("Exception when checking for stack named " + stack_id)

    return_dict = {'stackname': stack_id, 'status': stack_status}
    return return_dict


def lambda_handler(event, context):
    try:
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
        try:
            stack_to_check = event['dms']['stackname']
            return wait_for_stack(event['secondary_region_name'], stack_to_check, context)
        except:
            try:
                stack_to_check = event['rr']['stackname']
                return wait_for_stack(event['secondary_region_name'], stack_to_check, context)
            except:
                try:
                    stack_to_check = event['web']['stackname']
                    return wait_for_stack(event['region_name'], stack_to_check, context)
                except:
                    try:
                        stack_to_check = event['rds']['stackname']
                        return wait_for_stack(event['region_name'], stack_to_check, context)
                    except:
                        stack_to_check = event['vpc']['stackname']
                        return wait_for_stack(event['region_name'], stack_to_check, context)
    except SystemExit:
        logger.error("Exiting")
        sys.exit(1)
    except ValueError:
        exit(1)
    except:
        print("Unexpected error!\n Stack Trace:", traceback.format_exc())
        exit(0)


if __name__ == "__main__":
    event = {
        "log_level": "DEBUG",
        "region_name": "us-east-2",
        "secondary_region_name": "us-west-2",
        "cfn_region": "us-east-2",
        "cfn_bucket": "aws-well-architected-labs-ohio",
        "folder": "Reliability/",
        "workshop": "300-ResiliencyofEC2RDSandS3",
        "boot_bucket": "aws-well-architected-labs-ohio",
        "boot_prefix": "Reliability/",
        "vpc": {
            "stackname": "ResiliencyVPC",
            "status": "CREATE_COMPLETE"
        },
        "rds": {
            "stackname": "MySQLforResiliencyTesting"
        }
    }
    logger = init_logging()
    os.environ['log_level'] = os.environ.get('log_level', event['log_level'])

    logger = setup_local_logging(logger, os.environ['log_level'])

    # Add default level of debug for local execution
    lambda_handler(event, 0)
