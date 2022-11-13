# CONTRIBUTION GUIDE

# Development process

## Testing environment
You can test this lab in a dedicated account that preferably has following assets:
* EC2 instances, running more than 14 days (for Compute Optimizer and CE Rightsizing)
* At least one EBS and one Snapshot
* Activated Enterprise Support (for TA module)
* RDS cluster
* ECS cluster
* TransitGateway with at least one attachment
* Organization
* A bucket open to readonly access to internet

## Prerequisites for local environment
* cfn-lint https://github.com/aws-cloudformation/cfn-lint#install
* python3.8+
* 

## Testing

1. check the quality of cfn code

```bash
./static/Cost/300_Optimization_Data_Collection/Code/lint.sh
```

2. Upload code to a bucket and run integration tests

```bash
export bucket='mybucket'
./static/Cost/300_Optimization_Data_Collection/Code/upload.sh  "$bucket"
python3 ./static/Cost/300_Optimization_Data_Collection/Test/test-from-scratch.py
```

# Realease process
All yaml are files are in the account 87******** - well-architected-content@amazon.com 

In the bucket aws-well-architected-labs. These are then replicated to the other regional buckets.

```bash
./static/Cost/300_Optimization_Data_Collection/Code/upload.sh "aws-well-architected-labs"
```


## Adding more buckets
Each region requires a bucket for lambda code. To add a regional bucket follow these steps:
* create bucket following the naming convention aws-well-architected-labs-<region>
* 'Block all public access' Set to > Off
* Access control list (ACL) Change from default to  ACLs enabled
* add this to the role s3-replication-role
* Add bucket policy below
* create a replication role on the aws-well-architected-labs bucket on prefix Cost/Labs/300_Optimization_Data_Collection/
* Use the s3-replication-role role
* New files will be replicated

```json
    {
        "Version": "2008-10-17",
        "Id": "PolicyForCloudFrontPrivateContent",
        "Statement": [
            {
                "Sid": "1",
                "Effect": "Allow",
                "Principal": {
                    "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E3RRAWK7UHVS3O"
                },
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::aws-well-architected-labs-ap-sydney/*"
            }
        ]
    }
```
