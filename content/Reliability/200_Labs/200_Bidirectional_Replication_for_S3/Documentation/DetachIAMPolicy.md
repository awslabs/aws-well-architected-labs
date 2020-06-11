---
title: "Troubleshooting: CloudFormation stack deletion for Lab S3 replication lab"
date: 2020-04-24T11:16:09-04:00
chapter: false
hidden: true
---

If your CloudFormation stack deletion fails with status _DELETE_FAILED_

From the [CloudFormation console](https://console.aws.amazon.com/cloudformation)

1. Click on the **Events** tab and refresh
1. Verify the cause of the failure is the error: _Cannot delete entity, must detach all policies first_

## Delete workshop IAM Roles

Go the the [IAM console](https://console.aws.amazon.com/iam/home)

1. Click on **Roles**
1. In the search box enter `S3-Replication-Role`. There should be either:

      * _Two_ roles shown (if you setup both replication buckets)
      * Or just _one_ (if you only setup one replication bucket)
      * If you see more than two roles stop here and investigate which roles are associated with your execution of this lab

1. Check the box next to each of the IAM Roles
1. Click **Delete**

     ![DeleteIAMRoles.png](/Reliability/200_Bidirectional_Replication_for_S3/Images/DeleteIAMRoles.png)

1. Confirm the deletion by clicking **Yes, delete**

## Delete workshop CloudFormation stacks

1. Re-initiate deletion of the **S3-CRR-lab-east** CloudFormation stack in **Ohio** (**us-east-2**)
1. Re-initiate deletion of the **S3-CRR-lab-west** CloudFormation stack in **Oregon** (**us-west-2**)

* CloudFormation will give you an option for **Resources to retain - optional**
    * Do NOT check anything
    * Click **Delete stack**

**[Click here]({{< ref "../5_resources.md" >}}) to return to the Lab Guide**