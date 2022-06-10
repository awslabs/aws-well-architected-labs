+++
title = "Modify Application"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

### EC2

Now we have to modify the application in our secondary region **N. California (us-wes-1)**. 

1.1 Click [EC2](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Click the **Instances (running)** link.

{{< img BK-4.png >}}

1.3 In the search bar, paste the **Instance ID** that you copied from the [EC2 Section](../ec2/). This should start with **i-**.

1.4 Select the instance, copy the **Public IPv4 DNS** endpoint and then click the **Connect** button.

{{< img bk-1.png >}}

1.5 Click the **Session Manager** link, then click the **Connect** button.

{{< img am-4.png >}}

1.6 After a brief moment, a terminal prompt will display.

{{< img am-5.png >}}

1.7 Let's connect to the database in the secondary **N. California (us-west-1)** region. 
```sh
sudo su ec2-user
cd /home/ec2-user
```
Replace the below **backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com** with the endpoint you copied from [RDS Section](../rds/).

```sh
sudo mysql -u UniShopAppV1User -P 3306 -pUniShopAppV1Password -h backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com
```

Type **show databases**.

```sh
MySQL [(none)]> show databases;
```

You should see the following:

```sh 
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| unishop            |
+--------------------+
5 rows in set (0.02 sec)

```

Type **exit** to return to the command prompt.

```sh
MySQL [(none)]> exit
```

1.8 Open the **unishopcfg.sh** file for editing with either nano or vi.

```sh
sudo nano unishopcfg.sh
```

**Tip:** You can use the vi ([Debian ManPage]((https://manpages.debian.org/buster/vim/vi.1.en.html))) or nano command ([Debian ManPage](https://manpages.debian.org/stretch/nano/nano.1.en.html)) to edit the document.

1.9 Replace the **backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com** with the endpoint you copied from [RDS Section](../rds/).  Change the ***AWS_DEFAULT_REGION** to `us-west-1`.  Add the `-secondary` to the end of the UI_RANDOM_NAME.

```sh
#!/bin/bash
export Database=backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com
export DB_ENDPOINT=backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com
export AWS_DEFAULT_REGION=us-west-1
export UI_RANDOM_NAME=backupandrestore-uibucket-1hl8wmtj28dzl-secondary
```

Exit the editor, saving your changes.

1.10 Lets use the source command which reads and executes commands from the unishopcfg.sh file

```sh
source unishopcfg.sh
```
1.11 Reboot the EC2 instance so our changes take effect.

```sh
sudo reboot
```

### Create application configuration file

2.1 Using your favorite editor, create a new file named `config.json` file. Set the **host** property equal to the **EC2 public IPv4 DNS name** copied **Step 1.4** above. Add ('http://') and remove any trailing slash (`/`) if one is present.  Finally, set the **region** property to `us-west-1`.

```json
{
    "host": "http://{{Replace with your EC2 public IPv4 DNS name copied from EC2 section}}",
    "region": "us-west-1"
}
```

Your final `config.json` should look similar to this example.

```json
{
    "host": "http://ec2-XXX-XXX-XXX-XXX.us-west-1.compute.amazonaws.com",
    "region": "us-west-1"
}
```

### S3

3.1 Click [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard.

3.2 Click the link for **backupandrestore-uibucket-xxxx-secondary**

{{< img c-9.png >}}

3.3 Click the **Upload** button.

{{< img c-11.png >}}

3.4 Click the **Add Files** button and specify the **config.json** file..

{{< img c-12.png >}}

3.5 In the **Permissions Section** section. Select the **Specify Individual ACL permissions** radio button.  Enable the **Read** checkbox next to **Everyone (public access)** grantee.

{{< img c-13.png >}}

3.6 Enable the **I understand the effects of these changes on the specified objects.** checkbox.  Click the **Upload** button.

{{< img c-14.png >}}

Click the **Close** button.

3.7 Click the **Properties** link.  In the **Static website hosting** section, click the **Edit** button.

{{< img c-15.png >}}

{{< img c-16.png >}}

3.8 In the **Static website hosting** section select the **Enable** radio button.  Enter `index.html` as the **Index document** and enter `error.html` as the **Error document**.

{{< img c-17.png >}}

3.9 Click the **Save changes** button.

{{< img c-18.png >}}

3.10 In the **Static website hosting** section.  Click on the **Bucket website endpoint** link.

{{< img c-19.png >}}

{{< img rs-45.png >}}

#### Congratulations !  You should see your application The Unicorn Shop in the **us-west-1** region.

{{< prev_next_button link_prev_url="../ec2/" link_next_url="../../cleanup/" />}}

