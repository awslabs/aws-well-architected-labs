---
title: "Deploy The Build Automation With SSM"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

Now that our AMI Builder Pipeline is built, we can now work on the final automation stage with Systems Manager. 

In this section we will orchestrate the build of a newly patched AMI and its associated deployment into our application cluster. 

To automate this activities we will leverage [AWS Systems Manager Automation Document](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-documents.html). 

Using our SSM Automation document we will execute the following activities:

* Automate the execution of the EC2 Image Builder Pipeline.
* Wait for the pipeline to complete the build, and capture the newly created AMI with updated OS patch.
* Then it will Update the CloudFormation application stack with the new patched Amazon Machine Image.
* This AMI update to the stack will in turn trigger the CloudFormation [AutoScalingReplacingUpdate](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-attribute-updatepolicy.html) policy to perform a simple equivalent of a blue/green deployment of the new Autoscaling group. 

#### Note:

Using this approach, we streamline the creation of our AMI, and at the same time minimize interruption to applications within the environment.

Additionally, by leveraging the automation built in Cloudformation through autoscaling update policy, we reduce the complexity associated with building out a blue/green deployment structure manually. Lets look at how this works in detail:

* Firstly, CloudFormation detects the need to update the LaunchConfiguration with a new Amazon Machine Image.
* Then, CloudFormation will launch a new AutoScalingGroup, along with it's compute resource (EC2 Instance) with the newly patched AMI.
* CloudFormation will then wait until all instances are detected healthy by the Load balancer, before terminating the old AutoScaling Group, ultimately achieving a blue/green model of deployment. 
* Should the new compute resource failed to deploy, cloudformation will rollback and keep the old compute resource running.

For details about how this is implemented in the CloudFormation template, please review the `pattern3-application.yml` template deployed in section **2**.

Once we complete this section our architecture will reflect the following diagram:

![Section4 Automation Architecture Diagram ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section4/section4-pattern3-automate-architecture.png)

In this section you have the option to build the resources manually using AWS console. If however you are keen to complete the lab quickly, you can simply deploy from the CloudFormation template and take a look at the deployed architecture. Select the appropriate section:

{{%expand "Build with a CloudFormation template on the command-line"%}}

### 4.1. Get The Template

The template for Section 4 which can be found [here](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Code/templates/section4/pattern3-automate.yml "Section4 template").

#### 4.2. Deploy From The Command Line

To deploy from the command line, ensure that you have installed and configured AWS CLI with the appropriate credentials. When you are ready, execute the following command:

```
aws cloudformation create-stack --stack-name pattern3-automate \ 
                                --template-body file://pattern3-automate.yml \ 
                                --parameters  ParameterKey=ApplicationStack,ParameterValue=pattern3-app \
                                                ParameterKey=ImageBuilderPipelineARN,ParameterValue=<enter image builder pipeline arn>

```

### 4.3. Record The CloudFormation Output.

Once the template is finished execution, note the **Automation Document Name** from the Cloudformation output specified under **Pattern3CreateImageOutput**.


{{% /expand%}}

{{%expand "Build with a CloudFormation template in the console"%}}

#### 4.1. Get The Template

The template for Section 4 which can be found [here](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Code/templates/section4/pattern3-automate.yml "Section4 template").

#### 4.2. Deploy From The Console

To deploy the template from console please follow this [guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html) for information on how to deploy the cloudformation template. 

* Use `pattern3-automate` as the **Stack Name**.
* Provide the cloudformation stack name you created in section **3.2.6** as **ImageBuilderPipelineStack** parameter value. 
* Provide the cloudfromation stack name you created in section **2.1** as **ApplicationStack** parameter value. 

### 4.3. Record The CloudFormation Output.

Once the template is finished execution, note the **Automation Document Name** from the Cloudformation output specified under **Pattern3CreateImageOutput**.


{{% /expand%}}


{{%expand "Build Automation Document Manually"%}}

### 4.1. Access Systems Manager From The Console.

From the AWS console, select **'Systems Manager'**. 

When you get to the front page of the service, use the left hand panel and go down to the bottom of the menu to select **Documents** from the **Shared Resources** as follows:


![Accessing Automation Documents in Systems Manager](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section4/section4-pattern3-systemmanager-document.png).

### 4.2. Create Automation Document 

In this section we will go through steps to create the automation document, explaining the automation document configuration detail interactively as we walk through. To ensure that you get the formatting correct when you insert the automation document we have provided a full copy for you to download [here](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Code/scripts/section4_ssm_automation_document.yml).


#### 4.2.1. 

Firstly access Systems Manager from the AWS Console. 

#### 4.2.2. 

When you get to the front page of the service, use the left hand panel and go down to the bottom of the menu to select **Documents** from the **Shared Resources** as follows:

![Accessing Automation Documents in Systems Manager](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section4/section4-pattern3-systemmanager-document.png).

#### 4.2.3. 

From the main page, select the **Create Automation** button to build an automation document.

#### 4.2.4. 

Enter the name of the automation document and select the **Editor** option to enter a the document directly into the console. 

#### 4.2.5. 

