+++
title = "Modify Application"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

To connect the applicaiton to the newly promoted Aurora Database in the us-west-1 region, we need to modify the `Passive-Secondary` web application's configuration.

### Connecting the Application

1.1 Click [EC2](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#/) to navigate to the dashboard in the **N. California (us-west-1)** region.

1.2 Click the **Instances (running)** link.

{{< img am-2.png >}}

1.3 Select **UniShopAppV1EC2HotStandby**, then click the **Connect** button.

{{< img am-3.png >}}

1.4 Click the **Session Manager** link, then click the **Connect** button.

{{< img am-4.png >}}

1.5 After a brief moment, a terminal prompt will display.

{{< img am-5.png >}}

1.6 Change the current directory to the ec2-user's home folder.

```sh
sudo su ec2-user
cd /home/ec2-user/
```

1.7 Open the **unishoprun.sh** file for editing with either nano or vi.

```sh
sudo nano unishoprun.sh
```

**Tip:** You can use the vi ([Debian ManPage]((https://manpages.debian.org/buster/vim/vi.1.en.html))) or nano command ([Debian ManPage](https://manpages.debian.org/stretch/nano/nano.1.en.html)) to edit the document.

1.8 Delete the previous file contents.  Then copy and paste this script into the **unishoprun.sh** script.

```sh
#!/bin/bash
java -jar /home/ec2-user/UniShopAppV1-0.0.1-SNAPSHOT.jar &> /home/ec2-user/app.log &
```

1.9 Save the modifications (CTRL+O) and close the editor (CTRL+X).

1.10 Reboot the EC2 instance so our changes take effect.

```sh
sudo reboot
```

#### Congragulations!  Your Application has been updated to use the Aurora Promoted Database!

{{< prev_next_button link_prev_url="../promote-aurora/" link_next_url="../../verify-failover/" />}}

