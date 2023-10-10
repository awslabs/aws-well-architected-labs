+++
title = "Pre-requisites"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++

### Account setup 

#### Allow Amazon S3 Public Access

{{% notice warning %}}
Our application employs AWS Simple Storage Service (S3) Static website hosting. To make the application available to Internet users, the S3 bucket will be configured with public access. 
{{% /notice %}}


If you run into issues, you **MAY** need to congire S3 public access settings at the Account level. For example, if you allow public access for a bucket but block all public access at the account level, Amazon S3 will **continue** to block public access to the bucket. In this scenario, you would have to edit your account-level Block Public Access settings. For more information, see [Blocking public access to your Amazon S3 storage](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html). Before doing this, verify all other S3 buckets in your Account have the proper bucket level permission set. Please review the [best practices for Access control for you S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-best-practices.html).

#### Using an account provided by instructor at virtual or in-person workshop

If you are running this workshop as part of an instructor led workshop, please first log into the console using [this link](https://dashboard.eventengine.run/) and enter the hash provided to you as part of the workshop.

Then, everything is set to go! 

{{% notice info %}}
Just continue to [DynamoDb](/reliability/disaster-recovery/workshop_5/2-dynamodb/) section of the lab.
{{% /notice %}}

#### Using your own AWS account

This module is based on the resources provisioned for [Module 4: Hot Standby](/reliability/disaster-recovery/workshop_4/). Depending if you are running this module after you completed Module 4 or not, your next steps will differ as below.  

* **I have completed Module 4 and didn't clean up resources.** As you have completed "Module 4: Hot Standby" and haven't cleaned up resources created by it - everything is set to go! Just continue to [DynamoDb](/reliability/disaster-recovery/workshop_5/2-dynamodb/) section of the lab.


* **I didn't complete Module 4 OR have cleaned up its resources.** In this case, you need to complete the following steps to create the required resources. Click teh button **Next Step** to continue the account setup.

{{< prev_next_button link_prev_url="../" link_next_url="./1.1-account-setup/" />}}
