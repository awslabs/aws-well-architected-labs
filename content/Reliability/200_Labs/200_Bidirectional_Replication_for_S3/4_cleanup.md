---
title: "Tear down this lab"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

{{% common/EventEngineVsOwnAccountCleanup %}}

### Empty the S3 buckets

You cannot delete an Amazon S3 bucket unless it is empty, so you need to empty the buckets you created. There are a total of four buckets:

* Replication bucket in _east_ region: `<your_naming_prefix>-crrlab-us-east-2`
* Replication bucket in _west_ region: `<your_naming_prefix>-crrlab-us-west-2`
* Logging bucket in _east_ region: `logging-<your_naming_prefix>-us-east-2`
* Logging bucket in _west_ region: `logging-<your_naming_prefix>-us-west-2`

Go to the [Amazon S3 console](https://s3.console.aws.amazon.com/s3/home), or if you are already there click on **Amazon S3** in the upper left corner

**For _each_ of he four buckets do the following:**

1. Select the radio button next to the bucket
1. Click **Empty**
1. Type the bucket name in the confirmation box
1. Click **Empty**
1. After you see the message **Successfully emptied bucket** then click **Exit**
1. For the logging buckets it is also recommended your delete the bucket now to prevent the logs from writing more data there after you empty it
      * Follow the same steps as above, but click the **Delete** button (instead of Empty)

### Remove AWS CloudFormation provisioned resources

If you are using an AWS supplied to you as part of an in-person AWS workshop

#### How to delete an AWS CloudFormation stack

If you are already familiar with how to delete an AWS CloudFormation stack, then skip to the next section: **Delete workshop CloudFormation stacks**

{{% common/DeleteCloudFormationStack %}}

#### Delete workshop CloudFormation stacks

1. First delete the **S3-CRR-lab-east** CloudFormation stack in **Ohio** (**us-east-2**)
1. Then delete the **S3-CRR-lab-west** CloudFormation stack in **Oregon** (**us-west-2**)

**Troubleshooting**: if your CloudFormation stack deletion fails with status _DELETE_FAILED_ and error (from the **Events** tab) _Cannot delete entity, must detach all policies first_ then [see these additional instructions]({{< ref "Documentation/DetachIAMPolicy.md" >}})
