+++
title = "EC2"
date =  2021-05-11T11:43:28-04:00
weight = 2
+++

#### Launch EC2 

1.1 Click [AMIs](https://us-west-1.console.aws.amazon.com/ec2/v2/home?region=us-west-1#Images:visibility=owned-by-me) to navigate to the dashboard in the **N. California (us-west-1)** region.

{{% notice warning %}}
You will need to wait for the pilotAMI to have a status of **Available** before moving on to the next step.  This can take several minutes.
{{% /notice %}}

1.2 Select **pilotAMI**.  Click the **Launch instance from AMI** button.

{{< img pa-1.png >}}

1.3 Enter `pilot-secondary` as the **Name**.

{{< img pa-2.png >}}

1.4 In the **Key pair (login)** section. Select **ee-default-keypair** as the **Key pair name**.

{{< img pa-3.png >}}

1.5 In the **Network settings** section click the **Edit** button. 

{{< img pa-6.png >}}

1.6 Select **pilot-secondary** as the **VPC**. Select **Select existing security group** for the **Firewall (security groups)** and then select **pilot-secondary-EC2SecurityGroup-xxx** as the **Common security groups**.

{{< img pa-7.png >}}

1.7 Expand the **Advanced details** section.  Select **pilot-secondary-S3InstanceProfile-xxx** as the **IAM instance profile**.

{{< img pa-4.png >}}

1.8 We are going to want to bootstrap the instance to have the configurations necessary for the Unishop application in the  **N. California (us-west-1)** region.
We use [user data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) to achieve this.

Copy and paste the below script as the **User data**, then click the **Launch instance** button.

**User Data Script**:

```bash
#!/bin/bash     
sudo su ec2-user                        
export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | python -c "import json,sys; print json.loads(sys.stdin.read())['region']")
export DATABASE=$(aws rds describe-db-clusters --region $AWS_DEFAULT_REGION --db-cluster-identifier pilot-secondary --query 'DBClusters[*].[Endpoint]' --output text)
sudo bash -c "cat >/home/ec2-user/unishopcfg.sh" <<EOF
#!/bin/bash
export DB_ENDPOINT=$DATABASE
EOF
sudo systemctl restart unishop
```

{{< img pa-5.png >}}

{{% notice warning %}}
You will need to wait for the instance to be successfully launched. You can click the **View all instances** button to navigate to the EC2 dashboard. Verify **pilot-secondary** has an **Instance state** of **Running**. This can take several minutes.
{{% /notice %}}

{{< prev_next_button link_prev_url="../4.1-aurora" link_next_url="../../5-verify-secondary/" />}}

