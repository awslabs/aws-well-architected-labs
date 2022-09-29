from turtle import pd
import boto3
import sys
import logging 
#python3 s3_backwards_comp.py <payer_id> <ODC_your_bucket_name> 

payer_id = sys.argv[1]
your_bucket_name = sys.argv[2]

client = boto3.client('s3')

mods = ["ecs-chargeback-data/", "rds_metrics/rds_stats/", "budgets/", "rightsizing/","optics-data-collector/ami-data/","optics-data-collector/ebs-data/", "optics-data-collector/snapshot-data/","optics-data-collector/ta-data/", "Compute_Optimizer/Compute_Optimizer_ec2_instance/", "Compute_Optimizer/Compute_Optimizer_auto_scale/", "Compute_Optimizer/Compute_Optimizer_lambda/", "Compute_Optimizer/Compute_Optimizer_ebs_volume/", "reserveinstance/", "savingsplan/"]

for mod in mods:
    print(mod)
    response = client.list_objects_v2(Bucket= your_bucket_name, Prefix = mod)
    #import pdb; pdb.set_trace()
    try:
        for key in response['Contents']:
            source_key = key["Key"]
            if 'payer_id' not in source_key:
                x = source_key.split("/")[0]
                source_key_new = source_key.replace(mod, '')
                copy_source = {'Bucket': your_bucket_name, 'Key': source_key}
                client.copy_object(Bucket = your_bucket_name, CopySource = copy_source, Key =  f"{mod}payer_id={payer_id}/{source_key_new}")
                client.delete_object(Bucket = your_bucket_name, Key = source_key)
            else:
                print(f"{source_key} has payer")
    except Exception as e:
        logging.warning("%s" % e)
        continue
            