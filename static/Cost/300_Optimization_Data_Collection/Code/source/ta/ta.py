import boto3
import json
import datetime
import logging
from json import JSONEncoder
from datetime import date
from botocore.exceptions import ClientError
from botocore.client import Config
import os

# subclass JSONEncoder
class DateTimeEncoder(JSONEncoder):
    # Override the default method
    def default(self, obj):
        if isinstance(obj, (datetime.date, datetime.datetime)):
            return obj.isoformat()
def main(account_id):
    base = {"AccountId":account_id,"Category":"Cost Optimizing"}
    with open("/tmp/data.json", "w") as f:  # Saving in the temporay folder in the lambda
        support_client = assume_role(account_id, "support", "us-east-1")
        response = support_client.describe_trusted_advisor_checks(language="en")
        for case in response["checks"]:
            meta = case["metadata"]

            if case["category"] == "cost_optimizing":
                c_id = case["id"]
                CheckName = {"CheckName": case["name"], "CheckId": c_id}

                check_result = support_client.describe_trusted_advisor_check_result(
                    checkId=c_id, language="en"
                )
                
                

                p = '%Y-%m-%dT%H:%M:%SZ'
                mytime =check_result['result']['timestamp']
                epoch = datetime.datetime(1970, 1, 1)
                epoch_time = int((datetime.datetime.strptime(mytime, p) - epoch).total_seconds())      
                base.update({'DateTime':check_result['result']['timestamp'], 'Timestamp':epoch_time})

                for resource in check_result["result"]["flaggedResources"]: 
                    meta_result = dict(zip(meta, resource["metadata"]))
                    del resource['metadata']
                    resource["Region"] = resource.pop("region")
                    meta_result.update(base)
                    meta_result.update(CheckName)
                    meta_result.update(resource)
                    dataJSONData = json.dumps(meta_result, cls=DateTimeEncoder)

                    f.write(dataJSONData)
                    f.write("\n")

def assume_role(account_id, service, region):
    role_name = os.environ['ROLENAME']
    role_arn = f"arn:aws:iam::{account_id}:role/{role_name}" 
    sts_client = boto3.client('sts')
    
    try:
        assumedRoleObject = sts_client.assume_role(
            RoleArn=role_arn,
            RoleSessionName="AssumeRoleRoot"
            )
        
        credentials = assumedRoleObject['Credentials']
        client = boto3.client(
            service,
            aws_access_key_id=credentials['AccessKeyId'],
            aws_secret_access_key=credentials['SecretAccessKey'],
            aws_session_token=credentials['SessionToken'],
            region_name = region
        )
        return client

    except ClientError as e:
        logging.warning(f"Unexpected error Account {account_id}: {e}")
        return None


if __name__ == "__main__":
    accountid = os.environ['ACCOUNTID']
    main(accountid)





