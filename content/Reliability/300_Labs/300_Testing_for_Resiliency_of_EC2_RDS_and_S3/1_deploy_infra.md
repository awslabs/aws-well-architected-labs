---
title: "Deploy the Infrastructure and Application"
menutitle: "Deploy Application"
date: 2021-09-14T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

You will create a multi-tier architecture using AWS and run a simple service on it. The service is a web server running on Amazon EC2 fronted by an Elastic Load Balancer reverse-proxy, with a data store on Amazon Relational Database Service (RDS).

![ThreeTierArchitecture](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/ThreeTierArchitecture.png)

### 1.1 Log into the AWS console {#awslogin}

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

{{%expand "Click here for instructions to access your assigned AWS account:" %}} {{% common/Workshop_AWS_Account %}} {{% /expand%}}

**If you are using your own AWS account**:
{{%expand "Click here for instructions to use your own AWS account:" %}}
* Sign in to the AWS Management Console as an IAM user who has PowerUserAccess or AdministratorAccess permissions, to ensure successful execution of this lab.
* You will need the AWS credentials, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, of this IAM user for later use in this lab.
    * If you do not have this IAM user's credentials or you wish to create a new IAM user with needed permissions, follow the [instructions here to create them]({{< ref "Documentation/Self_AWS_Account.md" >}})
{{% /expand%}}

{{% notice note %}}
 Decide which deployment option you will use for this lab. It can be run as **single region** *or* **multi region** (two region) deployment. If you are attending an _in-person workshop_, use **single region** 
{{% /notice %}}
In later steps choose the appropriate instructions for the deployment option you you have decided upon.
* **single region** is faster to get up and running
* **multi region** enables you to test some additional aspects of cross-regional resilience.

{{% notice info  %}}
If you are attending an in-person workshop, then please continue to [Step 2](../2_configure_env) now.
{{% /notice %}}

### 1.2 Checking for existing service-linked roles

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**: 

Skip this step and go directly to [step 2. Configure Execution Environment](../2_configure_env).

**If you are using your own AWS account**: 

[Follow these steps]({{< ref "Documentation/Service_Linked_Roles.md#exist_service_linked_roles" >}}), and then return here and resume with the following instructions.


### 1.3 Deploy infrastructure and run the service {#create_statemachine}

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

Skip this step and go directly to [step 2. Configure Execution Environment](../2_configure_env).

**If you are using your own AWS account** 

{{%expand "Click here for instructions on creating the deployment machine" %}}

Here you will build a state machine using AWS Step Functions and AWS Lambda that orchestrates the deployment of the multi-tier infrastructure. This is not the service infrastructure itself, but meta-infrastructure we use to build the actual infrastructure.

*__Learn more__: After the lab see [this blog post](https://aws.amazon.com/blogs/devops/using-aws-step-functions-state-machines-to-handle-workflow-driven-aws-codepipeline-actions/) on how AWS Step Functions and AWS CodePipelines can work together to deploy your infrastructure*

1. Get the CloudFormation template: Download the appropriate file (You can right-click then choose download; or you can right click and copy the link to use with `wget`)
    * **single region**: [download CloudFormation template here](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/CloudFormation/lambda_functions_for_deploy.json)
    * **multi region**: [download CloudFormation template here](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/CloudFormation/lambda_functions_for_deploy_two_regions.json)

1. Ensure you have selected the **Ohio** region.  This region is also known as **us-east-2**, which you will see referenced throughout this lab.
![SelectOhio](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/SelectOhio.png)

1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation> and click **Create Stack** and select **With new resources** from the drop-down menu
![Images/CreateStackButton](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CreateStackButton.png)

1. Leave "Prepare template" setting as-is
      * 1 - For "Template source" select "Upload a template file"
      * 2 - Specify the CloudFormation template you downloaded
       ![CFNSFromDownloadedFile](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CFNSFromDownloadedFile.png)

1. Click the “Next” button. For "Stack name" enter: `DeployResiliencyWorkshop`

    ![CFNStackName-ohio](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CFNStackName-ohio.png)

1. On the same screen, for "Parameters" enter the appropriate values:
    * **If you are attending an in-person workshop and were provided with an AWS account by the instructor**: Leave all the parameters at their default values
    * **If you are using your own AWS account**: Set the [first three parameters using these instructions]({{< ref "Documentation/Service_Linked_Roles.md#cfn_service_linked_roles" >}}) and leave all other parameters at their default values.
    * You optionally may review [the default values of this CloudFormation template here]({{< ref "Documentation/CFN_Parameters.md" >}})

1. Click the “Next” button.
      * On the "Configure stack options" page, click “Next” again
      * On the "Review DeployResiliencyWorkshop" page, scroll to the bottom and tick the checkbox “I acknowledge that AWS CloudFormation might create IAM resources with custome names.”
      * Click the “Create stack” button.
     ![CFNIamCapabilities](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CFNIamCapabilities.png)

1. This will take you to the CloudFormation stack status page, showing the stack creation in progress.  
  ![StackCreationStarted](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StackCreationStarted.png)  
  This will take approximately a minute to deploy.  When it shows status `CREATE_COMPLETE`, then the state machine will start deploying the infrastructure and service.

1. Once the "deployment machine" starts deploying the infrastructure and service it will take approximately the following times to deploy:

      |Time until you can start...|Single region|Multi region|
      |---|---|---|
      |EC2 failure injection test|15-20 min|15-20 min|
      |RDS and AZ failure injection tests|20-25 min|40-45 min|
      |Multi-region failure injection tests |NA|50-55 min|
      |Total deployment time|20-25 min|50-55 min|

{{% /expand%}}

{{% notice tip %}}
To save time, you can move on to [Step 2](../2_configure_env) now while the application is deploying.
{{% /notice %}}

### 1.4 Monitoring progress of the deployment

{{%expand "Click here for instructions on monitoring the progress of the deployment" %}}

1. Go to the AWS Step Function console at <https://console.aws.amazon.com/states>

1. On the Step Functions dashboard, you will see “State Machines”. Click on the one named “DeploymentMachine-*random characters*.” This will bring up an execution console

1. Click on the state machine execution under **Executions**

1. You can watch the state machine as it executes by clicking the icon to expand the visual workflow to the full screen.  
![StateMachineExecuting](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StateMachineExecuting.png)

1. You can also watch the [CloudFormation stacks](https://console.aws.amazon.com/cloudformation) as they are created and transition from `CREATE_IN_PROGRESS` to `CREATE_COMPLETE`.
![DeploymentStacksInProgress](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/DeploymentStacksInProgress.png)

1. You can start the first test (EC2 failure injection testing)  when the web tier has been deployed in the Ohio region. Look for the `WaitForWebApp` step (for **single region**) or `WaitForWebApp1` step (for **multi region**) to have completed successfully.  This will look something like this on the visual workflow.

    ![StepFunctionWebAppDeployed](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StepFunctionWebAppDeployedSingleRegion.png)

     * Above screen shot is for **single region**. for **multi region** see [this diagram instead]({{< ref "Documentation/Multi_Region_State_Machine.md" >}})

{{% /expand %}}

### 1.5 View website deployed as part of this test application

* Later when the deployment is complete, you will be able to view the website that you deployed
* The steps to view the website are in [Step 3.3 View the website used for the test application for this lab](../3_failure_injection_prep#website)

{{< prev_next_button link_prev_url="../" link_next_url="../2_configure_env/" />}}
