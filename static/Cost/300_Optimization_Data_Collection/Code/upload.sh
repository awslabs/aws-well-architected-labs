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

aws s3 cp $path/Budgets.yaml                          s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/compute_optimizer.yaml                s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/Management.yaml                       s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/lambda_s3_athen_cf_template.yaml      s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/optimisation_read_only_role.yaml      s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/ecs_data.yaml                         s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/rds_util_template.yaml                s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/Optimization_Data_Collector.yaml      s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/get_accounts.yaml                     s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/organization_data.yaml                s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/lambda_data.yaml                      s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/organization_rightsizing_lambda.yaml  s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/trusted_advisor.yaml                  s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/transit_gateway.yaml                  s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/pricing_data.yaml                     s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/source/ecs.zip                        s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/source/fof.zip                        s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/source/ta.zip                         s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/  --acl public-read
aws s3 cp $path/source/regions.csv                    s3://$bucket/Cost/Labs/300_Optimization_Data_Collection/Region/  --acl public-read

