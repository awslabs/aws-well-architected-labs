#!/bin/bash
# This script uploads CloudFormation files to S3 bucket. Can be used with any testing bucket or prod.
# see also README.md

if [ -n "$1" ]; then
  bucket=$1
else
  echo "ERROR: First parameter not supplied. Provide a bucket name. aws-well-architected-labs for prod aws-wa-labs-staging for stage "
  echo " prod  aws-well-architected-labs "
  echo " stage aws-wa-labs-staging"
  exit 1
fi
folder=$(pwd)
code_path=$(git rev-parse --show-toplevel)/static/Cost/300_Optimization_Data_Collection/Code


echo "Building zips"

for mod in fof ecs ta
do
  echo Buidling $mod.zip
  cd $code_path/source
  rm -f $mod.zip
  cd $code_path/source/$mod
  zip -r $mod.zip * -x "**/__pycache__/*"
  mv $mod.zip ../
done

# FIXME: zips are allways recreated so allways uploaded. We can check if md5 is the same as before to avoid updates.

echo "Sync to $bucket"
aws s3 sync $code_path/       s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/ --exclude='*' --include='*.yaml' --acl public-read
aws s3 sync $code_path/source s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/ --exclude='*' --include='*.zip' --acl public-read
aws s3 sync $code_path/source s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/Region/ --exclude='*' --include='regions.csv' --acl public-read

cd $pwd