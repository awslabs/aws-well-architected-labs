---
title: "Test Resiliency Using Availability Zone (AZ) Failure Injection"
menutitle: "AZ Failure Injection"
date: 2021-09-14T11:16:08-04:00
chapter: false
pre: "<b>7. </b>"
weight: 7
---

### 7.1 AZ failure injection

This failure injection will simulate a critical problem with one of the three AWS Availability Zones (AZs) used by your service. AWS Availability Zones are  powerful tools for helping build highly available applications. If an application is partitioned across AZs, companies are better isolated and protected from issues such as lightning strikes, tornadoes, earthquakes and more.

In [Chaos Engineering](https://principlesofchaos.org/) we always start with a **hypothesis**.  For this experiment the hypothesis is:
> Hypothesis: If an entire Availability Zone dies, then availability will not be impacted

1. Go to the RDS Dashboard in the AWS Console at <http://console.aws.amazon.com/rds> and note which Availability Zone the AWS RDS _primary_ DB instance is in.
      * **Note**: If you previously ran the **RDS Failure Injection test**, you must wait until the console shows the AZs for the _primary_ and _standby_ instances as swapped, before running this test
      * A good way to run the AZ failure injection is first in an AZ _other_ than this - we'll call this **Scenario 1**
      * Then try it again in the _same_ AZ as the AWS RDS _primary_ DB instance - we'll call this **Scenario 2**
      * Taking down two out of the three AZs this way is an unlikely use case, however it will show how AWS systems work to maintain service integrity despite extreme circumstances.
      * And executing this way illustrates the impact and response under the two different scenarios.

1. To simulate failure of an AZ, select one of the Availability Zones used by your service (`us-east-2a`, `us-east-2b`, or `us-east-2c`) as `<az>`
      * For **scenario 1** select an AZ that is neither _primary_ nor _secondary_ for your RDS DB instance. Given the following RDS console you would choose `us-east-2c`
      * For **scenario 2** select the AZ that is _primary_ for your RDS DB instance. Given the following RDS console you would choose `us-east-2b`

      ![DBConfigurationShort](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/DBConfigurationShort.png)

1. use your VPC ID as `<vpc-id>`

1. Select _one_ (and only one) of the scripts/programs below. (choose the language that you setup your environment for).

    | Language   | Command                                             |
    | :--------- | :-------------------------------------------------- |
    | Bash       | `./fail_az.sh <az> <vpc-id>`                        |
    | Python     | `python3 fail_az.py <vpc-id> <az>`                   |
    | Java       | `java -jar app-resiliency-1.0.jar AZ <vpc-id> <az>` |
    | C#         | `.\AppResiliency AZ <vpc-id> <az>`                  |
    | PowerShell | `.\fail_az.ps1 <az> <vpc-id>`                       |

1. The specific output will vary based on the command used.
      * Note whether an RDS failover was initiated.  This would be the case if you selected the AZ containing the AWS RDS _primary_ DB instance

### 7.2 System response to AZ failure

Watch how the service responds. Note how AWS systems help maintain service availability. Test if there is any non-availability, and if so then how long.

#### 7.2.1 System availability

Refresh the service website several times

* **Scenario 1**: If you selected an AZ _not_ containing the AWS RDS _primary_ DB instance then you should see uninterrupted availability
* **Scenario 2**: If you selected the AZ containing the AWS RDS _primary_ DB instance, then an availability loss similar to what you saw with RDS fault injection testing will occur.

Verify your observations by going through the canary run data:

* Go to the AWS CloudFormation console at https://console.aws.amazon.com/cloudformation
* click on the `WebServersforResiliencyTesting` stack
* click on the **Outputs** tab
* Open the URL for **WorkloadAvailability** in a new window
* You will see that canary runs are failing because the website is _not_ available.

#### 7.2.2 Scenario 1 - Load balancer and web server tiers

This scenario is similar to the EC2 failure injection test because there is only one EC2 server per AZ in our architecture. Look at the same screens as you did before, for that test:

* [EC2 Instances](http://console.aws.amazon.com/ec2/v2/home?region=us-east-2#Instances:)
* Load Balancer [Target group](http://console.aws.amazon.com/ec2/v2/home?region=us-east-2#TargetGroups:)
* [Auto Scaling Groups](http://console.aws.amazon.com/ec2/autoscaling/home?region=us-east-2#AutoScalingGroups:)

One difference from the EC2 failure test that you will observe is that auto scaling will not replace the EC2 instance in the same AZ as the one that was terminated. Auto scaling attempts to balance the requested three EC2 instances across the remaining two AZs.

#### 7.2.3 Scenario 2 - Load balancer, web server, and data tiers

This scenario is similar to a combination of the RDS failure injection along with EC2 failure injection. In addition to the EC2 related screens look at the [Amazon RDS console](http://console.aws.amazon.com/rds), navigate to your DB screen and observe the following tabs:

* Configuration
* Monitoring
* Logs & Events

#### 7.2.4 AZ failure injection - conclusion

This similarity between **scenario 1** and the EC2 failure test, and between **scenario 2** and the RDS failure test is illustrative of how an AZ failure impacts your system. The resources in that AZ will have no or limited availability. With the strong partitioning and isolation between Availability Zones however, resources in the other AZs continue to provide your service with needed functionality. **Scenario 1** results in loss of the load balancer and web server capabilities in one AZ, while **Scenario 2** adds to that the additional loss of the data tier. By ensuring that every tier of your system is in multiple AZs, you create a partitioned architecture resilient to failure.

Our **hypothesis** is confirmed:
> Hypothesis: If an entire Availability Zone dies, then availability will not be impacted

#### 7.2.5 AZ failure recovery

This step is optional. To simulate the AZ returning to health do the following:

1. Go to the [Auto Scaling Group console](http://console.aws.amazon.com/ec2/autoscaling/home?region=us-east-2#AutoScalingGroups:)
1. Select the **WebServersforResiliencyTesting** auto scaling group
1. Actions >> Edit
1. In the **Subnet** field add any **ResiliencyVPC-PrivateSubnet**s that are missing (there should be three total) and **Save**
1. Go to the [Network ACL console](https://us-east-2.console.aws.amazon.com/vpc/home?region=us-east-2#acls:)
1. Look at the NACL entries for the VPC called **ResiliencyVPC**
1. For any of these NACLs that are _not_ _Default_ do the following
      1. Select the NACL
      1. **Actions** >> **Edit subnet associations**
      1. Uncheck all boxes and click **Edit**
      1. **Actions** >> **Delete network ACL**

* Note how the auto scaling redistributes the EC2 servers across the availability zones

{{< prev_next_button link_prev_url="../6_failure_injection_app" link_next_url="../8_failure_injection_optional/" />}}
