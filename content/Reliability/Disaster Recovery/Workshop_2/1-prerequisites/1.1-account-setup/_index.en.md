+++
title = "Account Setup"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++

#### Using your own AWS account

{{% notice note %}}
If you are using a personal AWS account, be aware that you will incur costs for the resources deployed in this workshop. After completing the workshop, remember to complete the [Cleanup](../../6-cleanup/) section to remove any unnecessary AWS resources.
{{% /notice %}}

#### Allow Amazon S3 Public Access

{{% notice warning %}}
Our application employs AWS Simple Storage Service (S3) Static website hosting. To make the application available to Internet users, the S3 bucket will be configured with public access. 
{{% /notice %}}

If you run into issues, you **MAY** need to congire S3 public access settings at the Account level. For example, if you allow public access for a bucket but block all public access at the account level, Amazon S3 will **continue** to block public access to the bucket. In this scenario, you would have to edit your account-level Block Public Access settings. For more information, see [Blocking public access to your Amazon S3 storage](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html). Before doing this, verify all other S3 buckets in your Account have the proper bucket level permission set. Please review the [best practices for Access control for you S3 bucket](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-best-practices.html).

This workshop takes about 60 minutes to complete. 

{{< prev_next_button link_prev_url="../" link_next_url="./1.1.1-primary-region/" />}}
