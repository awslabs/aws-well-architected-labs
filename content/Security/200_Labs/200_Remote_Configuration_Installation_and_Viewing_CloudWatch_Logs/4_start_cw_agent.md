---
title: "Start the CloudWatch Agent"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

Now that your CloudWatch agent is installed on your EC2 Instance, we need to load the configuration file and restart the CloudWatch agent in order to begin collecting logs. This can be done remotely from the Systems Manager console using Run Command.

1. Open the [Systems Manager console](http://%20https//console.aws.amazon.com/systems-manager/).
2. Choose **Run command** from the left side menu under **Instances & Nodes.** Click **Run Command** on the page that opens up.
3. In the **Command document** box, click in the search bar. Select “**Document name prefix”**, then “**equals**”, and enter **AmazonCloudWatch-ManageAgent**. Select the command that appears in the results. This command sends commands directly to the CloudWatch agent on your instances by remotely running scripts on the instance. You will be sending a “configure” command with the created parameter from Parameter Store to instruct the CloudWatch agent installed on the EC2 instance to use this configuration and start collecting logs.

![start-cw-agent-1](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/start-cw-agent-1.png)

4. Under **Command parameters:**
   1. Set **Action** to **Configure**.
   2. Set **Mode** to **ec2**.
   3. Set **Optional Configuration Source** to **ssm**.
   4. Set **Optional Configuration Location** to the name of the parameter you created in **Parameter Store**. If you used the name provided above, it should be called `AmazonCloudWatch-securitylab-cw-config`.
   5. Set **Optional Restart** to **yes**.

![start-cw-agent-2](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/start-cw-agent-2.png)

5. Under **Targets**:
   1. Select **Choose instances manually**.
   2. You should see a list of running instances. Select the instance that was launched by the CloudFormation template you deployed for this lab. This will be named `Security-CW-Lab-Instance`.
6. Under **Output Options**, deselect **Enable writing to an S3 bucket**.
7. Choose **Run**.
8. Optionally, in the **Targets and outputs** areas, select the button next to an instance name and choose **View output**. Systems Manager should show that the agent was successfully installed in a few seconds.

**Recap:** In this section, you started the CloudWatch Agent on your EC2 instance using Systems Manager Run Command. The command ran a shell script on the EC2 instance. This script instructs the CloudWatch agent to use the configuration file stored in Parameter Store, which gives the agent information on where to collect logs from, how often to collect them, and how to store them in CloudWatch. The script instructs the agent to reboot and begin collecting logs. This “enables people to perform actions at a distance” by not directly accessing the instance.

{{< prev_next_button link_prev_url="../3_create_cw_config.md/" link_next_url="../5_generate_logs/" />}}
