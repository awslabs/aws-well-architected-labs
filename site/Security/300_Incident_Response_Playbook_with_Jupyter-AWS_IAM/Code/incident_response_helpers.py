import boto3
import time
from datetime import datetime, timedelta

def execute_log_query(log_group, query, days_to_search):
    start_time = int((datetime.today() - timedelta(days=days_to_search)).timestamp())
    end_time=int(datetime.now().timestamp())
    client = boto3.client('logs')
    start_query_response = client.start_query(logGroupName=log_group,startTime=start_time,endTime=end_time,queryString=query,)
    query_id = start_query_response['queryId']
    print ('Running...')
    while True:
        response = client.get_query_results(queryId=query_id)
        if response['status'] != 'Running': break    
        time.sleep(3)
    print (response['status'])
    return response

def convert_dictionary_to_object(d):
    o = {}
    for f in d:
        o[f['field']] = f['value']
    return o