import json
from ec2_metadata import ec2_metadata

# For Database
import boto3

# Get the service resource. @TODO use EC2 metadata (ec2_metadata.region)


client = boto3.client('dynamodb', 'us-east-2')

# @TODO, read file from S3 or github
file = open('../Data/serviceCallMocks.json')
request_items = json.loads(file.read())
response = client.batch_write_item(RequestItems=request_items)

# @TODO add error handling 