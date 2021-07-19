+++
title = "Prepare the Environment"
weight = 1
+++

#### Step 1: Create a Key pair

- Open the [Amazon EC2 console](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:).
- Choose `Create key pair`.
- For Name, enter `cloudendure-dr-lab`.
- For File format, choose `pem`.
- Choose `Create key pair`.

The private key file is automatically downloaded by your browser. Save the private key file in a safe place, we will be using it in the later part of the lab.

#### Step2: Prepare the Simulated Source Environment

To create the source infrastructure, Click {{% button href="https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=TargetVPC&region=eu-west-1&templateURL=https://marketplace-sa-resources.s3.amazonaws.com/ctlabs/migration/LAMP2TierApp.yml&stackName=source-simulated" icon="fas fa-rocket" %}}Launch Source Environment{{% /button %}}

In the console, enter the following Parameters to create the stack:

![CloudFormation Parameters](/lab1/source-simulated-app.png?classes=shadow,border)

- **KeyName**: Choose `cloudendure-dr-lab`
- **MyClientIP**: Add the public IP of your laptop / desktop as a /32 CIDR block (i.e a.b.c.d/32) to allow access via http (port 80) to the web application.  If you don't know your IP, you can find your by [Clicking this link](http://checkip.amazonaws.com/).
- Click **Next** → **Next** → **Create Stack**.
- This creates a VPC and deploys the 2-Tier LAMP stack(webserver & dbserver) and takes ~5 minutes to complete.

1. When stack **Status** will show **CREATE_COMPLETE**, please go to **Outputs** tab and copy the **DatabaseServer IP** and open the **WebsiteURL** in new browser tab.

2. It will open the Web app. Enter the DatabaseServer IP copied from last step in the text box and click on **Connect** button as shown below. The webserver shall connect to dbserver and show the connection message.

![Web Page](/lab1/DatabaseServerIP.png?classes=shadow,border)

*At this stage our source simulated environment is ready for the lab.

#### Step3: Preparing your Target Environment

We will be creating the network stack required to run the target DR site. Click to launch target environment {{% button  href="https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=TargetVPC&region=eu-west-1&templateURL=https://marketplace-sa-resources.s3.amazonaws.com/ctlabs/migration/MigrationTargetVPC.yml" icon="fas fa-rocket" %}}Launch Target Environment{{% /button %}}

- **MyClientIP**: Add the public IP of your laptop / desktop as a /32 CIDR block (i.e a.b.c.d/32) to allow access via http (port 80) to the web application.  If you don't know your IP, you can find your by [Clicking this link](http://checkip.amazonaws.com/).

Click Next, review the options you select and click Next again. Wait for the Stack Status to become CREATE_COMPLETE.