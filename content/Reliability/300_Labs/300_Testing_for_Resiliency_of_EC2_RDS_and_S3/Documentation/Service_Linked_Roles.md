---
title: "Service-Linked Roles"
date: 2020-04-24T11:16:09-04:00
chapter: false
hidden: true
---

## Does AWS account already have service-linked roles {#exist_service_linked_roles}

AWS requires “service-linked” roles for **AWS Auto Scaling**, **Elastic Load Balancing**, and **Amazon RDS** to create the services and metrics they manage. If your AWS account has been previously been used, then these roles may already exist as they would have been automatically created for you. You will determine if any of the following three IAM service-linked roles already exists in the AWS account you are using for this workshop:

* `AWSServiceRoleForElasticLoadBalancing`
* `AWSServiceRoleForAutoScaling`
* `AWSServiceRoleForRDS`

### Steps to determine if service-linked roles already exist

1. Open the IAM console at [https://console.aws.amazon.com/iam/](https://console.aws.amazon.com/iam/)

1. In the navigation pane, click **Roles**.  
![SelectIAMRoles](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/SelectIAMRoles.png)  

1. In the filter box, type “Service” to find the service linked roles that exist in your account and look for the three roles. In this screenshot, the service linked role for AutoScaling exists (`AWSServiceRoleForAutoScaling`), but the roles for Elastic Load Balancing and RDS do not. Note which roles already exist as you will use this information when performing the next step.  
![LookingForServiceLinkedRoles](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/LookingForServiceLinkedRoles.png)

**STOP HERE and return to the [Lab Guide]({{< ref "../1_deploy_infra.md#create_statemachine" >}})**

---
*__Learn more__: After the lab see [the AWS documentation on Service-Linked Roles](https://docs.aws.amazon.com/IAM/latest/UserGuide/using-service-linked-roles.html)*

---

## Setup CloudFormation for service-linked roles {#cfn_service_linked_roles}

**If you are using your own AWS account**: Then use these instructions when entering CloudFormation parameters

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**: Skip this step and go to back to the [Lab Guide]({{< ref "../1_deploy_infra.md#create_statemachine" >}})

| If you already have this role           | ...then set this parameter **`false`** |
| --------------------------------------- | ----------------------------------- |
| `AWSServiceRoleForElasticLoadBalancing` | `CreateTheELBServiceRole`           |
| `AWSServiceRoleForAutoScaling`          | `CreateTheAutoScalingServiceRole`   |
| `AWSServiceRoleForRDS`                  | `CreateTheRDSServiceRole`           |

* If the service-linked role does not already exist, then leave the parameter value as **`true`**

![CFNParameters-service-linked-ohio](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CFNParameters-service-linked-ohio.png)

* Leave all the other parameter values at their [default values]({{< ref "./CFN_Parameters.md" >}})
