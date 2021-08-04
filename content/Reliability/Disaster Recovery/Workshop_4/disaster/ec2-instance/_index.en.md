+++
title = "Modify Application"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

To connect the applicaiton to the newly promoted Aurora Database in the us-west-1 region, we need to modify the `Passive-Secondary` web application's configuration.

1.1 Navigate to **EC2** in the console.

{{< img am-1.png >}}

1.2 Click on the **Instances (running)** tile.

{{< img am-2.png >}}

1.3 Enable the checkbox next to the **UniShopAppV1EC2** instance, then click the **Connect** button.

{{< img am-3.png >}}

1.4 Navigate to the **Session Manager** tab and click the **Connect** button.

{{< img am-4.png >}}

1.5 After a brief moment, a terminal prompt will display.

{{< img am-5.png >}}

1.6 Change the current directory to the ec2-user's home folder.

```sh
cd /home/ec2-user/
```

1.7 Open the `unishoprun.sh` file for editing with either nano or vi.

```sh
sudo nano unishoprun.sh
```

**Tip:** You can use the vi ([Debian ManPage]((https://manpages.debian.org/buster/vim/vi.1.en.html))) or nano command ([Debian ManPage](https://manpages.debian.org/stretch/nano/nano.1.en.html)) to edit the document.

1.8 Delete the previous file contents.  Then copy and paste this script into the `unishoprun.sh` script.

```sh
#!/bin/bash
java -jar /home/ec2-user/UniShopAppV1-0.0.1-SNAPSHOT.jar &> /home/ec2-user/app.log &
```

1.9 Save the modifications (CTRL+O) and close the editor (CTRL+X).

1.10 We need to restart the EC2 Instance before the new configuration will take effect.  Return to the browser tab where you launched Session Manager.  Click on the **Instance Id** link.

{{< img am-6.png >}}

1.11 Under the **Instance state** dropdown, click the **Reboot instance** menu item.

{{< img am-7.png >}}

## Congragulations!  Your Application has been updated to use the Aurora Promoted Database!
