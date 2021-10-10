+++
title = "CloudFormation Outputs"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

### Saving the Cloudformation Template Output Values

#### Primary Region

1.1 Click [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks/) to navigate to the dashboard in the **N. Virginia (us-east-1)** region.

1.2 Select **Active-Primary**.

1.3 Wait until the stack's status reports **CREATE_COMPLETE**.  Then click the **Outputs** link and record the values of the **APIGURL**, **WebsiteURL**, and **WebsiteBucket** outputs.  You will need these to complete future steps.

{{< img pr-6.png >}}

#### Secondary Region

2.1 Click [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) to navigate to the dashboard in the **N. California (us-west-1)** region.

2.2 Select **Passive-Secondary**.

2.3 Wait until the stack's status reports **CREATE_COMPLETE**.  Then cick the **Outputs** link and record the values of the **APIGURL**, **WebsiteURL**, and **WebsiteBucket** outputs.  You will need these to complete future steps.

{{< img sr-6.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../../dynamodb-global/" />}}

