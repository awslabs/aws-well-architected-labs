+++
title = "Prepare Secondary Region"
date =  2021-05-11T20:33:54-04:00
weight = 3
+++

{{% notice info %}}
We will **manually** create and copy an [Amazon Machine Images (AMI)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) to our secondary region **N. California (us-west-1)**.  
In a production environment, we would **automate** these steps as part of our CI/CD pipeline. You want to ensure that your primary region and your secondary region are configured the same and with the same artifacts to ensure if you need to failover to your secondary region, your workload will work as it does in your primary region.
{{% /notice %}}

{{< prev_next_button link_prev_url="../2-verify-primary" link_next_url="./3.1-ec2/" />}}
