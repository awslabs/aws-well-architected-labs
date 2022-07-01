---
title: "Test Fail Condition"
menutitle: "Test Fail Condition"
date: 2020-09-15T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

Now that an alarm has been created to alert and send out notifications when the external service is experiencing an outage, it is time to test it. To do this, an outage can be simulated so that the external service is no longer able to write data into S3. This can be achieved in a few different ways. These are also a few different failure modes for the dependent service, which could cause the Lambda function to not get invoked. While the alarm will provide visibility into the outage itself, it will not identify the root cause.

1. External service no longer has permission to write to S3 (role used by the service has been removed/modified)
1. S3 bucket policy has been changed so that the external service no longer has access to write to it
1. S3 bucket configuration has been modified and S3 notifications removed so that notifications are no longer sent to Lambda to invoke the function
1. External service is experiencing network connectivity issues preventing it from writing to S3

In this lab, the last failure mode - **Loss of connectivity** will be simulated. To do this, the default route for the subnet can be removed so that the external service running on EC2 will no longer have a path to reach the internet.

1. Go to the VPC console at <https://console.aws.amazon.com/vpc> and click on **Route Tables**
1. Search for the route table `WA-Lab-RouteTable`
1. Click on the **Routes* tab and then click *Edit routes**

    ![VPCEditRoute](/Operations/100_Dependency_Monitoring/Images/VPCEditRoute.png)

1. On the Edit routes page, find the route with the destination of 0.0.0.0/0 and click on the **REMOVE** button at the end of that row
1. Click on **Save routes**

    ![VPCDeleteRoute](/Operations/100_Dependency_Monitoring/Images/VPCDeleteRoute.png)

The external service running on EC2 no longer has a path to reach the internet, which means it cannot write data to S3. Now that an "outage" has occurred, it is time to see if the alarm is able to identify this and send out notifications.

1. Go to the Amazon CloudWatch console at <https://console.aws.amazon.com/cloudwatch> and click on **Alarms**
1. Search for the alarm `WA-Lab-Dependency-Alarm` and click on it
1. Monitor the alarm state to see if it changes (NOTE: It will take a few minutes for the alarm state to change since CloudWatch attempts to retrieve a higher number of data points than specified by Evaluation Periods when evaluating a metric with missing data)
1. Once the alarm state changes from **OK** to **In alarm**, CloudWatch will execute the action specified, in this case, sends a message to the SNS Topic specified

    ![CWAlarmExecution](/Operations/100_Dependency_Monitoring/Images/CWAlarmExecution.png)

1. Monitor the email address that was specified during the CloudFormation Stack creation process in section 1 **Deploy the Infrastructure**
1. SNS will send a notification providing details of the alarm, the change in state, reason for change, and additional data

    ![SNSNotification](/Operations/100_Dependency_Monitoring/Images/SNSNotification.png)

Once the notification has been received, the team responsible for the workload can start investigating to identify the cause of failure. This will ensure a timely response to dependent service outages, and allow for improved business continuity.

The alarm will go back to an **OK** state once the metric is no longer breaching the threshold defined, in this case, at least 1 Lambda invocation every minute. This can be achieved by adding the default route back to the route table so that the external service running on EC2 is able to reach the internet again.

1. Go to the VPC console at <https://console.aws.amazon.com/vpc> and click on **Route Tables**
1. Search for the route table `WA-Lab-RouteTable`
1. Click on the **Routes** tab and then click **Edit routes**

    ![VPCEditRoute](/Operations/100_Dependency_Monitoring/Images/VPCEditRoute.png)

1. On the Edit routes page, click on **Add route** and enter the following:

    * **Destination** - 0.0.0.0/0
    * **Target** - Click on the dropdown, select **Internet Gateway**, and click on `WA-Lab-InternetGateway`

    ![VPCAddRoute](/Operations/100_Dependency_Monitoring/Images/VPCAddRoute.png)

1. Click on **Save routes**

Now that internet connectivity has been re-established, the external service should start writing data to S3 again, which will in turn invoke the Lambda function. Since Lambda functions will now start getting invoked periodically again, the **WA-Lab-Dependency-Alarm** should go back to an **OK** state.

1. Go to the Amazon CloudWatch console at <https://console.aws.amazon.com/cloudwatch> and click on **Alarms**
1. Search for the alarm `WA-Lab-Dependency-Alarm` and click on it
1. The alarm should be in an **OK** state confirming that the fix worked and the external service is functioning normally again

You have now configured an alarm and tested it to ensure dependency monitoring has been established and notifications will be sent out in the event of an outage. While it is important to be notified of events affecting dependent resources, responses to these events are just as important. Once a notification has been received, the event has to be effectively tracked to ensure the right resources are assigned to it and to avoid duplication of effort. The Bonus Content in the next section talks about how this can be achieved and how it can be automated. With this approach responses to events will be manual. If there is a known and codified procedure (runbook) for the event, SNS can be used to trigger the execution of the runbook in response to the event.

{{< prev_next_button link_prev_url="../3_create_alarm/" link_next_url="../5_bonus_content/" />}}
