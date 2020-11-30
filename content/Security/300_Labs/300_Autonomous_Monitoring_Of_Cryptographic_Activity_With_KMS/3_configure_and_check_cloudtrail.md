---
title: "Configure CloudTrail "
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

We will now focus on the creation and configuration of the CloudTrail service. This represents the source of record for all API calls generated within our architecture which we will apply filters to later. Note in the architecture below how CloudTrail integrates with the other AWS services we will deploy:

![Section3 Base Architecture](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section3/section3-pattern1-full-architecture.png)


{{%expand "Click here for CloudFormation command-line deployment steps"%}}

#### Command Line:

### 3.1. Command Line Deployment

Firstly, download the logging template from [here.](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Code/templates/section3/pattern1-logging.yml "section3 logging template")

To deploy from the command line, ensure that you have installed and configured AWS CLI with the appropriate credentials. When your environment is ready, run the following command, taking note of the points below.  

```
aws cloudformation create-stack --stack-name pattern1-logging \
                                --template-body file://pattern1-logging.yml \
                                --parameters ParameterKey=AppECSTaskRoleArn,ParameterValue="<ECS Task Role ARN>" ParameterKey=EmailAddress,ParameterValue=< Email Address > \
                                --capabilities CAPABILITY_NAMED_IAM \
                                --region ap-southeast-2
```

#### Note :

* For simplicity, we have used Sydney 'ap-southeast-2' as the default region for this lab. 
* For **< ECS Task Role ARN >**, use the ECS Task Role Arn value you took note of from section **2.3.3** for **AppECSTaskRoleArn** parameter.
* Use the email address you would like to use to be notified with under **EmailAddress** parameter. 

{{% /expand%}}

{{%expand "Click here for CloudFormation console deployment steps"%}}

#### Console:

### 3.1. CloudFormation Console Deployment

Firstly, download the logging template from [here.](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Code/templates/section3/pattern1-logging.yml "section3 logging template")

To deploy the template from the console, please follow this [guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html) for information on how to deploy the cloudformation template, noting the following points before starting your deployment:

* Use `pattern1-logging` as the **Stack Name**.
* Provide the name of the VPC CloudFormation stack you created in **section 1** ( we used `pattern1-base` as default ). If you are unsure, refer to the output of the infrastructure stack, the stack name corresponds to the parameter value **BaselineVpcStack**. 
* Use the ECS Task Role Arn value you took note from section **1.3** for **AppECSTaskRoleArn** parameter.
* Use email address you would like to use to be notified with under **EmailAddress** parameter. 

{{% /expand%}}

{{%expand "Click here for manual console deployment"%}}

#### Manual Console Deployment

### 3.1. Create a Trail in CloudTrail Console

To create a trail for use within this lab, complete the following steps:

#### 3.1.1. 

Navigate to **CloudTrail** within the console, then click on **Create trail** as shown here:

![Section3 Trail Creation #1 ](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section3/section3-create-trail.png)

#### 3.1.2.

Enter `pattern1-logging-trail` as the Trail name.

#### 3.1.3. 

Select **Create new S3 bucket**  and enter a name for your logging s3 bucket.

Note that the name needs to be **globally unique**, so you can use your accountid or uuid to keep it unique for you.


#### 3.1.4. 

Enter the remainder of the settings as per the following example:

![Section3 Trail Creation #2 ](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section3/section3-create-trail2.png)

#### 3.1.5. 

Complete the following configuration choices:

* Tick on **Enabled** under CloudWatch Logs.
* Select **New** on the Log group radio button, and enter your log group name as `pattern1-logging-loggroup`
* Select **New** on IAM Role, and enter your role name as `CloudTrailRoleForCloudWatchLogs_pattern1-logging`

Your configuration should match the screenshot below:

![Section3 Trail Creation #3](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section3/section3-create-trail3.png)

When you are complete, click **Next**.

#### 3.1.6.

On the next screen, complete the following configuration choices:

* Select **management events**
* Select **read write API**
* Ensure that **exclude AWS KMS event** is **NOT** selected

Check your selection against the following screenshot and then click **Next**.


![Section3 Trail Creation #4 ](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section3/section3-create-trail4.png)

#### 3.1.7.

Review the settings and click **Create Trail**

### 3.2. Confirm Your CloudWatch Log Group Is Operational.

Now that your CloudWatch configuration is completed, we need to confirm that the log group is operational.

Follow the steps below to confirm the state of the Log Group:

#### 3.2.1.

Navigate to **CloudWatch** in your console and click on **Log Groups** on the side menu.

#### 3.2.2.

Locate the `pattern1-logging-loggroup` you created before and click on the the log group as show:

![Section3 Cloudwatch Console ](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section3/section3-create-trail5.png)

#### 3.2.3.

Click on the available log stream, and confirm that you are seeing logs being generated.
   
If you have completed the configuration correctly, you should see an ongoing record of all the API calls within your account as show here: 

![Section2 Cloudwatch Console ](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section3/section3-create-trail6.png)

In the next section, we are going to filter out the Events which matter to us. In doing this we will be able to create an appropriate Alarm 

{{% /expand%}}

___
**END OF SECTION 3**
___