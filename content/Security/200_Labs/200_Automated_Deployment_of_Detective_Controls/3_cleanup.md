---
title: "Tear down"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---
The following instructions will remove the resources that have a cost for running them.

Note: If you are planning on doing the lab [300_Incident_Response_with_AWS_Console_and_CLI](/Security/300_Incident_Response_with_AWS_Console_and_CLI/) we recommend you only tear down this stack after completing that lab as their is a dependency on AWS CloudTrail being enabled for the other lab.

Delete the stack:

1. Sign in to the AWS Management Console, and open the CloudFormation console at https://console.aws.amazon.com/cloudformation/.
2. Select the `DetectiveControls` stack.
3. Click the Actions button then click Delete Stack.
4. Confirm the stack and then click the Yes, Delete button.

Empty and delete the S3 buckets:

1. Sign in to the AWS Management Console, and open the S3 console at https://console.aws.amazon.com/s3/.
2. Select the CloudTrail bucket name you previously created without clicking the name.

![s3-empty-bucket](/Security/200_Automated_Deployment_of_Detective_Controls/Images/s3-empty-bucket.png)

3. Click Empty bucket and enter the bucket name in the confirmation box.

![s3-empty-confirm](/Security/200_Automated_Deployment_of_Detective_Controls/Images/s3-empty-confirm.png)

4. Click Confirm and the bucket will be emptied when the bottom task bar has 0 operations in progress.

![s3-progress.png](/Security/200_Automated_Deployment_of_Detective_Controls/Images/s3-progress.png)

5. With the bucket now empty, click Delete bucket.

![s3-delete-bucket](/Security/200_Automated_Deployment_of_Detective_Controls/Images/s3-delete-bucket.png)

6. Enter the bucket name in the confirmation box and click Confirm.

![s3-delete-confirm](/Security/200_Automated_Deployment_of_Detective_Controls/Images/s3-delete-confirm.png)

7. Repeat steps 2 to 6 for the Config bucket you created.

***

## References & useful resources

[AWS CloudTrail User Guide](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-user-guide.html)
[AWS CloudFormation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)
[Amazon GuardDuty User Guide](https://docs.aws.amazon.com/guardduty/latest/ug/what-is-guardduty.html)
[AWS Config User Guide](https://docs.aws.amazon.com/config/latest/)
