---
title: "Deploy The Application Infrastructure"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

The second section of the lab will build out the sample application stack what will run in the VPC which was build in section **1**. 

This application stack will comprise of the following :


* [Application Load Balancer (ALB)](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html).
* [Autoscaling Group](https://docs.aws.amazon.com/autoscaling/ec2/userguide/AutoScalingGroup.html.) along with it's Launch Configuration.

Once you completed below steps, you base architecture will be as follows:

![Section2 Application Architecture ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section2/section2-pattern3-app-architecture.png)

Building each components in this section manually will take a bit of time, and because our objective in this lab is to show you how to automate patching through AMI build and deployment. To save time, we have created a cloudformation template that you can deploy to expedite the process.

Please follow the steps below to do so : 

### 2.1. Get the Cloudformation Template.

To deploy the second CloudFormation template, you can either deploy directly from the command line or via the console. 

You can get the template [here](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Code/templates/section2/pattern3-application.yml "Section2 template").


{{%expand "Click here for CloudFormation command line deployment steps"%}}

##### Command Line:

#### 2.1.1. 

To deploy from the command line, ensure that you have installed and configured AWS CLI with the appropriate credentials.

```
aws cloudformation create-stack --stack-name pattern3-app \
                                --template-body file://pattern3-application.yml \
                                --parameters  ParameterKey=AmazonMachineImage,ParameterValue=ami-0f96495a064477ffb	\
                                              ParameterKey=BaselineVpcStack,ParameterValue=pattern3-base \
                                --capabilities CAPABILITY_IAM \
                                --region ap-southeast-2  
```
    
#### Important Note:

* For simplicity, we have used Sydney **'ap-southeast-2'** as the default region for this lab. 
* We have also pre configured the Golden Amazon Machine Image Id to be the AMI id of **Amazon Linux 2 AMI (HVM)** in Sydney region **`ami-0f96495a064477ffb`**. If you choose to to use a different region, please change the AMI Id accordingly for your region. 

{{% /expand%}}

{{%expand "Click here for CloudFormation console deployment steps"%}}

##### Console:

#### 2.1.1. 

If you need detailed instructions on how to deploy CloudFormation stacks from within the console, please follow this [guide.](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html)

To deploy the **pattern1-app** stack from the console, ensure that you follow below requirements:

1. Use `pattern3-app` as the **Stack Name**.
2. Provide the name of the VPC CloudFormation stack you create in **section 1** ( we used `pattern3-base` as default ) as the **BaselineVpcStack** parameter value. 
3. Use the AMI Id of **Amazon Linux 2 AMI (HVM)** as the **AmazonMachineImage** parameter value. ( In Sydney region **`ami-0f96495a064477ffb`** if you choose to to use a different region, please change the AMI Id accordingly for your region. )

{{% /expand%}}

### 2.2. Confirm Successful Application Installation

Once the stack creation is complete, let's check that the application deployment has been successful. 
To do this follow below steps: 

1. Go to the **Outputs** section of the cloudformation stack you just deployed.
2. Note the value of **OutputPattern3ALBDNSName** and you can find the DNS name as per screen shot below:
  ![Section2 CloudFormation Output](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section2/section2-pattern3-output-dnsname.png)
3. Copy the value and paste it into a web browser.
4. If you have configured everything correctly, you should be able to view a webpage with **'Welcome to Re:Invent 2020 The Well Architected Way'** as the page title. 
5. Adding `/details.php` to the end of your DNS address will list the packages currently available, together with the AMI which has been used to create the instance as follows:
  ![Section2 ALB Details.php Page ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section2/section2-pattern3-output-detailsphp.png)

6. *Take note of the installed packages and AMI Id (Copy and paste this elsewhere we will use this to confirm the changes later).*
7. When you have confirmed that the application deployment was successful, move to section 3 which will deploy your AMI Builder Pipeline.

___
**END OF SECTION 2**
___