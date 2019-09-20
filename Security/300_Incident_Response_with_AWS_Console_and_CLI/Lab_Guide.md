# Level 300: Incident Response with AWS Console and CLI

## Authors

- Ben Potter, Security Lead, Well-Architected

## Table of Contents

1. [Getting Started](#getting_Started)
2. [Identity & Access Management](#iam)
3. [Amazon VPC](#vpc)
4. [Knowledge Check](#knowledge_check)

## 1. Getting Started <a name="getting_Started"></a>

### 1.1 Install the AWS CLI

Although instructions in this lab are written for both AWS Management console and AWS CLI, its best to install the AWS CLI on the machine you will be using as you can modify the example commands to run different scenarios easily and across multiple AWS accounts.

[Install the AWS CLI on macOS](https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html)
[Install the AWS CLI on Linux](https://docs.aws.amazon.com/cli/latest/userguide/install-linux.html)
[Install the AWS CLI on Windows](https://docs.aws.amazon.com/cli/latest/userguide/install-windows.html)
You will also need jq to parse json from the CLI:
[Install jq ](https://stedolan.github.io/jq/download/)

A best practice is to enforce the use of MFA, so if you misplace your AWS Management console password and/or access/secret key, there is nothing anyone can do without your MFA credentials. You can follow the instructions [here](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-role.html) to configure AWS CLI to assume a role with MFA enforced.

### 1.2 Amazon CloudWatch Logs

[Amazon CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/WhatIsCloudWatchLogs.html) can be used to monitor, store, and access your log files from Amazon Elastic Compute Cloud (Amazon EC2) instances, AWS CloudTrail, Amazon Route 53, Amazon VPC Flow Logs, and other sources. It is a [best practice](https://wa.aws.amazon.com/wat.question.SEC_4.en.html) to enable logging and analyze centrally, and develop investigation proceses. Using the AWS CLI and developing runbooks for investigation into different events can be significantly faster than using the console. If your logs are stored in Amazon S3 instead, you can use [Amazon Athena](https://docs.aws.amazon.com/athena/latest/ug/what-is.html) to directly analyze data.

To list the Amazon CloudWatch Logs Groups you have configured in each region, you can describe them. Note you must specify the region, if you need to query multiple regions you must run the command for each. You must use the region ID such as *us-east-1* instead of the region name of *US East (N. Virginia)* that you see in the console. You can obtain a list of the regions by viewing them in the [AWS Regions and Endpoints](https://docs.aws.amazon.com/general/latest/gr/rande.html) or using the CLI command: `aws ec2 describe-regions`.
To list the log groups you have in a region, replace the example us-east-1 with your region:
`aws logs describe-log-groups --region us-east-1`
The default output is json, and it will give you all details. If you want to list only the names in a table:
`aws logs describe-log-groups --output table --query 'logGroups[*].logGroupName' --region us-east-1`

***

## 2. Identity & Access Management <a name="iam"></a>

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

Attaching an explicit deny policy to an AWS IAM role, user or group will quickly block **ALL** access for that entity which is useful if it is performing unauthorized operations.

#### 2.4.1 AWS Console

1. Sign in to the AWS Management Console as an AWS IAM user or role in your AWS account, and open the AWS IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/).
2. Click either **Groups**, **Users** or **Roles**  on the left, then click the name to modify.
3. Click **Permissions** tab.
4. Click **Add inline policy**.
5. Click the **JSON** tab then replace the example with the following:
`{ "Statement": [ { "Effect": "Deny", "Action": "*", "Resource": "*" } ] }`
6. Click **Review policy**.
7. Enter **Name** of *DenyAll* then click **Create policy**.

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

## 3. Amazon VPC <a name="vpc"></a>

A Amazon VPC that has [VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html) enabled captures information about the IP traffic going to and from network interfaces in your Amazon VPC. This log information may help you investigate how Amazon EC2 instances and other resources in your VPC are communicating, and what they are communicating with. You can follow the [Automated Deployment of VPC](../200_Automated_Deployment_of_VPC/README.md) lab for creating a Amazon VPC with Flow Logs enabled.

### 3.1 Investigate Amazon VPC Flow Logs

#### 3.1.1 AWS Management Console

The AWS Management console provides a visual way of querying CloudWatch Logs, using [CloudWatch Logs Insights](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html) and does not require any tools to be installed.

1. Open the Amazon CloudWatch console at [https://console.aws.amazon.com/cloudwatch/](https://console.aws.amazon.com/cloudwatch/) and select your region.
2. From the left menu, choose **Insights** under **Logs**.
3. From the dropdown near the top select your CloudTrail Logs group, then the relative time to search back on the right.
4. Copy the following example queries below into the query input, then click **Run query**.

**Rejected requests by IP address:**

Rejected requests indicate attempts to gain access to your VPC, however there can often be noise from internet scanners. To count the rejected requests by source IP address:
`filter action="REJECT"
| stats count(*) as numRejections by srcAddr
| sort numRejections desc`

**Reject requests originating from inside your VPC**

Rejected requests that originate from inside your VPC may indicate your infrastructure in your VPC is attempting to connect to something it is not allowed to, e.g. a database instance is trying to connect to the internet and is blocked. This example uses regex to match the start of your VPC as *10.*:
`filter action="REJECT" and srcAddr like /^10\./
| stats count(*) as numRejections by srcAddr
| sort numRejections desc`

**Requests from an IP address**

If you suspect an IP address and want to list all requests that originate, replace *192.0.2.1* with the IP you suspect:
`filter srcAddr = "192.0.2.1"
| fields @timestamp, interfaceId, dstAddr, dstPort, action`

**Request count from a private IP address by destination address**

If you want to list and count all connections by a private IP address, replace *10.1.1.1* with your private IP:
`filter srcAddr = "10.1.1.1"
| stats count(*) as numConnections by dstAddr
| sort numConnections desc`

## 4. Knowledge Check <a name="knowledge_check"></a>

The security best practices followed in this lab are: <a name="best_practices"></a>

* [Analyze logs centrally](https://wa.aws.amazon.com/wat.question.SEC_4.en.html) Amazon CloudWatch is used to monitor, store, and access your log files. You can use AWS CloudWatch to analyze your logs centrally.
* [Automate alerting on key indicators](https://wa.aws.amazon.com/wat.question.SEC_4.en.html) AWS CloudTrail, AWS Config,Amazon GuardDuty and Amazon VPC Flow Logs provide insights into your environment.
* [Implement new security services and features:](https://wa.aws.amazon.com/wat.question.SEC_5.en.html) New features such as Amazon VPC Flow Logs have been adopted.
* [Implement managed services:](https://wa.aws.amazon.com/wat.question.SEC_7.en.html)
Managed services are utilized to increase your visibility and control of your environment.
* [Identify Tooling](https://wa.aws.amazon.com/wat.question.SEC_11.en.html)
Using the AWS Management Console and/or AWS CLI tools with prepared scripts will assist in your investigations.

***

## References & useful resources

[AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/reference/)
[AWS Identity and Access Management User Guide](https://docs.aws.amazon.com/IAM/latest/UserGuide/introduction.html)
[CloudWatch Logs Insights Query Syntax](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html)

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
