```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:*",
            "Resource": "*",
            "Condition": {
                "ForAllValues:StringLike": {
                    "ec2:InstanceType": [
                        "t3.*",
                        "a1.*",
                        "m5.*"
                    ]
                }
            }
        }
    ]
}
```
