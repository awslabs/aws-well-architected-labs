---
title: "Deploy The AMI Builder Pipeline"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

In this section we will be building our Amazon Machine Image Pipeline leveraging [EC2 Image Builder](https://aws.amazon.com/image-builder/) service. EC2 Image Builder is a service that simplifies the creation, maintenance, validation, sharing, and deployment of Linux or Windows Server images for use with Amazon EC2 and on-premises. Using this service, eliminates the automation heavy lifting you have to build in order to streamline the build and management of your Amazon Machine Image. 

Upon completion of this section we will have an Image builder pipeline that will be responsible for taking a golden AMI Image, and produce a newly patched Amazon Machine Image, ready to be deployed to our application cluster, replacing the outdated one.

![Section3 Pipeline Architecture Diagram ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-pipeline-architecture.png)

In this section you have the option to build the pipeline manually using AWS console, or if you are keen to complete the lab quickly, you can simply deploy from the cloudformation template. 


{{%expand "Click here to build your pipeline using CloudFormation on the command line"%}}

### 3.1. Download The Cloudformation Template.

Download the template [here](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Code/templates/section3/pattern3-pipeline.yml "Section3 template").


### 3.2.  Deploy Using The Command Line.

#### Command Line:

To deploy from the command line, ensure that you have installed and configured AWS CLI with the appropriate credentials:

```
aws cloudformation create-stack --stack-name pattern3-pipeline \
                                --template-body file://pattern3-pipeline.yml \
                                --parameters  ParameterKey=MasterAMI,ParameterValue=ami-0f96495a064477ffb	\
                                              ParameterKey=BaselineVpcStack,ParameterValue=pattern3-base \
                                --capabilities CAPABILITY_IAM \
                                --region ap-southeast-2  
```

#### Note :
  * For simplicity, we have used Sydney **'ap-southeast-2'**  as the default region for this lab. 
  * We have also pre-configured the **MasterAMI** parameter to be the AMI id of **Amazon Linux 2 AMI (HVM)** in Sydney region **`ami-0f96495a064477ffb`**. If you choose to to use a different region, please change the AMI Id accordingly for your region. 

{{% /expand%}}


{{%expand "Click here to build your pipeline using CloudFormation through the console"%}}
#### Console:

### 3.1. Download The Cloudformation Template.

Download the template [here](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Code/templates/section3/pattern3-pipeline.yml "Section3 template").


### 3.2. Deploy Using The Console.

If you need detailed instructions on how to deploy CloudFormation stacks from within the console, please follow this [guide.](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html)
 
1. Use **`pattern3-pipeline`** as the **Stack Name**.
2. Provide the name of the vpc cloudformation stack you create in section 1 ( we used **`pattern3-base`** as default ) as the **BaselineVpcStack** parameter value. 
3. Use the AMI Id of **Amazon Linux 2 AMI (HVM)** as the **MasterAMI** parameter value. 
  ( In Sydney region **`ami-0f96495a064477ffb`** if you choose to to use a different region, please change the AMI Id accordingly for your region. )

### 3.3. Take note of the ARN.

When the CloudFormation template deployment is completed, note the output produced by the stack.

You can do this by clicking on the stack name you just created, and select the **'Outputs Tab'** as shown in diagram below.

Please take note of the Pipeline ARN specified under **Pattern3ImagePipeline** output

![Section3 CF Outputs](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-pipeline-arn-output.png)

{{% /expand%}}

{{%expand "Click here to build your pipeline interactively"%}}

In this section we will go through the process manually to get a better understanding of the how the pipeline is constructed in EC2 Image Builder service. 

To build this pipeline there are several subtasks we need to do:

* Create an S3 bucket for logging purposes.
* Create an IAM role for use by the EC2 Image Builder.
* Create an Image Builder Component.
* Create an Image Builder Recipe.
* Create an Image Builder Pipeline.


### 3.1. Create an S3 Bucket.

We are going to use an S3 bucket to store the the EC2 Image Build process, so lets create one. 

#### 3.1.1. 

As S3 is a global namespace, for consistency please use the naming convention `pattern3-logging` with a unique UUID number at the end. 

You can achieve this on a mac or UNIX terminal by setting a variable called **$bucket** as follows:  

```
bucket=pattern3-logging-`uuidgen | awk -F- '{print tolower($1$2$3)}'`
echo $bucket
```

#### 3.1.2. 

Hopefully you should have a bucket name returned to you which you can then use to create the bucket as follows:

```
aws s3 mb s3://$bucket --region ap-southeast-2 
```

* Alternatively you can use any randomized string at the end of the standard bucket name and create a bucket manually through the console.
* Please refer to this [guide](https://docs.aws.amazon.com/AmazonS3/latest/user-guide/create-bucket.html) to create S3 bucket.

---

### 3.2 Create IAM role

We will need to create an IAM role that will be used by the EC2 Image Builder service.This IAM role will be used as the instance profile role of the temporary EC2 instance the service will launch. The service will use this instance to run the necessary activity, in this case our patch update. Therefore the role will need to have the appropriate policies to do this activity.

Follow below steps to create the IAM role:

#### 3.2.1. 

Navigate to IAM within the console and select 'role' from the left hand panel and then select 'create role' as shown:
    
![Section3 IAM Role Creation ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-role-create.png)

#### 3.2.2. 

Select 'AWS Service' from the types of trusted entities and then select 'EC2', and 'next: Permissions' as shown:
    
![Section3 IAM Role for EC2 Trusted Entity ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-role-create2.png)

#### 3.2.3. 

Using the filter, search & select the following policies:
    * EC2InstanceProfileForImageBuilder
    * AmazonSSMManagedInstanceCore 

#### 3.2.4. 

Click **'Next:Tags'**.

#### 3.2.5. 

On the next screen click **'Next:Review'**.

#### 3.2.6. 

Enter `pattern3-recipe-instance-role` for the Role Name and add a description. The three policies listed above should be added as follows:
    
![Section3 IAM Role Summary ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-role-summary.png)

#### 3.2.7. 

In the IAM console, locate the role you just created.

#### 3.2.8. 

Click on the role and click **+ Add inline policy**

#### 3.2.9. 

Select the **JSON** Tab and paste in below policy, replace the `<s3 logging bucket>` in the json snippet below with the bucket name you created in previous step.

```
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Effect": "Allow",
          "Action": "s3:*",
          "Resource": [
              "arn:aws:s3:::<s3 logging bucket>/*"               
          ]
      }
  ]
}
```

#### 3.2.10. 

Click **Review Policy** 

#### 3.2.11. 

Enter a name for the policy, and click **'Create Policy'**

#### 3.2.12. 

Once you are done with this, you should now see another entry in the Policies with the name you just specified, expanding on that you should see the policy specified as screen shot below.
  
![Section3.2.2 S3 Policy](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-s3-policy.png)

### 3.3 Create a Security Group.

Our EC2 Image Build pipeline is also going to need a security group that will be assigned to the temporary EC2 instance it uses, so lets create one now so that we can include it later in the lab.

#### 3.3.1. 

Follow this [guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/working-with-security-groups.html) to create a Security Group.

#### 3.3.2. 

For this purpose, we do not need to assign anything in the Inbound rule of the security group.

#### 3.3.3. 

We do need to ensure that the outbound rules allow traffic out to the internet.
    
Your Security group rules should look like below, so edit your security group accordingly:

![Section3 SecurityGroup Inbound ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-sg-in.png)
![Section3 SecurityGroup Outbound ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-sg-out.png)

#### 3.3.4. 

Ensure that the security group is created in the VPC id you've taken note of in section **1.2**. 

If you don't remember the VPC-id, please refer to the instruction on section **1.2** in this lab for clarification.

#### 3.3.5. 

Name the Security Group `pattern3-pipeline-instance-security-group`

#### 3.4. Create a Component.

In this section we will create a construct in EC2 Image Builder called a **Component**. This construct essentially contains instructions on what you would like to build into the AMI. For more information about EC2 Image builder Component, please refer to this [guide](https://docs.aws.amazon.com/imagebuilder/latest/userguide/how-image-builder-works.html#image-builder-component-management).

To do this, Please follow below following steps:

#### 3.4.1. 

Navigate to the EC2 Image Builder service from the console main page.

#### 3.4.2. 

From the EC2 Image Builder service, select **Components** from the left hand menu and then select **Create Component** as shown here:
  
![Section3 Image Builder Create Component ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-create-component.png)

#### 3.4.3. 

Add the following values to to the options, leaving the rest of the settings as default:
    
* **Version:** 1.0.0
* **Platform** Linux
* **Compatible OS versions:** Amazon Linux 2
* **Component Name:** pattern3-pipeline-ConfigureOSComponent
* **Description:** Component to update the OS with latest package versions.

![Section3 Image Builder Component Details ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-component-details.png)


#### 3.4.4. 

Once that's done, select 'Define document content'

#### 3.4.5. 

Copy and paste in below definition document in the section under it. 

```
name: ConfigureOS
schemaVersion: 1.0
phases:
  - name: build
    steps:
      - name: UpdateOS
        action: UpdateOS
```
    
Please Note that this definition is specified in **YAML**, so please ensure indentation is correct.

In this scenario, we have a very simple definition in our component, which is to run an **UpdateOS** action which will the packages in our OS. There are many other action activity you can specify in the component. For more information about EC2 Image Builder component, please refer to this [guide](https://docs.aws.amazon.com/imagebuilder/latest/userguide/image-builder-application-documents.html#document-example)

    
![Section3 Image Builder Component Doc Details ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-component-doc-details.png)



#### 3.4.6. 

When you have completed these inputs, select **Create Component** to complete the component setup.


### 3.5. Create An Image Builder Recipe.

Next, we will create an **Image Builder Recipe**, which specifies the components, and other configuration we are going to define for our pipeline. 

To do this, please complete the following steps:

#### 3.5.1. 

Select Recipes from the left hand menu and then select **Create Recipe**.

#### 3.5.2. 

Enter the following as configuration details:

* **Name:** pattern3-pipeline-ConfigureOSRecipe
* **Version:** 1.0.0
* **Description:** Pattern3 Configure OS Recipe

#### 3.5.3. 

Select **Enter custom AMI ID** and enter: the AMI ID for Amazon Linux 2 AMI (HVM) in your region:

*( In Sydney region `ami-0f96495a064477ffb`, please change the AMI Id accordingly if you use other region.)*

![Section3 Image Builder Recipe Details ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-recipe-details.png)

#### 3.5.4. 

Under **Build components** select **Browse build components** and then filter by **Created by me** to include the component which you created earlier ( `pattern3-pipeline-ConfigureOSComponent` )/

![Section3 Image Builder Recipe Details ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-recipe-details-2.png)


#### 3.5.5. 

Once you have entered all of the configuration details, select **'Create Recipe'** at the bottom of the screen.


### 3.6. Create An Image Builder Pipeline Using the Recipe 

We will now create the **Image Builder Pipeline** to run our recipe.

To do this, please complete the following steps:

#### 3.6.1. 

Remain in the Image Builder Recipe screen and use the tick box to select the recipe which you just created.

#### 3.6.2. 

From the **Actions** menu, select **Create pipeline from this recipe** as shown here:

![Section3.2.6 Image Builder Pipeline Creation ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-pipeline-creation-page.png)

#### 3.6.3. 

Enter the following information to configure the pipeline:

* **Name:** pattern3-pipeline
* **Description:** Pattern 3 pipeline to update OS.
* **Role:** Specify the instance role which you created in step **3.2.2**.
* **Build Schedule:** Manual
* **Infrastructure Settings/Instance Type:** Select an M4.large here if possible, although smaller instances can be used.
* **Infrastructure Settings/VPC, subnet and security groups/Virtual Private Cloud:** Select the VPC that have taken note in section **1.2** of the lab (the output components will list the VPC details).
* **Infrastructure Settings/VPC, subnet and security groups/Subnet ID:** Select the private Subnet ID from section **1.2** of the lab.
* **Infrastructure Settings/VPC, subnet and security groups/Security Group** Select the security group which you created before in step **3.2.3**.
* **Infrastructure Settings/Troubleshooting Settings/S3 location:** Enter the S3 bucket that you specified in section **3.2.1**.

![Section3.2.6 Image Builder Pipeline Details 1 ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-pipeline-details-1.png)

![Section3.2.6 Image Builder Pipeline Details 2 ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-pipeline-details-2.png)

#### Note:

* For the instance types listed, an M4.large will take 20-30 minutes to build. 
* If you want to save costs, please use a smaller instance but be prepared to wait for a bit longer for completion.

#### 3.6.4. 

Once you have completed the above configuration, select **Next** at the bottom of the screen to go to the next configuation page.

#### 3.6.5. 

Leave the rest empty and click **Review**.

#### 3.6.6. 

Review the configuration is according to our specification above, and click **Create Pipeline**

#### 3.6.7. 

Take note of the **pipeline ARN**, as we will need this for the next section.


#### 3.7 Run Your Pipeline.

Now that we have created all the construct, we can test the pipeline to ensure that it is working correctly. 
To do this select **Run Pipeline** from the **Actions** menu with the pipeline selected as shown here:

![Section3.2.7 Running the image builder pipeline ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-pipeline-creation-page.png)

Once this is executed, you can observe the pipeline execution, and wait for the AMI to be built.

#### Note:

EC2 Image Builder pipeline will execute an SSM Automation Document in the background to orchestrate all the activities in building the AMI. If you go into your System Manager Automation document console, you should be able to see the execution running, and observe the activities in more detailed. 

Please refer to this [guide](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-working.html) on how to view the Automation document execution details in your console. 

You should be able to see an execution running under **ImageBuilderBuildImageDocument** document, which is the document used by EC2 Image builder to execute it's activities.

![Section3.2.7 Running the image builder ssm ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section3/section3-pattern3-ssm-auto-example.png)



{{% /expand%}}

Now that you have completed the deployment of the Image Builder Pipeline, move to **section 4** of the lab whre we will use **Systems Manager** to build the automation stage of the architecture.
___
**END OF SECTION 3**
___