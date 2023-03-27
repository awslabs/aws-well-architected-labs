---
title: "Deploy The Lab Base Infrastructure"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

In this section, we will build out a [Virtual Public Cloud (VPC)](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html), together with public and private subnets across two [Availability Zones](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/using-regions-availability-zones.html), [Internet Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html) and [NAT gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) along with the necessary routes from both public and private subnets. 

This VPC will become the baseline network architecture within which the application will run. When we successfully complete our initial stage template deployment, our deployed workload should reflect the following diagram:

![Section1 Base Architecture](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section1/section1-pattern3-base-architecture.png)

To deploy the template for the base infrastructure build follow the approptiate steps: 

### 1.1. Get the Cloudformation Template.

To deploy the first CloudFormation template, you can either deploy directly from the command line or via the console. 

You can get the template [here.](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Code/templates/section1/pattern3-base.yml "Section1 template")

{{%expand "Click here for CloudFormation command-line deployment steps"%}}

#### Command Line Deployment:

To deploy from the command line, ensure that you have installed and configured AWS CLI with the appropriate credentials.

#### 1.1.1. Execute Command
  
  
```
aws cloudformation create-stack --stack-name pattern3-base \
                                --template-body file://pattern3-base.yml \
                                --region ap-southeast-2 
```

Note: Please adjust your command-line if you are using profiles within your aws command line as required.

#### 1.1.2. 

Confirm that the stack has installed correctly. You can do this by running the describe-stacks command as follows:

```
aws cloudformation describe-stacks --stack-name pattern3-base 
```

Locate the StackStatus and confirm it is set to **CREATE_COMPLETE** as shown here:

![Section1 CF Outputs](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section1/section1-pattern3-cloudformation-output.png)
  
#### 1.1.3. 

Take note of this stack output as we will need it for later sections of the lab.

{{% /expand%}}

{{%expand "Click here for CloudFormation console deployment steps"%}}
#### Console:

If you need detailed instructions on how to deploy CloudFormation stacks from within the console, please follow this [guide.](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html)

* Use `pattern3-base` as the **Stack Name**, as this is referenced by other stacks later in the lab.


### 1.2. Note Cloudformation Template Outputs

When the CloudFormation template deployment is completed, note the outputs produced by the newly created stack as these will be required at later points in the lab.

You can do this by clicking on the stack name you just created, and select the Outputs Tab as shown in diagram below.


![Section1 Base Outputs](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section1/section1-pattern3-outputs.png)


You can now proceed to **Section 2** of the lab where we will build out the application stack.

{{% /expand%}}

___
**END OF SECTION 1**
___

