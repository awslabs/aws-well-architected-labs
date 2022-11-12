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

code_path=$(git rev-parse --show-toplevel)/static/Cost/300_Optimization_Data_Collection/Code

RED='\033[0;31m'
BLUE='\034[0;31m'
YELLOW='\033[0;33m'
END='\033[0m' # No Color

echo "linting CFN templates" 
for template in $code_path/*.yaml; do
  echo "Linting $(basename $template)"
  echo "$(cfn-lint  --ignore-checks W3005 -- $template && echo 'OK')"
done

echo "Building zips"
zip -rq -D -X -9 -A --compression-method deflate -r $code_path/source/fof.zip $code_path/source/fof -x "**/__pycache__/*"
zip -rq -D -X -9 -A --compression-method deflate -r $code_path/source/ta.zip  $code_path/source/ta  -x "**/__pycache__/*"
zip -rq -D -X -9 -A --compression-method deflate -r $code_path/source/ecs.zip $code_path/source/ecs -x "**/__pycache__/*"
# FIXME: zips are allways recreated so allways uploaded. We can check if md5 is the same as before to avoid updates.



echo 'Sync to $bucket'
aws s3 sync $code_path/       s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/ --exclude='*' --include='*.yaml' --acl public-read
aws s3 sync $code_path/source s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/ --exclude='*' --include='*.zip' --acl public-read
aws s3 sync $code_path/source s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/Region/ --exclude='*' --include='regions.csv' --acl public-read

