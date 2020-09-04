---
title: "Lab Recap"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 10
pre: "<b>10. </b>"
---

In this lab, you explored Well-Architected security best practices in the context of monitoring application and system logs.

First, you deployed a CloudFormation template containing an EC2 web server instance, an S3 bucket, and
networking infrastructure for the lab. Then, you installed, configured, and started up the CloudWatch agent remotely. Using Systems Manager Run Command demonstrates the best practices of “enabling people to perform actions at a distance” and “reducing attack surface” by enabling you to close ports on your instance and avoid having to SSH directly into it. Storing the agent configuration file in Parameter Store highlighted the best practice of “configuring services and resources centrally” by maintaining reusable configuration data in AWS.

Then, you generated some logs and viewed them in CloudWatch, illustrating the principle of “analyzing logs centrally” as you were able to view all your raw log data in a single location in CloudWatch. From there, you exported these logs to S3. This provides a method to store logs long term more cost-effectively in CloudWatch. Doing this facilitates the best practice of “configuring logging centrally” by enabling you to extract meaningful insights from large volumes of log data.

In Athena, you were able to query this S3 data using serverless SQL commands. You created a table within a database to track responses to site visits. In QuickSight, you directly used the results of your work in Athena to create a visualization. This keeps with the theme of “enabling people to perform actions from a distance” by abstracting the raw log data from users in both QuickSight and Athena. Additionally, you “analyzed logs centrally” in both services, generating useful insights from your application.

Overall, you should now have a better understanding of how to collect log data in a secure manner. You kept people away from directly accessing data and instances, which reduced the exposure of your workload. You also centrally implemented service and application logging, a valuable practice to monitor and investigate
 any security threats.

{{< prev_next_button link_prev_url="../9_create_quicksight_dashboard/" link_next_url="../11_teardown/" />}}
