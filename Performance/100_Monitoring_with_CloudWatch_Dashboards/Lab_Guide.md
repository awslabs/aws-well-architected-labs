# Level 100: Monitoring with CloudWatch Dashboards

## Authors

- Ben Potter, Security Lead, Well-Architected

## 1. View Amazon CloudWatch Automatic Dashboards <a name="automatic_dashboards"></a>

Amazon CloudWatch Automatic Dashboards allow you to easily monitor all AWS Resources, and is quick to get started. Explore account and resource-based view of metrics and alarms, and easily drill-down to understand the root cause of performance issues.

1. Open the Amazon CloudWatch console at [https://console.aws.amazon.com/cloudwatch/](https://console.aws.amazon.com/cloudwatch/) and select your region from the top menu bar.

![monitoring-overviewpage-console](Images/monitoring-overviewpage-console.png)

2. The upper left shows a list of AWS services you use in your account, along with the state of alarms in those services. The upper right shows two or four alarms in your account, depending on how many AWS services you use. The alarms shown are those in the ALARM state or those that most recently changed state.
These upper areas enable you to assess the health of your AWS services, by seeing the alarm states in every service and the alarms that most recently changed state. This helps you monitor and quickly diagnose issues.
3. Below these areas is the custom dashboard that you have created and named CloudWatch-Default, if any. This is a convenient way for you to add metrics about your own custom services or applications to the overview page, or to bring forward additional key metrics from AWS services that you most want to monitor.
4. If you use six or more AWS services, below the default dashboard is a link to the automatic cross-service dashboard. The cross-service dashboard automatically displays key metrics from every AWS service you use, without requiring you to choose what metrics to monitor or create custom dashboards. You can also use it to drill down to any AWS service and see even more key metrics for that service.
If you use fewer than six AWS services, the cross-service dashboard is shown automatically on this page.

***

## References & useful resources

* [See Key Metrics From All AWS Services](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Automatic_Dashboards_Cross_Service.html)
* [Focus on Metrics and Alarms in a Single AWS Service](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Automatic_Dashboards_Focus_Service.html)
* [Focus on Metrics and Alarms in a Resource Group](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Automatic_Dashboards_Resource_Group.html)

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
