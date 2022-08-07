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

# This Lambda (and the Step Function that invokes it) runs in one region.
# The CloudFormation stack for the DMS is deployed to another region
# Data flow Master (Ohio) --replication--> RR (Oregon) --DMS--> Master (Oregon)
AWS_REGION_SOURCE_DB = 'us-east-2' #Ohio
AWS_REGION_CFN_TEMPLATE = 'us-east-2' #Ohio
AWS_REGION_DMS_DEPLOY = 'us-west-2' #Oregon

stackname = 'DMSforResiliencyTesting'


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
        stackname = 'DMSforResiliencyTesting'
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


def get_db_password(db_region, parameter_name):
    db_region_client = boto3.client('ssm', db_region)
    parameter = db_region_client.get_parameter(
        Name=parameter_name,
        WithDecryption=True
    )
    return parameter['Parameter']['Value']



def deploy_dms(event):
    logger.debug("Running function deploy_dms")
    try:
        dms_deploy_region = event['secondary_region_name']
        source_db_region = event['region_name']
        cfn_s3_source_region = event['cfn_region']
        bucket = event['cfn_bucket']
        key_prefix = event['folder']
    except Exception:
        dms_deploy_region = AWS_REGION_DMS_DEPLOY
        source_db_region = os.environ.get('AWS_REGION', AWS_REGION_SOURCE_DB)
        cfn_s3_source_region = os.environ.get('AWS_REGION', AWS_REGION_CFN_TEMPLATE)
        bucket = "aws-well-architected-labs-ohio",
        key_prefix = "Reliability/"
    # Create CloudFormation client
    client = boto3.client('cloudformation', dms_deploy_region)

    # Get the outputs of the VPC stack
    vpc_stack = event['vpc']['stackname']
    try:
        stack_response = client.describe_stacks(StackName=vpc_stack)
        stack_list = stack_response['Stacks']
        if (len(stack_list) < 1):
            logger.debug("Cannot find stack named " + vpc_stack + ", so cannot parse outputs as inputs")
            sys.exit(1)
    except Exception:
        logger.debug("Cannot find stack named " + vpc_stack + ", so cannot parse outputs as inputs")
        sys.exit(1)
    vpc_outputs = stack_list[0]['Outputs']

    # Create the list of subnets to pass
    private_subnets = find_in_outputs(vpc_outputs, 'PrivateSubnets')
    subnet_list = private_subnets.split(',')
    if (len(subnet_list) < 2):
        logger.debug("Cannot find enough subnets in " + vpc_stack + ", so cannot deploy Multi-AZ")
        sys.exit(1)
    dms_subnet_list = subnet_list[0] + ',' + subnet_list[1]

    # Create the list of security groups to pass
    dms_sg = find_in_outputs(vpc_outputs, 'WebSecurityGroup')

    # Find the source DB endpoint and server name
    rds_replica_stack = event['rr']['stackname']
    try:
        stack_response = client.describe_stacks(StackName=rds_replica_stack)
        stack_list = stack_response['Stacks']
        if (len(stack_list) < 1):
            logger.debug("Cannot find stack named " + rds_replica_stack + ", so cannot parse outputs as inputs")
            sys.exit(1)
    except Exception:
        logger.debug("Cannot find stack named " + rds_replica_stack + ", so cannot parse outputs as inputs")
        sys.exit(1)
    rds_replica_outputs = stack_list[0]['Outputs']
    source_db_address = find_in_outputs(rds_replica_outputs, 'DBAddress')
    address_parsed = source_db_address.split('.')
    if (len(address_parsed) < 1):
        logger.debug("Cannot get the read replica (source) server from " + source_db_address)
        sys.exit(1)

    # Find the dest DB id
    rds_stack = event['rds']['stackname']
    try:
        stack_response = client.describe_stacks(StackName=rds_stack)
        stack_list = stack_response['Stacks']
        if (len(stack_list) < 1):
            logger.debug("Cannot find stack named " + rds_stack + ", so cannot parse outputs as inputs")
            sys.exit(1)
    except Exception:
        logger.debug("Cannot find stack named " + rds_stack + ", so cannot parse outputs as inputs")
        sys.exit(1)
    rds_outputs = stack_list[0]['Outputs']
    dest_db_address = find_in_outputs(rds_outputs, 'DBAddress')
    address_parsed = dest_db_address.split('.')
    if (len(address_parsed) < 1):
        logger.debug("Cannot get the destination RDS server from " + dest_db_address)
        sys.exit(1)

    # Get workshop name
    try:
        workshop_name = event['workshop']
    except Exception:
        logger.debug("Unexpected error! (when parsing workshop name)\n Stack Trace:", traceback.format_exc())
        workshop_name = 'UnknownWorkshop'

    # Get password for source database
    # Password for Read Replica in region2 is same as that for Primary in region 1
    source_db_password = get_db_password(source_db_region, workshop_name)

    # Get password for destination database
    # (would prefer to use dynamic parameter patterns directly from CloudFormation
    # but this is not supported for AWS::DMS::Endpoint 
    # https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/dynamic-references.html)
    dest_db_password = get_db_password(dms_deploy_region, workshop_name)


    # Get DB instance type only if it was specified (it is optional)
    try:
        if 'db_instance_class' in event:
          db_instance_class = event['db_instance_class']
        else:
          db_instance_class = None
    except Exception:
        logger.debug("Unexpected error! (when parsing DB instance class)\n Stack Trace:", traceback.format_exc())
        db_instance_class = None

    # Prepare the stack parameters
    dms_parameters = []
    dms_parameters.append({'ParameterKey': 'SourceDatabaseServer', 'ParameterValue': source_db_address, 'UsePreviousValue': True})
    dms_parameters.append({'ParameterKey': 'DestDatabaseServer', 'ParameterValue': dest_db_address, 'UsePreviousValue': True})
    dms_parameters.append({'ParameterKey': 'DatabaseName', 'ParameterValue': 'iptracker', 'UsePreviousValue': True})
    dms_parameters.append({'ParameterKey': 'MigrationSubnetIds', 'ParameterValue': dms_subnet_list, 'UsePreviousValue': True})
    dms_parameters.append({'ParameterKey': 'MigrationSecurityGroups', 'ParameterValue': dms_sg, 'UsePreviousValue': True})
    dms_parameters.append({'ParameterKey': 'SourceDBUser', 'ParameterValue': 'admin', 'UsePreviousValue': True})
    dms_parameters.append({'ParameterKey': 'DestDBPassword', 'ParameterValue': dest_db_password, 'UsePreviousValue': True})
    dms_parameters.append({'ParameterKey': 'SourceDBPassword', 'ParameterValue': source_db_password, 'UsePreviousValue': True})
    dms_parameters.append({'ParameterKey': 'DestDBUser', 'ParameterValue': 'admin', 'UsePreviousValue': True})
    dms_parameters.append({'ParameterKey': 'WorkshopName', 'ParameterValue': workshop_name, 'UsePreviousValue': True})
    # If DB instance class supplied then use it, otherwise CloudFormation template will use Parameter default
    if (db_instance_class is not None):
      dms_parameters.append({'ParameterKey': 'MigrationInstanceClass', 'ParameterValue': db_instance_class, 'UsePreviousValue': True})

    stack_tags = []
    stack_tags.append({'Key': 'Workshop', 'Value': 'AWSWellArchitectedReliability' + workshop_name})
    capabilities = []
    capabilities.append('CAPABILITY_NAMED_IAM')
    dms_template_s3_url = "https://s3." + cfn_s3_source_region + ".amazonaws.com/" + bucket + "/" + key_prefix + "dms.json"
    client.create_stack(
        StackName=stackname,
        TemplateURL=dms_template_s3_url,
        Parameters=dms_parameters,
        DisableRollback=False,
        TimeoutInMinutes=30,
        Capabilities=capabilities,
        Tags=stack_tags
    )
    return_dict = {'stackname': stackname}
    return return_dict


