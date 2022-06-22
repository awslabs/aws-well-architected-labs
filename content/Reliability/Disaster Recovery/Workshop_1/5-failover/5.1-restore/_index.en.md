+++
title = "Restore"
date =  2021-05-11T20:33:54-04:00
weight = 1
+++

### Restore RDS Database

{{% notice info %}}
If you are running this workshop as part of an instructor led workshop, the RDS has already been restored to the **N. California (us-west-1)** region due to time constraints.  **Please review the steps in this section so you understand how the restore should work and then continue with the Launch EC2 Section below**. This means that you will not be able to verify your cart items were successfully restored to the secondary region when we get to that section.
{{% /notice  %}}

1.1 Click [AWS Backup](https://us-west-1.console.aws.amazon.com/backup/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Click the **Backup Vaults** link, then click the **Default** link.

{{< img rs-1.png >}}

1.3 In the **Backups** section. Select the backup. Click **Restore** under the **Actions** dropdown.

{{< img rs-6.png >}}

{{% notice warning %}}
If you don't see your backup, check the status of the **Copy Job**. Click [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) to navigate to the dashboard in **N. Virginia (us-east-1)** region. Click the **Jobs** link, then click the **Copy jobs** link.  Verify the **Status** of your backup is **Completed**.
{{% /notice %}}

1.4 In the **Settings** section, enter `backupandrestore-secondary-region` as the **DB Instance Identifier**. Under **Network & Security** section, select **us-west-xx** as the **Availability zone**.

{{< img rs-7.png >}}

1.5 Select **Choose an IAM Role** and select **Team Role** as the **Role name**. Click the **Restore backup** button.

{{< img rs-8.png >}}

#### Configure Security Group

2.1 Click [VPC](https://us-west-1.console.aws.amazon.com/vpc/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

2.2 Click the **Security Groups** link, then click the **Create security group** button.

{{< img rs-9.png >}}

2.3 In the **Basic details** section, enter `backupandrestore-us-west-rds-SG` as the **Security group name** and **Description**.

{{< img rs-10.png >}}

2.4 in the **Inbound Rules** section, click the **Add rule** button.  Select **MYSQL/Aurora** as the **Type**.  Select **Custom** as the **Source** and choose **backupandrestore-us-west-ec2-SG**.  This will allow the communication between your EC2 instance and your RDS instance. Click the **Create security group** button.

{{< img rs-11.png >}}

#### Modify RDS 

3.1 Click [RDS](https://us-west-1.console.aws.amazon.com/rds/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

3.2 Click the **DB Instances** link.

{{< img rs-12.png >}}

3.3 Select **backupandrestore-secondary-region**, then click the **Modify** button.

{{% notice note %}}
The database must have a **Status** of **Available**.
{{% /notice %}}

{{< img rs-13.png >}}

3.4 In the **Connectivity** section, select **backupandrestore-us-west-rds-SG** as the **Security group**. Click the **Continue** button.

{{< img rs-14.png >}}

3.5 Select **Apply immediately** and then click the **Modify DB instance** button..

{{< img rs-15.png >}}

3.6 Click the **backupandrestore-secondary-region** link.

{{< img rs-16.png >}}

{{% notice note %}}
Copy the name of the endpoint and port.  You will need this in a later step.
{{% /notice %}}

{{< img rs-17.png >}}

### Launch EC2

4.1 Click [AWS Backup](https://us-west-1.console.aws.amazon.com/backup/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

4.2 Click the **Backup Vaults** link, then click the **Default** link.

{{< img rs-1.png >}}

4.3 In the **Backups** section. Select the EC2 backup. Click **Restore** under the **Actions** dropdown.

{{< img rs-19.png >}}

{{% notice warning %}}
If you don't see your backup, check the status of the **Copy Job**. Click [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) to navigate to the dashboard in **N. Virginia (us-east-1)** region. Click the **Jobs** link, then click the **Copy jobs** link.  Verify the **Status** of your EC2 copy job is **Completed**.
{{% /notice %}}

4.4 In the **Network settings** section, select **BackupAndRestoreDB-EC2SecurityGroup-xxxx** as the **Security groups**.

{{< img rs-20.png >}}

4.5 Select **Choose an IAM Role** and select **Team Role** as the **Role name**. 

{{< img rs-21.png >}}

4.6 We are going to want to bootstrap the instance to have the configurations necessary for the Unishop application in the  **N. California (us-west-1)** region.
We use [user data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) to achieve this.

Copy and paste the below script as the **User data**, then click the **Restore backup** button.

**User Data Script**:
{{% expand "Click here to see the user data:" %}}

```bash
#!/bin/bash     
sudo su ec2-user                        
export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | python -c "import json,sys; print json.loads(sys.stdin.read())['region']")
export UI_RANDOM_NAME=$(aws s3api list-buckets --region $AWS_DEFAULT_REGION --output text --query 'Buckets[?ends_with(Name, `-secondary`) == `true`]'.Name)
export HOSTNAME="http://$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)"
echo '{"host":"'"$HOSTNAME"'","region":"'"$AWS_DEFAULT_REGION"'"}' | sudo tee /home/ec2-user/UniShopUI/config.json                    
sudo aws s3 cp /home/ec2-user/UniShopUI/config.json s3://$UI_RANDOM_NAME/config.json --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers         
export DATABASE=$(aws rds describe-db-instances --region $AWS_DEFAULT_REGION --db-instance-identifier backupandrestore-secondary-region --query 'DBInstances[*].[Endpoint.Address]' --output text)
sudo bash -c "cat >/home/ec2-user/unishopcfg.sh" <<EOF
#!/bin/bash
export DB_ENDPOINT=$DATABASE
EOF
sudo systemctl restart unishop
```
{{% /expand %}}

{{< img rs-22.png >}}

{{% notice warning %}}
The restore job(s) must have a status of **Completed**, before you can move to the next step. This may take approximately **5-20** minutes.
{{% /notice %}}

{{< prev_next_button link_prev_url="../" link_next_url="../../6-verify-secondary/" />}}
