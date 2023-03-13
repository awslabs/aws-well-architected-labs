import boto3
import csv
import logging


def read_csv_function(filename):

    file = open(f"{filename}", "r",  encoding='utf-8-sig')
    data = list(csv.DictReader(file, delimiter=","))
    file.close()

    return data

def org_function(key,value, account_id):

    client = boto3.client('organizations')
    response = client.list_tags_for_resource(
    ResourceId=account_id
    )
    response = client.tag_resource(
        ResourceId=account_id,
        Tags=[
            {
                'Key': key,
                'Value': value
            },
        ]
    )
    return response

def main():
    filename = 'data.csv'
    key = 'cid_users'
    map_data = read_csv_function(filename)
    
    for line in map_data:
        try: 
            account_id = line['Account ID']
            value = line['cid_users']
            org_function(key, value, account_id)
        except Exception as e:
            logging.info("%s" % e)
            pass

def lambda_handler(event, context):
    main()

if __name__ == '__main__':
    main()

        
