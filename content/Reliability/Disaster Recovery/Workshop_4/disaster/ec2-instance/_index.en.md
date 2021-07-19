+++
title = "Modify Application"
date =  2021-05-11T11:43:28-04:00
weight = 7
+++

In order to connect the applicaiton to the newely promoted Aurora Database in us-west-1 region, we need to modify the application configuration.

1.1 From the search bar navigate to EC2  

{{< img am-1.png >}}

1.2 Click on **Instances (running)**

{{< img am-2.png >}}


1.3 Select the **UniShopAppV1EC2** and click **Connect**

{{< img am-3.png >}}

1.4 Click **Session Manager** and click **Connect**

{{< img am-4.png >}}

1.5 You should see a similar screen with a prompt

{{< img am-5.png >}}

1.6 At the prompt type the following commands:
```
sudo su
cd /home/ec2-user/
```

1.7 Edit the `unishoprun.sh` file using the following command:

```
nano unishoprun.sh
```

1.8 Replace the contents of the file with 

```
#!/bin/bash
java -jar /home/ec2-user/UniShopAppV1-0.0.1-SNAPSHOT.jar &> /home/ec2-user/app.log &
```

1.9 Save and Exit

2.0 We have to restart the EC2 Instance for the new configuration to take effect.  Return to the browser tab where you launched the Session Manager Window and click on the **Instance Id** link

{{< img am-6.png >}}

2.1 Click **Instance state** and select **Reboot instance**

{{< img am-7.png >}}

#### <center>Congragulations !  Your Application has been updated to use the Aurora Promoted Database ! ####
