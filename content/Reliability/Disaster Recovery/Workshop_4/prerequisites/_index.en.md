+++
title = "Pre-requisites"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++

### What are the pre-requisites for Module 4:  Hot Standby

<p>We are going to be launching the same CloudFormation template in two separate regions - N. Virgina (us-east-1) and N. California (us-west-1). These regions will represent our Primary (Active) Region (us-east-1) and our Secondary (Passive) Region (us-west-2).  Once the CloudFormation templates complete successfully, we will configure our static websites which are hosted in S3 to connect to the API Gateway endpoints that were created from running the CloudFormation template.</p>

{{% notice note %}}
If you are using your own AWS account be aware that you will incur costs for the resources deployed in this workshop. Complete the cleanup steps at the end to minimize those costs.

If you are running this at a group event - please log in via Event Engine. Instructions are provided by the event host.
{{% /notice %}}

### Getting Started
Log into your [**AWS Console**](https://us-east-1.console.aws.amazon.com/console)

1.1 Using the search bar at the top, navigate to **S3**.

{{< img c-8.png >}}

1.2 Click **Block Public Access settings for this account**.

{{< img pr-1.png >}}

1.3 If **Block all public access** is **On** click **Edit**

{{< img pr-2.png >}}

1.4 Uncheck **Block all public access** verifying all children are *unselected*.  Click **Save Changes**.

{{< img pr-3.png >}}

1.5 Type **confirm** and Click **Confirm**.

{{< img pr-4.png >}}