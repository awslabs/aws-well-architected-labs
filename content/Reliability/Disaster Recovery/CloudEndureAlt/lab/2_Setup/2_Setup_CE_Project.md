+++
title = "CloudEndure Configuration"
weight = 2
+++


To begin, you will need to the **AWS credentials** that we [previously created](/0_prerequisites/1_createawsaccount.html#step-3b--creating-a-new-iam-user-and-generating-aws-credentials). 

#### Step 1 - Create CloudEndure Project

1. Login to CloudEndure Console at [https://console.cloudendure.com](https://console.cloudendure.com/)

    ![CE-login](/ce/CE-login.png?classes=shadow,border&height=200px)

2. Project Setup:

- Project name – `AWS_CROSS_REGION_DR_DEMO`
- Project type – `Disaster Recovery`.
- Target cloud – CloudEndure exclusively utilizes the AWS cloud as a Target infrastructure.
- License - select the `Disaster Recovery` License Package to associate with your Project.

Your Create New Project dialog box should look similar to the following. Click **CREATE PROJECT** when you are ready to create the new Project.
![Project](/lab1/PROJECT_CONFIGURATION.png?classes=shadow,border&height=350px)

3. Once the project is created successfully, Navigate to **Setup & Info** > **AWS Credentials** tab and enter **AWS Access Key ID** and **AWS Secret Access Key** that we generated in the [**PreRequisites Section**](/0_prerequisites/1_createawsaccount.html).
   
4. Once you entered the **AWS Access Key ID** and **AWS Secret Access Key**, click the **SAVE** button.

#### Step 2 - Configure Replication Settings

Once you save your **AWS Credentials**, you will be automatically redirected to the **Setup & Info** > **REPLICATION SETTINGS** tab, this is where you will configure details of the **CloudEndure Replication Server**.

{{% notice note %}}
Before proceeding **refresh the browser** to retrieve the latest information from your AWS account (you can do this by pressing the **F5** button or manually refreshing your browser by clicking on the refresh button).
{{% /notice %}}

![CE-Replication-setting](/lab1/replication_settings.png?classes=shadow,border&height=350px)

1. Update the configuration of the **REPLICATION SETTINGS** screen to match the values below:

  The REPLICATION SETTINGS page enables you to define your Source and Target environments, and the default Replication Servers in the Staging Area of the Target infrastructure. 
  
    

 | Parameter                                  | Value |
    | ------------------------------------------ |------------------------------------------ | 
    | Disaster Recovery Source                           | AWS US East Infrastructure                                         |
    | Disaster Recovery Target                           | AWS EU (Ireland)                                         |
    | Replication Server instance type           | Default                                                      |
    | Converter instance type                    | m4.large/m5.large (default)                                                     |
    | Dedicated replication servers              | Unchecked                                                    |
    | Subnet for the replication servers         | TargetVPC-public-a |
    | Security Group for the replication servers | Default CloudEndure Security Group                                                     |
    | Use VPN or DirectConnect (using a private IP) | Unchecked                                                |
    | Enable volume encryption                   | UnChecked                                                     |    

Here is a quick explanation of some of the important settings: 

- **Source infrastructure** -  The source infrastructure, that you want to protect. This can be either of **Other Infrastructure**, **Specific AWS region** or 
**vCenter appliance**. In this lab, we will be using AWS region US East.

- **Target Infrastructure** - Select the AWS region that will serve as the Target to which you want to replicate your data. In this lab, that will be EU (Ireland)

- **Replication Servers** are small machines used to facilitate data replication. CloudEndure uses a t3.small instance type as the default. 

- **Dedicated Replication Server**. This will dedicate a single Replication Server for each Source machine. If you leave it unchecked then for every 15 disks in source infrastructure, a replication server will be created.  

- **Converter instance** are servers that converts the disks to boot and run in the Target infrastructure. The default is m4/m5.large which should suit most of the situations. 

{{% notice tip %}}
For a more detailed list of options on replication settings - please refer the 
[documentation](https://docs.cloudendure.com/#Defining_Your_Replication_Settings/Defining_Your_Replication_Settings.htm%3FTocPath%3DNavigation%7CDefining%2520Your%2520Replication%2520Settings%7C_____0).

{{% /notice %}}

2. Scroll to the bottom of the screen and click **SAVE REPLICATION SETTINGS** button. The dialog window  **Project Setup Complete!** will appear.