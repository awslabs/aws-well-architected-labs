---
title: "Deploy the sample application environment"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

In this section, you will prepare a sample application. The application is an API hosted inside a docker container, using [Amazon Elastic Compute Service (ECS).](https://aws.amazon.com/ecs/). The container is accessed via an [Application Load Balancer.](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html) 

The API is a private microservice within your [Amazon Virtual Private Cloud (VPC)](https://aws.amazon.com/vpc/). Communication to the API can only be done privately through routes within the VPC subnet. In our lab example, the business owner has agreed to run the API over HTTP protocol to simplify the implementation. 

The API has two actions available which encrypt and decrypt information. This is triggered by doing a REST POST call to the */encrypt* / */decrypt* methods as appropriate.

* The *encrypt* action will allow you to pass a secret message along with a 'Name' key as the identifier and it will return a 'Secret Key Id' that you can use later to decrypt your message.
* The *decrypt* action allows you to then decrypt the secret message passing along the 'Name' key and 'Secret Key Id' you obtained before to get your secret message.

Both actions will make a write and read call to the application database hosted in [Amazon Relation Database Service (RDS)](https://aws.amazon.com/rds/), where the encrypted messages are stored. 

The following step-by-step instructions will provision the application that you will use with your  **runbooks**  and  **playbooks** . 

Explore the contents of the CloudFormation script to learn more about the environment and application.

You will use this sample application as a sandbox to simulate an application performance issue, start your  **runbooks**  and  **playbooks**  to autonomously investigate and remediate.

#### Actions items in this section:

1. You will prepare the [Cloud9](https://aws.amazon.com/cloud9/) workspace launched with a new VPC.
2. You will run the application build script from the Cloud9 console to build the sample application as shown in the diagram below.

![Section1 App Arch](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section2-base-application.png)


### 1.0 Prepare Cloud9 workspace.

In this first step you will provision a [CloudFormation](https://aws.amazon.com/cloudformation/) stack that builds a Cloud9 workspace along with the VPC for the sample application. This Cloud9 workspace will be used to run the provisioning script of the sample application. You can choose the to deploy stack in one of the regions below. 

1. Click on the link below to deploy the stack. This will take you to the CloudFormation console in your account. Use `walab-ops-base-resources` as the stack name, and take the default values for all options.

    * **us-west-2** : [here](https://console.aws.amazon.com/cloudformation/home?region=us-west-2#/stacks/create/review?stackName=walab-ops-base-resources&templateURL=https://aws-well-architected-labs-singapore.s3.ap-southeast-1.amazonaws.com/Operations/200_Automating_operations_with_playbooks_and_runbooks/base_resources.yml)
    * **ap-southeast-2** : [here](https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-2#/stacks/create/review?stackName=walab-ops-base-resources&templateURL=https://aws-well-architected-labs-singapore.s3.ap-southeast-1.amazonaws.com/Operations/200_Automating_operations_with_playbooks_and_runbooks/base_resources.yml)
    * **ap-southeast-1** : [here](https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-1#/stacks/create/review?stackName=walab-ops-base-resources&templateURL=https://aws-well-architected-labs-singapore.s3.ap-southeast-1.amazonaws.com/Operations/200_Automating_operations_with_playbooks_and_runbooks/base_resources.yml)

2. Once the template is deployed, wait until the CloudFormation Stack reaches the **CREATE_COMPLETE** state.

![Section1 ](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section2-base-resources-create-complete.png)


### 1.1 Run the build application script.

Next, run the build script to build and deploy you application environment from the Cloud9 workspace as follows:

  1. From the main console, access the **Cloud9** service. 
  2. Click **Your environments** section on the left menu, and locate an environment named `WellArchitectedOps-walab-ops-base-resources` as below, then click **Open IDE**.

      ![Section 2 Cloud9 IDE Welcome Screen](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section2-environment-open-ide.png)

  3. Your environment will bootstrap the lab repository. You should see a terminal output showing the following output: 
  
      ![Section 2](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section2-base-bootstrap.png)

      When the bootstrap script finishes you will see a folder called `aws-well-architected-labs`. 

  4. In the IDE terminal console, change directory to the working folder where the build script is located:

      ```
      cd ~/environment/aws-well-architected-labs/static/Operations/200_Automating_operations_with_playbooks_and_runbooks/Code/scripts/
      ```

  5. Copy and paste the command below, replacing `sysops@domain.com` and `owner@domain.com` with the email address you would like the application to notify you with. Replace the `sysops@domain.com` value with email representing system operators team and `owner@domain.com` with email address representing business owner.


      ```
      bash build_application.sh walab-ops-base-resources sysops@domain.com owner@domain.com
      ```

  {{% notice note %}}
  The `build_application.sh` script will build and deploy your sample application, along with the architecture that hosts it.
  The application architecture will have capabilities to notify systems operators and owners, leveraging [Amazon Simple Notification Service](https://aws.amazon.com/sns/).
  You can use the same email address for `sysops@domain.com` and `owner@domain.com` if you need to, but ensure that you have both values specified.

  If you have deployed Amazon ECS before in your account, you may encounter InvalidInput error with message "AWSServiceRoleForECS has been taken" while running the build_application.sh script. You can safely ignore this message, as the script will continue despite the error.

  {{% /notice %}}

  6. The above command runs the build and provisioning of the application stack. The script should take about 20 mins to finish.

        ![Section 2 Cloud9 IDE Welcome Screen](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section2-base-app-build.png)

  {{% notice note %}}
  The `build_application.sh` will deploy the application docker image and push it to [Amazon ECR](https://aws.amazon.com/ecr/). This is used by [Amazon ECS.](https://aws.amazon.com/ecs/) Once the build script completes, another CloudFormation stack containing the application resources (ECS, RDS, ALB, and others) will be deployed.
  {{% /notice %}}

  7. In the CloudFormation console, you should see a new stack being deployed called `walab-ops-sample-application`. Wait until the stack reaches **CREATE_COMPLETE** state and proceed to the next step.
  
      ![Section 2 CreateComplete](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section2-base-app-create-complete.png)

### 1.2. Confirm the application status.

Once the application is successfully deployed, go to your [CloudFormation console](https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-2) and locate the stack named `walab-ops-sample-application`.

  1. Confirm that the stack is in a **'CREATE_COMPLETE'** state. 
  2. Record the following output details as it will be required later:
  3. Take note of the DNS value specified under **OutputApplicationEndpoint**  of the Outputs.

      The screenshot below shows the output from the CloudFormation stack:

      ![Section2 DNS Output](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section2-dns-outputs.png)

  4. Check for an email sent to the system operator and owner addresses you've specified in the build_application.sh script. This email should also be visible in the CloudFormation parameter under in the **SystemOpsNotificationEmail** and **SystemOwnerNotificationEmail**.

  5. Click `confirm subscription` on the email links to subscribe.

      ![Section2 DNS Output](/Operations/200_Automating_operations_with_playbooks_and_runbooks/Images/section2-email-confirm.png)

  {{% notice note %}}
  There will be 2 emails sent to your address, please ensure to subscribe to **both** of them.
  {{% /notice %}}


### 1.3. Test the application.

In this section, you will be testing the encrypt API action from the deployed application. 

The application will take a JSON payload with `Name` as the identifier and `Text` key as the value of the secret message.

The application will encrypt the value under `Text` key with a designated KMS key and store the encrypted text in the RDS database with `Name` as the primary key.

{{% notice note %}}
**Note:** For simplicity purposes the sample application will re-use the same KMS keys for each record generated.
{{% /notice %}}

1. In the **Cloud9** terminal, run the command below, replacing the `ApplicationEndpoint` with the **OutputApplicationEndpoint** from previous step. This command will run [curl](https://curl.se/) to send a POST request with the secret message payload `{"Name":"Bob","Text":"Run your operations as code"}` to the API.

    ```
    ALBEndpoint="ApplicationEndpoint"
    ```

    ```
    curl --header "Content-Type: application/json" --request POST --data '{"Name":"Bob","Text":"Run your operations as code"}' $ALBEndpoint/encrypt
    ```

2. Once you run this command, you should see output as follows:

    ```
    {"Message":"Data encrypted and stored, keep your key save","Key":"EncryptKey"}
    ```

3. Take note of the encrypt key value under **Key** .

4. Run the command below, pasting the encrypt key you took note of previously under the **Key** section to test the decrypt API.


    ```
    curl --header "Content-Type: application/json" --request GET --data '{"Name":"Bob","Key":"EncryptKey"}' $ALBEndpoint/decrypt

    ```

5. Once you run the command you should see the following output:

    ```
    {"Text":"Run your operations as code"}
    ```

## Congratulations! 

You have now completed the first section of the Lab.

You should have a sample application API which we will use for the remainder of the lab.

Click on **Next Step** to continue to the next section.

{{< prev_next_button link_prev_url="..//" link_next_url="../2_simulate_application_issue/" />}}


