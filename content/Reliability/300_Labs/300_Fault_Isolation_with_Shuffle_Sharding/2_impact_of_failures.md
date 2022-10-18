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

1. Imagine a situation where a customer accidentally triggers the bug in the application that causes it to shutdown on the instance where the request was received.
   * This can be done by including the query-string `&bug=true`.
   * The modified URL should look like this - http://shuffle-alb-1p2xbmzo541rr-1602891463.us-east-1.elb.amazonaws.com/?name=Alpha&bug=true (but using your own URL from the CloudFormation stack Outputs)
   * Request the page for customer **Alpha** using your modified URL

1. You should see an Internal Server Error response on the browser indicating that the application has stopped working as expected on the instance that processed this request

    ![PoisonPill](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/PoisonPill.png?classes=lab_picture_auto)

1. At this point, there are 7 healthy instances still available so other customers are not impacted. You can verify this:
   * Open another browser tab and specify the URL for a different customer (obtained from the CloudFormation stack Outputs) and **without** the **bug** query string.
   * Try with at least two other customers, you may try them all if you want to, but it is not necessary.
   * Refresh the browser for requests from these other customers. You will see that responses are being returned only from 7 EC2 instances instead of 8.

   Note: If you see a response that says "This site can't be reached", please make sure you are using the URL obtained from the outputs section of the CloudFormation stack and not the sample URL provided in this lab guide.

1. Customer **Alpha**, not aware of this bug in the application, will retry the request.
   * Return to the first browser tab (the one with the "buggy request" from **Alpha**)
   * Refresh the page *once* with customer **Alpha**'s request with the **bug=true** query string.

1. This new request is then routed to one of the 7 remaining healthy instances. The bug is triggered again and another instance goes down leaving only 6 healthy instances.
   * This can be verified in the second browser tab
   * Try sending requests from one of the **other** customers **without** including the query string **bug=true** and see that responses come from only 6 EC2 instances.

1. This process continues with customer **Alpha** retrying requests until all instances are unhealthy.
   * Return to the first browser tab
   * Keep refreshing the page as customer **Alpha** with the query string **bug=true**.
   * You will eventually see the response change to “502 Bad Gateway” because there are no healthy instances to handle requests.
   * You can verify this by sending requests from other customers (*without* including the query string **bug=true**), you should see a **502 Bad Gateway** response received for all requests from all customers.
   * This is what is known as a "retry storm", where a customer is unknowingly making bad requests and retrying the request every time it fails because they are not aware of the bug within the application.

   ![502BadGateway](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/502BadGateway.png?classes=lab_picture_auto)

   {{% notice tip %}}This lab will cover how to use sharding to mitigate the impact of retry storms. After the lab, also see the [AWS Well-Architected best practice **Control and limit retry calls**](https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/design-interactions-in-a-distributed-system-to-mitigate-or-withstand-failures.html) as another practice to limit problems caused by retry storms{{% /notice %}}

1. In this situation, a buggy request made by one customer has taken down all instances on the backend resulting in complete downtime and all customers are now affected. This is a widespread scope of impact with **100%** of customers affected.

    ![RegularFlowBroken](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/RegularFlowBroken.png?classes=lab_picture_auto)


### Verify workload availability

You can look at the **AvailabilityDashboard** to see the impact of the failure introduced by customer **Alpha** across all customers.

1. Switch to the tab that has the **AvailabilityDashboard** opened. (You can also retrieve the URL from the CloudFormation stack Outputs).

1. You can see that the introduction of the poison-pill and subsequent retries by customer **Alpha** has impacted all other customers as the canaries for these customers are unable to make successful requests to the workload.
    * **NOTE:** You might have to wait a few minutes for the dashboard to get updated.

  ![ImpactDashboardRegular](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/ImpactDashboardRegular.png?classes=lab_picture_auto)

### Fix the application

As previously mentioned, the development team is aware of this bug within the application and are working on a fix, however, the fix will not be rolled out for several weeks/months. They have been able to identify the root cause of the issue and provided a temporary manual fix for it. Whenever this issue is encountered, the Operations team executes the temporary fix to bring the application back up again. They have codified this process into a Systems Manager Document and use Systems Manager to implement the fix on their fleet if outages occur. The Systems Manager Document restarts the application on the selected instances.

1. Go to the Outputs section of the CloudFormation stack and open the link for “SSMDocument”. This will take you to the Systems Manager console.

    ![CFNOutputsSSM](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/CFNOutputsSSM.png?classes=lab_picture_auto)

1. Click on Run command which will open a new tab on the browser

    ![SSMRunCommand](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/SSMRunCommand.png?classes=lab_picture_auto)

1. Scroll down to the **Targets** section and select **Specify instance tags**
1. Enter `Workload` for the tag key and `WALab-shuffle-sharding` for the tag value. Click **Add**.

    ![RegularSSMSelectInstances](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/RegularSSMSelectInstances.png?classes=lab_picture_auto)

1. Scroll down to the **Output options** section and **uncheck** the box next to **Enable an S3 bucket**. This will prevent Systems Manager from writing log files based on the command execution to S3.

1. Click on **Run**

    ![SSMUncheckS3andRun](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/SSMUncheckS3andRun.png?classes=lab_picture_auto)

1. You should see the command execution succeed in a few seconds

    ![SSMSuccess](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/SSMSuccess.png?classes=lab_picture_auto)

1. Once the command has finished execution, you can go back to the application and test it to verify it is working as expected by using one of the customer URLs obtained from the CloudFormation stack Outputs.
    * Make sure that the query-string **bug** is not included in the request.
    * Refresh the page a few times to make sure all the instances are up and running and you are able to get responses from them.
    * Test with a few different customer URLs to see that functionality has returned to all customers.

    ![RegularAlpha](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/RegularAlpha.png?classes=lab_picture_auto)

1. Review the **AvailabilityDashboard** to make sure canary requests are succeeding and normal functionality has returned to all customers. You should see that **SuccessPercent** has returned to **100** for all customers.
    * **NOTE:** You might have to wait a few minutes for the dashboard to get updated.

    ![FixedDashboardRegular](/Reliability/300_Fault_Isolation_with_Shuffle_Sharding/Images/FixedDashboardRegular.png?classes=lab_picture_auto)


{{< prev_next_button link_prev_url="../1_deploy_workload" link_next_url="../3_implement_sharding/" />}}
