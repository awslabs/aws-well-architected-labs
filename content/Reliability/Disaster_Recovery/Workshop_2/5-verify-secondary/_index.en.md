+++
title = "Verify Failover"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

#### Secondary Region

1.1 Click [CloudFormation Stacks](https://console.aws.amazon.com/cloudformation/home?region=us-west-1#/stacks/) to navigate to the dashboard in **N. California (us-west-1)** region.

1.2 Choose the **pilot-secondary** stack.

1.3 Click the **Outputs** link.

{{< img vf-2.png >}}

1.4 Click on the **WebsiteURL** output link and open in a new browser tab or window.

{{% notice note %}}
If you do not see the Unishop webpage with all the products, it could be that the EC2 instance has not completed running the bootstrapping scripts. Continue to refresh the page until you see the Unishop webpage with all the products loaded.
{{% /notice %}}

#### Verify the Website

2.1 Log in to the application. You need to provide the registered email from the **Pre-requisites > Primary Region** section.

2.2 You should see items in your shopping cart that you added from the primary region **N. Virginia (us-east-1)**.

{{< img vf-1.png >}}

{{< prev_next_button link_prev_url="../4-failover/4.2-ec2/" link_next_url="../6-cleanup" />}}