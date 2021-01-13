---
title: "Testing the Workload Functionality"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

Following the completion of **section 4**, we can complete the lab by testing the workload. We will achieve this by running a decrypt API call to our application. This will trigger a failed decrypt event which should result in our alarm being triggered and an SNS notification sent to the email address which you specified as an endpoint in the previous section.

Complete the following steps to test the system functionality:

### 5.1. Initiate a successful decryption operation

Run the command shown below within your **Cloud9 IDE**, replacing the < encrypt key > with the key value that you took note of in section **2.4** as well as the < Application endpoint URL > with the **OutputPattern1ApplicationEndpoint** url you took note on section **2.3.3**

```
ALBURL="http://< Application endpoint URL >"
curl --header "Content-Type: application/json" --request GET --data '{"Name":"Andy Jassey","Key":"<encrypt key>"}' $ALBURL/decrypt
```

Once that is successful, you should see out put like below:

```
{"Text":"Welcome to ReInvent 2020!"}
```

### 5.2. Initiate an unsuccessful decryption operation

Now that we have confirmed that the decrypt API is operational, let's trigger a deliberate **decryption failure** to invoke our alerting.

Run below command once again, but this time, pass on a wrong key for the encrypt key (you can just use whatever value).

```
ALBURL="http://< Application endpoint URL >"
curl --header "Content-Type: application/json" --request GET --data '{"Name":"Andy Jassey","Key":"some-random-false-key"}' $ALBURL/decrypt
```

Once it is triggered, you should see output like below signifying that the decrypt procedure has failed, and in the background a failed KMS API has been called. :

```
{"Message":"Data decryption failed, make sure you have the correct key"}
```

Make sure that you repeat this several times in a row, to ensure you we are triggering the alarm. This will result in email notification to the endpoint you defined earlier in the lab.
    
#### Note:

* CloudTrail can typically take up to 15 mins to pick up the API event and trigger your alarm.
* For more information about this, please visit Cloudtrail [FAQ](https://aws.amazon.com/cloudtrail/faqs/) page 


### 5.3. Observing the alarm.

If all the components are configured correctly, you should receive an email notification triggered by the CloudWatch alarm similar to this:

![Section5 Cloudwatch Alarm Email](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section5/section5-cloudwatch-alarm1.png)


#### 5.3.1. 

Click on the URL included in the email that will take you to the **CloudWatch Alarm** resource in AWS console.


#### 5.3.2. 

Observe the state changes under the **History** section, and notice each activity change as follows:

![Section5 Cloudwatch Alarm ](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section5/section5-cloudwatch-alarm2.png)


Congratulations! you have completed the Pattern1 lab.

___
**END OF SECTION 5**
___