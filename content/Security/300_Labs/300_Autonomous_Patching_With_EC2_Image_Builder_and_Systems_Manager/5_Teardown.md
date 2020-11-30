---
title: "Teardown"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

The following steps will remove the services which are deployed in the lab. 

{{%expand "Teardown of CloudFormation Deployment"%}}

### 5.1. Remove the Automation Stack

From the CloudFormation console, select the stack named **pattern3-automate** from the list and select **Delete** and confirm the deletion in the next dialog box.

### 5.2. Remove the Pipeline Stack

#### 5.2.1.

**Note:** The stack will fail to remove unless the S3 bucket is empty. As a pre requisite, remove the contents of the bucket before continuing.

From the CloudFormation console, click on the **pattern3-pipeline** stack name and examine the resources.

Find the resource called **Pattern3LoggingBucket** and note the bucket name.

Proceed to the S3 console and remove the contents of the bucket, confirming the delete action.

#### 5.2.2.

Now, from the CloudFormation console, select the stack named **pattern3-pipeline** from the list and select **Delete** and confirm the deletion in the next dialog box.

### 5.3. Remove the Application Stack

From the CloudFormation console, select the stack named **pattern3-app** from the list and select **Delete** and confirm the deletion in the next dialog box.

### 5.4. Remove the Base Infrastructure Stack

From the CloudFormation console, select the stack named **pattern3-base** from the list and select **Delete** and confirm the deletion in the next dialog box.


{{% /expand%}}

