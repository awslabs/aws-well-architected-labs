+++
title = "Failover"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

When a regional service event affects the Unishop application in the primary region **N. Virginia (us-east-1)**, we want to fail over to the secondary region **N. California (us-west-1)**.

{{% notice info %}}
We will **manually** perform a series of tasks to failover our workload to our secondary region **N. California (us-west-1)**.  
In a production environment, we would **automate** these tasks as part of our failover process.
{{% /notice %}}

#### Simulating a Regional Service Event

We will now simulate a regional service event affecting the Unishop website in **N. Virginia (us-east-1)**.  We are going to achieve this by blocking public access to the S3 bucket that is hosting the website making the Unishop website unavailable.

1.1  Click [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard.

1.2 Click on the **warm-primary-uibucket-xxxx** link.

{{< img f-1.png >}}

1.3 Click the **Permissions** link. In the **Block public access (bucket settings)** section, click the **Edit** button.

{{< img f-2.png >}}

1.4 Enable the **Block all public access** checkbox, then click the **Save changes** button.

{{< img f-3.png >}}

1.5 Type `confirm`, then click the **Confirm** button.

{{< img d-8.png >}}

1.6 Click the **Properties** link.  

{{< img f-4.png >}}

1.7 In the **Static website hosting** section.  Click on the **Bucket website endpoint** link.

{{< img f-5.png >}}

1.8  You should get a **403 Forbidden** error.

{{< img d-9.png >}}

{{% notice note %}}
If you do not get a 403 Forbidden error, this might be due to caching.  Please try refreshing the page or opening the website in a different browser or incognito mode to see the error.
{{% /notice  %}}

{{< prev_next_button link_prev_url="../2-verify-websites/" link_next_url="./3.1-aurora/" />}}
