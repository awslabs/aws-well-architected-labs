import json
import boto3
from datetime import datetime
from botocore.client import Config
from botocore.exceptions import ClientError
from datetime import date, timedelta
import os 
import logging

bucket = os.environ['BUCKET_NAME']

last_day_of_prev_month = date.today().replace(day=1) - timedelta(days=1)
start_day_of_prev_month = date.today().replace(day=1) - timedelta(days=last_day_of_prev_month.day)

s3_client = boto3.client('s3')
today = date.today()
year = today.year
month = today.month

def lambda_handler(event, context):
    event = {'Records': [{'messageId': 'a520aa0d-9b42-4ee3-8ee9-906feee83c69', 'receiptHandle': 'AQEBmuXPrJ+kjS1/e8eg6nqhkkmSk8SWoaLgv1wgWaPQVkfVjLdJvZzcb8wbh4Yug5WajIy9k7M7LC6rRLtz+Qu/sUTDUX42CZOdSK/kEOFsZKfjoXoqNJHyatOOo7KZQluAl7Ao2tz1ls5+hpZtF2QhjNQFRE9BWDUmMSGHGvVjuNWUP0BDa7/qent4y5FhkSGcGDrtcZX7PbbzherQdhK5McqqgfC6sCHmKA6zwn9CSWxiPpGU2MSAgHxfDjsbjryY9rWR9CJRduhV8MYBCpqjqZa+eZfgMuhcFaK2COTmQOEQSqJkFBnFco+tFYG8meE0x9tQ5EDg67k+8l7WZp57iT15wzh0RpMy4fdlSVw/VSujtVFPfaOrW4phLpC/DTpp+27DfeTQ1XGGelRI9UKUru1/1pXM1rsWn4Zc9CzVBYs=', 'body': '{"account_id": "806331864324", "account_name": "xianshutrainingbilling"}', 'attributes': {'ApproximateReceiveCount': '1', 'SentTimestamp': '1664789470228', 'SenderId': 'AROAYQJSXGSHNS7FPPLME:AWS-Organization-Account-Collector', 'ApproximateFirstReceiveTimestamp': '1664789472228'}, 'messageAttributes': {}, 'md5OfBody': '49159a8328f27c1bb3ccf038332deaed', 'eventSource': 'aws:sqs', 'eventSourceARN': 'arn:aws:sqs:us-east-1:584758801550:TransitGatewayModule-TaskQueue', 'awsRegion': 'us-east-1'}]}

    print(event)
    for record in event['Records']:
        body = json.loads(record["body"])
        account_id = body["account_id"]
        account_name = body["account_name"]
        print(account_id)
        regions = get_supported_regions()
        for region_name in regions: 
            print(region_name)
            
            try:
                cw_client = assume_role('cloudwatch', account_id, region_name['RegionName'])
                ec2_client = assume_role('ec2', account_id, )
                tgw_attachment_results = []
                final_result = []
                list_tgw_attachments = ec2_client.describe_transit_gateway_attachments()
                print(list_tgw_attachments)
                for item in list_tgw_attachments['TransitGatewayAttachments']:
                    tgw_attachment_results.append(item)
                
                cw_result = []
                for item in tgw_attachment_results:
                    response_in = metrics(cw_client, 'BytesIn', item)
                    print(response_in)
                    
                    with open("/tmp/data.json", "w") as f:
                        region_name['RegionName']
                        for cwitem in response_in['MetricDataResults']:
                            cw_results = {
                                    'TGW': item['TransitGatewayId'],
                                    'NetworkingAccount': item['TransitGatewayOwnerId'],
                                    'CustomerAccount': item['ResourceOwnerId'],
                                    'TGW-Attachment': item['TransitGatewayAttachmentId'],
                                    'BytesIn': cwitem['Values'],
                                    'Region': region_name['RegionName']
                                }
                    
                        response_out = metrics(cw_client, 'BytesOut', item)
                        print(response_out)
                            
                        for cwitemout in response_out['MetricDataResults']:
                            cw_results['BytesOut']= cwitemout['Values']
                            print (cw_results)
                            jsondata = json.dumps(cw_results) 
                            f.write(jsondata)
                            f.write('\n')
                                                
                    s3 = boto3.client("s3", config=Config(s3={"addressing_style": "path"}))
                    s3.upload_file(
                        "/tmp/data.json",
                        bucket,
                        f"{os.environ['TABLE']}/year={year}/month={month}/tgw-{item['TransitGatewayAttachmentId']}-{region_name}.json")

            except Exception as e:
                # Send some context about this error to Lambda Logs
                logging.warning("%s" % e)
                continue
            
    start_crawler()
    print("Done")

def metrics(cw_client, byte, item):
    cw_data = cw_client.get_metric_data(
            MetricDataQueries=[
                    {
                        'Id': 'tgwMetric',
                        'MetricStat': {
                            'Metric': {
                                'Namespace': 'AWS/TransitGateway',
                                'MetricName': f'{byte}',
                                'Dimensions': [
                                    {
                                        'Name': 'TransitGatewayAttachment',
                                        'Value': item['TransitGatewayAttachmentId']
                                    },
                                    {
                                        'Name': 'TransitGateway',
                                        'Value': item['TransitGatewayId']
                                    },
                                ]
                            },
                            'Period': 2592000,
                            'Stat': 'Sum',
                        },
                        'ReturnData': True},
                ],
                StartTime=start_day_of_prev_month.strftime("%Y-%m-%dT%H:%M:%SZ"),
                EndTime=last_day_of_prev_month.strftime("%Y-%m-%dT%H:%M:%SZ"),
                ScanBy='TimestampDescending'
            )

    return cw_data

def assume_role(service, account_id, region_name):
    role_name = os.environ['ROLENAME']
    role_arn = f"arn:aws:iam::{account_id}:role/{role_name}"
    sts_client = boto3.client('sts')
    
    try:
        assumedRoleObject = sts_client.assume_role(
            RoleArn=role_arn,
            RoleSessionName="cross_acct_lambda"
            )
        
        credentials = assumedRoleObject['Credentials']
        client = boto3.client(
            service, 
            region_name=region_name,
            aws_access_key_id=credentials['AccessKeyId'],
            aws_secret_access_key=credentials['SecretAccessKey'],
            aws_session_token=credentials['SessionToken']
        )
        print(f"role retrived {service}")
        return client
    
    except ClientError as e:
        logging.warning(f"Unexpected error Account {account_id}: {e}")
        return None

def start_crawler():
    glue_client = boto3.client("glue")
    Crawler_Name = os.environ["CRAWLER_NAME"]
    try:
        glue_client.start_crawler(Name=Crawler_Name)
        print(f"{Crawler_Name} has been started")
    except Exception as e:
        # Send some context about this error to Lambda Logs
        logging.warning("%s" % e)

def get_supported_regions():
    response = []              
    ec2_c = boto3.client('ec2')
    response = ec2_c.describe_regions()
    return response['Regions'] if response['Regions'] else []

lambda_handler(None, None)


