---
title: "Configure ECS Respository and Deploy The Application Stack"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

### 2.0. Introduction.

In this section, we are going to prepare our sample application. We will package this as a docker image and push to a repository.

As we mentioned in our introduction, our sample application will be running in a docker container which we will deploy using [Amazon ECS](https://aws.amazon.com/ecs/). 

In preparation for the deployment, we will need to package our application as a docker image and push it into [ECR](https://aws.amazon.com/ecr/). When this is completed, we will use the image which we placed in ECR to build our application cluster. 

For more information on how ECS works, please refer to this [guide](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html).

When our application stack is completed, our architecture will look like this:

![Section2 App Arch](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section2/section2-pattern1-App-architecture.png)

Move through the sections below to complete the repository configuration and application stack deployment:

### 2.1. Configure the ECS Container Repository.

Our initial sample application preparation will require running several docker commands to create a local image in your computer which we will push into Amazon ECR. The following diagram shows the image creation process:

![Section2 ECR Arch](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section2/section2-pattern1-ECR-architecture.png)



To make this process simple for you, we have created a basic application and script to build the container for you. 

Complete the instructions as follows to download the :

#### 2.1.1. 

Our environment used to push the container to the repository will need to be running `Docker version 18.09.9` or above. To achieve this on a laptop such as a mac involves installing not only Docker itself, but also the Docker Machine and VirtualBox. Because of this, we will use AWS [Cloud9](https://aws.amazon.com/cloud9/) IDE in the console which has all of the dependencies pre-configured for you.

#### 2.1.2. 

From the main console, launch the **Cloud9** service. 

When you get to the welcome screen, select **Create Environment** as shown here:

![Section 2 Cloud9 IDE Welcome Screen](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section2/section2-pattern1-cloud9-welcome-screen.png)

#### 2.1.3.

Now we will enter naming details for the environment. To do this enter the following into the **name environment** dialog box:

Name: `pattern1-environment`
Description: `re:Invent 2020 pattern1 environment!`

When you are ready, click on **Next Step** to continue as shown:

![Section 2 Cloud9 IDE Welcome Screen](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section2/section2-pattern1-cloud9-name-environment.png)

#### 2.1.4.

On the **Configure Settings** dialog box, leave defaults and click **Next Step**

#### 2.1.5.

On the **Review** dialog box, click **Create Environment**

The Cloud9 IDE environment will now build, integrating the AWS command line and all docker components that we require to build out our lab.

This step can take a few minutes, so please be patient.

#### 2.1.6.

Once our environment is built, you will be greeted with a command prompt to your environment.

We will use this to build our application for upload to the repository.

Firstly we will need to download the files which contain all of the application dependencies. To do this, run the following command within the **Cloud9 IDE**:

```
curl -o sample-app.zip https://d3h9zoi3eqyz7s.cloudfront.net/Security/sample_app.zip
```

The command should show the file download as follows:

![Section 2 Cloud9 IDE Welcome Screen](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section2/section2-pattern1-cloud9-application-download.png)

#### 2.1.7. 

When you have downloaded the application, unzip it as follows:

```
unzip sample-app.zip
```

#### 2.1.8.

Now we will build our application and upload to the repository. We have built a script to help you with this process, which will query the previous CloudFormation stack which you created for the necessary repository information, build an image and then upload to the new repository.

Execute the script with the argument of `pattern1-base` as follows:
 
```
cd app/
./build-container.sh pattern1-base
```

Once your command runs successfully, you should be seeing the image being pushed to ECR and URI marked as shown here:

![Section 2 Cloud9 IDE Application Build](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section2/section2-pattern1-cloud9-application-build.png)


{{% notice note %}}
Take note of the ECS Image URI produced at the end of the script as we will require it later. This is highlighted in the screenshot above.
{{% /notice %}}

#### 2.1.9. 

Confirm that the ECR repository exists in the ECR console. To do this, launch ECR in your AWS Console. 

You can then follow this [guide](https://docs.aws.amazon.com/AmazonECR/latest/userguide/repository-info.html) to check to your repository as shown:

![Section2 Script Output](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section2/section2-pattern1-ECR.png)



### 2.2. Deploy The Application Stack

Now that we have pushed the docker image into our [Amazon ECR](https://aws.amazon.com/ecr/) repository, we will now deploy it within [Amazon ECS](https://aws.amazon.com/ecs/). 

Our sample application is configured as follows:

* Our application is built using nodejs express ( You can find the source code under app/app.js file of the [github]() repository ) 
* The service will expose a REST API wth **/encrypt** and **/decrypt** action.
* The **/encrypt** will take an input of a JSON payload with key and value as below `'{"Name":"Andy Jassy","Text":"Welcome To ReInvent 2020!"}'`
* The **Name** Key will be the identifier that we will use to store the encrypted value of **Text** Value.
* The application will then call the [KMS Encrypt API](https://docs.aws.amazon.com/kms/latest/APIReference/API_Encrypt.html) and encrypt it again using a KMS key that we designate. (For simplicity, in this mock app we will be using the same KMS key for every **Name** you put in, ideally you want to use individual key for each name)
* The encrypted value of **Text** key will then be stored in an [RDS](https://aws.amazon.com/rds/) database, and the app will return a **Encryption Key** value that the user will have to pass on to decrypt the Text later
* The **decrypt** API will do the reverse, taking the **Encryption Key** you pass to decrypt the text `{"Text":"Welcome To ReInvent 2020!"}`

{{% notice note %}}
**Note:** In this section we will be deploying a CloudFormation Stack which will launch an ECS cluster. If this is the first time you are working with the ECS service, you will need to deploy a service linked role which will be able to assume the IAM role to perform the required activities within your account. To do this, run the following from the command line using appropriate profile flags:
`aws iam create-service-linked-role --aws-service-name ecs.amazonaws.com `

{{% /notice %}}

Download the application template from [here](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Code/templates/section2/pattern1-app.yml "Section2 Application template") and deploy according to your preference below.



{{%expand "Click here for CloudFormation command-line deployment steps"%}}

##### Command Line:

To deploy from the command line, ensure that you have installed and configured AWS CLI with the appropriate credentials.

#### 2.2.1. 

Execute below command to create the application stack. Ensure that you pass the ECR Image URI you noted at the end of section **1.2** as follows:


```
aws cloudformation create-stack --stack-name pattern1-app \
                                --template-body file://pattern1-app.yml \
                                --parameters ParameterKey=BaselineVpcStack,ParameterValue=pattern1-base \
                                            ParameterKey=ECRImageURI,ParameterValue=<ECR Image URI> \
                                --capabilities CAPABILITY_NAMED_IAM \
                                --region ap-southeast-2
```

**Note:** Our example below shows sample arguments passed into the command for your reference:

```
aws cloudformation create-stack --stack-name pattern1-app \
                                --template-body file://pattern1-app.yml \
                                --parameters ParameterKey=BaselineVpcStack,ParameterValue=pattern1-base \
                                            ParameterKey=ECRImageURI,ParameterValue=111111111111.dkr.ecr.ap-southeast-2.amazonaws.com/pattern1appcontainerrepository-cu9vft86ml5e:latest \
                                --capabilities CAPABILITY_NAMED_IAM \
                                --region ap-southeast-2
```

{{% /expand%}}

{{%expand "Click here for CloudFormation console deployment steps"%}}

##### Console:

If you decide to deploy the stack from the console, ensure that you follow below requirements & step:

#### 2.2.1. 

Follow this [guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html) for information on how to deploy the cloudformation template via the console.

#### 2.2.2. 

Enter the following details into the stack details:

* Use `pattern1-app` as the **Stack Name**.
* Use `pattern1-base` as the **BaselineVpcStack**.
* Use the URI which you recorded in the application build as the **ECRImageURI**

An example would be as follows:

![Section2 App Stack Creation](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section2/section2-pattern1-application-stack-creation.png)

When you are ready, click **next** to continue.

#### 2.2.3.

On the **Configure Stack Options** click **Next**

#### 2.2.4.

On the **Review pattern1-app** click **Create Stack**.

**Note** Dont forget to tick the **Capabilities** acknowledgement at the bottom of the screen.

{{% /expand%}}

### 2.3. Confirm Stack Status.

#### 2.3.1.

Once the command deployed successfully, go to your [Cloudformation console](https://console.aws.amazon.com/cloudformation/home?region=ap-southeast-2) to locate the stack named `pattern1-app`.

#### 2.3.2.

Confirm that the stack is in a **'CREATE_COMPLETE'** state. 

#### 2.3.3.

Record the following output details as they will be required later:

* Take note of this **stack name**
* Take note of the DNS value specified under **OutputPattern1ApplicationEndpoint**  of the Outputs.
* Take note of the ECS Task Role Arn value specified under **OutputPattern1ECSTaskRole**  of the Outputs.
* Take note of the OutputPattern1ECSTaskRole.

The following diagram shows the output from the cloudformation stack:

![Section2 DNS Output](/Security/300_Autonomous_Monitoring_Of_Cryptographic_Activity_With_KMS/Images/section2/section2-dns-outputs.png)

### 2.4. Test the Application launched.

In this part of the Lab, we will be testing the encrypt API of the sample application we just deployed. Our application will basically take a JSON payload with `Name` and `Text` key, and it will encrypt the value under text key with a designated KMS key. Once the text is encrypted, it will store the encrypted text in the RDS database with the `Name` as the primary key.


{{% notice note %}}
**Note:** For simplicity our sample application is not generating individual KMS keys for each record generated. Should you wish to deploy this pattern to production, we recommend that you use a separate KMS key for each record.
{{% /notice %}}

From your **Cloud9** terminal, replace the < Application Endpoint URL > with the **OutputPattern1ApplicationEndpoint** from previous step.

```
ALBURL="< Application Endpoint URL >"

curl --header "Content-Type: application/json" --request POST --data '{"Name":"Andy Jassy","Text":"Welcome to ReInvent 2020!"}' $ALBURL/encrypt
```

Once you've executed this you should see an output similar to this:

```
{"Message":"Data encrypted and stored, keep your key save","Key":"<encrypt key (take note) >"}
```
Take note of the encrypt key value under **Key** from your output as we will need it for decryption later in the lab.

This completes **section 2** of the lab. Proceed to **section 3** where we will be configuring **CloudTrail**.
___
**END OF SECTION 2**
___
