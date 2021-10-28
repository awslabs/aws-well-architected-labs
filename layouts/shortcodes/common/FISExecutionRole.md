
1. Navigate to the [AWS Identity and Access Management (IAM) console](https://console.aws.amazon.com/iamv2/home?#/home).

1. Click on **Policies** from the menu on the left and then click **Create Policy**.

    ![IAMCreatePolicy](/Common/FISExecutionRole/IAMCreatePolicy.png?classes=lab_picture_auto)

1. On the **Create policy** wizard, click on the **JSON** tab and replace the contents with the following policy. Click **Next: Tags**.

    ```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "AllowFISExperimentRoleReadOnly",
                "Effect": "Allow",
                "Action": [
                    "ec2:DescribeInstances",
                    "ecs:DescribeClusters",
                    "ecs:ListContainerInstances",
                    "eks:DescribeNodegroup",
                    "iam:ListRoles",
                    "rds:DescribeDBInstances",
                    "rds:DescribeDbClusters",
                    "ssm:ListCommands"
                ],
                "Resource": "*"
            },
            {
                "Sid": "AllowFISExperimentRoleEC2Actions",
                "Effect": "Allow",
                "Action": [
                    "ec2:RebootInstances",
                    "ec2:StopInstances",
                    "ec2:StartInstances",
                    "ec2:TerminateInstances"
                ],
                "Resource": "arn:aws:ec2:*:*:instance/*"
            },
            {
                "Sid": "AllowFISExperimentRoleECSActions",
                "Effect": "Allow",
                "Action": [
                    "ecs:UpdateContainerInstancesState",
                    "ecs:ListContainerInstances"
                ],
                "Resource": "arn:aws:ecs:*:*:container-instance/*"
            },
            {
                "Sid": "AllowFISExperimentRoleEKSActions",
                "Effect": "Allow",
                "Action": [
                    "ec2:TerminateInstances"
                ],
                "Resource": "arn:aws:ec2:*:*:instance/*"
            },
            {
                "Sid": "AllowFISExperimentRoleFISActions",
                "Effect": "Allow",
                "Action": [
                    "fis:InjectApiInternalError",
                    "fis:InjectApiThrottleError",
                    "fis:InjectApiUnavailableError"
                ],
                "Resource": "arn:*:fis:*:*:experiment/*"
            },
            {
                "Sid": "AllowFISExperimentRoleRDSReboot",
                "Effect": "Allow",
                "Action": [
                    "rds:RebootDBInstance"
                ],
                "Resource": "arn:aws:rds:*:*:db:*"
            },
            {
                "Sid": "AllowFISExperimentRoleRDSFailOver",
                "Effect": "Allow",
                "Action": [
                    "rds:FailoverDBCluster"
                ],
                "Resource": "arn:aws:rds:*:*:cluster:*"
            },
            {
                "Sid": "AllowFISExperimentRoleSSMSendCommand",
                "Effect": "Allow",
                "Action": [
                    "ssm:SendCommand"
                ],
                "Resource": [
                    "arn:aws:ec2:*:*:instance/*",
                    "arn:aws:ssm:*:*:document/*"
                ]
            },
            {
                "Sid": "AllowFISExperimentRoleSSMCancelCommand",
                "Effect": "Allow",
                "Action": [
                    "ssm:CancelCommand"
                ],
                "Resource": "*"
            }
        ]
    }
    ```

    ![IAMPolicyDocument](/Common/FISExecutionRole/IAMPolicyDocument.png?classes=lab_picture_auto)

1. Click **Next: Review**.

1. On the **Review policy** page, enter `WALab-FIS-policy` under **Name** and click **Create policy**.

    ![IAMReviewPolicy](/Common/FISExecutionRole/IAMReviewPolicy.png?classes=lab_picture_auto)

1. Click on **Roles** from the menu on the left and then click **Create role**.

    ![IAMCreateRole](/Common/FISExecutionRole/IAMCreateRole.png?classes=lab_picture_auto)

1. FIS is currently not listed in the list of services under use cases. For the time being, Select **EC2** and click **Next: Permissions**.

    ![IAMSelectEC2](/Common/FISExecutionRole/IAMSelectEC2.png?classes=lab_picture_auto)

1. Under **Attach permissions policies**, enter `WALab-FIS-policy` and select the **WALab-FIS-policy**. This is the policy that was created in the previous steps.

1. Click **Next: Tags**.

    ![IAMAddPolicy](/Common/FISExecutionRole/IAMAddPolicy.png?classes=lab_picture_auto)

1. Click **Next: Review**.

1. Enter `WALab-FIS-role` for **Role name**. Update the description to `Allows FIS to call AWS services on your behalf.` and click **Create role**.

    ![IAMReviewRole](/Common/FISExecutionRole/IAMReviewRole.png?classes=lab_picture_auto)

1. Search for the newly created role **WALab-FIS-role** and click on it to view details.

1. On the **Trust relationships** tab, click **Edit trust relationship**.

    ![TrustRelationships](/Common/FISExecutionRole/TrustRelationships.png?classes=lab_picture_auto)

1. Replace the existing **Policy Document** with the following and click **Update Trust Policy**.

    ```
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "fis.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
    ```

    ![TrustPolicyDocument](/Common/FISExecutionRole/TrustPolicyDocument.png?classes=lab_picture_auto)

1. The change should be reflected in the **Trust relationships** tab,

    ![UpdatedTrust](/Common/FISExecutionRole/UpdatedTrust.png?classes=lab_picture_auto)

