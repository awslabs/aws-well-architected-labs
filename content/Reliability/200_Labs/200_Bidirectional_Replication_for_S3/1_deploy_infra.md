---
title: "Deploy the Infrastructure"
menutitle: "Deploy Infrastructure"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

You will create two Amazon S3 buckets in two different AWS regions. The **Ohio** region (also known as **us-east-2**) will be referred to throughout this lab as the _east_ S3 bucket, and **Oregon** (also known as **us-west-2**) will be referred to as the _west_ S3 bucket.

### 1.1 Log into the AWS console {#awslogin}

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

{{%expand "Click here for instructions to access your assigned AWS account:" %}} {{% common/Workshop_AWS_Account %}} {{% /expand%}}

**If you are using your own AWS account**:
{{%expand "Click here for instructions to use your own AWS account:" %}}
* Sign in to the AWS Management Console as an IAM user who has PowerUserAccess or AdministratorAccess permissions, to ensure successful execution of this lab.
{{% /expand%}}

### 1.2 Deploy the infrastructure in two AWS Regions using an AWS CloudFormation template

You will deploy the infrastructure for two Amazon S3 buckets. Since these will be in two different regions, you will need to create an AWS CloudFormation stack in each region. You will use the same CloudFormation template for both regions.

* Download the [_s3_bucket.yaml_](/Reliability/200_Bidirectional_Replication_for_S3/Code/CloudFormation/s3_bucket.yaml) CloudFormation template

#### 1.2.1 Deploy _east_ S3 bucket

1. It is recommended that you deploy the _east_ s3 bucket in the **Ohio** region.  This region is also known as **us-east-2**.
      * Use the drop-down to select this region
      ![SelectOhio](/Reliability/200_Bidirectional_Replication_for_S3/Images/SelectOhio.png)
      * If you choose to use a different region, you will need to ensure future steps are consistent with your region choice.
1. On the AWS Console go to the [CloudFormation console](https://console.aws.amazon.com/cloudformation)
1. Select **Stacks**
1. Create a CloudFormation stack (with new resources) using the CloudFormation Template file and the **Upload a template file** option.
1. For **Stack name** use **`S3-CRR-lab-east`**
1. Under **Parameters** enter a **NamingPrefix**
      * This will be used to name your S3 buckets
      * Must be string consisting of lowercase letters, numbers, periods (.), and dashes (-) between five and 40 characters
      * This will be part of your Amazon S3 bucket name, which must be unique across all of S3.
      * Record this value in an accessible place -- you will need it again later in the lab.
1. Click **Next** until the last page
1. At the bottom of the page, select **I acknowledge that AWS CloudFormation might create IAM resources with custom names**
1. Click **Create stack**
1. You can go ahead and create the _west_ bucket before this CloudFormation stack completes

**Troubleshooting**: If your CloudFormation stack deployment fails with the error _\<bucket name\> already exists_

* You did not pick a unique enough **NamingPrefix**
* Delete the failed stack
* Start over and choose a more unique **NamingPrefix**
* Amazon S3 bucket names share a global name space across all of AWS (including all AWS regions)

#### 1.2.2 Deploy _west_ S3 bucket

1. It is recommended that you deploy the _west_ s3 bucket in the **Oregon** region for this lab.  This region is also known as **us-west-2**.
      * Use the drop-down to select this region
      ![SelectOregon](/Reliability/200_Bidirectional_Replication_for_S3/Images/SelectOregon.png)
      * If you choose to use a different region, you will need to ensure future steps are consistent with your region choice.

1. On the AWS Console go to the [CloudFormation console](https://console.aws.amazon.com/cloudformation)
1. Select **Stacks**
1. Create a CloudFormation stack (with new resources) using the _same_ CloudFormation Template file as before, and the **Upload a template file** option.
1. For **Stack name** use **`S3-CRR-lab-west`**
1. Under **Parameters** enter a **NamingPrefix**
      * You must use the _same_ value as you did previously
1. Click **Next** until the last page
1. At the bottom of the page, select **I acknowledge that AWS CloudFormation might create IAM resources with custom names**
1. Click **Create stack**

#### 1.2.3 Get bucket information

1. Go back to the **Ohio** AWS Region and wait for the CloudFormation stack you created there to complete
1. Click on the **Outputs** tab and record the **Value** of the S3 bucket name in an accessible location as _east bucket_
1. Go to the the **Oregon** AWS Region and do the same thing, copying that S3 bucket name down as _west bucket_
1. Go to the [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home) and verify that both buckets were created.
      * Although S3 buckets are specific to an AWS region, the Amazon S3 console shows all buckets from all AWS Regions
      * The two S3 buckets you will work with begin with `<your_naming_prefix>-crrlab`
      * Note the regions for the two S3 buckets your created
      * There are also two new `logging` buckets -- you will _not_ need to do any actions with these.
1. Click on either the _east_ region or _west_ region bucket, and note the following
      1. **This bucket is empty** - We will be adding objects to the bucket soon
      1. Click on **Properties** and note what properties are _Enabled_

{{%expand "Click here to learn why are these properties enabled" %}}
1. Versioning is Enabled:
For S3 Replication, both source and destination buckets MUST have versioning enabled

2. Default encryption is Enabled:
In our exercise we are demonstrating replication of encrypted objects.
It is a best practice to encrypt your data at rest.

3. Object-level logging is Enabled:
This logging will be used later in the lab.
It is used to better understand replication operations AWS takes on your behalf.
      {{% /expand%}}
