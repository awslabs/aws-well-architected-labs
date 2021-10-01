+++
title = "Modify Application"
date =  2021-05-11T11:43:28-04:00
weight = 3
+++

## Modifying the application

### EC2

1.1 Navigate to [EC2](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#/) in the **N. California (us-west-1)** region.

1.2 Select the instance and click **Connect**.

{{% notice note %}}
If you have more than one instance running you can verify you are selecting the correct one by checking **Security group name**.
{{% /notice %}}

{{< img RS-44.png >}}

1.3 Navigate to the **Session Manager** tab and click the **Connect** button.

{{< img am-4.png >}}

1.4 After a brief moment, a terminal prompt will display.

{{< img am-5.png >}}

1.5 Let's connect to the database in the secondary **N. California (us-west-1)** region. Replace the below `backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com` with the endpoint you copied from [RDS Section](../rds/).

```sh
sh-4.2$ sudo mysql -u UniShopAppV1User -P 3306 -pUniShopAppV1Password -h backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com 
sh-4.2$ SHOW DATABASES;
```
1.6 Open the `unishopcfg.sh` file for editing with either nano or vi.

```sh
sudo nano unishopcfg.sh
```

**Tip:** You can use the vi ([Debian ManPage]((https://manpages.debian.org/buster/vim/vi.1.en.html))) or nano command ([Debian ManPage](https://manpages.debian.org/stretch/nano/nano.1.en.html)) to edit the document.

1.7 Replace the `backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com` with the endpoint you copied from [RDS Section](../rds/).  Change the region to `us-west-1`.  Add the `-dr` to the end of the S3 bucket name.

```sh
#!/bin/bash
export Database=backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com
export DB_ENDPOINT=backupandrestore-secondary-region.xxxx.us-west-1.rds.amazonaws.com
export AWS_DEFAULT_REGION=us-west-1
export UI_RANDOM_NAME=backupandrestore-uibucket-xxxx-dr
```

1.8 Let's copy the application files to the S3 buckets.  Replace the `backupandrestore-uibucket-xxxx-dr` with the name of your S3 bucket.

{{% notice note %}}
If our S3 buckets contained application data then it would be necessary to schedule recurring backups to meet the target RPO. This could be done with Cross Region Replication. Since our buckets contains no data, only code, we will restore the contents from the EC2 instance.
{{% /notice %}}

```sh
sudo aws s3 cp /home/ec2-user/UniShopUI s3://backupandrestore-uibucket-xxxx-dr/ --recursive --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
```

1.9 Reboot the EC2 instance so our changes take effect.

```sh
sudo reboot
```

### Create application configuration file

2.1 Using your favorite editor, create a new file named `config.json` file. Set the **host** property equal to the **EC2 public IPv4 DNS name** copied from [EC2 Section](../ec2/).  Remove the trailing slash (`/`) if one is present.  Finally, set the **region** property to `us-east-1`.

```json
{
    "host": "{{Replace with your EC2 public IPv4 DNS name copied from EC2 section}}",
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

3.1 Navigate to [S3](https://console.aws.amazon.com/s3/home?region=us-east-1#/).

3.2 Find the bucket that ends with **-dr-*.

{{< img c-9.png >}}

3.3 Next, click into the bucket and then click the **Upload** button.

{{< img c-11.png >}}

3.4 Click the **Add Files** button and specify the `config.json` file from the previous step.

{{< img c-12.png >}}

3.5 Scroll down to **Permissions Section** section. Select the **Specify Individual ACL permissions** radio button.  Next, check the **Read** checkbox next to **Everyone (public access)** grantee.

{{< img c-13.png >}}

3.6 Enable the **I understand the effets of these changes on the specified objects.** checkbox.  Then click the **Upload** button to continue.

{{< img c-14.png >}}

3.7 Navigate to the **Properties** tab.  Scroll down to **Static website hosting** section and click the **Edit** button.

{{< img c-15.png >}}

{{< img c-16.png >}}

3.8 Under the **Static website hosting** section select Enable and add `index.html` for **Index document** and `error.html` for **Error document**.

{{< img c-17.png >}}

3.9 Click the **Save changes** button.

{{< img c-18.png >}}

3.10 Scroll down to **Static website hosting** section.  Click on the **Bucket website endpoint**.

{{< img c-19.png >}}

#### Congratulations !  You should see your application The Unicorn Shop in the **us-west-1** region.

{{< prev_next_button link_prev_url="../rds/" link_next_url="../../cleanup/" />}}

