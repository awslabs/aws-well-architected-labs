import boto3
import json
import datetime
import logging
from json import JSONEncoder
from datetime import date
from botocore.client import Config
import os

# subclass JSONEncoder
class DateTimeEncoder(JSONEncoder):
    # Override the default method
    def default(self, obj):
        if isinstance(obj, (datetime.date, datetime.datetime)):
            return obj.isoformat()
def main():
    with open("/tmp/data.json", "w") as f:  # Saving in the temporay folder in the lambda

        support_client = boto3.client("support", region_name="us-east-1")
        response = support_client.describe_trusted_advisor_checks(language="en")
        for case in response["checks"]:
            meta = case["metadata"]
            if case["category"] == "cost_optimizing":
                c_id = case["id"]
                check_name = {"name": case["name"], "id": c_id}

                check_result = support_client.describe_trusted_advisor_check_result(
                    checkId=c_id, language="en"
                )

                if check_result["result"]["status"] == "warning":
                    flaggedResources = {
                        "flaggedResources": check_result["result"]["flaggedResources"]
                    }

                    for resource in flaggedResources.get("flaggedResources"):
                        meta_result = dict(zip(meta, resource["metadata"]))

                f.write(check_result)
                f.write("\n")

if __name__ == "__main__":
    main()