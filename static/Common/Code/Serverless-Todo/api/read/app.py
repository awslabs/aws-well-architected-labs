import json
import os

import boto3

from botocore.exceptions import ClientError

TABLE = boto3.resource("dynamodb").Table(os.environ["DDB_TABLE"])

def handler(event, context) -> dict:
    return httpEvent(event)

def httpEvent(event: dict) -> dict:
    try:
        results = TABLE.scan()
    except ClientError as e:
        return response(str(e), 500)

    return response("ok", 200, results["Items"])

def response(body: str, code: int=200, data: list=None) -> dict:
    return {
        "statusCode": code,
        "body": json.dumps({
            "message": body,
            "data": data
        }),
        "headers": {
            "Access-Control-Allow-Origin": "*"
        }
    }