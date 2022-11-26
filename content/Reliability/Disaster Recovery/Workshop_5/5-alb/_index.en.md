+++
title = "Application Load Balancer"
date =  2021-05-11T11:43:28-04:00
weight = 5
+++

Now that we've set up the reverse proxy on the EC2 instances in our primary and secondary regions, we'll set up an internet-facing Application Load Balancer (ALB) in each region to serve as the application endpoints in our primary and secondary regions.

Each of our regions represents a cell, and the ALB is the entry point of our application in each, which we’ll use in later steps when we configure Route 53.

### Primary Region

1.1 As the nginx reverse proxy is listening on TCP port 8080, we’ll need to add port 8080 to the EC2 instance security groups in each region. Currently they only allow traffic to and from port 80, so we’ll need to update them.
 
Click [Security Groups](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#SecurityGroups) to navigate to the primary region Security Groups section of the Amazon EC2 dashboard in the **N. Virginia (us-east-1)** region.

Select the security group with the **“Security group name“** field starting with **”hot-primary-EC2SecurityGroup-“**:

{{< img ALB-primary-step-1.png >}}

1.2 Select the **“Inbound rules”** tab on the bottom of the page, and add an inbound rule for TCP port 8080 with a source CIDR range of `0.0.0.0/0`:

{{< img ALB-primary-step-2a.png >}}

Select the **“Outbound rules”** tab, and add an outbound rule for TCP port 8080 with a destination CIDR range of `0.0.0.0/0`:

{{< img ALB-primary-step-2b.png >}}

1.3 Click [ALB Target Groups](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#CreateTargetGroup) to navigate to the primary Application Load Balancer Target Groups page in the **N. Virginia (us-east-1)** region.

In the **“Basic configuration”** section, select the **“Instances”** radio button, give your target group a meaningful name (e.g. `PrimaryTargetGroup`), and select HTTP as the protocol, and set the the Port to `8080`:

{{< img ALB-primary-step-3a.png >}}

In the VPC pull-down, select the VPC called **“hot-primary”**:

{{< img ALB-primary-step-3b.png >}}

Ensure the Protocol version radio button is set to **HTTP 1**, and click **“Next”**.

Then, register the target instance. Select the instance with the Name **“hot-primary”**, and click **“Include as pending below”**:

{{< img ALB-primary-step-3c.png >}}

Click **“Create target group”**:

{{< img ALB-primary-step-3d.png >}}

1.4 Click [Create ALB](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#LoadBalancers:sort=loadBalancerName) to navigate to the Application Load Balancer console in the **N. Virginia (us-east-1)** region.

Click Create Load Balance to begin:

{{< img ALB-primary-step-4a.png >}}

Then, in the **“Application Load Balancer”** pane, select **“Create”**:

{{< img ALB-primary-step-4b.png >}}

Give your ALB a meaningful name (e.g. `PrimaryALB`), and ensure that the **“Internet-facing”** and **“IPv4”** radio buttons are selected:

{{< img ALB-primary-step-4c.png >}}

Next, in the **“Network mapping”** section, select the VPC named **“hot-primary”** in the VPC pulldown:

{{< img ALB-primary-step-4d.png >}}

And then select the subnets with labels starting **“hot-primary-”** in the two Availability Zones:

{{< img ALB-primary-step-4e.png >}}

And then select the Security Group we updated previously that starts **“hot-primary-EC2SecurityGroup”**:

{{< img ALB-primary-step-4f.png >}}

Then, in the **“Listeners and routing”** section, set up an HTTP listener on Port 80, with a Default action to forward to the Target Group you set up in Step 1.3 above (**PrimaryTargetGroup**):

{{< img ALB-primary-step-4g.png >}}

Then, check the details in the Summary section, and click **“Create load balancer”**:

{{< img ALB-primary-step-4h.png >}}

Finally, select the ALB we’ve just created, and while it’s provisioning, copy down the DNS name under **"Basic Configuration"** as you will need it later:

{{< img ALB-primary-step-4i.png >}}

### Secondary Region

You can follow the identical process as for the primary region, but substituting **“primary”** for **“secondary”** when selecting or creating resources.

{{% notice note %}}

2.1 However, click [Security Groups](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#SecurityGroups) to navigate to the secondary region Security Groups section of the Amazon EC2 dashboard in the **N. California (us-west-1)** region. Complete the rest of the actions in step 1.1 above, substituting or selecting **“secondary”** instead of **“primary**” as required.

2.2 Complete the steps in 1.2 above, again substituting or selecting **“secondary”** instead of **“primary**” as required.

2.3 Click [ALB Target Groups](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#CreateTargetGroup) to navigate to the primary Application Load Balancer Target Groups page in the **N. California (us-west-1)** region. Complete the rest of the actions in step 1.3 above, substituting or selecting **“secondary”** instead of **“primary**” as required.

2.4 And finally, click [Create ALB](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#LoadBalancers:sort=loadBalancerName) to navigate to the Application Load Balancer console in the **N. California (us-west-1)** region. Complete the rest of the actions in step 1.4 above, substituting or selecting **“secondary”** instead of **“primary**” as required.

{{% /notice %}}


### Test the Application Load Balancer endpoints

Finally, we’re going to test the endpoints you’ve just set up. You will have noted down the DNS names for the Application Load Balancer in **N. Virginia (us-east-1)** and **N. California (us-west-1)**. In your browser, navigate to each of these URLs, and compare the results you get when you navigate to the S3 website endpoint available in the CloudFormation outputs for your primary and secondary stacks.

You should see the same application from all 4 endpoints. If you don’t, review the steps above to ensure that you have set up the ALBs in each region, and the nginx server correctly on the EC2 instances. 

Congratulations! You have now created the simulated application endpoints, and we can move on.


{{< prev_next_button link_prev_url="../4-nginx/" link_next_url="../6-r53arc-readiness/" />}}

