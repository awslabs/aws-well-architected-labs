---
title: "Test Resiliency Using RDS Failure Injection"
menutitle: "RDS Failure Injection"
date: 2021-09-14T11:16:08-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

### 5.1 RDS failure injection {#rdsfailureinjection}

This failure injection will simulate a critical failure of the Amazon RDS DB instance.

In [Chaos Engineering](https://principlesofchaos.org/) we always start with a **hypothesis**.  For this experiment the hypothesis is:
> Hypothesis: If the primary RDS instance dies, then availability will not be impacted


1. Before starting, view the deployment machine in the [AWS Step Functions console](https://console.aws.amazon.com/states) to verify the deployment has reached the stage where you can start testing:
    * **single region**: `WaitForMultiAZDB` shows completed (green)
    * **multi region**: both `WaitForRDSRRStack1` and `CheckRDSRRStatus1` show completed (green)

1. Before you initiate the failure simulation, refresh the service website several times. Every time the image is loaded, the website writes a record to the Amazon RDS database

1. Click on **click here to go to other page** and it will show the latest ten entries in the Amazon RDS DB
        ![DemoWebsiteClickHere](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/DemoWebsiteClickHere.png)
      1. The DB table shows "hits" on your _image web page_
      1. These include requests you may make as well as load balancer health checks
      1. Refresh and note that new data is constantly being written to the table
      1. Click on **click here to go to other page** again to return to the _image web page_

1. Go to the RDS Dashboard in the AWS Console at <http://console.aws.amazon.com/rds>

1. From the RDS dashboard
      * Click on "DB Instances (_n_/40)"
      * Click on the DB identifier for your database (if you have more than one database, refer to the **VPC ID** to find the one for this workshop)
      * If running the **multi-region** deployment, select the DB instance with Role=**Master**

1. Look at the configured values. Note the following:
      * Value of the **Status** field is **Available**
      * **Region & AZ** shows the AZ for your _primary_ DB instance
      * Select the **Configuration** tab: **Multi-AZ**. is enabled, and **Secondary Zone** shows the AZ for you _standby_ DB instance
        ![DBInitialConfiguration](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/DBInitialConfiguration.png)

1. To failover of the RDS instance, use the VPC ID as the command line argument replacing `<vpc-id>` in _one_ (and only one) of the scripts/programs below. (choose the language that you setup your environment for)

    | Language   | Command                                         |
    | :--------- | :---------------------------------------------- |
    | Bash       | `./failover_rds.sh <vpc-id>`                    |
    | Python     | `python3 fail_rds.py <vpc-id>`                   |
    | Java       | `java -jar app-resiliency-1.0.jar RDS <vpc-id>` |
    | C#         | `.\AppResiliency RDS <vpc-id>`                  |
    | PowerShell | `.\failover_rds.ps1 <vpc-id>`                   |

1. The specific output will vary based on the command used, but will include some indication that the your Amazon RDS Database is being failedover: `Failing over mdk29lg78789zt`

### 5.2 System response to RDS instance failure {#response}

Watch how the service responds. Note how AWS systems help maintain service availability. Test if there is any non-availability, and if so then how long.

#### 5.2.1 System availability

1. The website is _not_ available. Some errors you might see reported:
      * **No Response / Timeout**: Request was successfully sent to EC2 server, but server no longer has connection to an active database
      * **504 Gateway Time-out**: Amazon Elastic Load Balancer did not get a response from the server.  This can happen when it has removed the servers that are unable to respond and added new ones, but the new ones have not yet finished initialization, and there are no healthy hosts to receive the request
      * **502 Bad Gateway**: The Amazon Elastic Load Balancer got a bad request from the server
      * An error you will _not_ see is **This site can’t be reached**. This is because the Elastic Load Balancer has a node in each of the three Availability Zones and is always available to serve requests.

1. Continue on to the next steps, periodically returning to attempt to refresh the website.

#### 5.2.2 Failover to standby

1. On the database console **Configuration** tab
      1. Refresh and note the values of the **Status** field. It will ultimately return to **Available** when the failover is complete.
      1. Note the AZs for the _primary_ and _standby_ instances. They have swapped as the _standby_ has no taken over _primary_ responsibility, and the former _primary_ has been restarted. (After RDS failover it can take several minutes for the console to update as shown below. The failover has however completed)

         ![DBPostFailConfiguration](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/DBPostFailConfiguration.png)

      1. From the AWS RDS console, click on the **Logs & events** tab and scroll down to **Recent events**. You should see entries like those below. (Note: you may need to page over to the most recent events) .In this case failover took less than a minute.

              Mon, 11 Oct 2021 19:53:37 GMT - Multi-AZ instance failover started.
              Mon, 11 Oct 2021 19:53:45 GMT - DB instance restarted
              Mon, 11 Oct 2021 19:54:21 GMT - Multi-AZ instance failover completed

#### 5.2.3 EC2 server replacement

1. From the AWS RDS console, click on the **Monitoring** tab and look at **DB connections**
      * As the failover happens the existing three servers all cannot connect to the DB
      * AWS Auto Scaling detects this (any server not returning an http 200 status is deemed unhealthy), and replaces the three EC2 instances with new ones that establish new connections to the new RDS _primary_ instance
      * The graph shows an unavailability period of about four minutes until at least one DB connection is re-established

        ![RDSDbConnections](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/RDSDbConnections.png)

1. [optional] Go to the [Auto scaling group](http://console.aws.amazon.com/ec2/autoscaling/home?region=us-east-2#AutoScalingGroups:) and AWS Elastic Load Balancer [Target group](http://console.aws.amazon.com/ec2/v2/home?region=us-east-2#TargetGroups:) consoles to see how EC2 instance and traffic routing was handled

#### 5.2.4 RDS failure injection - results

* AWS RDS Database failover took less than a minute
* Time for AWS Auto Scaling to detect that the instances were unhealthy and to start up new ones took four minutes. This resulted in a four minute non-availability event.

Our requirements for availability require that downtime be under one minute.  Therefore our **hypothesis** is _not_ confirmed:
> Hypothesis: If the primary RDS instance dies, then availability will not be impacted

Chaos Engineering uses the scientific method. We ran the experiment, and in the verify step found that our hypothesis was not confirmed, therefore the next step is to _improve_ and run the experiment again.

![ChaosEngineeringCycle](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/ChaosEngineeringCycle.png)

### 5.3 RDS failure injection - improving resiliency

In this section you reduce the unavailability time from four minutes to _under one minute_.

You observed before that failover of the RDS instance itself takes under one minute. However the servers you are running are configured such that they cannot recognize that the IP address for the RDS instance DNS name has changed from the primary to the standby. Availability is only regained once the servers fail to reach the primary, are marked unhealthy, and then are replaced. This accounts for the four minute delay.  **In this part of the lab you will update the server code to be more resilient to RDS failover. The new code will re-establish the connection to the database, and therefore uses the new DNS record to connect to the RDS instance.**

Use _either_ the **Express Steps** or **Detailed Steps** below:

##### Express Steps
1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation>
1. For the **WebServersForResiliencyTesting** Cloudformation stack
   1. Redeploy (Update) the stack and **Use current template**
   1. Change the **BootObject** parameter to `server_with_reconnect.py`

##### Detailed Steps
{{%expand "Click here for detailed steps for updating the Cloudformation stack:" %}}
1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation>
1. Click on **WebServersForResiliencyTesting** Cloudformation stack
1. Click the **Update** button
1. Select **Use current template** then click **Next**
1. On the **Parameters** page, find the  **BootObject** parameter and replace the value there with `server_with_reconnect.py`
1. Click **Next**
1. Click **Next**
1. Scroll to the bottom and under **Changes (2)** note that you are changing the **WebServerAutoscalingGroup** and **WebServerLaunchConfiguration**. This CloudFormation deployment will modify the launch configuration to use the improved server code.
1. Check **I acknowledge that AWS CloudFormation might create IAM resources.**
1. Click **Update stack**
1. Go the **Events** tab for the **WebServersForResiliencyTesting** Cloudformation stack and observe the progress. When the status is **UPDATE_COMPLETE** or **UPDATE_COMPLETE_CLEANUP_IN_PROGRESS** you may continue.

{{% /expand%}}

{{% notice tip %}}
When you see **UPDATE_COMPLETE_CLEANUP_IN_PROGRESS** you may continue. There is no need to wait.
{{% /notice %}}

* This update deploys three new EC2 instances in a new Auto Scaling group. There may be a period that you will still see the old three instances running, before they are drained and terminated.
* There may be a short period of unavailability. Make sure the web site is available before continuing.


Now you will re-run the experiment as per the steps below:
* Before we used a custom script. For this run of the experiment, we will show how to use AWS Fault Injection Simulator (FIS)

### 5.4 RDS failure injection using AWS Fault Injection Simulator (FIS) {#rdsfailureinjectionfis}

As in section **5.1**, you will simulate a critical failure of the Amazon RDS DB instance, but using FIS.

{{% notice note %}}
We would not normally change our execution approach as part of the "**improve / experiment**" cycle. However, for this lab it is illustrative to see the different ways that the experiment can be executed.
{{% /notice %}}

#### 5.4.1 Create experiment template

1. Go to the RDS Dashboard in the AWS Console at <http://console.aws.amazon.com/rds>

1. From the RDS dashboard
      * Click on "DB Instances (_n_/40)"
      * Click on the DB identifier for your database (if you have more than one database, refer to the **VPC ID** to find the one for this workshop)
      * If running the **multi-region** deployment, select the DB instance with Role=**Master**

1. Look at the configured values. Note the following:
      * Value of the **Status** field is **Available**
      * **Region & AZ** shows the AZ for your _primary_ DB instance
      * Select the **Configuration** tab: **Multi-AZ**. is enabled, and **Secondary Zone** shows the AZ for you _standby_ DB instance
      * Select the **Tags** tab: Note the **Value** for the `Workshop` tag
        ![DBInitialConfiguration](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/DBInitialConfiguration.png)

1. Navigate to the [FIS console](https://us-east-2.console.aws.amazon.com/fis/home) and click **Experiment templates** in the left pane.

1. Click on **Create experiment template** to define the type of failure you want to inject.

    ![FISconsole](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/FISconsole.png?classes=lab_picture_auto)

1. Enter `Experiment template for RDS resiliency testing` for **Description** and `RDS-resiliency-testing` for **Name**. For **IAM role** select `WALab-FIS-role`.

    ![ExperimentName-RDS](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/ExperimentName-RDS.png?classes=lab_picture_auto)

1. Scroll down to **Actions** and click **Add action**.

    ![AddAction](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/AddAction.png?classes=lab_picture_auto)

1. Enter `reboot-database` for the **Name**. Under **Action type** select **aws:rds:reboot-db-instances**. Enter `true` under **forceFailover - optional** and click **Save**.

    ![ActionRDS](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/ActionRDS.png?classes=lab_picture_auto)

1. Scroll down to **Targets** and click **Edit** next to **DBInstances-Target-1 (aws:rds:db)**.

    ![EditTargetRDS](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/EditTargetRDS.png?classes=lab_picture_auto)

1. Under **Target method**, select **Resource tags and filters**. Select **Count** for **Selection mode** and enter `1` under **Number of resources**. This ensures that FIS will only reboot one RDS DB instance.

1. Scroll down to **Resource tags** and click **Add new tag**. Enter `Workshop` for **Key** and `AWSWellArchitectedReliability300-ResiliencyofEC2RDSandS3` for **Value**. These are the same tags that are on the RDS DB instance used in this lab.

    ![SelectTargetRDS](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/SelectTargetRDS.png?classes=lab_picture_auto)

1. You can choose to stop running an experiment when certain thresholds are met, in this case, using CloudWatch Alarms under **Stop condition**. For this lab, this is a single point in time event (with no duration) so you can leave this blank.

1. Click **Create experiment template**.

1. In the warning pop-up, confirm that you want to create the experiment template without a stop condition by entering `create` in the text box. Click **Create experiment template**.

    ![CreateTemplate](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CreateTemplate.png?classes=lab_picture_auto)

#### 5.4.2 Run the experiment

1. Click on **Experiment templates** from the menu on the left.

1. Select the experiment template **RDS-resiliency-testing** and click **Actions**. Select **Start experiment**.

    ![StartExperimentRDS-1](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StartExperimentRDS-1.png?classes=lab_picture_auto)

1. You can choose to add a tag to the experiment if you wish to do so.

1. Click **Start experiment**.

    ![StartExperimentRDS-2](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StartExperimentRDS-2.png?classes=lab_picture_auto)

1. In the pop-up, type `start` and click **Start experiment**.

    ![StartExperiment](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StartExperiment.png?classes=lab_picture_auto)

1. Check the website availability. Re-check every 20-30 seconds.
1. Revisit [section **5.2**](#response) to observe the system response to the RDS instance failure.
    * At a minimum, return to the RDS console, go the the **Logs & events** tab, and look at the most recent events to verify that a failover has occurred.

#### 5.4.3 RDS failure injection, second experiment - results

* You will observe that the unavailability time is now under one minute
* What else is different compared to the previous time the RDS instance failed over?

### 5.5 RDS failure injection - conclusion

After making the necessary _improvements_, now our **hypothesis** is confirmed:
> Hypothesis: If the primary RDS instance dies, then availability will not be impacted

---

### Resources

*__Learn more__: After the lab see [High Availability (Multi-AZ) for Amazon RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html) for more details on high availability and failover support for DB instances using Multi-AZ deployments.*

**High Availability (Multi-AZ) for Amazon RDS**
> The primary DB instance switches over automatically to the standby replica if any of the following conditions occur:
> * An Availability Zone outage
> * The primary DB instance fails
> * The DB instance's server type is changed
> * The operating system of the DB instance is undergoing software patching
> * A manual failover of the DB instance was initiated using Reboot with failover

{{< prev_next_button link_prev_url="../4_failure_injection_ec2" link_next_url="../6_failure_injection_app/" />}}