Next we need to add the document specification below into the editor. Add the document which you downloaded at the start of section **4.2.**. The following steps will explain the document configuration in stages.

#### 4.2.6. 

Firstly, we need to specify the **schemaVersion** and parameters which our document will take as an Input.
   
In this case we will take the **ImageBuilderPipeline ARN** as well as the name of the Application Stack (default: **pattern3-app**)

```
description: CreateImage
schemaVersion: '0.3'
parameters:
    ImageBuilderPipelineARN:
    description: (Required) Corresponding EC2 Image Builder Pipeline to execute.
    type: String
    ApplicationStack:
    description: (Required) Corresponding Application Stack to Deploy the Image to.
    type: String
```

#### 4.2.7. 

Next we will specify the first step which is to execute image builder pipeline we created in previous section. Passing the parameter inputs we specified before. This execution is achieved by calling the AWS service API directly leveraging [aws:executeAwsApi](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-action-executeAwsApi.html) action type in SSM Automation Document.

```
mainSteps:
    - name: ExecuteImageCreation
    action: aws:executeAwsApi
    maxAttempts: 10
    timeoutSeconds: 3600
    onFailure: Abort
    inputs:
        Service: imagebuilder
        Api: StartImagePipelineExecution
        imagePipelineArn: '{{ ImageBuilderPipelineARN }}'
    outputs:
    - Name: imageBuildVersionArn
        Selector: $.imageBuildVersionArn
        Type: String
```

#### 4.2.8. 

In the next we will specify [aws:waitForAwsResourceProperty](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-action-waitForAwsResourceProperty.html) action wait for the Image to complete building. 

```
      - name: WaitImageComplete
        action: aws:waitForAwsResourceProperty
        maxAttempts: 10
        timeoutSeconds: 3600
        onFailure: Abort
        inputs:
          Service: imagebuilder
          Api: GetImage
          imageBuildVersionArn: '{{ ExecuteImageCreation.imageBuildVersionArn }}'
          PropertySelector: image.state.status
          DesiredValues: 
            - AVAILABLE
```

#### 4.2.9. 

Once the wait is complete, and the Image is ready, we will then call another [aws:executeAwsApi](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-action-executeAwsApi.html) to capture the AMI Id and pass the value into the next step.
  
```
  - name: GetBuiltImage
    action: aws:executeAwsApi
    maxAttempts: 10
    timeoutSeconds: 3600
    onFailure: Abort
    inputs:
      Service: imagebuilder
      Api: GetImage         
      imageBuildVersionArn: '{{ ExecuteImageCreation.imageBuildVersionArn }}'
    outputs:
    - Name: image
      Selector: $.image.outputResources.amis[0].image
      Type: String
```

#### 4.2.10. 

