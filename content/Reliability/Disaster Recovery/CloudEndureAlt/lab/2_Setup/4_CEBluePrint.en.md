+++
title = "Prepare Blueprint(s)"
weight = 4
+++


Blueprint includes parameters such as machine type (for example t3.medium), **subnet** where the machine should be running, **private IP** address and disk types.

To configure the Blueprint, go to the **Machines** tab and click on the name of the machine that you want to configure. Then navigate to the **BLUEPRINT** section.

{{% notice tip %}}
Clicking the machine name (not the checkbox) will provide more configuration options.
{{% /notice %}}



#### Step 1: Configure Webserver Blueprint

In the CloudEndure console, select Machines from the left sidebar. 
1. Select the the server named **Webserver**. This opens the details page to configure the machine blueprint with target instance options. 
2. Fill the details as below

| Parameter                                  | Value                                                        |
    | ------------------------------------------ | ------------------------------------------------------------ |
    | Machine Type | t3.small|
    | Launch Type                          | On demand |
    | Subnet                          | Public Subnet 1 …(TargetVPC)|
    | Security Groups                          | TargetVPC-sgweb-xxx|
    | Private IP address                          | Select create new.(It will choose new private IP from the target subnet selected)|
    |Disks                        |  select SSD |

  Click **SAVE BLUEPRINT**

Here's a quick explanation of  the above parameters. 

- **Machine Type** – Select the type of Target machine from the dropdown menu. In this case, we have selected t3.small to match the source Webserver.
- **Subnet** -  You can select an existing Subnet or create a new subnet. In this case, we have selected **Public Subnet** in the **Target VPC**
- **Security groups** – Security Groups are connected to subnets. You can attach the security group that has **sgweb** in it.
- **Disks** - Select the volume type for your Target disk. You can select Standard, SSD, or Provisioned SSD. In this case, we have selected SSD to match the source server. 

![Webserver-BluePrints](/lab1/webserver.png?classes=shadow,border)

#### Sep 2: Configure DB Server Blueprint

In the CloudEndure console, select Machines from the left sidebar. 
1. Select the the server named **DBserver**. This opens the details page to configure the machine blueprint with target instance options. 
2. Fill the details as below 

| Parameter                                  | Value                                                        |
    | ------------------------------------------ | ------------------------------------------------------------ |
    | Machine Type | t3.small|
    | Launch Type                          | On demand |
    | Subnet                          | Private Subnet 1A.(TargetVPC)|
    | Security Groups                          |TargetVPC-sgdatabase-xxx|
    | Private IP address                          | Select create new.(It will choose new private IP from the target subnet selected)|
    |Disks                        |  select SSD |

  
  Click **SAVE BLUEPRINT**

Now that we have set the blueprints, we are ready to do a Test Launch, or actual Failover.