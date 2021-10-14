+++
title = "Failover to Secondary"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

When a regional service event affects the Unicorn application in the primary region **N. Virginia (us-east-1)**, we want to bring up the resources in the secondary region **N. California (us-west-1)**.

We assume a regional service event has occurred. In this section, we will manually perform a series of tasks to bring up the application in the secondary region **N. California (us-west-1)**.  In a production environment, we would automate these steps using an AWS Cloudformation template or third-party tools. 

We will perform the following:
- Launch an EC2 instance from the AMI (Amazon Machine Image)
- Restore the RDS database from backup
- Configure the application 

### Simulating a Regional Service Event

We will now simulate a regional service event affecting the S3 static website in **N. Virginia (us-east-1)** serving The Unicorn Shop website.

1.1 Click [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard.

1.2 Click on the **backupandrestore-uibucket-xxxx** link.

{{< img c-9.png >}}

1.3 Click the **Permissions** link. In the **Block public access (bucket settings)** section, click the **Edit** button.

{{< img d-6.png >}}

1.4 Enable the **Block all public access** checkbox, then click the **Save** button.

{{< img d-7.png >}}

1.5 Type `confirm`, then click the **Confirm** button.

{{< img d-8.png >}}

1.6 Click the **Properties** link.  

{{< img d-10.png >}}

1.7 In the **Static website hosting** section.  Click on the **Bucket website endpoint** link.

{{< img d-11.png >}}

1.8  You should get a **403 Forbidden** error.

{{< img d-9.png >}}

{{< prev_next_button link_prev_url="../verify-website/" link_next_url="./ec2/" />}}

