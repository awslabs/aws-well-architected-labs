---
title: "Tear down"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

The following instructions will remove the resources that have a cost for running them. Please note that
Security Groups and SSH key will exist. You may remove these also or leave for future use.

Terminate the instance:

1. Sign in to the AWS Management Console, and open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.
2. From the left console instance menu, select Instances.
3. Select the instance you created to terminate.
4. From the Actions button (or right click) select Instance State > Terminate.

![ec2-terminate](/Security/200_Basic_EC2_with_WAF_Protection/Images/ec2-terminate.png)

5. Verify this is the instance you want terminated, then click the Yes, Terminate button.

Delete the Application Load Balancer:

1. Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.
2. From the console dashboard, choose Load Balancers from the Load Balancing section.
3. Choose the load balancer you created previously such as `lab-alb` and click Actions, then Delete.
4. Confirm by clicking Yes, Delete.
5. From the console dashboard, choose Target Groups from the Load Balancing section.
3. Choose the target group you created previously such as `lab-alb` and click Actions, then Delete.

Delete the AWS WAF stack:

1. Open the CloudFormation console at https://console.aws.amazon.com/cloudformation/.
2. Select the `lab-waf-regional` stack.
3. Click the Actions button, and then click Delete Stack.
4. Confirm the stack, and then click the Yes, Delete button.
