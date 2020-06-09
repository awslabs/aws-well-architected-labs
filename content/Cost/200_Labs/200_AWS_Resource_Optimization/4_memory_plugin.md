---
title: "Cloudwatch Agent Manual Install"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

1. We are now going to manually install the **CloudWatch agent** to start collecting memory data, to start let's go back to the **Amazon EC2 Dashboard**.
![Images/MemInstall01.png](/Cost/200_AWS_Resource_Optimization/Images/AgentInstall01.png)

2. On the left bar, click on **Instances** and select the **EC2 Instance** with the *CloudWatchAgentServerRole* IAM role.
![Images/MemInstall02.png](/Cost/200_AWS_Resource_Optimization/Images/AgentInstall02.png)

3. Connect into the EC2 Instance using the **browser-based SSH connection tool**.
![Images/MemInstall03.png](/Cost/200_AWS_Resource_Optimization/Images/AgentInstall03.png)
![Images/MemInstall04.png](/Cost/200_AWS_Resource_Optimization/Images/AgentInstall04.png)
![Images/MemInstall05.png](/Cost/200_AWS_Resource_Optimization/Images/AgentInstall05.png)

4. Download the **Amazon Cloudwatch** agent package, the instructions below are for Amazon Linux, for other OS please check [here](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/download-cloudwatch-agent-commandline.html)

```
wget https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip
```

![Images/MemInstall06.png](/Cost/200_AWS_Resource_Optimization/Images/AgentInstall06.png)

5. Unzip and Install the package

```
unzip AmazonCloudWatchAgent.zip
sudo ./install.sh
```

![Images/MemInstall07.png](/Cost/200_AWS_Resource_Optimization/Images/AgentInstall07.png)

6. Configure the AmazonCloudWatchAgent profile

Before running the CloudWatch agent on any servers, you must create a CloudWatch agent configuration file, which is a JSON file that specifies the metrics and logs that the agent is to collect, including custom metrics. You can create it by using the wizard or by writting it yourself from scratch. Any time you change the agent configuration file, you must then restart the agent to have the changes take effect.

The wizard can autodetect the credentials and AWS Region to use if you have the AWS credentials and configuration files in place. For more information about these files, see [Configuration and Credential Files](https://docs.aws.amazon.com/cli/latest/userguide/cli-config-files.html) in the *AWS Systems Manager User Guide* and the [AWS documentation page](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/create-cloudwatch-agent-configuration-file.html).

For now, let's start the CloudWatch agent configuration file wizard executing the command below at the selected EC2 instance.

```
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-config-wizard
```

![Images/MemInstall08.png](/Cost/200_AWS_Resource_Optimization/Images/AgentInstall08.png)

For this lab we want to keep the following structure:

| CloudWatch Agent Configutation File Wizard                  | Parameter    |
| ----------------------------------------------------------- |:------------:|
| On which OS are you planning to use the agent?              | 1. Linux     |
| Are you using EC2 or On-Premises hosts?                     | 1. EC2       |
| Which user are you planning to run the agent?               | 2. cwagent   |
| Do you want to turn on StatsD daemon?                       | 2. No        |
| Do you want to monitor metrics from CollectD?               | 2. No        |
| Do you want to monitor any host metrics?                    | 1. Yes       |
| Do you want to monitor cpu metrics per core?                | 2. No        |
| Do you want to add ec2 dimensions?                          | 1. Yes       |
| Would you like to collect your metrics at high resolution?  | 4. 60s       |
| Which default metrics config do you want?                   | 1. Basic     |
| Are you satisfied with the above config?                    | 1. Yes       |
| Do you have any existing CloudWatch Log Agent?              | 2. No        |
| Do you want to monitor any log files?                       | 2. No        |
| Do you want to store the config in the SSM parameter store? | 2. No        |

The CloudWatch Agent config file should look like the following:

```
{
	"agent": {
			"metrics_collection_interval": 60,
			"run_as_user": "cwagent"
	},
	"metrics": {
			"append_dimensions": {
				"AutoScalingGroupName": "${aws:AutoScalingGroupName}",
				"ImageId": "${aws:ImageId}",
				"InstanceId": "${aws:InstanceId}",
				"InstanceType": "${aws:InstanceType}"
			},
			"metrics_collected": {
				"disk": {
					"measurement": [
						"used_percent"
				],
				"metrics_collection_interval": 60,
					"resources": [
							"*"
				]
			},
			"mem": {
					"measurement": [
						"mem_used_percent"
					],
					"metrics_collection_interval": 60
			}
		}
	}
}
```

7. Start the CloudWatch Agent

```
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
```

![Images/MemInstall09.png](/Cost/200_AWS_Resource_Optimization/Images/AgentInstall09.png)

It may take up to 5 minutes for the metrics to become available, go back to the **Amazon CloudWatch** console page, under the **Metrics** session to validate that you are getting Memory information.

Click **CWAgent**:
![Images/MemInstall10.png](/Cost/200_AWS_Resource_Optimization/Images/AgentInstall10.png)

Click **ImageID,InstanceID,InstanceType**:
![Images/MemInstall11.png](/Cost/200_AWS_Resource_Optimization/Images/AgentInstall11.png)

Select the **Instance** from the list below:
![Images/MemInstall12.png](/Cost/200_AWS_Resource_Optimization/Images/AgentInstall12.png)

You have now completed the CloudWatch agent installation and will be able to monitor on Amazon CloudWatch the memory utilization of that instance.

**[BONUS]** The next step is not mandatory to complete this lab.

If you have a lot of instances manually installing the CloudWatch agent in each of them is not a scalable option, instead consider using a pre-configured AWS CloudFormation template to automatically install the CloudWatch agent by default on all your stack. As an example on how to do that check the following steps:

- Right-click and save link as: [here](https://raw.githubusercontent.com/awslabs/aws-cloudformation-templates/master/aws/solutions/AmazonCloudWatchAgent/inline/amazon_linux.template) to download the **AWS Cloudformation** template

- Go to the **AWS CloudFormation** console

- Click to **Create Stack** and select **Upload a template file** and point to the downloaded file

- Enter a **Stack Name** and select a **KeyName**

- Enter the tag **Key: Event | Value: myStackforWACostLab**

- Click **Next** and **Create stack**
