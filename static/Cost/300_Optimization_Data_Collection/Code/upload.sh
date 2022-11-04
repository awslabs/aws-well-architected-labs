#!/bin/bash
# This script uploads CloudFormation files to S3 bucket. Can be used with any testing bucket or prod.
# see also WA_s3_process.txt

if [ -n "$1" ]; then
  bucket=$1
else
  echo "ERROR: First parameter not supplied. Provide a bucket name. aws-well-architected-labs for prod aws-wa-labs-staging for stage "
  echo " prod  aws-well-architected-labs "
  echo " stage aws-wa-labs-staging"
  exit 1
fi

path=$(git rev-parse --show-toplevel)/static/Cost/300_Optimization_Data_Collection/Code/

echo 'Sync to $bucket'
aws s3 sync $path/       s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/ --exclude='*' --include='*.yaml' --acl public-read
aws s3 sync $path/source s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/ --exclude='*' --include='*.zip' --acl public-read
aws s3 sync $path/source s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/Region/ --exclude='*' --include='regions.csv' --acl public-read