With the AMI id we received in previous step, we will then pass the id to our Application CloudFormation Stack and trigger an update using [aws:executeAwsApi](https://docs.aws.amazon.com/systems-manager/latest/userguide/automation-action-executeAwsApi.html) action.

```
  - name: UpdateCluster
    action: aws:executeAwsApi
    maxAttempts: 10
    timeoutSeconds: 3600
    onFailure: Abort
    inputs:
      Service: cloudformation
      Api: UpdateStack
      StackName: '{{ ApplicationStack }}'
      UsePreviousTemplate: true
      Parameters:
        - ParameterKey: BaselineVpcStack
          UsePreviousValue: true
        - ParameterKey: AmazonMachineImage
          ParameterValue: '{{ GetBuiltImage.image }}'
      Capabilities:
        - CAPABILITY_IAM
```          

#### 4.2.11. 

Once the update executes we will once again wait for the Cloudformation update to complete, and return with the UPDATE_COMPLETE status.

```
  - name: WaitDeploymentComplete
    action: aws:waitForAwsResourceProperty
    maxAttempts: 10
    timeoutSeconds: 3600
    onFailure: Abort
    inputs:
      Service: cloudformation
      Api: DescribeStacks
      StackName: '{{ ApplicationStack }}'
      PropertySelector: Stacks[0].StackStatus
      DesiredValues: 
        - UPDATE_COMPLETE
```

#### 4.2.12. 

We have provided commentary above, to give you a picture of what is being executed in this automation document. As a whole your Automation Document should look as below. Please copy and paste below, and make that the indentation is correct as this document is specified in YAML format. Alternatively you can download the file [here](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Code/scripts/section4_ssm_automation_document.yml)

```
description: CreateImage
schemaVersion: '0.3'
parameters:
  ImageBuilderPipelineARN:
    description: (Required) Corresponding EC2 Image Builder Pipeline to execute.
    type: String
  ApplicationStack:
    description: (Required) Corresponding Application Stack to Deploy the Image to.
    type: String
mainSteps:
  - name: ExecuteImageCreation
    action: aws:executeAwsApi
    maxAttempts: 10
    timeoutSeconds: 3600
    onFailure: Abort
    inputs:
      Service: imagebuilder
      Api: StartImagePipelineExecution
      imagePipelineArn: '{{ ImageBuilderPipelineARN }}'
    outputs:
    - Name: imageBuildVersionArn
      Selector: $.imageBuildVersionArn
      Type: String
  - name: WaitImageComplete
    action: aws:waitForAwsResourceProperty
    maxAttempts: 10
    timeoutSeconds: 3600
    onFailure: Abort
    inputs:
      Service: imagebuilder
      Api: GetImage
      imageBuildVersionArn: '{{ ExecuteImageCreation.imageBuildVersionArn }}'
      PropertySelector: image.state.status
      DesiredValues: 
        - AVAILABLE
- name: GetBuiltImage
  action: aws:executeAwsApi
  maxAttempts: 10
  timeoutSeconds: 3600
  onFailure: Abort
  inputs:
    Service: imagebuilder
    Api: GetImage         
    imageBuildVersionArn: '{{ ExecuteImageCreation.imageBuildVersionArn }}'
  outputs:
  - Name: image
    Selector: $.image.outputResources.amis[0].image
    Type: String
- name: UpdateCluster
  action: aws:executeAwsApi
  maxAttempts: 10
  timeoutSeconds: 3600
  onFailure: Abort
  inputs:
    Service: cloudformation
    Api: UpdateStack
    StackName: '{{ ApplicationStack }}'
    UsePreviousTemplate: true
    Parameters:
      - ParameterKey: BaselineVpcStack
        UsePreviousValue: true
      - ParameterKey: AmazonMachineImage
        ParameterValue: '{{ GetBuiltImage.image }}'
    Capabilities:
      - CAPABILITY_IAM
- name: WaitDeploymentComplete
  action: aws:waitForAwsResourceProperty
  maxAttempts: 10
  timeoutSeconds: 3600
  onFailure: Abort
  inputs:
    Service: cloudformation
    Api: DescribeStacks
    StackName: '{{ ApplicationStack }}'
    PropertySelector: Stacks[0].StackStatus
    DesiredValues: 
      - UPDATE_COMPLETE
```

#### 4.2.13. 

Once that's done click **Create Automation**

Now that we have created the Automation Document, let's go ahead and execute it.

### 4.3. Start The Monitor Script.

Before we execute the document, we have provided a simple script for you to continuously query the Application Load Balancer http address during the document execution. This is to show that the load balancer remains available throughout the deployment. 

#### 4.3.1. 

Firstly, download the monitor script [here](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Code/scripts/watchscript.sh). 

#### 4.3.2. 

Now change permissions of the script if required and execute passing in the application load balancer DNS address. Note that the DNS address is provided in the output of the application CloudFormation stack in section **2.2** under **OutputPattern3ALBDNSName**.

Execute the script as follows:

```
./watchscript.sh http://<enter DNS address for the Application Load Balancer>
```

As mentioned above, the script will run a continuous poll of the ALB throughout the next few steps to demonstrate that there is no interruption to traffic during the patch process.

For clarity, you might want to run this in a separate dedicated terminal as it will continue to poll the ALB in a loop.

You can leave this script running, and monitor to see if there is any failed response to the application. Your output should look similar to this:

![Section4 Watch Script ](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section4/section4-pattern3-watch-script.png)

### 4.4 Start the Automation Document.

Once your monitor script is running a continous poll of the ALB, you can execute the SSM automation document.

To Execute the automation document, you can run the following command:

```
aws ssm start-automation-execution \
    --document-name "<enter_document_name>" \
    --parameters "ApplicationStack=<enter_application_stack_name>,imageBuilderPipeline=<enter_image_builder_pipeline_arn>"

```

#### Note:

* The value of **<enter_document_name>** is provided as output to the CloudFormation template which you noted in section **4.1.1**, or in section **4.2** if you are building it manually.
* The value of **<enter_application_stack_name>** is the name that you provided to the application stack in Section **2** (default is pattern3-app).
* The value of **<enter_image_builder_pipeline_arn>** is the ARN of the Image Builder Pipeline. You can get this from the output to the pipeline stack from Section **3.1.2** or **3.2.6** if you are building it manually via the console..

When you have successfully executed the command you will be provided with an **AutomationExecutionID**.

To check the status of the currently running automation executions, you can use the following command:

```
aws ssm describe-automation-executions 
```

Note that you can pass a filter to the command with the AutomationExecutionID which you were provided from the automation execution as follows:

```
aws ssm describe-automation-executions --filter "Key=ExecutionId,Values=<enter_execution_id>"

```

### 4.5. Confirm that the AMI has been Updated Via the Load Balancer DNS Name.

When the automation execution is completed, use your web browser to access your application load balancer DNS name, together with the 'details.php' script added to the end of the address. You will now find that the AMI-ID has been updated with a new one, indicating that your original autoscaling group has been replaced with an updated group which is configured to use the patched AMI. as follows:


![Section4.6 Check Updated AMI ID from ALB DNS address](/Security/300_Autonomous_Patching_With_EC2_Image_Builder_and_Systems_Manager/Images/section4/section4-pattern3-checkALBDNSname.png)


This concludes our lab. 

{{% /expand%}}

___
**END OF SECTION 4**
**END OF LAB**
___
