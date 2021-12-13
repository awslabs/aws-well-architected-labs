---
title: "Quest: AWS Incident Response - Credential Misuse"
menutitle: "IR - Credential Misuse"
date: 2021-06-27T11:16:08-04:00
chapter: false
weight: 3
description: "This quest is the guide for incident response workshop on credential misuse at AWS organized events."
---

## About this Guide

This is a guide for an AWS led event, to help you learn about responding to an incident related to the misuse of credentials. The credentials are specifically an IAM User with an access key. It has been designed to run in teams of 2 to 4 people where you have 1 or more partners to work with. You can also use this guide to run your own event or training. The skills you learn will help you secure your workloads in alignment with the [AWS Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/).

{{% notice warning %}}
This guide makes use of IAM users and access keys which should not be used for production purposes. Instead of IAM users follow the recommendations as detailed in the [Identity and Access Management](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/identity-and-access-management.html) section of Well-Architected to centralize your identities and use the [AWS Single Sign-On](https://aws.amazon.com/single-sign-on/) service.
{{% /notice %}}

## Prerequisites

* At least 2 [AWS accounts](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html) that you are able to use for training, that are not used for production or any other purpose.
* Permission in the accounts to use the following services: IAM, CloudTrail, S3, Athena, GuardDuty, Config, EC2.
* [AWS CloudTrail](https://aws.amazon.com/cloudtrail/) configured to log to an S3 bucket, you can enable this by following [this lab](https://wellarchitectedlabs.com/security/200_labs/200_automated_deployment_of_detective_controls/)

NOTE: If you use your own AWS account you will be billed for any applicable AWS resources used that are not covered in the [AWS Free Tier](https://aws.amazon.com/free/).


***


## Practical - Prerequisites: Implement Detection Services

In this practical we are going to:
1. Login to the AWS console
2. Use CloudFormation to automate configuration of [AWS CloudTrail](https://aws.amazon.com/cloudtrail/), [Amazon GuardDuty](https://aws.amazon.com/guardduty/), [AWS Config](https://aws.amazon.com/config/), and [AWS Security Hub](https://aws.amazon.com/security-hub/) services.
3. Accept email subscription request for GuardDuty

[AWS CloudTrail](https://aws.amazon.com/cloudtrail/) is a service that enables governance, compliance, operational auditing, and risk auditing of your AWS account. With CloudTrail, you can log, continuously monitor, and retain account activity related to actions across your AWS infrastructure. CloudTrail provides event history of your AWS account activity, including actions taken through the AWS Management Console, AWS SDKs, command line tools, and other AWS services. This event history simplifies security analysis, resource change tracking, and troubleshooting.

[Amazon GuardDuty](https://aws.amazon.com/guardduty/) is a threat detection service that continuously monitors for malicious activity and unauthorized behavior to protect your AWS accounts, workloads, and data stored in Amazon S3. With the cloud, the collection and aggregation of account and network activities is simplified, but it can be time consuming for security teams to continuously analyze event log data for potential threats. With GuardDuty, you now have an intelligent and cost-effective option for continuous threat detection in AWS. The service uses machine learning, anomaly detection, and integrated threat intelligence to identify and prioritize potential threats. GuardDuty analyzes tens of billions of events across multiple AWS data sources, such as AWS CloudTrail event logs, Amazon VPC Flow Logs, and DNS logs.

[AWS Config](https://aws.amazon.com/config/) is a service that enables you to assess, audit, and evaluate the configurations of your AWS resources. Config continuously monitors and records your AWS resource configurations and allows you to automate the evaluation of recorded configurations against desired configurations. With Config, you can review changes in configurations and relationships between AWS resources, dive into detailed resource configuration histories, and determine your overall compliance against the configurations specified in your internal guidelines.

[AWS Security Hub](https://aws.amazon.com/security-hub/) gives you a comprehensive view of your security alerts and security posture across your AWS accounts. There are a range of powerful security tools at your disposal, from firewalls and endpoint protection to vulnerability and compliance scanners. But oftentimes this leaves your team switching back-and-forth between these tools to deal with hundreds, and sometimes thousands, of security alerts every day. With Security Hub, you now have a single place that aggregates, organizes, and prioritizes your security alerts, or findings, from multiple AWS services, such as Amazon GuardDuty, Amazon Inspector, Amazon Macie, AWS Identity and Access Management (IAM) Access Analyzer, AWS Systems Manager, and AWS Firewall Manager, as well as from AWS Partner Network (APN) solutions. AWS Security Hub continuously monitors your environment using automated security checks based on the AWS best practices and industry standards that your organization follows.


### 1. Login to console

1.1 Login to the AWS console of your AWS account dedicated to training, and select your closest region. If you are at an AWS event follow the instructions provided.

### 2. Deploy detective controls using CloudFormation

2.1 Follow the instructions in [Automated Deployment of Detective Controls](https://www.wellarchitectedlabs.com/security/200_labs/200_automated_deployment_of_detective_controls/1_create_stack/) and wait for the deployment to complete. It's important that you name your S3 buckets to be globally unique and adhere to [bucket naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html). It's a common practice to include your account ID as part of the name.

### 3. Accept email subscription request for GuardDuty

3.1 You will receive an email notification from Amazon SNS, click the link to confirm your subscription to receive GuardDuty alerts via email.


***


## Practical 1: Create IAM user, keys, test

In this practical we are going to:
1. Login to the AWS console
2. Create IAM user with an access key
3. Test new access key using CloudShell

### 1. Login to console

1.1 Login to the AWS console of your AWS account dedicated to training, with access to the services listed in the prerequisites, and select your closest region. If you are at an AWS event follow the instructions provided.

### 2. Create IAM user with an access key

The reason we are going to create an IAM user and access key and go against recommendations is IAM users are still commonly used. The steps for responding are similar for both IAM users and federated users (e.g. AWS Single Sign-On).

2.1 [Create an IAM user using the console]( https://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_console) without console access, with programmatic access (access & secret key), and attach existing policy directly: *AdministratorAccess*. Name it your name or nickname, adhering to the requirements. Securely save the access and secret key for future use. 

NOTE: Never use the *AdministratorAccess* policy other than for testing or training purposes, as it provides full access to all services in every region. You can learn about least privilege in a blog: [Techniques for writing least privilege IAM policies](https://aws.amazon.com/blogs/security/techniques-for-writing-least-privilege-iam-policies/).

### 3. Test new access key using CloudShell
To test an access key you must use the AWS API, which the [AWS Command Line Interface (CLI)](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html) uses to interact with AWS services allowing you to test without writing any code. The [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/index.html) documents all commands available with examples. You can install the AWS CLI in Linux, macOS, Docker and Windows, however the easiest way is to use the [AWS CloudShell](https://aws.amazon.com/cloudshell/) service. AWS CloudShell is a browser-based, pre-authenticated shell that you can launch directly from the AWS Management Console. You can run AWS CLI commands against AWS services using your preferred shell (Bash, PowerShell, or Z shell). And you can do this without needing to download or install command line tools.

3.1 Using the [CloudShell console](https://console.aws.amazon.com/cloudshell/), once your shell is prepared test your shell by issuing the following command to list all your IAM users:
```
aws iam list-users
```
This uses the *aws* CLI to select the *iam* service and issue *list-users* command. You will see a list of IAM users in your account in JSON format.

3.2 Now that works using your existing console credentials, test your new user and its access key that you just created. We can do this by setting an environment variable that the CLI will use. Issue the following commands replacing YOUR_ACCESS_KEY and YOUR_SECRET_KEY with the ones you saved from previous step.

```
export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_KEY
```

3.3 Issue the `aws iam list-users` command again to test your new user. If you receive an error check your export commands do not have any extra spaces and the keys are identical to what you saved previously. If you receive a permissions error check the policy you attached to the IAM user. Note: If CloudShell times out at any stage you can simply press enter and it will resume / prepare the session.


***


## Practical 2: Discover CloudTrail, test partners keys

In this practical we are going to:
1. Find the API action in CloudTrail where you created your user
2. Share your access & secret key with your partner
3. List account information in your partners account
4. Investigate what the actions they performed

### 1. Find the API action in CloudTrail where you created your user

1.1 Access the [CloudTrail console](https://console.aws.amazon.com/cloudtrail/) and select *Event history* from the left menu (you may need to skip a welcome page). The recent account history is displayed and you can filter the events. Each API action is a separate event, and you can expand on the details by selecting the event name. You are looking in the *Resource Name* column for the user you created, note the *User name* column is the user that initiated the request, e.g. the one you are using. 

1.2 To filter the event history for the creation of the IAM user select *Event name* from the lookup attributes, then `CreateUser` in the search field. To the right is the time period to search. Note the event may take 5-30 minutes to appear.

### 2. Share your access & secret key with your partner

2.1 Securely share your access and secret key with your partner, you may choose to encrypt it in a zip archive and exchange via email or memory device, or simply read it out loud (if no one is listening!). The proper way of storing credentials in AWS is secrets manager, however this is a training scenario in a controlled environment with no sensitive data or systems.

### 3. List account information in your partners account

3.1 Following step 3 in practical 1 again, replace your CloudShell environment variables for the access and secret key from your partner. You should see their user name they created in the message returned instead of yours. Now you can test a few CLI commands in their account:

List managed policies attach to user *test*:
```aws iam list-attached-user-policies --user-name test```

List S3 buckets:
```aws s3 ls```

List roles:
```aws iam list-roles```

### 4. Investigate the actions they performed

4.1 Start a new CloudShell session by simply opening the service in a new tab and verify that you are back to using your credentials again. 

4.2 Now we want to see what actions your partner has performed back in the CloudTrail console. Clear the filter by selecting *Event history* again, and as your test account doesn’t have much activity you should see their actions appear.

If you are at an event and you and your partner are ahead, experiment with other read-only type commands e.g. describe, list, get.


***


## Practical 3: Querying CloudTrail using Amazon Athena

In this practical we are going to:
1. Setup Amazon Athena
2. Query CloudTrail logs

### 1. Setup Amazon Athena

[Amazon Athena]( https://aws.amazon.com/athena/) is an interactive query service that makes it easy to analyze data in Amazon S3 using standard SQL. Athena is serverless, so there is no infrastructure to manage, and you pay only for the queries that you run. You can use Athena to query CloudTrail logs directly stored in S3.

1.1	Check that CloudTrail is configured and the S3 bucket that contains your logs by accessing the [CloudTrail console](https://console.aws.amazon.com/cloudtrail/) and choose trails from the left side menu.

1.2	Take note of the bucket name next to your trail. If you followed the previous prerequisite step your trail will be named *default*, there may be another trail if you are using an AWS supplied training account.

1.3	Access the [S3 console](https://console.aws.amazon.com/s3/) and create a new S3 bucket that will contain logs for the Athena service, in the region where you will be running Athena queries. It’s recommended that this is the same region where your CloudTrail bucket is located. Don't forget bucket names must be globally unique and adhere to [bucket naming rules](https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html).

1.4	Access the [Athena console](https://console.aws.amazon.com/athena/).

1.5	Click *Get Started* to display the main Athena console.

1.6 A number of banners will be displayed, look for one *Before you run your first query, you need to set up a query result location in Amazon S3* and click the link to set up a query result location in Amazon S3.

1.7	In *Query result location* Click *select* and choose the bucket you created before by selecting the small right arrow next to the name. Accept the defaults then *Save*.

1.8	Now create the table for querying the CloudTrail logs. Athena supports both partitioned and unpartitioned tables, this example uses unpartitioned tables as the queries are easier, however if you have lots of logs then partitioning based on date or region can reduce query times. Find out more from the Athena documentation for CloudTrail. 

In the query editor insert the following query to create the table then click *Run query*, replace *CLOUDTRAIL-BUCKET-NAME* with your CloudTrail bucket name:
```
CREATE EXTERNAL TABLE cloudtrail_log (
eventversion STRING,
useridentity STRUCT<
               type:STRING,
               principalid:STRING,
               arn:STRING,
               accountid:STRING,
               invokedby:STRING,
               accesskeyid:STRING,
               userName:STRING,
sessioncontext:STRUCT<
attributes:STRUCT<
               mfaauthenticated:STRING,
               creationdate:STRING>,
sessionissuer:STRUCT<  
               type:STRING,
               principalId:STRING,
               arn:STRING, 
               accountId:STRING,
               userName:STRING>>>,
eventtime STRING,
eventsource STRING,
eventname STRING,
awsregion STRING,
sourceipaddress STRING,
useragent STRING,
errorcode STRING,
errormessage STRING,
requestparameters STRING,
responseelements STRING,
additionaleventdata STRING,
requestid STRING,
eventid STRING,
resources ARRAY<STRUCT<
               ARN:STRING,
               accountId:STRING,
               type:STRING>>,
eventtype STRING,
apiversion STRING,
readonly STRING,
recipientaccountid STRING,
serviceeventdetails STRING,
sharedeventid STRING,
vpcendpointid STRING
)
ROW FORMAT SERDE 'com.amazon.emr.hive.serde.CloudTrailSerde'
STORED AS INPUTFORMAT 'com.amazon.emr.cloudtrail.CloudTrailInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3://CLOUDTRAIL-BUCKET-NAME/';
```


### 2. Query CloudTrail logs

2.1 To run a test query, click the triple dots next to the table name under table, then click *Preview table*. It will automatically create a query for you like ```SELECT * FROM "default"."cloudtrail_log" limit 10;``` and you should see some results. This means Athena is querying your CloudTrail logs directly from S3!

2.2 Here are some sample queries to get you started, you can find more in an open source repository too: https://github.com/easttimor/aws-incident-response


#### Identities

What ARNs are creating the most events? An [ARN](https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html) is an Amazon Reource Name, in this case it's an identity that is creating events by accessing:
```
SELECT useridentity.arn, COUNT(useridentity.arn) as count
FROM cloudtrail_log
group by useridentity.arn
order by count DESC
```

Alternate, by PrincipalID:
```
SELECT useridentity.principalid, COUNT(useridentity.principalid) as count
FROM cloudtrail_log
group by useridentity.principalid order by count DESC
```

Check for all uses of specific access key:
```
select
   eventTime,
   userIdentity.userName,
   useridentity.accesskeyid
   eventName,
   requestParameters
from default.cloudtrail_log
WHERE useridentity.accesskeyid = 'AKIAEXAMPLE'
AND from\_iso8601\_timestamp(eventtime) > date\_add('day', -90, now());
order by eventTime
```

#### Actions & Regions

If you want a quick look at what is going on in your account(s) you can do a count per event, look for any services that you don't recognise:
```
select eventsource, eventname, COUNT (eventname) as eventcount
FROM cloudtrail_log
group by eventsource, eventname
order by eventcount DESC
```

High level number of events per region to detect regions in use that you would not normally use:
```
select awsregion, COUNT(awsregion) as region
FROM cloudtrail_log
group by awsregion
order by region DESC
```

Similar query, which events per region ordered by individual event count. Note that it's normal to get a small number of requests for console use:
```
select awsregion, eventname, COUNT (eventname) as eventcount
FROM cloudtrail_log
group by awsregion, eventname
order by eventcount DESC
```

To drill down on a specific region to see what is going on there. Look for EC2 instance launches, access to data, anything that could indicate misuse. In this example region sa-east-1 is queried:
```
select awsregion, eventsource, eventname, COUNT (eventname) as eventcount
FROM cloudtrail_log
WHERE awsregion = 'sa-east-1'
group by awsregion, eventsource, eventname
order by eventcount DESC
```

Query all actions for specific service:
```
select * from cloudtrail_log where eventsource = 'wafv2.amazonaws.com'
```

Check for access denied attempts:
```
SELECT *
FROM cloudtrail_log
where errorcode = 'Unauthorized' OR errorcode = 'Denied' OR errorcode = 'Forbidden'
```

***


## Practical 4: Establish persistence

In this practical we are going to:
1. Create a method for persistence in your partners account
2. Monitor your partners actions
3. Share with the class

### 1. Create a method for persistence in your partners account

You need to create at least one method of maintaining persistence in your partners account with the objective of not being discovered quickly. This is a common method that adversaries use to continue their activities after you discover the initial entry point. There are many methods you can use with a few listed below as a start. As you will see they all require privileged access to be granted in the first place, which is why you should only use least-privileged permissions outside of this training. Also consider a combination of methods, the more complex it is the more difficult it will be to contain and eradicate. For this training do not take any action that could lockout your partner from managing their account – play nice! Now is also a good time to create two timelines; one for the actions you are taking on them, and another for the actions they are taking on you.

1.1 Create an access key for an existing IAM user

Each IAM user can have 2 access keys, each of which can be enabled or disabled. It’s simple to create a new access key for an existing user if they only have 1 assigned or 1 disabled. If your partner is looking for new events from the IAM user they will start to see the new access key used. This is very simple and can easily be discovered.

1.2 Create new IAM user

Simple creating a new IAM user, especially if the account has many of them, is simple however you can gain console access by using a new password instead of changing an existing one. This is very simple and can easily be discovered.

1.3 Create new IAM role

Create an IAM role that can be assumed by an IAM user (using the trust policy) or another AWS service. You could name the new IAM role to look similar to existing ones however you are limited in the names so experiment. You can use this new IAM role in the CLI, the console, and AWS services like EC2.

1.4 Launch EC2 instance with IAM role

[Launching an EC2 instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EC2_GetStarted.html) with an existing or new IAM role can allow you to run commands from the instance using the role attached to the instance. Follow the instructions to use the launch wizard and when you get to step 3 create a new IAM role and attach. You could make the instance “look” like others that are running, or even hide it in a region that you know is not being used. You could also simply get the credentials that are vended to the EC2 instance and use them elsewhere – beware that GuardDuty will detect this very quickly!

1.5 Obfuscate your IP address

You can use a VPC endpoint for your EC2 instance that will obfuscate the IP address that will appear in the CloudTrail logs. This could make it more difficult for your partner to find as they won’t be able to search by your IP. This is covered in detail in [this article](https://www.hunters.ai/blog/hunters-research-detecting-obfuscated-attacker-ip-in-aws).

1.6 Get-session-token

The [get-session-token](https://docs.aws.amazon.com/cli/latest/reference/sts/get-session-token.html) command in the CLI and associated API action has the ability to create a temporary access and secret key along with a token. You can then use these credentials instead for a limited period of time.

### 2. Monitor your partners actions

2.1 Using CloudTrail either through the console or querying via Athena, monitor the actions your partner is taking.

First thing you should look for is attempts to establish persistence, the adverary will want a way back in if their primary mechanism is discovered and stopped. The most simple things they could do would be to get temporary credentials, create IAM access keys, or create IAM users or roles.

```
select eventtime, eventsource, eventname, recipientaccountid, useridentity.arn, useridentity.principalId, awsregion, sourceipaddress, useragent, errorcode, requestparameters, responseelements
FROM cloudtrail_log
where eventname = 'CreateRole' OR eventname = 'CreateUser' OR eventname = 'CreateAccessKey' OR eventname = 'GetFederationToken'
order by eventtime
```

2.2 Using the [AWS GuardDuty](https://console.aws.amazon.com/guardduty/) service explore any findings in your account.   

### 3. Share with the class

Share your methods of establishing persistence with the class, and refer to your timeline.


***


## Practical 5: Contain & eradicate threat

In this practical we are going to:
1. Contain your partner
2. Monitor your partners actions
3. Eradicate your partner
4. Share with the class


### 1. Contain your partner

The aim of containment is to stop the spread of the threat, in this case its the spreading and re-use of credentials. Using your knowledge of what your partner has created from their actions taken, stop the methods they are using to authenticate into your account.
* Have they created a new IAM user or access key you can disable (deleting means you will not receive any CloudTrail access denied attempts)?
* Have they launched an EC2 instance? Did that have a new IAM role? Should you isolate it, stop it, or terminate it?
* Have they created new credentials using *get-session-token*?

### 2. Monitor your partners actions

When you believe you have contained your partner, keep monitoring for any suspicous actions that will help you eradicate them.

### 3. Eradicate your partner

The aim of eradication is to completely remove all traces of the threat. What you need to eradicate depends on the actions the adversary performed. Refer to [AWS Documentation](https://docs.aws.amazon.com/) for removal of different resources you find.

### 4. Share with the class

Share your methods of establishing persistence with the class, and refer to your timeline.  