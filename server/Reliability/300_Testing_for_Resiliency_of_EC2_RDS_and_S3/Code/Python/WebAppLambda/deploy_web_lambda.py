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

stackname = 'WebServersForResiliencyTesting'

AWS_REGION = 'us-east-2'


ARCH_TO_AMI_NAME_PATTERN = {
    # Architecture: (pattern, owner)
    "PV64": ("amzn2-ami-pv*.x86_64-ebs", "amazon"),
    "HVM64": ("amzn2-ami-hvm-*-x86_64-gp2", "amazon"),
    "HVMG2": ("amzn2-ami-graphics-hvm-*x86_64-ebs*", "679593333241")
}


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
        stackname = 'WebServersForResiliencyTesting'
    except SystemExit:
        sys.exit(1)
    except Exception:
        logger.error("Unexpected error!\n Stack Trace:", traceback.format_exc())


def find_latest_ami_name(region, arch):
    assert region, "Region is not defined"
    assert arch, "Architecture is not defined"
    assert arch in ARCH_TO_AMI_NAME_PATTERN, \
        "Architecture must be one of {}".format(
            ARCH_TO_AMI_NAME_PATTERN.keys())
    pattern, owner = ARCH_TO_AMI_NAME_PATTERN[arch]
    ec2 = boto3.client("ec2", region_name=region)
    images = ec2.describe_images(
        Filters=[dict(
            Name="name",
            Values=[pattern]
        )],
        Owners=[owner]
    ).get("Images", [])
    assert images, "No images were found"
    sorted_images = sorted(
        images,
        key=lambda image: image["CreationDate"],
        reverse=True
    )
    latest_image = sorted_images[0]
    return latest_image["ImageId"]


def find_in_outputs(outputs, key_to_find):
    output_string = None
    for output in outputs:
        if (output['OutputKey'] == key_to_find):
            output_string = output['OutputValue']
            break
    return output_string


def get_password_from_ssm(parameter_name, region):
    client = boto3.client('ssm', region_name=region)
    logger.debug("Getting pwd from SSM parameter store.")
    value = client.get_parameter(
        Name=parameter_name,
        WithDecryption=True
    )
    return value['Parameter']['Value']


def deploy_web_servers(event):
    logger.debug("Running function deploy_web_servers")
    try:
        region = event['region_name']
        cfn_region = event['cfn_region']
        bucket = event['cfn_bucket']
        key_prefix = event['folder']
    except Exception:
        region = os.environ.get('AWS_REGION', AWS_REGION)
        cfn_region = os.environ.get('AWS_REGION', AWS_REGION)
        bucket = "aws-well-architected-labs-ohio",
        key_prefix = "/"
    # Create CloudFormation client
    client = boto3.client('cloudformation', region)

    # Get the S3 bucket the boot script is in, and the object to retrieve and the image to display
    boot_bucket = event['boot_bucket']
    boot_prefix = event['boot_prefix']
    if 'boot_object' in event:
      boot_object = event['boot_object']
    else:
      boot_object = None
    websiteimage = event['websiteimage']

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

    try:
        workshop_name = event['workshop']
    except Exception:
        logger.debug("Unexpected error!\n Stack Trace:", traceback.format_exc())
        workshop_name = 'UnknownWorkshop'

    # Create the list of subnets to pass
    igw_subnets = find_in_outputs(vpc_outputs, 'IGWSubnets')
    private_subnets = find_in_outputs(vpc_outputs, 'PrivateSubnets')

    # Get the VPC
    vpcid = find_in_outputs(vpc_outputs, 'VPC')

    # Get the list of security groups to pass
    elb_sg = find_in_outputs(vpc_outputs, 'WebELBSecurityGroup')
    web_sg = find_in_outputs(vpc_outputs, 'WebSecurityGroup')
    bastion_sg = find_in_outputs(vpc_outputs, 'BastionSecurityGroup')
    webserver_sg_list = web_sg + ',' + bastion_sg

    # Run in zones a, b, and c
    azs = region + "a," + region + "b," + region + "c"

    # Get the latest AMI
    latest_ami = find_latest_ami_name(region, "HVM64")

    # Get the outputs of the RDS stack
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
    try:
        workshop_name = event['workshop']
    except Exception:
        workshop_name = 'UnknownWorkshop'

    rds_outputs = stack_list[0]['Outputs']

    # Get the hostname of the RDS host
    rds_host = find_in_outputs(rds_outputs, 'DBAddress')

    rds_password = get_password_from_ssm(workshop_name, region)

    # Prepare the stack parameters
    webserver_parameters = []
    webserver_parameters.append({'ParameterKey': 'VPCID', 'ParameterValue': vpcid, 'UsePreviousValue': True})
    webserver_parameters.append({'ParameterKey': 'WebServerSecurityGroups', 'ParameterValue': webserver_sg_list, 'UsePreviousValue': True})
    webserver_parameters.append({'ParameterKey': 'WebLoadBalancerSG', 'ParameterValue': elb_sg, 'UsePreviousValue': True})
    webserver_parameters.append({'ParameterKey': 'WebLoadBalancerSubnets', 'ParameterValue': igw_subnets, 'UsePreviousValue': True})
    webserver_parameters.append({'ParameterKey': 'WebServerSubnets', 'ParameterValue': private_subnets, 'UsePreviousValue': True})
    webserver_parameters.append({'ParameterKey': 'WebServerInstanceType', 'ParameterValue': 't2.micro', 'UsePreviousValue': True})
    webserver_parameters.append({'ParameterKey': 'WebServerAMI', 'ParameterValue': latest_ami, 'UsePreviousValue': False})
    webserver_parameters.append({'ParameterKey': 'AvailabilityZones', 'ParameterValue': azs, 'UsePreviousValue': True})
    webserver_parameters.append({'ParameterKey': 'BootBucketRegion', 'ParameterValue': cfn_region, 'UsePreviousValue': True})
    webserver_parameters.append({'ParameterKey': 'BootBucket', 'ParameterValue': boot_bucket, 'UsePreviousValue': True})
    webserver_parameters.append({'ParameterKey': 'BootPrefix', 'ParameterValue': boot_prefix, 'UsePreviousValue': True})
    webserver_parameters.append({'ParameterKey': 'WebSiteImage', 'ParameterValue': websiteimage, 'UsePreviousValue': True})
    webserver_parameters.append({'ParameterKey': 'RDSHostName', 'ParameterValue': rds_host, 'UsePreviousValue': True})
    webserver_parameters.append({'ParameterKey': 'RDSUser', 'ParameterValue': 'admin', 'UsePreviousValue': True})
    webserver_parameters.append({'ParameterKey': 'RDSPassword', 'ParameterValue': rds_password, 'UsePreviousValue': False})
    
    # If Boot Object is supplied then use it, otherwise CloudFormation template will use Parameter default
    if boot_object is not None: 
      webserver_parameters.append({'ParameterKey': 'BootObject', 'ParameterValue': boot_object, 'UsePreviousValue': True})
    
    stack_tags = []

    stack_tags.append({'Key': 'Workshop', 'Value': 'AWSWellArchitectedReliability' + workshop_name})
    capabilities = []
    capabilities.append('CAPABILITY_NAMED_IAM')
    web_template_s3_url = "https://s3." + cfn_region + ".amazonaws.com/" + bucket + "/" + key_prefix + "web_server_autoscaling.json"
    client.create_stack(
        StackName=stackname,
        TemplateURL=web_template_s3_url,
        Parameters=webserver_parameters,
        DisableRollback=False,
        TimeoutInMinutes=10,
        Capabilities=capabilities,
        Tags=stack_tags
    )
    return_dict = {'stackname': stackname}
    return return_dict


