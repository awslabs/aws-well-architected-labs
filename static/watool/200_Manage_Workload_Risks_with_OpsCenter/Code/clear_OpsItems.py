import boto3
import sys

try:
    region = sys.argv[1]
    ssm = boto3.client('ssm', region_name=region)

    response = ssm.describe_ops_items(
        OpsItemFilters=[
            {
                'Key': 'Source',
                'Values': [
                    'Well-Architected',
                ],
                'Operator': 'Equal'
            },
            {
                'Key': 'Status',
                'Values': [
                    'Open',
                ],
                'Operator': 'Equal'
            }
        ]
    )


    for i,val in enumerate(response['OpsItemSummaries']):
            opsitem = response['OpsItemSummaries'][i]['OpsItemId']
            update = ssm.update_ops_item(
            Status='Resolved',
            OpsItemId=opsitem
        )

    while 'NextToken' in response:
        response = ssm.describe_ops_items(
        OpsItemFilters=[
            {
                'Key': 'Source',
                'Values': [
                    'Well-Architected',
                ],
                'Operator': 'Equal'
            },
            {
                'Key': 'Status',
                'Values': [
                    'Open',
                ],
                'Operator': 'Equal'
            }
        ]
    )

        for i,val in enumerate(response['OpsItemSummaries']):
            opsitem = response['OpsItemSummaries'][i]['OpsItemId']
            update = ssm.update_ops_item(
            Status='Resolved',
            OpsItemId=opsitem
        )

    print('Well-Architected OpsItems have been resolved')
except:
    print('Please specify an AWS Region and try again.')
