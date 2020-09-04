---
title: "Store the CloudWatch Config File in Parameter Store"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## 3. Create the CloudWatch Config File with Parameter Store

You will use Parameter Store, a tool in Systems Manager, to store the CloudWatch agent configuration. Parameter store allows you to securely store configuration data and secrets for reusability. You can re-use configuration data that is well controlled and consistent. In this case, you need to store the configuration file for CloudWatch Agent on your EC2 instance. The CloudWatch agent configuration data specifies which logs and metrics will be sent to CloudWatch as well as the source of this data.

1. Open the [Systems Manager console](https://console.aws.amazon.com/systems-manager/).
2. Choose **Parameter Store** from the left side menu under **Application Management.** Choose **Create parameter** from that screen.

![create-cw-config-1](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/create-cw-config-1.png)

3. Enter the parameter name `AmazonCloudWatch-securitylab-cw-config`. You may use a different name, but it *must* begin with `AmazonCloudWatch``-` in order to be recognized by CloudWatch as a valid configuration file.
4. Give your parameter a description, such as “This is a CloudWatch Agent config file for use in the Well Architected security lab”.
5. Set **Tier** to **Standard.**
6. Set **Type** to **String.**
7. Set **Data type** to **text.**
8. In the **Value** field, copy and paste the contents of the [`config.json`](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/code/config.json) file found in the lab assets. This config file specifies which metrics and logs to collect.
   1. The `agent` section specifies which user to run the logs agent as, and how frequently to collect logs.
   2. The `logs` section specifies which log files to monitor and which log group and stream to place those logs in. This information can be seen in `collect_list`. For this lab, you are collecting SSH logs, Apache Web Server logs, and logs for the CloudWatch Agent itself. We will examine these logs more closely in a later step
   3. The `metrics` section specifies which metrics are collected (in `metrics_collected`), the frequency of collection, measurement, and other details.
   4. To learn more about creating config files, see [this link](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch-Agent-Configuration-File-Details.html#CloudWatch-Agent-Configuration-File-Agentsection).
9. Click **Create parameter**.

![create-cw-config-2](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/create-cw-config-2.png)

**Recap**: In this portion of the lab, you created a re-usable, centrally stored configuration file stored in Amazon Systems Manager Parameter Store. You can re-use configuration data stored in Parameter Store while ensuring that it is consistent and correct across uses. This becomes especially helpful when scaling, as you can re-use configuration files across fleets of instances. This highlights the Well-Architected best practice of “configuring services and resources centrally” by maintaining configuration files centrally in Parameter Store.

{{< prev_next_button link_prev_url="../2_install_cw_agent/" link_next_url="../4_start_cw_agent/" />}}
