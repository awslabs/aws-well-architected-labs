import json
import os

import boto3

from botocore.exceptions import ClientError

TABLE = boto3.resource("dynamodb").Table(os.environ["DDB_TABLE"])

def handler(event, context) -> dict:
    return httpEvent(event)

def httpEvent(event: dict) -> dict:
    if event["pathParameters"] is None and "id" not in event["pathParameters"]:
        return response("id not found in request", 400)

    id = event["pathParameters"]["id"]

    try:
        TABLE.delete_item(Key={
            "todo_id": id
        })
    except ClientError as e:
        return response(str(e), 500)

    return response("deleted {id}".format(id=id), 200)

def response(body: str, code: int=200) -> dict:
    return {
        "statusCode": code,
        "body": json.dumps({
            "message": body
        }),
        "headers": {
            "Access-Control-Allow-Origin": "*"
        }
    }