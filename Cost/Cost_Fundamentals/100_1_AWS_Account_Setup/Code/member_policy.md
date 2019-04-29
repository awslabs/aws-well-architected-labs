NOTE: Policy should be removed from user after exercise is complete 
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole",
                "organizations:AcceptHandshake",
                "organizations:DescribeHandshake"
            ],
            "Resource": [
                "arn:aws:iam::*:role/*",
                "arn:aws:organizations::*:handshake/o-*/*/h-*"
            ]
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "organizations:DescribeAccount",
            "Resource": "arn:aws:organizations::*:account/o-*/*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "organizations:ListHandshakesForAccount",
                "organizations:DescribeOrganization",
                "organizations:DescribeCreateAccountStatus"
            ],
            "Resource": "*"
        }
    ]
} 
```
