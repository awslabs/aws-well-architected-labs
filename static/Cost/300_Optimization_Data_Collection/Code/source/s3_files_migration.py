"""
Moving s3 objects from old structure to the new one.

Usage:
    python3 {prog} <ODC_bucket>


"""
import re
import sys
import logging
import boto3

logger = logging.getLogger(__name__)

def migrate(bucket):
    s3 = boto3.client('s3')
    payer_id = get_payer()
    mods = {
        # Migration from v0 (no payer_id)
        "ecs-chargeback-data/year=": f"ecs-chargeback/ecs-chargeback-data/payer_id={payer_id}/year=",
        "rds_metrics/rds_stats/year=": f"rds-usage/rds-usage-data/payer_id={payer_id}/year=",
        "budgets/year=": f"budgets/budgets-data/payer_id={payer_id}/year=",
        "rightsizing/year=": f"cost-explorer-rightsizing/cost-explorer-rightsizing-data/payer_id={payer_id}/year=",
        "optics-data-collector/ami-data/year=":      f"inventory/inventory-ami-data/payer_id={payer_id}/year=",
        "optics-data-collector/ebs-data/year=":      f"inventory/inventory-ebs-data/payer_id={payer_id}/year=",
        "optics-data-collector/snapshot-data/year=": f"inventory/inventory-snapshot-data/payer_id={payer_id}/year=",
        "optics-data-collector/ta-data/year=":       f"trusted-advisor/trusted-advisor-data/payer_id={payer_id}/year=",
        "Compute_Optimizer/Compute_Optimizer_ec2_instance/year=":   f"compute_optimizer/compute_optimizer_ec2_instance/payer_id={payer_id}/year=",
        "Compute_Optimizer/Compute_Optimizer_auto_scale/year=":     f"compute_optimizer/compute_optimizer_auto_scale/payer_id={payer_id}/year=",
        "Compute_Optimizer/Compute_Optimizer_lambda/year=":         f"compute_optimizer/compute_optimizer_lambda/payer_id={payer_id}/year=",
        "Compute_Optimizer/Compute_Optimizer_ebs_volume/year=":     f"compute_optimizer/compute_optimizer_ebs_volume/payer_id={payer_id}/year=",
        "reserveinstance/year=":    f"reserveinstance/payer_id={payer_id}/year=",
        "savingsplan/year=":        f"savingsplan/payer_id={payer_id}/year=",
        "transitgateway/year=":     f"transit-gateway/transit-gateway-data/payer_id={payer_id}/year=",

        # Migration from v1 (payer_id exists)
        "ecs-chargeback-data/payer_id=": "ecs-chargeback/ecs-chargeback-data/payer_id=",
        "rds_metrics/rds_stats/payer_id=": "rds-usage/rds-usage-data/payer_id=",
        "budgets/payer_id=": "budgets/budgets-data/payer_id=",
        "rightsizing/payer_id=": "cost-explorer-rightsizing/cost-explorer-rightsizing-data/payer_id=",
        "optics-data-collector/ami-data/payer_id=":      "inventory/inventory-ami-data/payer_id=",
        "optics-data-collector/ebs-data/payer_id=":      "inventory/inventory-ebs-data/payer_id=",
        "optics-data-collector/snapshot-data/payer_id=": "inventory/inventory-snapshot-data/payer_id",
        "optics-data-collector/ta-data/payer_id=":       "trusted-advisor/trusted-advisor-data/payer_id=",
        "Compute_Optimizer/Compute_Optimizer_ec2_instance/payer_id=": "compute_optimizer/compute_optimizer_ec2_instance/payer_id=",
        "Compute_Optimizer/Compute_Optimizer_auto_scale/payer_id=":   "compute_optimizer/compute_optimizer_auto_scale/payer_id=",
        "Compute_Optimizer/Compute_Optimizer_lambda/payer_id=":       "compute_optimizer/compute_optimizer_lambda/payer_id=",
        "Compute_Optimizer/Compute_Optimizer_ebs_volume/payer_id=":   "compute_optimizer/compute_optimizer_ebs_volume/payer_id=",
        "reserveinstance/payer_id=": "reserveinstance/payer_id=",
        "savingsplan/payer_id=": "savingsplan/payer_id=",
        "transitgateway/payer_id=": "transit-gateway/transit-gateway-data/payer_id=",

        # Migration from v1.1 (adding payer to organizations)
        "organization/organization-data/([a-z\-]*?)-(\d{12}).json": rf"organization/organization-data/payer_id=\2/\1.json",
    }

    for old_prefix, new_prefix in mods.items():
        logger.debug(f'Searching for {old_prefix} in {bucket}' )
        contents =s3.list_objects_v2(Bucket=bucket, Prefix=old_prefix).get('Contents', [])
        for content in contents:
            try:
                key = content["Key"]
                new_key = re.sub(old_prefix, new_prefix, key)
                logger.info(f'  Moving {key} to {new_key}')
                copy_source = {'Bucket': bucket, 'Key': key}
                s3.copy_object(Bucket=bucket, CopySource=copy_source, Key=new_key)
                s3.delete_object(Bucket=bucket, Key=key)
            except Exception as e:
                logger.warning(e)

def get_payer():
    org = boto3.client('organizations')
    try:
        payer_id = org.describe_organization()["Organization"]['MasterAccountId']
        logger.info(f'payer_id={payer_id}')
    except org.exceptions.AccessDeniedException:
        logger.info('Cannot read organizations. Please enter payer_id (12 digits)')
        payer_id = input('payer_id>')
        assert re.match(r'^\d{12}$', payer_id), 'Wrong user input. Payer id must be 12 digits'
    except org.exceptions.AWSOrganizationsNotInUseException:
        sts = boto3.client('sts')
        payer_id = sts.get_caller_identity()['Account']
        logger.info(f'Account is not a part of org. Using Account id = {payer_id}')
    return payer_id


if __name__ == '__main__':
    logging.basicConfig(level=logging.ERROR)
    logger.setLevel(logging.DEBUG)
    try:
        bucket = sys.argv[1]
    except:
        print(__doc__.format(prog=sys.argv[0]))
        exit(1)
    logger.info(f'bucket={bucket}')

    migrate(bucket)
