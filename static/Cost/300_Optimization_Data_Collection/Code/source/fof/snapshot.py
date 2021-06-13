import boto3
import json
import datetime
import logging
from json import JSONEncoder
import os

# subclass JSONEncoder
class DateTimeEncoder(JSONEncoder):
    # Override the default method
    def default(self, obj):
        if isinstance(obj, (datetime.date, datetime.datetime)):
            return obj.isoformat()
def main():
    client = boto3.client("ec2")
    response = client.describe_regions().get("Regions")
    regions = [item.get("RegionName") for item in response]
    with open("/tmp/data.json", "w") as f:  # Saving in the temporay folder in the lambda
        for region in regions:
            print(region)
            ec2 = boto3.client("ec2", region_name=region)
            try:
                response = ec2.describe_snapshots(OwnerIds=["self"])

                for image in response["Snapshots"]:
                    
                    dataJSONData = json.dumps(image, cls=DateTimeEncoder)  # indent=4,

                    # jsondata = json.dumps(data) #converts datetime to be able to placed in json

                    f.write(dataJSONData)
                    f.write("\n")
            except Exception as e:
                            print(e)
                            pass

if __name__ == "__main__":
    main()