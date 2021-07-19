+++
title = "Failover"
weight = 4

+++

Once you have completed the replication of volumes (status next to machine name says **Continuous Data Replication**) and set up the blueprint as per our requirements, we are then able to perform a **Test/Failover**.

This is how the project looks when it is in **Continous Data Protection** mode. 
![CDP Status](/lab1/instances_cdp_status.PNG?classes=shadow,border)

{{% notice note %}}
CloudEndure will, by default, removes any resources created during the test process either when requested by the user or when a new test machine is launched. To prevent this in AWS, you can enable Termination Protection, for the Target instance, and the resources will not be removed upon a new Target launch.

{{% /notice %}}

1. Confirm that the volumes are fully replicated
   
    Confirm that the instance is in a state of **Continuous Data Replication** under the **DATA REPLICATION PROGRESS** column.

    If it's still replicating, wait until it reaches the **Continuous Data Replication** state. While waiting you can review <a href="https://docs.cloudendure.com/" target="_blank">CloudEndure documentation</a>.

2. From the **Machines** list select the DBServer and the Webserver that you want to Failover, click **LAUNCH 2 TARGET MACHINE** button in the top right corner of the screen, then **Recovery Mode** and **CONTINUE** in the confirmation popup.

    ![CE-Failover](/lab1/recovery_mode_launch.png?classes=shadow,border)


    In the next screen, choose Recovery Point. With CloudEndure you can perform Point-in-Time Recovery. The frequency and number of Recovery Points are exact - every 10 minutes in the last hour, every hour in the last day and every day in the last month (60 in total per disk).

    ![Recovery Point](/lab1/choose_recovery_point.png?classes=shadow,border&height=350px)

    CloudEndure will now perform a final sync/snapshot on the volumes and begin the process of building new servers in the target infrastructure, all while maintaining data consistency. See the **Job Progress** screen for details.


    ![CE-job-progress](/lab1/job_progress.PNG?classes=shadow,border)

    Monitor the **Job Progress** log until you see **Finished starting converters** message (it should take 3-5 minutes). 

    

{{% notice tip %}}
While the Job is progressing, please review the [Connectivity Requirements](https://docs.cloudendure.com/#Preparing_Your_Environments/Network_Requirements/Network_Requirements.htm) for CloudEndure DisasterRecovery solution.
{{% /notice %}}

1. Review resources created by CloudEndure in your AWS account
   
    Switch back to the [AWS Console](https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:).
   
    You will see two additional instances managed by CloudEndure:
    - **CloudEndure Machine Converter** - used for conversion of the source boot volume, making AWS-specific bootloader changes, injecting hypervisor drivers and installing cloud tools. It's running for couple of minutes per each Test or Failover.
    - **CloudEndure Replication Server** - used to receive encrypted data from agents installed in the source environment. It's running when the replication of data is taking place.

    Both types of instances are fully managed by CloudEndure and are NOT accessible by users.

    As soon as the failover is finished, you will see 2 new EC2 instance on [AWS Console](https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#Instances:) - this is your target Webserver and DB Servers created by CloudEndure. 
    Make a note of Webserver's public and Database server's private IPs, as you will need them in the next step.

    ![Launched Instances](/lab1/launched_instances.png?classes=shadow,border)

    5. Select the webserver and copy its public DNS/IP and paste it in browser. It shall show the PHP landing page.

    ![Test PHP WebServer](/lab1/test_dr_site.png?classes=shadow,border&height=350px)

    This will confirm that, our test of the DR site is successful. Congratulations! You have set up your DR environment to AWS using CloudEndure.

{{% notice info %}}
Please note that in an actual DR, after the failover completes, additional manual steps are needed to change the website’s DNS entry to point to the IP address of the failed over webserver. However, since CloudEndure operations can be invoked via API, this process can be fully automated. For more information on this topic, please refer this [blog post](https://aws.amazon.com/blogs/architecture/automated-disaster-recovery-using-cloudendure/).  
{{% /notice %}}