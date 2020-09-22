---
title: "Bonus Content"
menutitle: "Bonus Content"
date: 2020-09-15T11:16:09-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

Now that dependency monitoring has been established by leveraging CloudWatch Metrics and CloudWatch alarms, the last piece of the "puzzle" is to ensure that events related to the external service are tracked effectively so that relevant stakeholders are aware of the status of resolution. Alarms and notifications are good to alert teams of potential issues, however, tracking an event such as this will ensure co-ordination of efforts towards resolution. [AWS Systems Manager OpsCenter](https://docs.aws.amazon.com/systems-manager/latest/userguide/OpsCenter.html) can be used to achieve this. An OpsItem can be created to track events and quickly understand the current status of an event and can help answer questions such as - what level of severity is the event? what resources are affected? what is the status of the event? are there other events similar to this?

Automating creation of an OpsItem, coupled with alarms and notifications will allow teams to quickly triage events and lead to faster, more organized resolution.

![ArchitectureBonus.png](/Operations/100_Dependency_Monitoring/Images/ArchitectureBonus.png)

This process can be automated by using a Lambda function to create an OpsItem every time the dependency alarm goes into an **In alarm** state.

1. Go to the Amazon SNS console at <https://console.aws.amazon.com/sns/v3> and click on **Topics**
1. Click on the SNS Topic that was created as part of this lab - `WA-Lab-Dependency-Notification`

    ![SNSSelectTopic](/Operations/100_Dependency_Monitoring/Images/SNSSelectTopic.png)

1. Scroll down to the **Subscriptions** section and click on **Create subscription**

    ![SNSAddSubscription](/Operations/100_Dependency_Monitoring/Images/SNSAddSubscription.png)

1. On the **Create subscription** page, make the following changes:

    * **Topic ARN** - leave the default value that is already on there
    * **Protocol** - select AWS Lambda from the dropdown
    * **Endpoint** - paste the ARN of the **OpsItemFunction** copied from the **Outputs** section of the CloudFormation stack from section 1 **Deploy the Infrastructure**

1. Click on **Create subscription**

    ![SNSCreateSubscription](/Operations/100_Dependency_Monitoring/Images/SNSCreateSubscription.png)

To test this, follow the instructions in the previous section on testing a fail condition by deleting the default route. This time, when the alarm goes into an **In alarm** state, an OpsItem will be created in OpsCenter, in addition to the notification being sent to the email address specified.

1. Go to the AWS Systems Manager console at <https://console.aws.amazon.com/systems-manager> and click on **OpsCenter**
1. Click on the **OpsItems** tab, search by **Title**, select **contains**, and enter the value as `S3 Data Writes`
1. Click on the OpsItem that has been created with the title **S3 Data Writes failing**

    ![SSMOpsCenter](/Operations/100_Dependency_Monitoring/Images/SSMOpsCenter.png)

1. Expand the **OpsItem details** section by clicking on the triangle next to it, and view the information available there such as severity, category, etc.
1. Scroll down to the see the **Related resources**, in this case, the S3 bucket to which the writes are failing

    ![SSMOpsItem](/Operations/100_Dependency_Monitoring/Images/SSMOpsItem.png)

The event can now be efficiently tracked using the OpsItem, and remediation work can be better co-ordinated. Additionally, you can choose to execute pre-created [Runbooks](https://docs.aws.amazon.com/systems-manager/latest/userguide/OpsCenter-remediating.html) which are listed under the **Runbooks** section and automate the remediation. You can create custom runbooks depending on the type of event.
