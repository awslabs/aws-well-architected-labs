import boto3
from boto3.session import Session
from botocore.exceptions import ClientError
import json
import datetime
from json import JSONEncoder
import logging
import os

# subclass JSONEncoder
class DateTimeEncoder(JSONEncoder):
    # Override the default method
    def default(self, obj):
        if isinstance(obj, (datetime.date, datetime.datetime)):
            return obj.isoformat()


def main(account_id):
    list_region = lits_regions()
    with open(
        "/tmp/data.json", "w"
    ) as f:  # Saving in the temporay folder in the lambda
        session = assume_session(account_id)
        for region in list_region:
            client = session.client("ec2",region_name = region)
                        
            try:
                response = client.describe_images(Owners=["self"])

                for image in response["Images"]:
                    image['region']=region
                    dataJSONData = json.dumps(image, cls=DateTimeEncoder)  # indent=4,
                    f.write(dataJSONData)
                    f.write("\n")
            except Exception as e:
                print(e)
                pass
    


def assume_session(account_id):
    role_name = os.environ['ROLENAME']
    role_arn = f"arn:aws:iam::{account_id}:role/{role_name}"
    sts_client = boto3.client('sts')
    
    try:
        #region = sts_client.meta.region_name
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
    lambda_handler(None, None)