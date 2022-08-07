Bucket policy for member/linked account access to CUR files

NOTE: Replace the Account ID [Sub-Account ID] with your own account ID, and the bucket name [S3 Bucket Name] with your bucket name.

```
{
    "Version": "2008-10-17",
    "Id": "Policy1335892530063",
    "Statement": [
        {
            "Sid": "Stmt1335892150622",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::386209384616:root"
            },
            "Action": [
                "s3:GetBucketAcl",
                "s3:GetBucketPolicy"
            ],
            "Resource": "arn:aws:s3:::[S3 Bucket Name]"
        },
        {
            "Sid": "Stmt1335892526596",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::386209384616:root"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::[S3 Bucket Name]/*"
        },
        {
            "Sid": "Stmt1546900919345",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::[Sub-Account ID]:root"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::[S3 Bucket Name]"
        },
        {
            "Sid": "Stmt1546901049588",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::[Sub-Account ID]:root"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::[S3 Bucket Name]/*"
        }
    ]
}
```
