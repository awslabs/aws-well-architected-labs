+++
title = "EC2"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

#### Reconfigure Application

We are going to want to change the application that is running in the secondary region to point to the newly promoted Amazon Aurora cluster.

1.1 Click [EC2](https://us-west-1.console.aws.amazon.com/ec2/v2/home?region=us-west-1#Instances:instanceState=running) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Select **hot-secondary**, then click the **Connect** button.

{{< img am-3.png >}}

1.3 Click the **Session Manager** link, then click the **Connect** button.

{{< img am-4.png >}}

1.4 After a brief moment, a terminal prompt will display.

{{< img am-5.png >}}

1.5. Copy and paste the following script which will configure the application to use the secondary region **N. California (us-west-1)** database and restart the application.

```sh
sudo su ec2-user                        
export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | python -c "import json,sys; print json.loads(sys.stdin.read())['region']")
export DATABASE=$(aws rds describe-db-clusters --region $AWS_DEFAULT_REGION --db-cluster-identifier hot-secondary --query 'DBClusters[*].[Endpoint]' --output text)
sudo bash -c "cat >/home/ec2-user/unishopcfg.sh" <<EOF
#!/bin/bash
export DB_ENDPOINT=$DATABASE
EOF
sudo bash -c "cat >/home/ec2-user/unishopstart.sh" <<EOF
#!/bin/bash
source /home/ec2-user/unishopcfg.sh   
java -jar /home/ec2-user/UniShopAppV1-0.0.1-SNAPSHOT.jar &> /home/ec2-user/app.log &
EOF
sudo systemctl restart unishop

```

{{< prev_next_button link_prev_url="../5.1-aurora/" link_next_url="../../6-verify-secondary/" />}}

