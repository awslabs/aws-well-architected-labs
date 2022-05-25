import boto3
from boto3.session import Session
from botocore.exceptions import ClientError
import json
from json import JSONEncoder
import os
import logging
import datetime 
# subclass JSONEncoder
class DateTimeEncoder(JSONEncoder):
    # Override the default method
    def default(self, obj):
        if isinstance(obj, (datetime.date, datetime.datetime)):
            return obj.isoformat()

def main(account_id):
    list_region = lits_regions()
    with open("/tmp/data.json", "w") as f:  # Saving in the temporay folder in the lambda
        session = assume_session(account_id)      
        for region in list_region:
            print(region)
            client = session.client("ec2",region_name = region)
            try:
               
                paginator = client.get_paginator('describe_volumes')
                response_iterator = paginator.paginate()
                for response in response_iterator:
                    data = response["Volumes"][0]
                    data['region']=region
                    data['accountid']=account_id
                    dataJSONData = json.dumps(data, cls=DateTimeEncoder)  # indent=4,

                    f.write(dataJSONData)
                    f.write("\n")
                print(f"{region} ebs data collected")
            except Exception as e:
                print(e)
                pass

def assume_session(account_id):
    role_name = os.environ['ROLENAME']
    role_arn = f"arn:aws:iam::{account_id}:role/{role_name}" 
    sts_client = boto3.client('sts')
    
    try:

        assumedRoleObject = sts_client.assume_role(
            RoleArn=role_arn,
            RoleSessionName="AssumeRoleRoot"
            )
        
        credentials = assumedRoleObject['Credentials']
        session = Session(
            aws_access_key_id=credentials['AccessKeyId'],
            aws_secret_access_key=credentials['SecretAccessKey'],
            aws_session_token=credentials['SessionToken']
        )
        return session

    except ClientError as e:
        logging.warning(f"Unexpected error Account {account_id}: {e}")
        return None


def lits_regions():
    from boto3.session import Session

    s = Session()
    ecs_regions = s.get_available_regions('ecs')
    return ecs_regions


if __name__ == "__main__":
    main()