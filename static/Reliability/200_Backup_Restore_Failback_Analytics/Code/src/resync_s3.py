# Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
# 
#     https://www.apache.org/licenses/LICENSE-2.0
# 
# or in the "license" file accompanying this file. This file is distributed 
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either 
# express or implied. See the License for the specific language governing 
# permissions and limitations under the License.

import logging
import argparse
import traceback
import boto3
import csv

s3 = boto3.client('s3')
logger = logging.getLogger()

def cp_file(src_bucket, src_key, dest_bucket, dest_key):
    copy_source = {
        'Bucket': src_bucket,
        'Key': src_key
    }
    try:
        s3.copy(copy_source, dest_bucket, dest_key)
        logger.debug(f"Copied {src_key} to {dest_bucket}")
    except Exception as e:
        trc = traceback.format_exc()
        logger.warn(f"Failed to copy {src_key} to {dest_bucket}: {str(e)}\n\n{trc}")

if __name__ == "__main__":
    logger.setLevel(logging.INFO)
    fileHandler = logging.FileHandler("resync_s3.log")
    logger.addHandler(fileHandler)
    consoleHandler = logging.StreamHandler()
    logger.addHandler(consoleHandler)
    parser = argparse.ArgumentParser(description='Resync S3 after a failover')
    parser.add_argument('--input', help='Athena CSV result file', required=True)
    parser.add_argument('--primary', help='Primary Bucket Name', required=True)
    args = parser.parse_args()
    with open(args.input, newline='') as csvfile:
        freader = csv.reader(csvfile)
        next(freader)
        for row in freader:
            cp_file(row[0], row[1], args.primary, row[1])