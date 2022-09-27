from turtle import pd
import boto3
import sys
import logging 
#python3 s3_backwards_comp.py <payer_id> <ODC_your_bucket_name> 

payer_id = sys.argv[1]
your_bucket_name = sys.argv[2]

client = boto3.client('s3')

mods = [ "rds_metrics/rds_stats/"]  #, "budgets/", "rightsizing/","optics-data-collector/", "ecs-chargeback-data/", "Compute_Optimizer/Compute_Optimizer_ec2_instance/", "Compute_Optimizer/Compute_Optimizer_auto_scale/", "Compute_Optimizer/Compute_Optimizer_lambda/", "Compute_Optimizer/Compute_Optimizer_ebs_volume/"

for mod in mods:
    print(mod)
    response = client.list_objects_v2(Bucket= your_bucket_name, Prefix = mod)
    #import pdb; pdb.set_trace()
    try:
        for key in response['Contents']:
            source_key = key["Key"]
            x = source_key.split("/")[0]
            source_key_new = source_key.replace(mod, '')
            copy_source = {'Bucket': your_bucket_name, 'Key': source_key}
            client.copy_object(Bucket = your_bucket_name, CopySource = copy_source, Key =  f"{mod}payer_id={payer_id}/{source_key_new}")
            client.delete_object(Bucket = your_bucket_name, Key = source_key)
    except Exception as e:
        logging.warning("%s" % e)
        continue
            