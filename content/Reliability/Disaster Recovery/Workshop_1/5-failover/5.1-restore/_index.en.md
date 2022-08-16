+++
title = "Restore"
date =  2021-05-11T20:33:54-04:00
weight = 1
+++

#### Restore RDS Database

{{% notice info %}}
The RDS instance has already been restored to the **N. California (us-west-1)** region due to time constraints.  Please review [RDS Restore](https://docs.aws.amazon.com/aws-backup/latest/devguide/restoring-rds.html) for AWS Backup RDS restore steps.
{{% /notice %}}

#### Launch EC2

1.1 Click [AWS Backup](https://us-west-1.console.aws.amazon.com/backup/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Click the **Backup Vaults** link, then click the **Default** link.

{{< img rs-1.png >}}

1.3 In the **Backups** section. Select the EC2 backup. Click **Restore** under the **Actions** dropdown.

{{< img rs-19.png >}}

{{% notice warning %}}
If you don't see your backup, check the status of the **Copy Job**. Click [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) to navigate to the dashboard in **N. Virginia (us-east-1)** region. Click the **Jobs** link, then click the **Copy jobs** link.  Verify the **Status** of your EC2 copy job is **Completed**.
{{% /notice %}}

1.4 In the **Network settings** section, select **backupadnrestore-secondary-EC2SecurityGroup-xxxx** as the **Security groups** and de-select **default**.

{{< img rs-20.png >}}

1.5 In the **Restore Role** section, select **Choose an IAM Role** and select **Team Role** as the **Role name**. 

{{< img rs-21.png >}}

1.6 We are going to want to bootstrap the instance to have the configurations necessary for the Unishop application in the  **N. California (us-west-1)** region.
We use [user data](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html) to achieve this.

Expand the **Advanced settings** section and copy and paste the below script as the **User data**, then click the **Restore backup** button.

**User Data Script**:

```bash
#!/bin/bash     
sudo su ec2-user                        
export AWS_DEFAULT_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | python -c "import json,sys; print json.loads(sys.stdin.read())['region']")
export DATABASE=$(aws rds describe-db-instances --region $AWS_DEFAULT_REGION --db-instance-identifier backupandrestore-secondary --query 'DBInstances[*].[Endpoint.Address]' --output text)
sudo bash -c "cat >/home/ec2-user/unishopcfg.sh" <<EOF
#!/bin/bash
export DB_ENDPOINT=$DATABASE
EOF
sudo systemctl restart unishop
```

{{< img rs-22.png >}}

{{% notice warning %}}
You will need to wait for the restore job to have a status of **Completed** before moving on to the next step. This can take several minutes.
{{% /notice %}}

{{< prev_next_button link_prev_url="../" link_next_url="../../6-verify-secondary/" />}}
