---
title: "Configure Lab Environment"
date: 2020-12-17T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---
 
In this section, we will deploy our base lab infrastructure using [AWS Serverless Application Model (AWS SAM)](https://aws.amazon.com/serverless/sam/) in [AWS Cloud9](https://aws.amazon.com/cloud9/) environment. This will consist of a public [Amazon API Gateway](https://aws.amazon.com/api-gateway/) which connects to [AWS Lambda function](https://aws.amazon.com/lambda/) that puts items in AWS DynamoDB. We will also create a rule in [Amazon EventBridge](https://aws.amazon.com/eventbridge/) and another AWS Lambda that will retrieve data related to cost optimization from [AWS Compute Optimizer](https://aws.amazon.com/compute-optimizer) and [AWS Trusted Advisor](https://aws.amazon.com/trusted).
 
Our initial deployment should reflect the following diagram:

![Section2 Base Architecture](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/Architecture-Cost.png)
 
Note the following:
 
1. AWS SAM deployment includes an Amazon API gateway with an IAM role to invoke our Lambda function. This function references a JSON mapping file that contains trusted advisor check IDs allowing for mapping to the appropriate questions within the Well-Architected tool.
 
2. AWS Lambda function puts items in AWS DynamoDB.
 
3. In the Well-Architected Tool, a reviewer will define a workload which is a collection of resources and applications that delivers business value. 
 
4. Defining a workload in the Well-Architected Tool generates an API event called **CreateWorkload** that Amazon EventBridge receives. This will invoke the second AWS Lambda function. 
 
5. This AWS Lambda function collects usage data and recommends an appropriate instance type based on rightsizing information from **AWS Compute Optimizer** and **AWS Trusted Advisor**.
 
6. The AWS Lambda function will be able to retrieve Question ID from AWS DynamoDB.
 
7. The AWS Lambda function eventually updates data points into **Notes** in Well-Architected Tool.
 
{{% notice note %}}
**Note:** Select the region in which your EC2 Instances are running.
{{% /notice %}}
 
To deploy the template for the base infrastructure, complete the following steps:
 
### 1.1. Get the CloudFormation Template and deploy Cloud9.
 
You can get the CloudFormation template [here.](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Code/templates/section1/section1-base.yaml "Section1 template")
 
The first CloudFormation template will deploy AWS Cloud9 and you can create CloudFormation Stack directly via the AWS console.
 
{{%expand "Click here for CloudFormation console deployment steps"%}}
#### Console:
 
If you need detailed instructions on how to deploy CloudFormation stacks from within the console, please follow this [guide.](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html)
 
1. Open the CloudFormation console at [https://console.aws.amazon.com/cloudformation](https://console.aws.amazon.com/cloudformation/) and select the region in which your existing Amazon EC2 Instances running.
 
![Section2 CFStack](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/CFStack.png)
 
2. Select the stack template which you downloaded earlier, and create a stack. Click **Choose file** to upload **section1-base.yaml** and click **Next**.
 
![Section2 Upload_CFStack](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/Upload_CFStack.png)
 
For the stack name use any stack name you can identify and click **Next**.
![Section2 StackName](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/StackName.png)
 
3. Skip stack options and click **Next**.
 
![Section2 StackOptions](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/StackOptions.png)
 
4. Scroll down to the bottom of the stack creation page and acknowledge the IAM resources creation by selecting **all the check boxes**. Then launch the stack. It may take 1~2 minutes to complete Cloud9 deployment.
 
![Section2 StackOptions](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/IAM.png)
 
5. Click **cloud9-stack** and go to the **Outputs** section of the CloudFormation stack. Then, click **Cloud9URL** to set up your IDE environment.
 
![Section2 StackOptions](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/Cloud9.png)
 
{{% /expand%}}
 
### 1.2. Application Deployment using SAM(AWS Serverless Application Model).
 
1. In Cloud9, a git repo will be automatically cloned and go to a working directory called **integration** to execute **sam build**. The sam build command processes your AWS SAM template file, application code, and any applicable language-specific files and dependencies.
  
```
cd /home/ec2-user/environment/aws-well-architected-labs/static/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Code/integration
sam build
```
 
![Section2 SAMBuild](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/SAMBuild.png)
 
2. Deploy an AWS SAM application using **sam deploy --guided**.
```
sam deploy --guided
```
* Answer **y** to lambda authorization question. (**LambdaPutDynamoDB may not have authorization defined, Is this ok?**)
 
![Section2 SAMDeploy](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/SAMDeploy.png)
 
3. In Outputs, take a note of **APIGWUrl**.
 
![Section2 APIGWUrl](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/APIGWUrl.png)
 
4. Now you will update the AWS DynamoDB table with a sample mapping table in json file via API Gateway. This mapping table contains the association between the Well-Architected Question ID and AWS Trusted Advisor check ID.
 
* Replace **APIGWUrl** with your APIGWUrl that you copied from Outputs.
```
curl --header "Content-Type: application/json" -d @mappings/wa-mapping.json -v POST {APIGWUrl}
 
```
 
![Section2 MappingTable](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/MappingTable.png)
 
5. Confirm that **UnprocessedItems** appear to be empty, which means you successfully put items into AWS DynamoDB. 
![Section2 Confirm](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/Confirm.png)
 
6. In AWS DynamoDB console, click **wa-mapping** which you just deployed and click **Explore table items**. 
![Section2 Table](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/Table.png)
 
![Section2 Explore](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/Explore.png)
 
7. As per the screenshot below, you should be able to see 1 Question ID listed, together with 1 AWS Trusted Advisor check ID.
![Section2 Items](/watool/200_Integration_with_AWS_Compute_Optimizer_and_AWS_Trusted_Advisor/Images/section2/Items.png)

## Congratulations! 

You have now completed the first section of the Lab.

Click on **Next Step** to continue to the next section.

___
**END OF SECTION 1**
___
 
{{< prev_next_button link_prev_url="../1_prerequisites/" link_next_url="../3_create_workload/" />}}
 
