---
title: "Teardown"
date: 2020-11-19T12:00:00-04:00
chapter: false
weight: 6
pre: "<b>6. </b>"
tags:
 - Windows Server
 - Windows
 - EC2
 - CloudWatch
 - CloudWatch Dashboard
---

## Summary
In order to monitor your compute resources to ensure they are performing properly, you must record performance related metrics. In this simple lab, you were able to create an EC2 instance and generate a simulated high-load situation to observe how CloudWatch can be used to monitor those resources.  These are important concepts that you should use across all of your compute resources to ensure you are meeting [PERF7 - "How do you monitor your resources to ensure they are performing?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-monitoring.html)

Now that you know how to have an EC2 instance report its metrics to CloudWatch, you should define the Key Performance Indicators (KPIs) to measure workload performance. In some cases, such as a image rendering farm, a high-cpu may be a valid metric and not be indicative of performance. Once defined, you should establish CloudWatch alarms to ensure you are meeting your performance metrics. 


## Additional Tasks
In addition to the lab tasks, feel free to use this lab deployment to test some additional CloudWatch features:
- Create a CPU or Memory alarm and test triggering the alarm by running the cpu_stress.ps1 script
  - https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/using-cloudwatch-createalarm.html
- Zoom into various timeframes on the CloudWatch dashboard. Notice how it will link the two charts together when you zoom in.
- Use Metrics Explorer to look at other metrics deployed into the EC2 instance
- Explore the CloudFormation template to see how the various CW Agent configurations were deployed

## Remove all the resources via CloudFormation
{{% common/DeleteCloudFormationStack %}}

## Delete the CloudWatch Dashboard
1. Go to [CloudWatch Dashboards](https://console.aws.amazon.com/cloudwatch/home?#dashboards:)
1. Click the radio button next to the dashboard you created and then click Delete


## References & useful resources
* [Using CloudWatch Dashboards](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Dashboards.html)
* [Monitoring your Windows instances using CloudWatch](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/using-cloudwatch.html)
* [Connect to a Windows instance using Session Manager](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/connecting_to_windows_instance.html#session-manager)

{{< prev_next_button link_prev_url="../5_generating_load/" title="Congratulations!" final_step="true"  />}}
Now that you have completed the lab, if you have implemented this knowledge in your environment, you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with [PERF7 - "How do you monitor your resources to ensure they are performing?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-monitoring.html)
{{< prev_next_button />}}
