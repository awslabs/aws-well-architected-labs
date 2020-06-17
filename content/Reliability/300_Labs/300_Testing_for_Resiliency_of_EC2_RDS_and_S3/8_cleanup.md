---
title: "Tear down this lab"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>8. </b>"
weight: 8
---

{{% common/EventEngineVsOwnAccountCleanup %}}

### Remove manually provisioned resources

Some resources were created by the failure simulation scripts. You need to remove these first

1. Go to the [Network ACL console](https://us-east-2.console.aws.amazon.com/vpc/home?region=us-east-2#acls:)
1. Look at the NACL entries for the VPC called **ResiliencyVPC**
1. For any of these NACLs that are _not_ _Default_ do the following
      1. Select the NACL
      1. **Actions** >> **Edit subnet associations**
      1. Uncheck all boxes and click **Edit**
      1. **Actions** >> **Delete network ACL**

### Remove AWS CloudFormation provisioned resources

As part of lab setup you have deployed several AWS CloudFormation stacks. These directions will show you:

* How to delete an AWS CloudFormation stack
* In what specific order the stacks must be deleted

#### How to delete an AWS CloudFormation stack

1. Go to the AWS CloudFormation console: <https://console.aws.amazon.com/cloudformation>
1. Select the CloudFormation stack to delete and click **Delete**

    ![DeletingWebServers](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/DeletingWebServers.png)

1. In the confirmation dialog, click **Delete stack**
1. The _Status_ changes to **DELETE_IN_PROGRESS**
1. Click the refresh button to update and status will ultimately progress to **DELETE_COMPLETE**
1. When complete, the stack will no longer be displayed. To see deleted stacks use the drop down next to the Filter text box.

    ![ShowDeletedStacks](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/ShowDeletedStacks.png)

1. To see progress during stack deletion
      * Click the stack name
      * Select the Events column
      * Refresh to see new events

### Delete workshop CloudFormation stacks

* Since AWS resources deployed by AWS CloudFormation stacks may have dependencies on the stacks that were created before, then deletion must occur in the opposite order they were created
* Stacks with the same ordinal can be deleted at the same time. _All_ stacks for a given ordinal must be **DELETE_COMPLETE** before moving on to the next ordinal

#### Single region

If you deployed the **single region** option, then delete your stacks in the following order

|Order|CloudFormation stack|
|:---:|:---|
|1|WebServersforResiliencyTesting|
|1|MySQLforResiliencyTesting|
|  |  |
|2|ResiliencyVPC|
|2|DeployResiliencyWorkshop|

#### Multi region

If you deployed the **multi region** option, then [see these instructions for the order in which to delete the CloudFormation stacks]({{< ref "Documentation/Multi_Region_Stack_Deletion.md" >}})

### Delete remaining resources

#### Delete Lambda execution role used to create custom resource

This role was purposely not deleted by the CloudFormation stack, because CloudFormation needs it to delete the custom resource it was used to create.  _Choose ONE_: AWS CLI **or** AWS Console.

* Do this step only after ALL CloudFormation stacks are **DELETE_COMPLETE**

Using AWS CLI:

    aws iam delete-role-policy --role-name LambdaCustomResourceRole-SecureSsmForRds --policy-name LambdaCustomResourcePolicy

    aws iam delete-role --role-name LambdaCustomResourceRole-SecureSsmForRds

Using AWS Console:

1. Go to the IAM Roles Console: <https://console.aws.amazon.com/iam/home#/roles>
1. Search for `SecureSsmForRds`
1. Check the box next to `LambdaCustomResourceRole-SecureSsmForRds`
1. Click **Delete role** button
1. Click **Yes, delete** button

#### Delete Systems Manager parameter

The password(s) for your Amazon RDS instances were stored in AWS Systems Manager secure parameter store. These steps will verify the parameter(s) were deleted, and if not then guide you to deleting them. _Choose ONE_: AWS CLI **or** AWS Console.

* **single region** You only need to do the following steps in **us-east-2**
* **multi region** Do the following steps for both **us-east-2** and **us-west-**2

Using AWS CLI:

* In the following command use the [workshop name supplied in step 1.4.4.](#deployinfra) when you ran the step function state machine. If you kept the defaults, the command will work as-is:

        aws ssm delete-parameter --name 300-ResiliencyofEC2RDSandS3

If you get `ParameterNotFound` then the password was already deleted by the CloudFormation stack (as expected).

Using AWS Console:

1. Select the region
1. Wait until **ResiliencyVPC** CloudFormation stack is **DELETE_COMPLETE** in the region
1. Go to the [AWS Console for AWS Systems Manager parameter store](https://console.aws.amazon.com/systems-manager/parameters/)
1. Look for the parameter created for your infrastructure. If you used our default values, this will be named **300-ResiliencyofEC2RDSandS3**
1. If it is not present (check all regions you deployed to) then you are finished
1. If it is present then
      1. Click on the parameter name
      1. Click the **Delete** button
      1. Click **Delete** again

---

## References & useful resources

* EC2 [Auto Scaling Groups](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html)
* [What Is an Application Load Balancer?](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)
* [High Availability (Multi-AZ) for Amazon RDS](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html)
* [Amazon RDS Under the Hood: Multi-AZ](https://aws.amazon.com/blogs/database/amazon-rds-under-the-hood-multi-az/)
* [Regions and Availability Zones](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.RegionsAndAvailabilityZones.html)
* [Injecting Chaos to Amazon EC2 using AWS System Manager](https://medium.com/@adhorn/injecting-chaos-to-amazon-ec2-using-amazon-system-manager-ca95ee7878f5)
* [Build a serverless multi-region, active-active backend solution in an hour](https://read.acloud.guru/building-a-serverless-multi-region-active-active-backend-36f28bed4ecf)
