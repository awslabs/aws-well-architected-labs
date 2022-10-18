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

    body = json.loads(event["body"])
    update = {}

    if body["content"] is not None:
        update["content"] =  {"Value": body["content"], "Action": "PUT"}
    if body["completed"] is not None:
        update["completed"] = {"Value": body["completed"], "Action": "PUT"}

    try:
        TABLE.update_item(
            Key={"todo_id": id},
            AttributeUpdates={
                "content": {"Value": body["content"], "Action": "PUT"},
                "completed": {"Value": body["completed"], "Action": "PUT" }
            }
        )
    except ClientError as e:
        return response(str(e), 500)

    return response("updated {id}".format(id=id), 200)

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