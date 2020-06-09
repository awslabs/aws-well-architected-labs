Review the policy below, and use it as a starting point to create your policy for the Lambda fuction.

The following fields will need to be changed: 

 - Output bucket: The S3 bucket that will contain the output from the Athena queries 
 - Account ID: the master/payer account ID
 - Source bucket: the location of the original CUR files in the master/payer 


```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "athena:StartQueryExecution",
                "s3:DeleteObjectVersion",
                "athena:GetQueryResults",
                "s3:ListBucket",
                "athena:GetNamedQuery",
                "logs:PutLogEvents",
                "athena:ListQueryExecutions",
                "athena:ListNamedQueries",
                "s3:PutObject",
                "s3:GetObject",
                "logs:CreateLogStream",
                "athena:GetQueryExecution",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::(output bucket)/*",
                "arn:aws:logs:us-east-1:(account ID):log-group:/aws/lambda/SubAcctSplit:*",
                "arn:aws:athena:*:*:workgroup/*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "glue:GetDatabase",
                "glue:CreateTable",
                "glue:GetPartitions",
                "glue:DeleteTable",
                "glue:GetTable"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:ListBucketMultipartUploads",
                "s3:ListMultipartUploadParts",
                "s3:AbortMultipartUpload",
                "s3:CreateBucket",
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::aws-athena-query-results-us-east-1-(account ID)/*",
                "arn:aws:s3:::aws-athena-query-results-us-east-1-(account ID)"
            ]
        },
        {
            "Sid": "VisualEditor4",
            "Effect": "Allow",
            "Action": [
                "s3:GetObject",
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::(source bucket)/*"
        },
        {
            "Sid": "VisualEditor5",
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:us-east-1:(account ID):*"
        }
    ]
}


```
