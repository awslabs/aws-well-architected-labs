# Level 200: Implementing Bi-Directional Cross-Region Replication for Amazon Simple Storage Service (Amazon S3)

## Author

* Seth Eliot, Principal Reliability Solutions Architect, AWS Well-Architected

## AWS Well-Architected

This lab illustrates best practices for reliability as described in the [AWS Well-Architected](https://aws.amazon.com/architecture/well-architected/) Reliability pillar. It addresses best practices to help answer the questions:

* How do you back up data?
* How do you plan for disaster recovery (DR)?

When this lab is completed, you will have two S3 buckets in two regions. When a new object is put into one of them, it will be replicated to the other. Objects will be encrypted in both buckets. Objects will be replicated once -- no replication "looping" will occur.

![ReplicationOverview](Images/ReplicationOverview.jpg)

This is a useful configuration for multi-region strategies that enable the workload to _failover_ from the primary to the secondary region. All objects that were added to the primary region S3 bucket are asynchronously replicated to the secondary region S3 bucket. After a failover, when the workload is running in what was the secondary region, new objects added to the bucket in this region are _also_ asynchronously replicated back to what was the primary region bucket. This bi-directional replication occurs automatically. Looping is eliminated with this configuration -- an object replicated from the primary region bucket to the secondary secondary bucket will _not_ be re-replicated back to the primary.

## Table of Contents

1. [Deploy the infrastructure](#deploy_infra)
1. [Configure bi-directional cross-region replication for S3 buckets](#configure_replication)
1. [Test replication](#test_replication)
1. [Tear down this lab](#tear_down)

## 1. Deploy the infrastructure <a name="deploy_infra"></a>

You will create two Amazon S3 buckets in two different AWS regions. The **Ohio** region (also known as **us-east-2**) will be your _primary_ region, and **Oregon** (also known as **us-west-2**) will be your _secondary_ region.

### 1.1 Log into the AWS console <a name="awslogin"></a>

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

* Follow the instructions [here for accessing your AWS account](../../common/documentation/Workshop_AWS_Account.md)

**If you are using your own AWS account**:

* Sign in to the AWS Management Console as an IAM user who has PowerUserAccess or AdministratorAccess permissions, to ensure successful execution of this lab.

### 1.2 Deploy the infrastructure in two AWS Regions using an AWS CloudFormation template

You will deploy the infrastructure for two Amazon S3 buckets. Since these will be in two different regions, we will need to create an AWS CloudFormation stack in each region.

1. Download the [_s3_bucket.yaml_](https://raw.githubusercontent.com/awslabs/aws-well-architected-labs/master/Reliability\200_Bidirectional_Replication_for_S3\Code\CloudFormation/s3_bucket.yaml) CloudFormation template

#### 1.2.1 Deploy primary S3 bucket

1. It is recommended that you deploy the _primary_ s3 bucket in the **Ohio** region.  This region is also known as **us-east-2**, which you will see referenced throughout this lab.
      ![SelectOhio](Images/SelectOhio.png)
      * If you choose to use a different region, you will need to ensure future steps are consistent with your region choice.

1. On the AWS Console go to the [CloudFormation console](https://console.aws.amazon.com/cloudformation)
1. Create a CloudFormation stack (with new resources) by uploading this CloudFormation Template file
1. For **Stack name** use **`S3-CRR-lab-primary`**
1. Under **Parameters** enter a **NamingPrefx**
      * This will be used to name your S3 buckets
      * It must be string consisting of lowercase letters or numbers between three and 63 characters long
1. Click **Next** until the last page
1. At the bottom of the page, select **I acknowledge that AWS CloudFormation might create IAM resources with custom names** @TODO
1. Click **Create stack**
1. You can go ahead and create the secondary bucket before this CloudFormation stack completes

**Troubleshooting**: If your CloudFormation stack deployment fails with the error _\<bucket name\> already exists_

* You did not pick a unique enough **NamingPrefx**
* Delete the failed stack
* Start over and choose a more unique **NamingPrefx**
* Amazon S3 bucket names share a global name space across all of AWS (including all AWS regions)

#### 1.2.2 Deploy secondary S3 bucket

1. It is recommended that you deploy the _primary_ s3 bucket in the **Oregon** region.  This region is also known as **us-west-2**, which you will see referenced throughout this lab.
      ![SelectOregon](Images/SelectOregon.png)
      * If you choose to use a different region, you will need to ensure future steps are consistent with your region choice.

1. On the AWS Console go to the [CloudFormation console](https://console.aws.amazon.com/cloudformation)
1. Create a CloudFormation stack (with new resources) by uploading this CloudFormation Template file
1. For **Stack name** use **`S3-CRR-lab-secondary`**
1. Under **Parameters** enter a **NamingPrefx**
      * You should use the _same_ value as you did previously (however, it is not strictly necessary that you do)
      * This will be used to name your S3 buckets
      * It must be string consisting of lowercase letters or numbers between three and 63 characters long
1. Click **Next** until the last page
1. At the bottom of the page, select **I acknowledge that AWS CloudFormation might create IAM resources with custom names** @TODO
1. Click **Create stack**

#### 1.2.3 Get bucket information

1. Go back to the **Ohio** AWS Region and wait for the CloudFormation stack you created there to complete
1. Click on the **Outputs** tab and record the **Value** of the S3 bucket name in an accessible location as _primary bucket_
1. Got the the **Oregon** AWS Region and do the same thing, copying that S3 bucket name down as _secondary bucket_
1. Go to the [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home) and verify that both buckets were created.
      * Although S3 buckets are specific to an AWS region, the Amazon S3 console shows all buckets from all AWS Regions
      * Note the regions for the two S3 buckets your created

## 2. Configure bi-directional cross-region replication for S3 buckets <a name="configure_replication"></a>

Amazon S3 replication enables automatic, asynchronous copying of objects across Amazon S3 buckets. Buckets that are configured for object replication can be owned by the same AWS account or by different accounts. You can copy objects between different AWS Regions or within the same Region. We will setup bi-directional replication between S3 buckets in different regions, owned by the same AWS account.

Replication is configured via _rules_. There is no rule for bi-directional replication. We will however setup a rule to replicate from the S3 bucket in the primary AWS region to the secondary bucket, and we will setup a second rule to replicate going the opposite direction. These two rules will enable bi-directional replication across AWS regions.

![TwoReplicationRules](Images/TwoReplicationRules.png)

## 2.1 Setup rule to replicate objects from the S3 bucket in the primary AWS region to the bucket in the secondary region

1. Go to the [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home)
1. Click on the name of the primary bucket
      * if you used **Ohio** the name will be `<your_naming_prefix>-crrlab-us-east-2`
1. Click on the **Management** tab
1. Click **Replication**
1. Click **+ Add Rule**
1. For **Set source** select **Entire bucket**
1. For **Replication criteria** leave **Replicate objects encrypted with AWS KMS** not selected
      * Our objects are encrypted using server-side encryption
      * However since we used SSE-S3, we do not need to select this option and do not need to provide a KMS key
      * SSE-S3 uses KMS keys, but these managed by Amazon S3 for the user
      * For more detail see [What Does Amazon S3 Replicate?](https://docs.aws.amazon.com/AmazonS3/latest/dev/replication-what-is-isnot-replicated.html)
1. Click **Next**
1. For **Destination bucket** leave **Buckets in this account** selected, and select the name of the secondary bucket from the drop-down
      * If you used **Oregon** the name will be `<your_naming_prefix>-crrlab-us-west-2`
1. Click **Next**
1. For **IAM Role** select @TODO (use Create new role ?)
1. For **Rule name** enter **primary to secondary**
1. Leave **Status** set to **enabled**
1. Click **Next**
1. Review the configuration
1. Click **Save**

The screen should say **Replication configuration updated successfully.** and display the Source, Destination, and Permissions of your replication rule

![RuleOneCreated](Images/RuleOneCreated.png)

@TODO on this screen note the "IAM Role"


@TODO put this somewhere
* Replication Status
* Still Encrypted
![ReplicatedObject](Images/ReplicatedObject.png)

## 5. Tear down this lab <a name="tear_down"></a>

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

* There is no need to tear down the lab. Feel free to continue exploring. Log out of your AWS account when done.

**If you are using your own AWS account**:

* You may leave these resources deployed for as long as you want. When you are ready to delete these resources, see the following instructions

### Remove AWS CloudFormation provisioned resources

#### How to delete an AWS CloudFormation stack

If you are already familiar with how to delete an AWS CloudFormation stack, then skip to the next section: **Delete workshop CloudFormation stacks**

1. Go to the AWS CloudFormation console: <https://console.aws.amazon.com/cloudformation>
1. Select the CloudFormation stack to delete and click **Delete**
1. In the confirmation dialog, click **Delete stack**
1. The **Status** changes to _DELETE_IN_PROGRESS_
1. Click the refresh button to update and status will ultimately progress to _DELETE_COMPLETE_
1. When complete, the stack will no longer be displayed. To see deleted stacks use the drop down next to the Filter text box.
1. To see progress during stack deletion
      * Click the stack name
      * Select the Events column
      * Refresh to see new events

#### Delete workshop CloudFormation stacks

1. First delete the **HealthCheckLab** CloudFormation stack
1. Wait for the **HealthCheckLab** CloudFormation stack to complete (it will no longer be shown on the list of actice stacks)
1. Then delete the **WebApp1-VPC** CloudFormation stack

### Remove CloudWatch logs

After deletion of the **WebApp1-VPC** CloudFormation stack is complete then delete the CloudWatch Logs:

1. Open the CloudFormation console at [https://console.aws.amazon.com/cloudwatch/](https://console.aws.amazon.com/cloudwatch/).
1. Click **Logs** in the left navigation.
1. Click the radio button on the left of the **WebApp1-VPC-VPCFlowLogGroup-\<some unique ID\>**.
1. Click the **Actions Button** then click **Delete Log Group**.
1. Verify the log group name then click **Yes, Delete**.

---

## References & useful resources

* [Patterns for Resilient Architecture — Part 3](https://medium.com/@adhorn/patterns-for-resilient-architecture-part-3-16e8601c488e)
* Amazon Builders' Library: [Implementing health checks](https://aws.amazon.com/builders-library/implementing-health-checks/)
* [Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) (see the Reliability pillar)
* [Well-Architected best practices for reliability](https://wa.aws.amazon.com/wat.pillar.reliability.en.html)
* [Health Checks for Your Target Groups](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/target-group-health-checks.html) (for your Application Load Balancer)

---

## License

### Documentation License

Licensed under the [Creative Commons Share Alike 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license.

### Code License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

<https://aws.amazon.com/apache2.0/>

or in the ["license" file](../../LICENSE-Apache) accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