def check_stack(region, stack_name):
    # Create CloudFormation client
    logger.debug("Running function check_stack in region " + region)
    logger.debug("Running function check_stack on stack " + stack_name)
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
            logger.debug("Client error:" + str(e.response))
            return True

    except Exception:
        logger.debug("Stack will not be created: Unexpected exception found looking for stack named " + stack_name)
        print("Stack Trace:", traceback.format_exc())
        return True

def status_complete(status):
    return status == 'UPDATE_COMPLETE' or status == 'CREATE_COMPLETE' or status == 'UPDATE_ROLLBACK_COMPLETE'

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

        # Check to see if the previous stack was actually created
        vpc_stack_status = event['vpc']['status']
        if (status_complete(vpc_stack_status)):

            rds_stack_status = event['rds']['status']
            if (status_complete(rds_stack_status)):
                if not check_stack(event['region_name'], stackname):
                    logger.debug("Stack " + stackname + " doesn't exist; creating")
                    return deploy_web_servers(event)
                else:
                    logger.debug("Stack " + stackname + " exists")
                    return_dict = {'stackname': stackname}
                    return return_dict
            else:
                logger.debug("RDS Stack was not completely created: status = " + rds_stack_status)
                sys.exit(1)

        else:
            logger.debug("VPC Stack was not completely created: status = " + vpc_stack_status)
            sys.exit(1)

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
        'vpc': {
            'stackname': 'ResiliencyVPC',
            'status': 'CREATE_COMPLETE'
        },
        'rds': {
            'stackname': 'MySQLforResiliencyTesting',
            'status': 'CREATE_COMPLETE'
        },
        'log_level': 'DEBUG',
        'region_name': 'us-west-2',
        'cfn_region': 'us-east-2',
        'cfn_bucket': 'aws-well-architected-labs-ohio',
        'folder': 'Reliability/',
        'boot_bucket': 'aws-well-architected-labs-ohio',
        'boot_prefix': 'Reliability/',
        'boot_object': 'bootstrapARC327.sh',
        'websiteimage': 'https://aws-well-architected-labs-ohio.s3.us-east-2.amazonaws.com/images/Cirque_of_the_Towers.jpg',
        'workshop': 'LondonSummit'
    }
    os.environ['log_level'] = os.environ.get('log_level', event['log_level'])

    logger = setup_local_logging(logger, os.environ['log_level'])

    # Add default level of debug for local execution
    lambda_handler(event, 0)
