# Level 200: EC2 Right Sizing - Collecting Memory utilization from EC2 Instances
http://wellarchitectedlabs.com 

## Introduction
 This hands-on lab will guide you through the steps to install the CloudWatch agent to collect memory utilization (% GB consumption) and analyze how that new datapoint can help during EC2 right sizing exercises with the AWS Resource Optimization tool.
 
## Goals
- Learn how to check metrics like CPU, Network and Disk usage on Amazon CloudWatch
- Learn how to install and collect Memory data through a custom metric at Amazon CloudWatch
- Enable AWS Resource Optimization and observe how the recommendations are impacted by this new datapoint (Memory)

## Prerequisites
- Root user access to the master account
- Enable AWS Resource Optimization at *AWS Cost Explorer > Recommendations* no additional cost.

## Permissions required
- Root user access to the master account
- NOTE: There may be permission error messages during the lab, as the console may require additional privileges. These errors will not impact the lab, and we follow security best practices by implementing the minimum set of privileges required.

<BR>

## [Start the Lab!](Lab_Guide.md)

<BR>
<BR> 

## Best Practice Checklist
- [ ] Launch Amazon CloudWatch and observe the average CPU, Disk and Network consuption of your EC2 instances
- [ ] Manually install CloudWatch Agent on an EC2 instance to track memory utilization
- [ ] Observe the impact on the AWS Resource Optimization when you have additional datapoints (Memory utilization)

***

## License
Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
