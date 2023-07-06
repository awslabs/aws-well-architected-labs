+++
title = "Create recovery group and cells"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

Click [Route 53 Application Recovery Controller](https://us-west-2.console.aws.amazon.com/route53recovery/home#/readiness/home) to navigate to the Amazon Route 53 Recovery Controller console.

We’re going to build a readiness check for our application. We have two running stacks, our hot primary in **N. Virginia (us-east-1)** and the hot secondary in **N. California (us-west-1)**.  We’re going to set up a **Recovery Group** composed of **cells** to represent the readiness of the application components across our regions. This will allow us to check the readiness of the application for failover.

Our application is relatively simple. We’ll be representing it with two cells, one in **N. Virginia (us-east-1)** and one in **N. California (us-west-1)**. It is possible to nest cells for more complex applications, as is visible in the diagram. Read through the Readiness check section, and then click **“create recovery group”** to proceed:

{{< img intro.png >}}

1. First, we're going to create a **Recovery Group** for our application. Click [Create Recovery Group](https://us-west-2.console.aws.amazon.com/route53recovery/home#/readiness/create-recovery-group) to navigate to the Amazon Route 53 Recovery Group console.  

And then give your recovery group a meaningful name (e.g. `UnicornAppRecoveryGroup`) and click Next:

{{< img step-1.png >}}

2. Now, we’re going to create the cells in our recovery group, representing the two regions where the application is deployed.

Select the **“Create cells”** radio button, and click **Add cell**:

{{< img step-2a.png >}}

3. Now, add two cells, the prefix may have been filled in for you, and given them meaningful names (e.g. `UnicornAppRecoveryGroup-East` and `UnicornAppRecoveryGroup-West`), and click Next to continue:

{{< img step-2b.png >}}

4. Review the recovery group with our two cells, and click **Create recovery group**:

{{< img step-2c.png >}}

At the next step, we will create readiness checks for the created cells.

{{< prev_next_button link_prev_url="../" link_next_url="../6.2-readiness-check-dynamo-db/" />}}