def check_stack(dms_deploy_region, stack_name):
    # Create CloudFormation client
    logger.debug("Running function check_stack in region " + dms_deploy_region)
    client = boto3.client('cloudformation', dms_deploy_region)

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
        if (e.response['Error']['Code'] == 'ValidationError'):
            return False
        else:
            logger.debug("Stack will not be created: Unexpected exception found looking for stack named " + stack_name)
            logger.debug("Client error:" + str(e.response))
            return True

    except Exception:
        logger.debug("Stack will not be created: Unexpected exception found looking for stack named " + stack_name)
        print("Stack Trace:", traceback.format_exc())
        return True


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

        # Make sure there is not already a DMS Stack in the secondary region

        # Temporary logic to disable DMS stack until we have a solution for cross region SSM secure paramters (to get dest DB password)
        # logger.debug("Stack " + stackname + " SKIPPED")
        # return_dict = {'stackname': stackname}
        # return return_dict

        dms_deploy_region = event['secondary_region_name']
        if not check_stack(dms_deploy_region, stackname):
            logger.debug("Stack " + stackname + " doesn't exist; creating")
            return deploy_dms(event)
        else:
            logger.debug("Stack " + stackname + " exists")
            return_dict = {'stackname': stackname}
            return return_dict

    except SystemExit:
        logger.error("Exiting")
        sys.exit(1)
    except ValueError:
        exit(1)
    except Exception:
        print("Unexpected error!\n Stack Trace:", traceback.format_exc())
    exit(0)


if __name__ == "__main__":
    logger = init_logging()
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
        "websiteimage": "https://aws-well-architected-labs-ohio.s3.us-east-2.amazonaws.com/images/Cirque_of_the_Towers.jpg",
        "vpc": {
            "stackname": "ResiliencyVPC",
            "status": "CREATE_COMPLETE"
        },
        "rds": {
            "stackname": "MySQLforResiliencyTesting",
            "status": "CREATE_COMPLETE"
        },
        "web": {
            "stackname": "WebServersForResiliencyTesting",
            "status": "CREATE_COMPLETE"
        },
        "rr": {
            "stackname": "MySQLReadReplicaResilienceTesting",
            "status": "CREATE_COMPLETE"
        }
    }
    os.environ['log_level'] = os.environ.get('log_level', event['log_level'])

    logger = setup_local_logging(logger, os.environ['log_level'])

    # Add default level of debug for local execution
    lambda_handler(event, 0)
