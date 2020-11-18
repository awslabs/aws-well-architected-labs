---
title: "Measure blast radius of failures"
date: 2020-11-18T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

### Break the application

In the scenario used in the lab, the application has a known issue which is triggered by passing a "bad" query string. If such a request is received, the EC2 instance that handles the request will become unresponsive and the application will crash on the instance. The "bad" query string that triggers this is **bug** with possible values of **true** or **false**. The development team is aware of this bug and are working on a fix, however, the issue exists today and customers might accidentally or intentionally trigger it. This is what is known as a "poison-pill", a bug or issue which when introduced into a system could compromise the functionality of the system.

1. Imagine a situation where a customer accidentally triggers the bug in the application that causes it to shutdown on the instance where the request was received. This can be done by including the query-string **bug** with a value of **true**. The modified URL should look like this - http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Alpha&bug=true
1. You should see an Internal Server Error response on the browser indicating that the application has stopped working as expected on the instance that processed this request

    ![PoisonPill](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/PoisonPill.png)

1. At this point, there are 3 healthy instances still available so other customers are not impacted. You can verify this by opening another browser tab and specifying the URL with a different customer name and without the **bug** query string such as:

    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Bravo
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Charlie
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Delta
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Echo
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Foxtrot

    If you refresh the browser for requests from the other customers listed above, you will see that responses are being returned only from 3 EC2 instances instead of 4.

1. Customer Alpha, not aware of this bug in the application, will retry the request. Refresh the page with customer Alpha's request with the **bug** query string to simulate this. This request is then routed to one of the 3 remaining healthy instances. The bug is triggered again and another instance goes down leaving only 2 healthy instances. This can be verified by sending requests from one of the other customers and seeing responses from only 2 EC2 instances.
1. This process continues with customer Alpha retrying requests until all instances are unhealthy. Refresh the page a few more times. You will eventually see the response change to “502 Bad Gateway” because there are no healthy instances to handle requests. You can verify this by sending requests from other customers, you should see a **502 Bad Gateway** response received for all requests from all customers. This is what is known as a "retry-storm", where a customer is unknowingly making bad requests and retrying the request every time it fails because they are not aware of the bug within the application.

    ![502BadGateway](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/502BadGateway.png)

1. In this situation, a buggy request made by one customer has taken down all instances on the backend resulting in complete downtime and all customers are now affected. This is a widespread blast radius with **100%** of customers affected.

### Fix the application

As previously mentioned, the development team is aware of this bug within the application and are working on a fix, however, the fix will not be rolled out for several weeks/months. They have been able to identify the root cause of the issue and provided a temporary manual fix for it. Whenever this issue is encountered, the Operations team executes the temporary fix to bring the application back up again. They have codified this process into a Systems Manager Document and use Systems Manager to implement the fix on their fleet if outages occur.

1. Go to the Outputs section of the CloudFormation stack and open the link for “SSMDocument”. This will take you to the Systems Manager console.

    ![CFNOutputsSSM](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/CFNOutputsSSM.png)

1. Click on Run command which will open a new tab on the browser

    ![SSMRunCommand](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/SSMRunCommand.png)

1. Scroll down to the **Targets** section under **Command parameters** and select **Specify instance tags**
1. For **Tag key** enter `aws:cloudformation:stack-name`, and for **Tag value** enter `Shuffle-sharding-lab` if you have followed the naming convention used in the lab guide. If you specified a different name for the CloudFormation stack, enter that value for the **Tag value** field instead. Click **Add**.

    ![RegularSSMSelectInstances](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/RegularSSMSelectInstances.png)

1. Scroll down to the **Output options** section and uncheck the box next to **Enable writing to an S3 bucket**. This will prevent Systems Manager from writing log files based on the command execution to S3.
1. Click on **Run**

    ![SSMUncheckS3andRun](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/SSMUncheckS3andRun.png)

1. You should see the command execution succeed in a few seconds

    ![SSMSuccess](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/SSMSuccess.png)

1. Once the command has finished execution, you can go back to the application and test it to verify it is working as expected. Make sure that the query-string **bug** is not included in the request. For example, http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Alpha should return a valid response. Refresh the page a few times to make sure all 4 instances are up and running. You can also change the customer name in the query string to see that functionality has returned to all customers.

    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Alpha
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Bravo
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Charlie
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Delta
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Echo
    * http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Foxtrot

    ![RegularAlpha](/Reliability/300_Minimize_Blast_Radius_with_Shuffle_Sharding/Images/RegularAlpha.png)
