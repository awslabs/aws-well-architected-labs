# Service-Linked Roles

AWS requires “service-linked” roles for AWS Auto Scaling, Elastic Load Balancing, and Amazon RDS to create the services and metrics they manage. If your AWS account has been previously been used, then these roles may already exist as they would have been automatically created for you. You will determine if any of the following three IAM service-linked roles already exists in the AWS account you are using for this workshop:

* AWSServiceRoleForElasticLoadBalancing
* AWSServiceRoleForAutoScaling
* AWSServiceRoleForRDS

1. Open the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/)

2. In the navigation pane, click **Roles**.  
![SelectIAMRoles](../Images/SelectIAMRoles.png)  

1. In the filter box, type “Service” to find the service linked roles that exist in your account and look for the three roles. In this screenshot, the service linked role for AutoScaling exists (`AWSServiceRoleForAutoScaling`), but the roles for Elastic Load Balancing and RDS do not. Note which roles already exist as you will use this information when performing the next step.  
![LookingForServiceLinkedRoles](../Images/LookingForServiceLinkedRoles.png) 

---
*__Learn more__: After the lab see [the AWS documentation on Service-Linked Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/using-service-linked-roles.html)*
