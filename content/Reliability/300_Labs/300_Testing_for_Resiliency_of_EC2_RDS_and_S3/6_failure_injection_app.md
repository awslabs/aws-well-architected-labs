---
title: "Test Resiliency Using Application Failure Injection"
menutitle: "Application Failure Injection"
date: 2021-09-14T11:16:08-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6

---

### 6.1 Web server failure injection

This failure injection will simulate a critical failure of the web server running on the EC2 instances using FIS.

In [Chaos Engineering](https://principlesofchaos.org/) we always start with a **hypothesis**.  For this experiment the hypothesis is:
> Hypothesis: If the server process on a single instance is killed, then availability will not be impacted

1. [Optional] Before starting, view the deployment machine in the [AWS Step Functions console](https://console.aws.amazon.com/states) to verify the deployment has reached the stage where you can start testing:
   * **single region**: `WaitForWebApp` shows completed (green)
   * **multi region**: `WaitForWebApp1` shows completed (green)

#### 6.1.1 Create experiment template

1. Navigate to the FIS console at <http://console.aws.amazon.com/fis> and click **Experiment templates** in the left pane.
   * Troubleshooting: If screen is blank, then select the region **US East (Ohio)**

2. Click on **Create experiment template** to define the type of failure you want to inject.

    ![FISconsole](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/FISconsole.png?classes=lab_picture_auto)

3. Enter `Experiment template for application resiliency testing` for **Description** and `App-resiliency-testing` for **Name**. For **IAM role** select `WALab-FIS-role`.

    ![ExperimentName-App](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/ExperimentName-App.png?classes=lab_picture_auto)

4. Scroll down to **Actions** and click **Add action**.

    ![AddAction](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/AddAction.png?classes=lab_picture_auto)

5. Enter `kill-webserver` for the **Name**. Under **Action type** select **aws:ssm:send-command/AWSFIS-Run-Kill-Process**. Under **documentParameters** enter `{"ProcessName":"python3","Signal":"SIGKILL"}`. For **duration** select **Minutes** and then enter 2 in the text box next to it. Click **Save**.

    ![ActionApp](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/ActionApp.png?classes=lab_picture_auto)

6. Scroll down to **Targets** and click **Edit** next to **Instances-Target-1 (aws:ec2:instance)**.

    ![EditTargetApp](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/EditTargetApp.png?classes=lab_picture_auto)

7. Under **Target method**, select **Resource tags and filters**. Select **Count** for **Selection mode** and enter `1` under **Number of resources**. This ensures that FIS will only kill the web server on one instance.

8. Scroll down to **Resource tags** and click **Add new tag**. Enter `Workshop` for **Key** and `AWSWellArchitectedReliability300-ResiliencyofEC2RDSandS3` for **Value**. These are the same tags that are on the EC2 instances used in this lab.
   
9. For **Resource filters** click **Add new filter**. Enter `State.Name` for **Attribute path** and `running` for **Values**. This ensures FIS targets a running instance. Click **Save**.

    ![SelectTargetEC2](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/SelectTargetEC2.png?classes=lab_picture_auto)

10. You can choose to stop running an experiment when certain thresholds are met, in this case, using CloudWatch Alarms under **Stop condition**. For this lab, you can leave this blank.

11. Click **Create experiment template**.

12. In the warning pop-up, confirm that you want to create the experiment template without a stop condition by entering `create` in the text box. Click **Create experiment template**.

    ![CreateTemplate](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CreateTemplate.png?classes=lab_picture_auto)

#### 6.1.2 Run the experiment

1. Click on **Experiment templates** from the menu on the left.

1. Select the experiment template **App-resiliency-testing** and click **Actions**. Select **Start experiment**.

    ![StartExperimentApp-1](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StartExperimentApp-1.png?classes=lab_picture_auto)

1. You can choose to add a tag to the experiment if you wish to do so.

1. Click **Start experiment**.

    ![StartExperimentApp-2](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StartExperimentApp-2.png?classes=lab_picture_auto)

1. In the pop-up, type `start` and click **Start experiment**.

    ![StartExperiment](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StartExperiment.png?classes=lab_picture_auto)

### 6.2 System response to web server failure

The instances launched as part of this lab are running simple Python webservers. This experiment uses [AWS Systems Manager](https://aws.amazon.com/systems-manager/) to run a command on the selected instance(s). In this workshop, the command used is **kill-process**. When the experiment runs, the **python3** web server process is terminated on one of the instances and it can no longer handle requests. Watch how the service responds. Note how AWS systems help maintain service availability. Test if there is any non-availability, and if so then how long.

#### 6.2.1 System availability

Refresh the service website several times. Note the following:

* Website remains available
* The remaining two EC2 instances are handling all the requests (as per the displayed `instance_id`)
* Also note the `availability_zone` value when you refresh. You can see that requests are being handled by the EC2 instances in only two Availability Zones, while the EC2 instance in the third zone is being replaced

This can also be verified by viewing the canary run data.

* Go to the AWS CloudFormation console at https://console.aws.amazon.com/cloudformation
* click on the `WebServersforResiliencyTesting` stack
* click on the **Outputs** tab
* Open the URL for **WorkloadAvailability** in a new window
* Canary runs continue to be successful confirming that the website is available

Load balancing and Auto Scaling work here much the way they did for the [EC2 failure injection experiment](../4_failure_injection_ec2#response).

{{%expand "[Optional] If you want to review the Load balancing and Auto Scaling behavior again for this case, click here" %}}

#### 6.2.2 Load balancing

Load balancing ensures service requests are not routed to unhealthy resources, such as the EC2 instance where the web server process was killed.

1. Go to the **Target Groups** console you already have open (or [click here to open a new one](http://console.aws.amazon.com/ec2/v2/home?region=us-east-2#TargetGroups:))
     * If there is more than one target group, select the one with the **Load Balancer** named **ResiliencyTestLoadBalancer**

1. Click on the **Targets** tab and observe:
      * Status of the instances in the group. The load balancer will only send traffic to healthy instances.
      * When the auto scaling launches a new instance, it is automatically added to the load balancer target group.
      * In the screen cap below the _unhealthy_ instance is the newly added one.  The load balancer will not send traffic to it until it is completed initializing. It will ultimately transition to _healthy_ and then start receiving traffic.
      * Note the new instance was started in the same Availability Zone as the failed one. Amazon EC2 Auto Scaling automatically maintains balance across all of the Availability Zones that you specify.

        ![TargetGroups](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/TargetGroups.png)  

1. From the same console, now click on the **Monitoring** tab and view metrics such as **Unhealthy hosts** and **Healthy hosts**

      ![TargetGroupsMonitoring](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/TargetGroupsMonitoring.png)

#### 6.2.3 Auto scaling

Auto Scaling ensures we have the capacity necessary to meet customer demand. The auto scaling for this service is a simple configuration that ensures at least three EC2 instances are running. More complex configurations in response to CPU or network load are also possible using AWS. [Auto scaling uses health checks](https://docs.aws.amazon.com/autoscaling/ec2/userguide/healthcheck.html) to ensure that all instances that are part of the Auto Scaling group are running as expected. In this lab, the Auto scaling group's health check is configured to use the Load Balancer's health check. If the Load Balancer marks one of the EC2 instances as unhealthy, Auto Scaling will also consider the instance to be unhealthy and replace it.

1. Go to the **Auto Scaling Groups** console you already have open (or [click here to open a new one](http://console.aws.amazon.com/ec2/autoscaling/home?region=us-east-2#AutoScalingGroups:))
      * If there is more than one auto scaling group, select the one with the name that starts with **WebServersforResiliencyTesting**

1. Click on the **Activity History** tab and observe:
      * The screen cap below shows that all three instances were successfully started at 17:25
      * At 19:29 the instance targeted by the script was put in _draining_ state and a new instance ending in _...62640_ was started, but was still initializing. The new instance will ultimately transition to _Successful_ status

        ![AutoScalingGroup](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/AutoScalingGroup.png)  

_Draining_ allows existing, in-flight requests made to an instance to complete, but it will not send any new requests to the instance.
  * __Learn more__: After the lab [see this blog post](https://aws.amazon.com/blogs/aws/elb-connection-draining-remove-instances-from-service-with-care/) for more information on _draining_.

_Auto Scaling_ helps you ensure that you have the correct number of Amazon EC2 instances available to handle the load for your workload.
  * __Learn more__: After the lab see [Auto Scaling Groups](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html) to learn more how auto scaling groups are setup and how they distribute instances

{{% /expand%}}

### 6.3 Web server failure injection - conclusion

In this section, you simulated an application level failure where the web server process running the application was killed using FIS and SSM. Although there was no infrastructure failure, your workload was able to detect and correct the issue by replacing the EC2 instance. Deploying multiple servers and Elastic Load Balancing enables a service suffer the loss of a server with no availability disruptions as user traffic is automatically routed to the healthy servers. Amazon Auto Scaling ensures unhealthy hosts are removed and replaced with healthy ones to maintain high availability.

Our **hypothesis** is confirmed:
> Hypothesis: If the server process on a single instance is killed, then availability will not be impacted

{{< prev_next_button link_prev_url="../5_failure_injection_rds" link_next_url="../7_failure_injection_az/" />}}
