import json
import os

import boto3

from botocore.exceptions import ClientError

TABLE = boto3.resource("dynamodb").Table(os.environ["DDB_TABLE"])

def handler(event, context) -> dict:
	return sqsEvent(event["Records"])


def sqsEvent(records: list) -> dict:
	for r in records:
		body = json.loads(r["body"])
		try:
			TABLE.put_item(Item={
				"todo_id": r["messageId"],
				"content": body["content"],
				"created_date": r["attributes"]["SentTimestamp"],
				"completed": False,
			})
		except ClientError as e:
			raise e

def httpEvent(event: dict) -> dict:
	body = json.loads(event["body"])

	try:
		TABLE.put_item(Item={
			"todo_id": "123",
			"content": body["content"],
			"completed": False
		})
	except ClientError as e:
		return fail(str(e))
	
	return {
		"statusCode": 201,
		"body": json.dumps({
			"message": "done"
		})
	}

def fail(body: str) -> dict:
	return {
		"statusCode": 500,
		"body": json.dumps({
			"message": body,
		})
	}