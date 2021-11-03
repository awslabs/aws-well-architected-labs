---
title: "Test Resiliency Using EC2 Failure Injection"
menutitle: "EC2 Failure Injection"
date: 2021-09-14T11:16:08-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

### 4.1 EC2 failure injection

This failure injection will simulate a critical problem with one of the three web servers used by your service.

In [Chaos Engineering](https://principlesofchaos.org/) we always start with a **hypothesis**.  For this experiment the hypothesis is:
> Hypothesis: If one EC2 instance dies, then availability will not be impacted

1. Before starting, view the deployment machine in the [AWS Step Functions console](https://console.aws.amazon.com/states) to verify the deployment has reached the stage where you can start testing:
    * **single region**: `WaitForWebApp` shows completed (green)
    * **multi region**: `WaitForWebApp1` shows completed (green)

1. Navigate to the EC2 console at <http://console.aws.amazon.com/ec2> and click **Instances** in the left pane.

1. There are three EC2 instances with a name beginning with **WebServerforResiliency**. For these EC2 instances note:
      1. Each has a unique *Instance ID*
      1. All instances are running and healthy
      1. There is one instance per each Availability Zone

    ![EC2InitialCheck](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/EC2InitialCheck.png)

1. Open up two more console in separate tabs/windows. From the left pane, open **Target Groups** and **Auto Scaling Groups** in separate tabs. You now have three console views open

    ![NavToTargetGroupAndScalingGroup](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/NavToTargetGroupAndScalingGroup.png)

1. To fail one of the EC2 instances, use the VPC ID as the command line argument replacing `<vpc-id>` in _one_ (and only one) of the scripts/programs below. (choose the language that you setup your environment for)

    | Language   | Command                                         |
    | :--------- | :---------------------------------------------- |
    | Bash       | `./fail_instance.sh <vpc-id>`                   |
    | Python     | `python3 fail_instance.py <vpc-id>`              |
    | Java       | `java -jar app-resiliency-1.0.jar EC2 <vpc-id>` |
    | C#         | `.\AppResiliency EC2 <vpc-id>`                  |
    | PowerShell | `.\fail_instance.ps1 <vpc-id>`                  |

1. The specific output will vary based on the command used, but will include a reference to the ID of the EC2 instance and an indicator of success.  Here is the output for the Bash command. Note the `CurrentState` is `shutting-down`

        $ ./fail_instance.sh vpc-04f8541d10ed81c80
        Terminating i-0710435abc631eab3
        {
            "TerminatingInstances": [
                {
                    "CurrentState": {
                        "Code": 32,
                        "Name": "shutting-down"
                    },
                    "InstanceId": "i-0710435abc631eab3",
                    "PreviousState": {
                        "Code": 16,
                        "Name": "running"
                    }
                }
            ]
        }

1. Go to the *EC2 Instances* console which you already have open (or [click here to open a new one](http://console.aws.amazon.com/ec2/v2/home?region=us-east-2#Instances:))

      * Refresh it. (_Note_: it is usually more efficient to use the refresh button in the console, than to refresh the browser)

           ![RefreshButton](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/RefreshButton.png)

      * Observe the status of the instance reported by the script. In the screen cap below it is _shutting down_ as reported by the script and will ultimately transition to _terminated_.

        ![EC2ShuttingDown](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/EC2ShuttingDown.png)

### 4.2 System response to EC2 instance failure {#response}

Watch how the service responds. Note how AWS systems help maintain service availability. Test if there is any non-availability, and if so then how long.

#### 4.2.1 System availability

Refresh the service website several times. Note the following:

* Website remains available
* The remaining two EC2 instances are handling all the requests (as per the displayed `instance_id`)
* Also note the `availability_zone` value when you refresh. You can see that requests are being handled by the EC2 instances in only two Availability Zones, while the EC2 instance in the third zone is being replaced

#### 4.2.2 Load balancing

Load balancing ensures service requests are not routed to unhealthy resources, such as the failed EC2 instance.

1. Go to the **Target Groups** console you already have open (or [click here to open a new one](http://console.aws.amazon.com/ec2/v2/home?region=us-east-2#TargetGroups:))
     * If there is more than one target group, select the one with the **Load Balancer** named **ResiliencyTestLoadBalancer**

1. Click on the **Targets** tab and observe:
      * Status of the instances in the group. The load balancer will only send traffic to healthy instances.
      * When the auto scaling launches a new instance, it is automatically added to the load balancer target group.

        {{%expand "Click here to see an example of what you might expect to see:" %}}

* In the screen cap below the _unhealthy_ instance is the newly added one.  The load balancer will not send traffic to it until it is completed initializing. It will ultimately transition to _healthy_ and then start receiving traffic.
* Note the new instance was started in the same Availability Zone as the failed one. Amazon EC2 Auto Scaling automatically maintains balance across all of the Availability Zones that you specify.

  ![TargetGroups](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/TargetGroups.png)

        {{% /expand%}}

1. From the same console, now click on the **Monitoring** tab and view metrics such as **Unhealthy hosts** and **Healthy hosts**.

#### 4.2.3 Auto scaling

Auto scaling ensures we have the capacity necessary to meet customer demand. The auto scaling for this service is a simple configuration that ensures at least three EC2 instances are running. More complex configurations in response to CPU or network load are also possible using AWS.

1. Go to the **Auto Scaling Groups** console you already have open (or [click here to open a new one](http://console.aws.amazon.com/ec2/autoscaling/home?region=us-east-2#AutoScalingGroups:))
      * If there is more than one auto scaling group, select the one with the name that starts with **WebServersforResiliencyTesting**

1. Click on the **Activity** tab and observe the sequence of events

    {{%expand "Click here to see an example of what you might expect to see:" %}}
* The screen cap below shows that all three instances were successfully started at 22:48
* At 23:44 the instance targeted by the script was put in _draining_ state and a new instance ending in _...55ee_ was started to replace it.

  ![AutoScalingGroup](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/AutoScalingGroup.png)  

_Draining_ allows existing, in-flight requests made to an instance to complete, but it will not send any new requests to the instance.
  * *__Learn more__*: After the lab [see this blog post](_https://aws.amazon.com/blogs/aws/elb-connection-draining-remove-instances-from-service-with-care/_) for more information on _draining_.

    {{% /expand%}}

_Auto Scaling_ helps you ensure that you have the correct number of Amazon EC2 instances available to handle the load for your workload.
  * *__Learn more__*: After the lab see [Auto Scaling Groups](_https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html_) to learn more how auto scaling groups are setup and how they distribute instances

### 4.3 [Optional] EC2 failure injection using AWS Fault Injection Simulator (FIS)

You can also use AWS FIS to simulate failure of an EC2 instance. This step is _optional_. You will get experience using AWS FIS later during the RDS failure experiment and application failure experiments.

{{% notice note %}}
If you are running this lab as part of a live workshop, then skip this step and come back to it later if you wish
{{% /notice %}}

{{%expand "Click here for instructions to simulate EC2 instance failure using AWS FIS:" %}}

As in section **4.1**, you will simulate a critical problem with one of the three web servers used by your service, but using AWS FIS. You can create an experiment template and use this template to run failure injection experiments on your resources.

#### 4.3.1 Create experiment template

1. Navigate to the EC2 console at <http://console.aws.amazon.com/ec2> and click **Instances** in the left pane.

1. There are three EC2 instances with a name beginning with **WebServerforResiliency**. For these EC2 instances note:
      1. Each has a unique *Instance ID*
      1. There is one instance per each Availability Zone
      1. All instances are healthy

    ![EC2InitialCheck](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/EC2InitialCheck.png)

1. Select the checkbox next to any one of the **WebServerforResiliency** EC2 instances, then click the **Tags** tab.
    * Verify that there is a tag with **Key** = `Workshop` and **Value** = `AWSWellArchitectedReliability300-ResiliencyofEC2RDSandS3` 

    ![EC2TagCheck](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/EC2TagCheck.png)

1. Open up two more console in separate tabs/windows. From the left pane, open **Target Groups** and **Auto Scaling Groups** in separate tabs. You now have three console views open

    ![NavToTargetGroupAndScalingGroup](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/NavToTargetGroupAndScalingGroup.png)

1. Navigate to the AWS FIS console at <http://console.aws.amazon.com/fis> and click **Experiment templates** in the left pane.

1. Click on **Create expermient template** to define the type of failure you want to inject.

    ![FISconsole](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/FISconsole.png)

1. Enter `Experiment template for EC2 resiliency testing` for **Description** and `EC2-resiliency-testing` for **Name**. For **IAM role** select `WALab-FIS-role`.

    ![ExperimentName-EC2](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/ExperimentName-EC2.png?classes=lab_picture_auto)

1. Scroll down to **Actions** and click **Add action**.

    ![AddAction](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/AddAction.png?classes=lab_picture_auto)

1. Enter `terminate-instance` for the **Name**. Under **Action type** select **aws:ec2:terminate-instances** and click **Save**.

    ![ActionEC2](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/ActionEC2.png?classes=lab_picture_auto)

1. Scroll down to **Targets** and click **Edit** next to **Instances-Target-1 (aws:ec2:instance)**.

    ![EditTargetEC2](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/EditTargetEC2.png?classes=lab_picture_auto)

1. Under **Target method**, select **Resource tags and filters**. Select **Count** for **Selection mode** and enter `1` under **Number of resources**. This ensures that FIS will only terminate one instance.

1. Scroll down to **Resource tags** and click **Add new tag**. Enter `Workshop` for **Key** and `AWSWellArchitectedReliability300-ResiliencyofEC2RDSandS3` for **Value**. These are the same tags that are on the EC2 instances used in this lab. Click **Save**. This ensures that EC2 instances launched as part of this lab are the only ones selected for failure injection.

    ![SelectTargetEC2](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/SelectTargetEC2.png?classes=lab_picture_auto)

1. You can choose to stop running an experiment when certain thresholds are met, in this case, using CloudWatch Alarms under **Stop condition**. For this lab, you can leave this blank.

1. Click **Create experiment template**.

1. In the warning pop-up, confirm that you want to create the experiment template without a stop condition by entering `create` in the text box. Click **Create experiment template**.

    ![CreateTemplate](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CreateTemplate.png?classes=lab_picture_auto)

#### 4.3.4 Run the experiment

1. Click on **Experiment templates** from the menu on the left.

1. Select the experiment template **EC2-resiliency-testing** and click **Actions**. Select **Start experiment**.

    ![StartExperimentEC2-1](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StartExperimentEC2-1.png?classes=lab_picture_auto)

1. You can choose to add a tag to the experiment if you wish to do so.

1. Click **Start experiment**.

    ![StartExperimentEC2-2](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StartExperimentEC2-2.png?classes=lab_picture_auto)

1. In the pop-up, type `start` and click **Start experiment**.

    ![StartExperiment](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StartExperiment.png?classes=lab_picture_auto)

1. Go to the *EC2 Instances* console which you already have open (or [click here to open a new one](http://console.aws.amazon.com/ec2/v2/home?region=us-east-2#Instances:))

      * Periodically refresh it. (_Note_: it is usually more efficient to use the refresh button in the console, than to refresh the browser)

           ![RefreshButton](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/RefreshButton.png)

      * Observe the status of the instances listed. As shown in the screen cap below, one of the instances will show _shutting down_ and will ultimately transition to _terminated_.

           ![EC2ShuttingDown](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/EC2ShuttingDown.png)

1. Revisit [section **4.2**](#response) to observe the system response to the EC2 failure.

{{% /expand%}}

### 4.4 EC2 failure injection - conclusion

By deploying multiple servers and using Elastic Load Balancing, the workload can suffer the loss of a server but experience no availability disruption. This is because user traffic is automatically routed to the healthy servers and Amazon Auto Scaling ensures unhealthy hosts are removed and replaced with healthy ones to maintain high availability.

Our **hypothesis** is confirmed:
> Hypothesis: If one EC2 instance dies, then availability will not be impacted


{{< prev_next_button link_prev_url="../3_failure_injection_prep" link_next_url="../5_failure_injection_rds/" />}}
