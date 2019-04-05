```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:*",
                "rds:*",
                "s3:*"
            ],
            "Resource": "*",
      "Condition": {"StringEquals": {"aws:RequestedRegion": "us-east-1"}}
        }
    ]
}
```
