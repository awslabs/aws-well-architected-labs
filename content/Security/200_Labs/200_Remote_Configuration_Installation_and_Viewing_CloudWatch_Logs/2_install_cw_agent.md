---
title: "Install the CloudWatch Agent"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

The CloudWatch agent monitors activity on your EC2 instance to collect logs and metrics. This improves your security posture by providing detailed records you can use to investigate security incidents. The CloudWatch agent needs to be installed on the EC2 instance using AWS Systems Manager Run Command. Run Command enables you to perform actions on EC2 instances remotely. This tool is especially helpful at scale, where you can manage the  configuration of many instances with a single command. It is possible to completely automate this process using user data scripts, but that is beyond the scope of this lab.

1. Open the [Systems Manager console](https://console.aws.amazon.com/systems-manager/).
2. Choose **Run Command** from the left side menu under **Instances & Nodes.** Click **Run Command** on the page that opens up.

![install-cw-agent-1](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/install-cw-agent-1.png)

3. In the **Command document** box, click in the search bar. Select “**Document name prefix”**, then “**Equals**”, and enter **AWS-ConfigureAWSPackage**. Select the command that appears below. This command allows you to install packages on EC2 instances without directly accessing the instance; the `AmazonCloudWatchAgent` package we will use in this lab is one of these packages.

![install-cw-agent-2](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/install-cw-agent-2.png)

4. Under **Command parameters:**
   1. Set **Action** to **Install**
   2. Set **Installation Type** to **Uninstall and Reinstall**
   3. In the **Name **field**,** enter `AmazonCloudWatchAgent`
   4. In the **Version** field, enter `latest`
   5. Do not modify the **Additional Arguments** field

![install-cw-agent-3](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/install-cw-agent-3.png)

5. Under **Targets**:
   1. Select **Choose instances manually**.
      1. For the purpose of this lab, there is only one EC2 Instance you need to run a command on. If you have a large fleet of EC2 instances, you can assign a tag to those instances and choose **Specify instance tags** to run a command on many tagged instances easily.
      2. You should see a list of running instances. Select the instance that was launched by the CloudFormation template you deployed for this lab, which will be named `Security-CW-Lab-Instance`.
      3. In order to use Systems Manager with an instance, the instance needs certain IAM permissions. The initial CloudFormation stack you deployed created and assigned an [IAM role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles.html) to this instance. The [policy](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies.html) document `AmazonSSMManagedInstanceCore` is attached to this role, allowing Systems Manager to perform operations on the instance.

![install-cw-agent-4](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/install-cw-agent-4.png)

6. Under **Output Options**, deselect **Enable writing to an S3 bucket**.
7. Choose **Run**.
8. Optionally, in the **Targets and outputs** areas, select the button next to an instance name and choose **View output**. Systems Manager should show that the agent was successfully installed.

**Recap:** In this portion of the lab, you installed the AWS CloudWatch agent on an EC2 Instance using AWS Systems Manager Run Command. Run Command facilitated installing the package on the instance without directly accessing it using SSH - exemplifying the Well-Architected Best Practice of “enabling people to perform actions at a distance” and “reducing attack surface”.

{{< prev_next_button link_prev_url="../1_deploy_cfn_stack/" link_next_url="../3_create_cw_config/" />}}
