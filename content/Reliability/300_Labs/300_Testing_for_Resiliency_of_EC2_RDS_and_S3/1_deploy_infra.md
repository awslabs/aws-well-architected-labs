---
title: "Deploy the Infrastructure and Application"
menutitle: "Deploy Application"
date: 2020-04-24T11:16:09-04:00
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

### 1.2 Checking for existing service-linked roles

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**: Skip this step and go directly to step [Create the "deployment machine"](#create_statemachine).

**If you are using your own AWS account**: [Follow these steps]({{< ref "Documentation/Service_Linked_Roles.md#exist_service_linked_roles" >}}), and then return here and resume with the following instructions.

### 1.3 Create the "deployment machine" {#create_statemachine}

Here you will build a state machine using AWS Step Functions and AWS Lambda that orchestrates the deployment of the multi-tier infrastructure. This is not the service infrastructure itself, but meta-infrastructure we use to build the actual infrastructure.

*__Learn more__: After the lab see [this blog post](https://aws.amazon.com/blogs/devops/using-aws-step-functions-state-machines-to-handle-workflow-driven-aws-codepipeline-actions/) on how AWS Step Functions and AWS CodePipelines can work together to deploy your infrastructure*

1. Decide which deployment option you will use for this lab. It can be run as **single region** *or* **multi region** (two region) deployment.
    * **single region** is faster to get up and running
    * **multi region** enables you to test some additional aspects of cross-regional resilience.
    * Decide on one of these options, then in later steps choose the appropriate instructions for the option you have chosen. If you are attending an in-person workshop, your instructor will specify which to use.

1. Get the CloudFormation template: Download the appropriate file (You can right-click then choose download; or you can right click and copy the link to use with `wget`)
    * **single region**: [download CloudFormation template here](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/CloudFormation/lambda_functions_for_deploy.json)
    * **multi region**: [download CloudFormation template here](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Code/CloudFormation/lambda_functions_for_deploy_two_regions.json)

1. Ensure you have selected the **Ohio** region.  This region is also known as **us-east-2**, which you will see referenced throughout this lab.
![SelectOhio](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/SelectOhio.png)

1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation> and click “Create Stack:”
![Images/CreateStackButton](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CreateStackButton.png)

1. Leave "Prepare template" setting as-is
      * 1 - For "Template source" select "Upload a template file"
      * 2 - Specify the CloudFormation template you downloaded
       ![CFNSFromDownloadedFile](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CFNSFromDownloadedFile.png)

1. Click the “Next” button. For "Stack name" enter:

        DeployResiliencyWorkshop
    ![CFNStackName-ohio](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CFNStackName-ohio.png)

1. On the same screen, for "Parameters" enter the appropriate values:
    * **If you are attending an in-person workshop and were provided with an AWS account by the instructor**: Leave all the parameters at their default values
    * **If you are using your own AWS account**: Set the [first three parameters using these instructions]({{< ref "Documentation/Service_Linked_Roles.md#cfn_service_linked_roles" >}}) and leave all other parameters at their default values.
    * You optionally may review [the default values of this CloudFormation template here]({{< ref "Documentation/CFN_Parameters.md" >}})

1. Click the “Next” button.
      * On the "Configure stack options" page, click “Next” again
      * On the "Review DeployResiliencyWorkshop" page, scroll to the bottom and tick the checkbox “I acknowledge that AWS CloudFormation might create IAM resources.”
      * Click the “Create stack” button.
     ![CFNIamCapabilities](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CFNIamCapabilities.png)

1. This will take you to the CloudFormation stack status page, showing the stack creation in progress.  
  ![StackCreationStarted](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StackCreationStarted.png)  
  This will take approximately a minute to deploy.  When it shows status `CREATE_COMPLETE`, then you are finished with this step.

### 1.4 Deploy infrastructure and run the service {#deployinfra}

1. Go to the AWS Step Function console at <https://console.aws.amazon.com/states>

1. On the Step Functions dashboard, you will see “State Machines” and you will have a new one named “DeploymentMachine-*random characters*.” Click on that state machine. This will bring up an execution console. Click on the “Start execution” button.
![ExecutionStart-ohio](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/ExecutionStart-ohio.png)

1. On the "New execution" dialog, for "Enter an execution name" delete the auto-generated name and replace it with:  `BuildResiliency`

1. Then for "Input" enter JSON that will be used to supply parameter values to the Lambdas in the workflow.
      * **single region** uses the following values:

            {
              "log_level": "DEBUG",
              "region_name": "us-east-2",
              "cfn_region": "us-east-2",
              "cfn_bucket": "aws-well-architected-labs-ohio",
              "folder": "Reliability/",
              "workshop": "300-ResiliencyofEC2RDSandS3",
              "boot_bucket": "aws-well-architected-labs-ohio",
              "boot_prefix": "Reliability/",
              "websiteimage" : "https://s3.us-east-2.amazonaws.com/arc327-well-architected-for-reliability/Cirque_of_the_Towers.jpg"
            }

      * **multi region** uses the [values here]({{< ref "Documentation/Multi_Region_Event_Data.md" >}})
      * **Note**: for `websiteimage` you can supply an alternate link to a public-read-only image in an S3 bucket you control. This will allow you to run S3 resiliency tests as part of the lab
      * Then click the “Start Execution” button.

        ![ExecutionInput-ohio](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/ExecutionInput-ohio.png)  

1. The "deployment machine" is now deploying the infrastructure and service you will use for resiliency testing.

      |Time until you can start...|Single region|Multi region|
      |---|---|---|
      |EC2 failure injection test|15-20 min|15-20 min|
      |RDS and AZ failure injection tests|20-25 min|40-45 min|
      |Multi-region failure injection tests |NA|50-55 min|
      |Total deployment time|20-25 min|50-55 min|

1. You can watch the state machine as it executes by clicking the icon to expand the visual workflow to the full screen.  
![StateMachineExecuting](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StateMachineExecuting.png)

1. You can also watch the [CloudFormation stacks](https://console.aws.amazon.com/cloudformation) as they are created and transition from `CREATE_IN_PROGRESS` to `CREATE_COMPLETE`.
![DeploymentStacksInProgress](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/DeploymentStacksInProgress.png)

1. Note: If you are in a workshop, the instructor will share background and technical information while your service is deployed.

1. You can start the first test (EC2 failure injection testing)  when the web tier has been deployed in the Ohio region. Look for the `WaitForWebApp` step (for **single region**) or `WaitForWebApp1` step (for **multi region**) to have completed successfully.  This will look something like this on the visual workflow.

    ![StepFunctionWebAppDeployed](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/StepFunctionWebAppDeployedSingleRegion.png)

     * Above screen shot is for **single region**. for **multi region** see [this diagram instead]({{< ref "Documentation/Multi_Region_State_Machine.md" >}})

### 1.5 View website for test web service {#website}

1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation>.
      * click on the `WebServersforResiliencyTesting` stack
      * click on the "Outputs" tab
      * For the Key `WebSiteURL` copy the value.  This is the URL of your test web service.
      ![CFNComplete](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/CFNComplete.png)

1. Click the value and it will bring up the website:  
![DemoWebsite](/Reliability/300_Testing_for_Resiliency_of_EC2_RDS_and_S3/Images/DemoWebsite.png)

(image will vary depending on what you supplied for `websiteimage`)
