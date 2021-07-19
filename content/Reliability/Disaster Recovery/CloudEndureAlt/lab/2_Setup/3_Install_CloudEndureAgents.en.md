+++
title = "Install Agents on Source Machines"
weight = 3
+++

#### Install CloudEndure Agents

From [CloudEndure console](https://console.cloudendure.com/), navigate to the Machines screen which will show you How to Add Machines and provide instructions to install the agent on the source machine. This is how an instruction will look like. 

![Instructions](/lab1/instructions.png?classes=shadow,border&height=250px)

### Install Agent on the Webserver

Get the source Webserver information




![AWS-RunShellScriptParams](/lab1/AWS-RunShellScriptParams.png?classes=shadow,border)

For target instances, select **Choose instances manually**. Then check the checkbox next to Database & Web server instances to select them, as shown in the following screenshot.

{{%expand "CloudEndure Agent Additional Options" %}}
``` 
-t TOKEN, --token=TOKEN
--no-replication – for stopping the replication from starting automatically.
--no-prompt – for running a silent installation.
[Linux] --devices=disks to replicate; [Windows] --drives=disks to replicate
Note: To replicate selected disks of the Source machine, type the exact list of physical disks you want to replicate, and separate them with a comma, as follows: [Linux] /dev/sda,/dev/sdb [Windows] C:,D:,E:

--force-volumes – must be used with the --no-prompt argument - for cancelling the automatic Agent Installer detection of physical disks to replicate, following your –-drives/–-device input. When using this argument, you will need to specify the exact list of physical disks. The first disk in the list must be the boot disk. 
--log-file – Agent Installer log file name.
—no-auto-disk-detection - Disables the Agent's automatic disk detection functionality. You will be prompted to select which disks you want to replicate and newly added disks will not be automatically detected.
```
{{% /expand%}}


![AWS-RunShellScriptTargets](/lab1/AWS-RunShellScriptTargets.png?classes=shadow,border&height=350px)

From the Output options, uncheck the **Enable writing to an S3 bucket** box and click on Run button. Wait until the status changes to Success.

![AWS-RunShellScriptsSuccess](/lab1/AWS-RunShellScriptSuccess.png?classes=shadow,border&height=350px)

Then navigate back to the **CloudEndure User Console** browser dashboard. Your instance now appears as an object in the Initial Sync phase. Wait until all instances reach **Continuous Data Replication** in the Data Replication Progress column.

![CloudEndure Machine Status](/lab1/machine_status_cloudendure.PNG?classes=shadow,border&height=350px)

While the instances are being replicated, let's move on to configuring a CloudEndure Target Machine Blueprint, which is the specification of your Target machine (replicated instance) that will be launched in AWS.