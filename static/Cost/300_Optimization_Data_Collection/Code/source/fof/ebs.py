import boto3
import json
from json import JSONEncoder
import os
import logging
import datetime 
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
            ec2 = boto3.resource("ec2", region_name=region)
            
            volumes = ec2.volumes.filter()
            volume_ids = [v.id for v in volumes]

            for vol in volume_ids:
                try:
                    
                    response = client.describe_volumes(VolumeIds=[vol])
                    data = response["Volumes"][0]

                    dataJSONData = json.dumps(data, cls=DateTimeEncoder)  # indent=4,

                    f.write(dataJSONData)
                    f.write("\n")
                except Exception as e:
                    print(e)
                    pass
# {"VolumeId": just print that }
def lits_regions():
    from boto3.session import Session

    s = Session()
    ecs_regions = s.get_available_regions('ecs')
    return ecs_regions


if __name__ == "__main__":
    main()