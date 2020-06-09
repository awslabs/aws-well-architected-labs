---
title: "Identity & Access Management"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

### 2.1 Investigate AWS CloudTrail

As AWS CloudTrail logs API activity for [supported services](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-aws-service-specific-topics.html), it provides an audit trail of your AWS account that you can use to track history of an adversary. For example, listing recent access denied attempts in AWS CloudTrail may indicate attempts to escalate privilege unsuccessfully. Note that some services such as Amazon S3 have their own logging, for example read more about [Amazon S3 server access logging](https://docs.aws.amazon.com/AmazonS3/latest/dev/ServerLogs.html). You can enable AWS CloudTrail by following the [Automated Deployment of Detective Controls](../200_Automated_Deployment_of_Detective_Controls/README.md) lab.

#### 2.1.1 AWS Console

The AWS console provides a visual way of querying Amazon CloudWatch Logs, using [CloudWatch Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html) and does not require any tools to be installed.

1. Open the Amazon CloudWatch console at [https://console.aws.amazon.com/cloudwatch/](https://console.aws.amazon.com/cloudwatch/) and select your region.
2. From the left menu, choose **Insights** under **Logs**.
3. From the dropdown near the top select your CloudTrail Logs group, then the relative time to search back on the right.
4. Copy the following example queries below into the query input, then click **Run query**.

**IAM access denied attempts:**

To list all IAM access denied attempts you can use the following example. Each of the line item results allows you to drill down to reveal further details:

`filter errorCode like /Unauthorized|Denied|Forbidden/
| fields awsRegion, userIdentity.arn, eventSource, eventName, sourceIPAddress, userAgent`

**IAM access key:**

If you need to search for what actions an access key has performed you can search for it e.g. `AKIAIOSFODNN7EXAMPLE`:

`filter userIdentity.accessKeyId ="AKIAIOSFODNN7EXAMPLE"
| fields awsRegion, eventSource, eventName, sourceIPAddress, userAgent`

**IAM source ip address:**

If you suspect a particular IP address as an adversary you can search such as `192.0.2.1`:

`filter sourceIPAddress = "192.0.2.1"
| fields awsRegion, userIdentity.arn, eventSource, eventName, sourceIPAddress, userAgent`

**IAM access key created**

An access key id will be part of the responseElements when its created so you can query that:

`filter responseElements.credentials.accessKeyId ="AKIAIOSFODNN7EXAMPLE"
| fields awsRegion, eventSource, eventName, sourceIPAddress, userAgent`

**IAM users and roles created**

Listing users and roles created can help identify unauthorized activity:

`filter eventName="CreateUser" or eventName = "CreateRole"
| fields requestParameters.userName, requestParameters.roleName, responseElements.user.arn, responseElements.role.arn, sourceIPAddress, eventTime, errorCode`

**S3 List Buckets**

Listing buckets may indicate someone trying to gain access to your buckets. Note that [Amazon S3 server access logging](https://docs.aws.amazon.com/AmazonS3/latest/dev/ServerLogs.html) needs to be enabled on each bucket to gain further S3 access details:

`filter eventName ="ListBuckets"
| fields awsRegion, eventSource, eventName, sourceIPAddress, userAgent`

#### 2.1.2 AWS CLI

Remember you might need to update the *--log-group-name*, *--region* and/or *--start-time* parameter to a millisecond epoch start time of how far back you wish to search. You can use a web conversion tool such as [www.epochconverter.com](https://www.epochconverter.com/).

**IAM access denied attempts:**

To list all IAM access denied attempts you can use CloudWatch Logs with *--filter-pattern* parameter of `AccessDenied` for roles and `Client.UnauthorizedOperation` for users:

`aws logs filter-log-events --region us-east-1 --start-time 1551402000000 --log-group-name CloudTrail/DefaultLogGroup --filter-pattern AccessDenied --output json --query 'events[*].message'| jq -r '.[] | fromjson | .userIdentity, .sourceIPAddress, .responseElements'`

**IAM access key:**

If you need to search for what actions an access key has performed you can modify the *--filter-pattern* parameter to be the access key to search such as `AKIAIOSFODNN7EXAMPLE`:

`aws logs filter-log-events --region us-east-1 --start-time 1551402000000 --log-group-name CloudTrail/DefaultLogGroup --filter-pattern AKIAIOSFODNN7EXAMPLE --output json --query 'events[*].message'| jq -r '.[] | fromjson | .userIdentity, .sourceIPAddress, .responseElements'`

**IAM source ip address:**

If you suspect a particular IP address as an adversary you can modify the *--filter-pattern* parameter to be the IP address to search such as `192.0.2.1`:

`aws logs filter-log-events --region us-east-1 --start-time 1551402000000 --log-group-name CloudTrail/DefaultLogGroup --filter-pattern 192.0.2.1 --output json --query 'events[*].message'| jq -r '.[] | fromjson | .userIdentity, .sourceIPAddress, .responseElements'`

**S3 List Buckets**

Listing buckets may indicate someone trying to gain access to your buckets. Note that [Amazon S3 server access logging](https://docs.aws.amazon.com/AmazonS3/latest/dev/ServerLogs.html) needs to be enabled on each bucket to gain further S3 access details:

`aws logs filter-log-events --region us-east-1 --start-time 1551402000000 --log-group-name CloudTrail/DefaultLogGroup --filter-pattern ListBuckets --output json --query 'events[*].message'| jq -r '.[] | fromjson | .userIdentity, .sourceIPAddress, .responseElements'`

### 2.2 Block access in AWS IAM

Blocking access to an IAM entity, that is a role, user or group can help when there is unauthorized activity as it will no longer be able to perform any actions. Be careful as blocking access may disrupt the operation of your workload, which is why it is important to practice in a non-production environment. Note that the AWS IAM entity may have created another entity, or other resources that may allow access to your account. You can use [AWS CloudTrail](https://aws.amazon.com/cloudtrail/) that logs activity in your AWS account to determine the IAM entity that is performing the unauthorized operations. Additionally [service last accessed data](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_access-advisor.html) in the AWS Console can help you audit permissions.

### 2.3 List AWS IAM roles/users/groups

If you need to confirm the name of a role, user or group you can list:

#### 2.3.1 AWS Console

1. Sign in to the AWS Management Console as an IAM user or role in your AWS account, and open the AWS IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
2. Click Roles on the left, the role will be displayed and you can use the search field.

#### 2.3.2 AWS CLI

`aws iam list-roles`
This provides a full json formatted list of all roles, if you only want to display the *RoleName* use an output of table and query:

`aws iam list-roles --output table --query 'Roles[*].RoleName'`
List all users:

`aws iam list-users --output table --query 'Users[*].UserName'`
List all groups:

`aws iam list-groups --output table --query 'Groups[*].GroupName'`

### 2.4 Attach inline deny policy

Attaching an explicit deny policy to an AWS IAM role, user or group will quickly block **ALL** access for that entity which is useful if it is performing unauthorized operations. Please note that the role will still be able to call the sts API to obtain information on itself, e.g. using get-caller-identity will return the account ID, user ID and ARN.

#### 2.4.1 AWS Console

1. Sign in to the AWS Management Console as an AWS IAM user or role in your AWS account, and open the AWS IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
2. Click either **Groups**, **Users** or **Roles**  on the left, then click the name to modify.
3. Click **Permissions** tab.
4. Click **Add inline policy**.
5. Click the **JSON** tab then replace the example with the following:
`{ "Statement": [ { "Effect": "Deny", "Action": "*", "Resource": "*" } ] }`
6. Click **Review policy**.
7. Enter **Name** of *DenyAll* then click **Create policy**. Note that the console may incorrectly display the access level.

#### 2.4.2 AWS CLI

Block a role, modify *ROLENAME* to match your role name:

`aws iam put-role-policy --role-name ROLENAME --policy-name DenyAll --policy-document '{ "Statement": [ { "Effect": "Deny", "Action": "*", "Resource": "*" } ] }'`
Block a user, modify *USERNAME* to match your user name:

`aws iam put-user-policy --user-name USERNAME --policy-name DenyAll --policy-document '{ "Statement": [ { "Effect": "Deny", "Action": "*", "Resource": "*" } ] }'`
Block a group, modify *GROUPNAME* to match your user name:

`aws iam put-group-policy --group-name GROUPNAME --policy-name DenyAll --policy-document '{ "Statement": [ { "Effect": "Deny", "Action": "*", "Resource": "*" } ] }'`

### 2.5 Delete inline deny policy

To delete the policy you just attached and restore the original permissions the entity had:

#### 2.5.1 AWS Console

1. Sign in to the AWS Management Console as an IAM user or role in your AWS account, and open the AWS IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
2. Click **Roles** on the left.
3. Click the checkbox next to the role to delete.
4. Click **Delete role**.
5. Confirm the role to delete then click **Yes, delete**

#### 2.5.2 AWS CLI

Delete policy from a role:
`aws iam delete-role-policy --role-name ROLENAME --policy-name DenyAll`
Delete policy from a user:
`aws iam delete-user-policy --user-name USERNAME --policy-name DenyAll`
Delete policy from a group:
`aws iam delete-group-policy --group-name GROUPNAME --policy-name DenyAll`
