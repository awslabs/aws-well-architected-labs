---
title: "Teardown"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 6
pre: "<b>6. </b>"
---

The following steps will remove the services which are deployed in the lab. 

### 6.1. Remove the CloudWatch Alarm

#### 6.1.1.

From the CloudWatch console, select **Alarms** from the left-hand dashboard, and select the alarms which you created in the lab using the radio box.

#### 6.1.2.

From the **Actions** button, select **Delete** and confirm the alarm deletion.

### 6.2. Remove the CloudWatch Metric Filter

From the CloudWatch console, select **Log group** under **Logs** and locate the log group which you created in the lab.

Under the **Metric filters** section, click on **1 filter** and check the radio button next to the metric filter that you created.

Select the **Delete** button and confirm the deletion of the metric filter.

### 6.3. Remove the CloudWatch Log Group

From the CloudWatch console, select **Log group** under **Logs** and select the log group which you created in the lab.

Select the **Actions** button and delete the log group confirming the deletion.

### 6.4. Remove the Trail from CloudTrail

From the CloudTrail console, select **Trails** from the left-hand menu. 

Use the radio button to select the trail that you created and select the **Delete** button to delete the Trail.

### 6.5. Remove the SNS topic

From the SNS console, select **Topics** and then select the name of the topic which you created, and select the **Delete** button, confirming the deletion in the next dialog box.

### 6.6. Remove the ECS Cluster

From the ECS console, select **Clusters** in the left-hand-menu and select the cluster which you created for the lab. 
* Select the **Task** tab and remove all active tasks for the cluster, confirming the deletion in the next window.
* Select the **service** tab and select the **Delete** button, confirming the delete in the next window. 

### 6.7. Remove the ECR Repository

From the ECR console, select **Repositories** in the left-hand menu, highlight the repository name in the main panel and select the **Delete** button, confirming the delete in the next window.

### 6.8. Remove the Application Stack

From the CloudFormation console, select the **pattern1-app** and select the **Delete** button, confirming the deletion in the next window.

### 6.9. Remove the Base Stack

Firstly, remove the data from the S3 bucket you created, or the deletion of the stack will fail. To do this, go to the **S3** console and find the bucket which you created. Select the bucket and delete all the objects confirming the deletion in the next dialog box.

Now, from the CloudFormation console, select the **pattern1-base** and select the **Delete** button, confirming the deletion in the next window.


### 6.10. Finally Remove The Cloud9 Environment

From the **Cloud9 IDE** highlight the environment which you created and select the **delete** button


