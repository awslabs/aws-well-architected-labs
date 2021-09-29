+++
title = "Modify Application"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

To connect the applicaiton to the newly promoted Aurora Database in the us-west-1 region, we need to modify the `Passive-Secondary` web application's configuration.

## Connecting the Application

1.1 Change your [console](https://us-west-1.console.aws.amazon.com/console)’s region to **N. California (us-west-1)** using the Region Selector in the upper right corner.

2.1 Navigate to **EC2** in the console.

{{< img am-1.png >}}

2.2 Click on the **Instances (running)** tile.

{{< img am-2.png >}}

2.3 Enable the checkbox next to the **UniShopAppV1EC2HotStandby** instance, then click the **Connect** button.

{{< img am-3.png >}}

2.4 Navigate to the **Session Manager** tab and click the **Connect** button.

{{< img am-4.png >}}

2.5 After a brief moment, a terminal prompt will display.

{{< img am-5.png >}}

2.6 Change the current directory to the ec2-user's home folder.

```sh
sudo su ec2-user
cd /home/ec2-user/
```

2.7 Open the `unishoprun.sh` file for editing with either nano or vi.

```sh
sudo nano unishoprun.sh
```

**Tip:** You can use the vi ([Debian ManPage]((https://manpages.debian.org/buster/vim/vi.1.en.html))) or nano command ([Debian ManPage](https://manpages.debian.org/stretch/nano/nano.1.en.html)) to edit the document.

2.8 Delete the previous file contents.  Then copy and paste this script into the `unishoprun.sh` script.

```sh
#!/bin/bash
java -jar /home/ec2-user/UniShopAppV1-0.0.1-SNAPSHOT.jar &> /home/ec2-user/app.log &
```

2.9 Save the modifications (CTRL+O) and close the editor (CTRL+X).

2.10 We need to restart the EC2 Instance before the new configuration will take effect.  Return to the browser tab where you launched Session Manager.  Click on the **Instance Id** link.

{{< img am-6.png >}}

2.11 Under the **Instance state** dropdown, click the **Reboot instance** menu item.

{{< img am-7.png >}}

## Congragulations!  Your Application has been updated to use the Aurora Promoted Database!

{{< prev_next_button link_prev_url="../promote-aurora/" link_next_url="../../verify-failover/" />}}

