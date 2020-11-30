---
title: "Configure The Workload Logging and Alarm"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

### 4.1.

We are now going to create a filter within our CloudWatch Log Group. This filter will generate a CloudWatch metric which we will use as to create our alarm. 

To create your filter, complete the following configuration steps:

#### 4.1.1.

Navigate to **CloudWatch** in your console and click on **Log Groups** on the side menu.

#### 4.1.2.

Locate the **pattern1-logging-loggroup** you created in the previous section and click on the the log group as shown:

![Section4 Create CloudTrail Trail](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section4/section4-create-trail5.png)

#### 4.1.3. 

Select the tick box beside the log groups, click on **Actions** and then **Create metric filter** as shown:

![Section4 Cloudwatch Filter Metric 1 ](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section4/section4-create-metricfilter1.png)

#### 4.1.4. 

Enter below filter under **Filter pattern**


```
{ $.errorCode = "*" && $.eventSource= "kms.amazonaws.com" && $.userIdentity.sessionContext.sessionIssuer.arn = "<ECS Task Role ARN>" }
```

**Note:** Replace < ECS Task Role ARN > with the value of **OutputPattern1ECSTaskRole**. This value was provided in the Output section in the **pattern1-app**. If you need a reminder, you can refer to section **2.3**.

When you have completed this, you can click **Next**.

#### 4.1.5.

It is important at this stage to understand the importance of filtering using this rule. The filter which we created in the previous step will look for all error codes which come from an **eventSource** of **kms.amazonaws.com** where the **identity** of the request matches the **ECS Task role ARN**.

This means that When KMS triggers an event by our application, the event registered within CloudTrail will look like this:

```
    {
        "eventVersion": "1.05",
        "userIdentity": {
            "type": "AssumedRole",
            ...
            "sessionContext": {
                "sessionIssuer": {
                    "type": "Role",
                    "principalId": "AROAQKTRYBJEYHGY4HLFO",
                    "arn": "arn:aws:iam::xxxxxxxxxxx:role/pattern1-application-Pattern1ECSTaskRole",
                    "accountId": "xxxxxxxxxxx",
                    "userName": "pattern1-application-Pattern1ECSTaskRole"
                },
            ...
            }
        },
        "eventTime": "2020-11-16T22:25:39Z",
        "eventSource": "kms.amazonaws.com",
        "eventName": "Decrypt",
        "awsRegion": "ap-southeast-2",
        "errorCode": "IncorrectKeyException",
        "errorMessage": "The key ID in the request does not identify a CMK that can perform this operation.",
        .....
        "responseElements": null,
        "requestID": "11748bbd-ddcd-4ee2-9f42-9cec69f414b1",
        "eventID": "1f620618-46e5-4f78-93cc-0b7bccfff5d2",
        "readOnly": true,
        "eventType": "AwsApiCall",
        "recipientAccountId": "xxxxxxxxxxx"
    }
```

Our configured filter rule will perform filtering based on the JSON keys which are presented by the event as follows:

* `$.eventSource` : Describes the **EventSource** of **"kms.amazon.com"** signifying that it is a KMS event.
* `$.errorCode`   : Describes any value with key **"ErrorCode"** signifying that an error event is being generated.
* `$.userIdentity.sessionContext.sessionIssuer.arn`:  filters for the the **userIdentity** that executes the event. This is the assumed role that is used by ECS, which indicates that this call was made from our application running in the container.

Now that we have explained the details of how our filter operates, we can complete the configuration.

#### 4.1.5. 

In the **Assign Metric** form, enter the following configuration detail:

* Enter **`pattern1-logging-metricfilter`** as the **Filter name**.
* Enter **`Pattern1Application/KMSSecurity`** as the **Metric namespace**.
* Enter **`KMSSecurityError`** as the **Metric name**.
* Enter `1` as the **Metric Value**.

Your completed configuration should match the following screenshot:

![Section4 Assign Metric Screenshot ](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section4/section4-create-metricfilter2.png)

When you have verified your configuration, click **Next** and **Create metric filter**

### 4.2 Create The Metric Alarm.

Once your **Metric filter** has been created, you should be able to view it under the **Metric filters** tab of your LogGroups. We will now create the **Metric Alarm** from this filter. 

Complete the following steps:

#### 4.2.1.

Select the Metric filter you just created, then click on **CreateAlarm** as shown:

![Section4 Metric Alarm Creation #1 ](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section4/section4-create-metricalarm1.png)


#### 4.2.2. 

Change the name of the metric to `KMSsecurityError` and set the **Period** to **10 seconds** as shown:

![Section2 Cloudwatch Console ](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section4/section4-create-metricalarm2.png)

When you are ready, click **Next**

#### 4.2.3. 

Within the **conditions** dialog box, configure the following:

* Set the Threshold type as **Static** 
* Set the condition as **Greater > threshold** 
* Set the threshold value as **1**  
* Under **Additional Configuration** set **Missing data treatment** as **Treat missing data as Ignore(maintain the alarm state)**

Your configuration should match the following screenshot:

![Section4 Metric Alarm Conditions Configuration](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section4/section4-create-metricalarm3.png)

When your configuration is complete, click **Next**

#### 4.2.4.

In the **Notification** dialog box, configure the following:

* Select **In alarm** as alarm trigger state.
* Select **Create new topic** and enter **`pattern1-logging-topic`** as the topic name.
* Enter an email address where you would like to receive notification.

![Section4 Metric Alarm Notification Configuration ](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section4/section4-create-metricalarm4.png)

When your configuration is complete, click **Create topic** then click **Next**

#### 4.2.5.

Complete the following configuration to complete the alarm setup:

* Enter `pattern1-logging-alarm` as the Alarm name and click **Next**
* Review the setting and click **Create Alarm**
* Wait for an email to arrive in your mailbox, and confirm subscription to you the topic once it arrives as shown here:

![Section2 Cloudwatch Alarm ](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section4/section4-create-sub3.png)

This completes the creation of the filter and alarm for the lab. Proceed to **Section 5** to test functionality.

___
**END OF SECTION 4**
___