---
title: "Test Resiliency Using RDS Failure Injection"
menutitle: "RDS Failure Injection"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

### 5.1 RDS failure injection {#rdsfailureinjection}

This failure injection will simulate a critical failure of the Amazon RDS DB instance.

1. Before starting, view the deployment machine in the [AWS Step Functions console](https://console.aws.amazon.com/states) to verify the deployment has reached the stage where you can start testing:
    * **single region**: `WaitForMultiAZDB` shows completed (green)
    * **multi region**: both `WaitForRDSRRStack1` and `CheckRDSRRStatus1` show completed (green)

1. Before you initiate the failure simulation, refresh the service website several times. Every time the image is loaded, the website writes a record to the Amazon RDS database

1. Click on **click here to go to other page** and it will show the latest ten entries in the Amazon RDS DB
      1. The DB table shows "hits" on our _image page_
      1. Website URL access requests are shown here for traffic against the _image page_. These include IPs of browser traffic as well as IPs of load balancer health checks
      1. For each region the AWS Elastic Load Balancer makes these health checks, so you will see three IP addresses from these
      1. Click on **click here to go to other page** again to return to the _image page_

1. Go to the RDS Dashboard in the AWS Console at <http://console.aws.amazon.com/rds>

1. From the RDS dashboard
      * Click on "DB Instances (_n_/40)"
      * Click on the DB identifier for your database (if you have more than one database, refer to the **VPC ID** to find the one for this workshop)
      * If running the **multi-region** deployment, select the DB instance with Role=**Master**
      * Select the **Configuration** tab

1. Look at the configured values. Note the following:
      * Value of the **Info** field is **Available**
      * RDS DB is configured to be **Multi-AZ**.  The _primary_ DB instance is in AZ **us-east-2a** and the _standby_ DB instance is in AZ **us-east-2b**
        ![DBInitialConfiguration](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/DBInitialConfiguration.png)

1. To failover of the RDS instance, use the VPC ID as the command line argument replacing `<vpc-id>` in _one_ (and only one) of the scripts/programs below. (choose the language that you setup your environment for)

    | Language   | Command                                         |
    | :--------- | :---------------------------------------------- |
    | Bash       | `./failover_rds.sh <vpc-id>`                    |
    | Python     | `python fail_rds.py <vpc-id>`                   |
    | Java       | `java -jar app-resiliency-1.0.jar RDS <vpc-id>` |
    | C#         | `.\AppResiliency RDS <vpc-id>`                  |
    | PowerShell | `.\failover_rds.ps1 <vpc-id>`                   |

1. The specific output will vary based on the command used, but will include some indication that the your Amazon RDS Database is being failedover: `Failing over mdk29lg78789zt`

### 5.2 System response to RDS instance failure

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
      1. Refresh and note the values of the **Info** field. It will ultimately return to **Available** when the failover is complete.
      1. Note the AZs for the _primary_ and _standby_ instances. They have swapped as the _standby_ has no taken over _primary_ responsibility, and the former _primary_ has been restarted. (After RDS failover it can take several minutes for the console to update as shown below. The failover has however completed)

         ![DBPostFailConfiguration](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/DBPostFailConfiguration.png)

      1. From the AWS RDS console, click on the **Logs & events** tab and scroll down to **Recent events**. You should see entries like those below. In this case failover took less than a minute.

              Mon, 14 Oct 2019 19:53:37 GMT - Multi-AZ instance failover started.
              Mon, 14 Oct 2019 19:53:45 GMT - DB instance restarted
              Mon, 14 Oct 2019 19:54:21 GMT - Multi-AZ instance failover completed

#### 5.2.3 EC2 server replacement

1. From the AWS RDS console, click on the **Monitoring** tab and look at **DB connections**
      * As the failover happens the existing three servers all cannot connect to the DB
      * AWS Auto Scaling detects this (any server not returning an http 200 status is deemed unhealthy), and replaces the three EC2 instances with new ones that establish new connections to the new RDS _primary_ instance
      * The graph shows an unavailability period of about four minutes until at least one DB connection is re-established

        ![RDSDbConnections](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/RDSDbConnections.png)

1. [optional] Go to the [Auto scaling group](http://console.aws.amazon.com/ec2/autoscaling/home?region=us-east-2#AutoScalingGroups:) and AWS Elastic Load Balancer [Target group](http://console.aws.amazon.com/ec2/v2/home?region=us-east-2#TargetGroups:) consoles to see how EC2 instance and traffic routing was handled

#### 5.2.4 RDS failure injection - conclusion

* AWS RDS Database failover took less than a minute
* Time for AWS Auto Scaling to detect that the instances were unhealthy and to start up new ones took four minutes. This resulted in a four minute non-availability event.

#### 5.2.5 [OPTIONAL] RDS failure injection - improving resiliency

In this section you reduce the unavailability time from four minutes to _under one minute_.

{{% notice note %}}
This part of the RDS failure simulation is optional. If you are running this lab as part of a live workshop, then you may want to skip this and come back to it later.
{{% /notice %}}

You observed before that failover of the RDS instance itself takes under one minute. However the servers you are running are configured such that they cannot recognize that the IP address for the RDS instance DNS name has changed from the primary to the standby. Availability is only regained once the servers fail to reach the primary, are marked unhealthy, and then are replaced. This accounts for the four minute delay.  **In this part of the lab you will update the server code to be more resilient to RDS failover. The new code can recognize underlying changes in IP address for the RDS instance DNS name**

Use _either_ the **Express Steps** or **Detailed Steps** below:

##### Express Steps
1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation>
1. For the **WebServersForResiliencyTesting** Cloudformation stack
   1. Redeploy the stack and **Use current template**
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
1. Scroll to the bottom and under **Change set preview** note that you are changing the **WebServerAutoscalingGroup** and **WebServerLaunchConfiguration**. This CloudFormation deployment will modify the launch configuration to use the improved server code.
1. Check **I acknowledge that AWS CloudFormation might create IAM resources.**
1. Click **Update stack**
1. Go the **Events** tab for the **WebServersForResiliencyTesting** Cloudformation stack and observe the progress. When the status is **UPDATE_COMPLETE_CLEANUP_IN_PROGRESS** you may continue.
{{% /expand%}}

##### RDS failure injections - observations
Now repeat the RDS failure injection steps on this page, starting with [**5.1 RDS failure injection**]({{< ref "#rdsfailureinjection" >}}).

* You will observe that the unavailability time is now under one minute
* What else is different than the previous time you the RDS instance failed over?

---

#### Resources

*__Learn more__: After the lab see [High Availability (Multi-AZ) for Amazon RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html) for more details on high availability and failover support for DB instances using Multi-AZ deployments.*

**High Availability (Multi-AZ) for Amazon RDS**
> The primary DB instance switches over automatically to the standby replica if any of the following conditions occur:
> * An Availability Zone outage
> * The primary DB instance fails
> * The DB instance's server type is changed
> * The operating system of the DB instance is undergoing software patching
> * A manual failover of the DB instance was initiated using Reboot with failover

