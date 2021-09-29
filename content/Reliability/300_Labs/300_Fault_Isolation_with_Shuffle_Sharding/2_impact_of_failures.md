---
title: "Scope of Impact of failures"
menutitle: "Impact of failures"
date: 2020-12-07T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

### Break the application

In the scenario used in the lab, the application has a known issue which is triggered by passing a "bad" query string. If such a request is received, the EC2 instance that handles the request will become unresponsive and the application will crash on the instance. The "bad" query string that triggers this is **bug** with a value of **true**. The development team is aware of this bug and are working on a fix, however, the issue exists today and customers might accidentally or intentionally trigger it. This is referred to as a "poison pill", a bug or issue which when introduced into a system could compromise the functionality of the system.

1. Imagine a situation where a customer accidentally triggers the bug in the application that causes it to shutdown on the instance where the request was received. This can be done by including the query-string **bug=true**. The modified URL should look like this - http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Alpha&bug=true

1. You should see an Internal Server Error response on the browser indicating that the application has stopped working as expected on the instance that processed this request

    ![PoisonPill](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/PoisonPill.png?classes=lab_picture_auto)

1. At this point, there are 7 healthy instances still available so other customers are not impacted. You can verify this by opening another browser tab and specifying the URL with a different customer name and **without** the **bug** query string as shown below. Try with at least two other customers, you may try them all if you want to, but it is not necessary.

    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Bravo`
    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Charlie`
    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Delta`
    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Echo`
    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Foxtrot`
    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Golf`
    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Hotel`

    If you refresh the browser for requests from the other customers listed above, you will see that responses are being returned only from 7 EC2 instances instead of 8.

    Note: If you see a response that says "This site can't be reached", please make sure you are using the URL obtained from the outputs section of the CloudFormation stack and not the sample URL provided in this lab guide.

1. Customer Alpha, not aware of this bug in the application, will retry the request. Refresh the page with customer Alpha's request with the **bug=true** query string to simulate this. This request is then routed to one of the 7 remaining healthy instances. The bug is triggered again and another instance goes down leaving only 6 healthy instances. This can be verified by sending requests from one of the other customers without including the query string **bug=true** and seeing responses from only 6 EC2 instances.

1. This process continues with customer Alpha retrying requests until all instances are unhealthy. Refresh the page at least 6 more times as customer Alpha with the query string **bug=true**. You will eventually see the response change to “502 Bad Gateway” because there are no healthy instances to handle requests. You can verify this by sending requests from other customers, you should see a **502 Bad Gateway** response received for all requests from all customers.

    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Bravo`
    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Charlie`
    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Delta`
    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Echo`
    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Foxtrot`
    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Golf`
    * `http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Hotel`

    This is what is known as a "retry-storm", where a customer is unknowingly making bad requests and retrying the request every time it fails because they are not aware of the bug within the application.

    ![502BadGateway](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/502BadGateway.png?classes=lab_picture_auto)

1. In this situation, a buggy request made by one customer has taken down all instances on the backend resulting in complete downtime and all customers are now affected. This is a widespread scope of impact with **100%** of customers affected.

### Fix the application

As previously mentioned, the development team is aware of this bug within the application and are working on a fix, however, the fix will not be rolled out for several weeks/months. They have been able to identify the root cause of the issue and provided a temporary manual fix for it. Whenever this issue is encountered, the Operations team executes the temporary fix to bring the application back up again. They have codified this process into a Systems Manager Document and use Systems Manager to implement the fix on their fleet if outages occur.

1. Go to the Outputs section of the CloudFormation stack and open the link for “SSMDocument”. This will take you to the Systems Manager console.

    ![CFNOutputsSSM](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNOutputsSSM.png?classes=lab_picture_auto)

1. Click on Run command which will open a new tab on the browser

    ![SSMRunCommand](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/SSMRunCommand.png?classes=lab_picture_auto)

1. Scroll down to the **Targets** section and select **Specify instance tags**
1. Enter `Workload` for the tag key and `WALab-shuffle-sharding` for the tag value. Click **Add**.

    ![RegularSSMSelectInstances](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/RegularSSMSelectInstances.png?classes=lab_picture_auto)

1. Scroll down to the **Output options** section and uncheck the box next to **Enable an S3 bucket**. This will prevent Systems Manager from writing log files based on the command execution to S3.

1. Click on **Run**

    ![SSMUncheckS3andRun](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/SSMUncheckS3andRun.png?classes=lab_picture_auto)

1. You should see the command execution succeed in a few seconds

    ![SSMSuccess](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/SSMSuccess.png?classes=lab_picture_auto)

1. Once the command has finished execution, you can go back to the application and test it to verify it is working as expected. Make sure that the query-string **bug** is not included in the request. For example, http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Alpha should return a valid response. Refresh the page a few times to make sure all 4 instances are up and running. You can also change the customer name in the query string to see that functionality has returned to all customers.

    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Alpha
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Bravo
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Charlie
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Delta
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Echo
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Foxtrot
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Golf
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Hotel

    ![RegularAlpha](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/RegularAlpha.png?classes=lab_picture_auto)

{{< prev_next_button link_prev_url="../1_deploy_workload" link_next_url="../3_implement_sharding/" />}}
