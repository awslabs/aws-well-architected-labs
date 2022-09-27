from turtle import pd
import boto3
import sys

#python3 s3_backwards_comp.py <payer_id> <ODC_your_bucket_name> 

payer_id = sys.argv[1]
your_bucket_name = sys.argv[2]

client = boto3.client('s3')

mods = ["budgets/", "rightsizing/", "rds_metrics/", "optics-data-collector/", "ecs-chargeback-data/", "Compute_Optimizer/"] 

for mod in mods:
    print(mod)
    response = client.list_objects_v2(Bucket= your_bucket_name, Prefix = mod)
    #import pdb; pdb.set_trace()
    for key in response['Contents']:
        try:
            source_key = key["Key"]
            x = source_key.split("/")[0]
            source_key_new = source_key.replace(f'{x}/', '')
            copy_source = {'Bucket': your_bucket_name, 'Key': source_key}
            client.copy_object(Bucket = your_bucket_name, CopySource = copy_source, Key =  f"{mod}/payer={payer_id}/{source_key_new}")
            client.delete_object(Bucket = your_bucket_name, Key = source_key)
        except:
            pass