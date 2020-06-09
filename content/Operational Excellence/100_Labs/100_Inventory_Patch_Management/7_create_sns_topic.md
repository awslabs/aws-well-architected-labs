---
title: "Creating a Simple Notification Service Topic"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>7. </b>"
weight: 7
---
[Amazon Simple Notification Service](https://docs.aws.amazon.com/sns/latest/dg/welcome.html) (Amazon SNS) coordinates and manages the delivery or sending of messages to subscribing endpoints or clients. In Amazon SNS, there are two types of clients: publishers and subscribers. These are also referred to as producers and consumers. Publishers communicate asynchronously with subscribers by producing and sending a message to a topic, which is a logical access point and communication channel. Subscribers (i.e., web servers, email addresses, Amazon SQS queues, AWS Lambda functions) consume or receive the message or notification over one of the supported protocols (i.e., Amazon SQS, HTTP/S, email, SMS, Lambda) when they are subscribed to the topic.

### 6.1 Create and Subscribe to an SNS Topic

To create and subscribe to an SNS topic:

1. Navigate to the SNS console at <https://console.aws.amazon.com/sns/>.
1. Choose **Create topic**.
1. In the **Create new topic** window:
   1. In the **Topic name** field, enter `AdminAlert`.
   1. In the **Display name** field, enter `AdminAlert`.
   1. Choose **Create topic**.
1. On the **Topic details: AdminAlert** page, choose **Create subscription**.
1. In the **Create subscription** window:
   1. Select **Email** from the **Protocol** list.
   1. Enter your email address in the **Endpoint** field.
   1. Choose **Create subscription**.
1. You will receive an email request for confirmation. Your Subscription ID will remain **PendingConfirmation** until you confirm your subscription by clicking through the link to **Confirm subscription** in the email.
1. Refresh the page after confirming your subscription to view the populated **Subscription ARN**.

You can now use this SNS topic to send notifications to your Administrator user.
