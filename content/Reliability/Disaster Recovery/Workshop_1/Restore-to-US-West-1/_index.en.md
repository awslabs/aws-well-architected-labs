+++
title = "Restore to US-West-1"
date =  2021-05-11T20:35:50-04:00
weight = 7
+++


We will simulate a disaster in this exercise by revoking public access to the S3 bucket hosting the website. We will then perform a series of tasks to bring the application up in the DR region us-west-1. The steps would be included in a DR run book so that any system administrator with proper access could execute them. In a production environment, we would automate these steps using an AWS Cloudformation template or third-party tools. We will perform the following steps manually to learn how the AWS services support Disaster Recovery:
- Revoke access to the primary site S3 bucket
- Launch an EC2 instance from the AMI in the DR region
- Restore the RDS database from backup in the DR region
- Configure the application

## Revoke access to the primary site S3 bucket

1.1 Login to the AWS [Console](https://us-west-1.console.aws.amazon.com/console ) and navigate to **S3** by searching for it.

{{< img BK-35.png >}}

1.2 Click on the **Name** of the UI bucket.

{{< img RS-59.png >}}

1.3 Select **Permission** and click the **Edit** button under **Block public access**.

{{< img RS-55.png >}}

1.4 Check the box to block all public access and click the **Save changes** button.

{{< img RS-56.png >}}

1.5 Type **confirm** in the text entry box and click the **Confirm** button.

{{< img RS-57.png >}}

Our application is now down. We have simulated a disaster. You can test this by trying to reload the website's URL.

{{< img RS-58.png >}}

---

## Launch an EC2 instance from the AMI in the DR region

2.1 Navigate to EC2 (Search for EC from console), and change the region to us-west-1.

{{< img BK-1.png >}}

{{< img RS-37.png >}}

2.2 Click on **Images** and select **AMIs**.

{{< img RS-6.png >}}

2.3 Find the AMI and choose **Actions** then **Launch**.

{{< img RS-7.png >}}

2.4 Select the t3.micro instance type and click the **Next: Configure Instance Details** button.

{{< img RS-8.png >}}

2.5 Set the IAM role to BackupRestore-S3InstanceProfile, leave the remaining defaults and click the **Next: Add Storage** button.  Note, the prefix might be different depending on the CloudFormation Stack name specified during **US-East-1 Deployment** section.

{{< img RS-9.png >}}

2.6 Leave the default and click the **Next:Add tags** button.

{{< img RS-10.png >}}

2.7 Leave the defaults and click the **Next: Configure Security Group** button.

{{< img RS-11.png >}}

2.8 Add rules as shown and click **Review and Launch**. Save the security group name for later.

{{< img RS-12.png >}}

2.9 Click the **Launch** button.

{{< img RS-14.png >}}

2.10 Select **Proceed without a key pair**, check the acknowledgment and then click **Launch Instances**.

{{< img RS-15.png >}}

2.11 Make a note of the instance Public IPv4 DNS as we will need it later.

{{< img RS-47.png >}}

## Restore the RDS database from backup in the DR region

3.1 Navigate to **AWS Backup** by searching for it in the AWS [Console](https://us-west-1.console.aws.amazon.com/console).

{{< img BK-10.png >}}

3.2 Click on **Backup vaults**, select **Default**, and choose the most recent backup.

{{< img RS-16.png >}}

3.3 Select **Restore** from the **Actions** menu.

{{< img RS-17.png >}}

3.4 Configure the RDS options as shown.

**Note:** The security group will have to be changed after the restore is complete.

{{< img RS-18.png >}}

Enter a **DB instance identifier**.

{{< img RS-19.png >}}

Choose an Availability Zone (AZ) and Subnet Group within us-west-1.

{{< img RS-38.png >}}

Set the **Database port** and **DB parameter group** as shown. Disable IAM DB Authentication.

{{< img RS-20.png >}}

Click the **Restore backup** button.

{{< img RS-21.png >}}

Wait for the restore to complete.

{{< img RS-22.png >}}

3.5  Navigate to **VPC** by searching for it in the AWS [Console](https://us-west-1.console.aws.amazon.com/console).

{{< img RS-39.png >}}

3.6 Find **Security Groups** in the left-hand menu and click the **Create Security Group** button.

{{< img RS-23.png >}}

3.7 Enter a **Security group name** and **Description**.

{{< img RS-24.png >}}

Click **Add rule** and allow MYSQL/Aurora TCP inbound port 3306 from the EC2 security group attached to the DR EC2 instance (from step 2.8 above).

**Tip:** This is an inbound rule. No changes are required to ourbound rules.

{{< img RS-40.png >}}

Leave the **Outbound rules** as default and click the **Create security group** button.

{{< img RS-41.png >}}

3.8 Navigate to **RDS** by searching for it in the AWS [Console](https://us-west-1.console.aws.amazon.com/console).

{{< img RS-31.png >}}

Select the database that we just restored and click the **Modify** button.

{{< img RS-25.png >}}

In the **Connectivity** section, change the security group to the new one we created in step 3.7.

{{< img RS-27.png >}}

Click the **Continue** button.

{{< img RS-42.png >}}

Choose **Apply immediately** and click the **Modify DB instance** button.

{{< img RS-43.png >}}

Click on the DB identifier to bring up the database details.

{{< img RS-26.png >}}

Please make a note of the **Endpoint** as we will need it later.

{{< img RS-46.png >}}

## Configure the application

4.1 Navigate to **EC2** by searching for it in the AWS [Console](https://us-west-1.console.aws.amazon.com/console).

{{< img BK-1.png >}}

4.2 Select the EC2 instance and click the **Connect** button.

{{< img RS-44.png >}}

4.3 Select the **Session Manager** tab and click the **Connect** button to log in.

{{< img RS-45.png >}}

4.4 Once logged in test database connectivity. Use the database endpoint we saved in step 3.8 above.

```sh
sudo mysql -u UniShopAppV1User -h dr-lab-restore.XXXXXXXXXXXX.us-west-1.rds.amazonaws.com -P 3306 -pUniShopAppV1Password
```

```sql
SHOW DATABASES;
```

```sh
[ec2-user@ip-XXX-XXX-XXX-XXX ~]$ sudo mysql -u UniShopAppV1User -h dr-lab-restore.XXXXXXXXXXXX.us-west-1.rds.amazonaws.com -P 3306 -pUniShopAppV1Password


Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 22
Server version: 8.0.20 Source distribution

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]> SHOW DATABASES;
+--------------------------------+
| Database                       |
+--------------------------------+
| information_schema             |
| mysql                          |
| performance_schema             |
| unishop                        |
| unishopappv1dbbackupandrestore |
+--------------------------------+
5 rows in set (0.00 sec)

MySQL [(none)]>
```

4.5 Edit the /home/ec2-user/unishopcfg.sh file. Change the database endpoint to the one we saved in step 4.8 above. Change the regions to us-west-1. Finally, change the bucket names to the DR buckets we used in step 2.4 above.

**Tip:** You can use the vi ([Debian ManPage]((https://manpages.debian.org/buster/vim/vi.1.en.html))) or nano command ([Debian ManPage](https://manpages.debian.org/stretch/nano/nano.1.en.html)) to edit the document.

```sh
sudo vi /home/ec2-user/unishopcfg.sh
```

**Tip:** Use the full DNS name of the database.

```sh
#!/bin/bash
export Database=dr-lab-restore.XXXXXXXXXXXX.us-west-1.rds.amazonaws.com
export DB_ENDPOINT=dr-lab-restore.XXXXXXXXXXXX.us-west-1.rds.amazonaws.com
export AWS_DEFAULT_REGION=us-west-1
export UI_RANDOM_NAME=backupandrestore-uibucket-<XXXXXXXXXXXX>-dr
export ASSETS_RANDOM_NAME=backupandrestore-assetbucket-<XXXXXXXXXXXX>-dr
export PATH=$PATH:/home/ec2-user/gradle-4.6.3/bin
```

4.6 Run the following two commands to copy application files to the DR S3 buckets:

**Note:**  If our S3 buckets contained application data then it would be necessary to schedule recurring backups to meet the target RPO. This could be done with [Cross Region Replication](https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication.html). Since our buckets contains no data, only code, we will restore the contents from the EC2 instance.

```sh
sudo aws s3 cp /home/ec2-user/UniShopUI s3://backupandrestore-uibucket-XXXXXXXXXXXX-dr/ --recursive --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
```

4.7 Reboot the EC2 instance.

```sh
sudo reboot
```

4.8 Navigate to S3.

{{< img BK-35.png >}}

4.9 Locate the STACK-NAME-uibucket-XXXXXXXXXXXX-dr bucket we created earlier and click on the **Name**.

{{< img RS-60.png >}}

4.9 Download the **config.json** file from S3 in the  to your local machine.

Save file name: `config.json`

4.10 Update the config.json with the DR EC2 instance public IPv4 DNS name we saved in step 2.11 above. Also, change the region to us-west-1. Then upload to the DR UI bucket.

- Make sure you are using HTTP (not HTTPS).
- Make sure there is no trailing slash at the end of the URL.
- Make sure the region is set to us-west-1.

```json
{

    "host": "http://ec2-XXX-XXX-XXX-XXX.us-west-1.compute.amazonaws.com"
    "region": "us-west-1"
}
```

4.11 Navigate to the **Objects** tab for the UI Bucket and click the **Upload** button. Follow the prompt to upload `config.json` to your S3 static website.

{{< img FE-9.png >}}

4.12 Grant public access to the file by allowing **Everyone** Read permissions.

{{< img FE-6.png >}}

4.13 Navigate to the **Properties** tab of the S3 UI bucket.

{{< img RS-49.png >}}

Enable **Static website hosting** by scrolling to the bottom and clicking the **Edit** button.

{{< img RS-50.png >}}

Retain the default settings and enter the file names for Index and Error documents.

{{< img RS-51.png >}}

Click the **Save changes** button.

{{< img RS-52.png >}}

Write down the provided website URL.

{{< img RS-53.png >}}

Open the URL provided, and you will see the Unicorn shop!

**Tip:** Due to browser caching, you may need to open the site in your browser’s incognito mode (CTRL+P on Microsoft Edge or CTRL+ALT P on Google Chrome).

{{< img RS-29.png >}}

## Congrats! You have responded to the disaster and restored your application in accordance with the desired RPO and RTO
