---
title: "Deploy The Blue Car Application"
date: 2021-05-31T11:16:08-04:00
chapter: false
pre: "<b>1. </b>"
weight: 1
---

You will start by deploying the example application which allows a customer to order medical assistance based on selecting a map location. The application consists of a public AWS API gateway which connects to a serverless application layer [AWS Lambda](https://aws.amazon.com/lambda/), which uses [Amazon DynamoDB](https://aws.amazon.com/dynamodb/) . 

You will also deploy [AWS Amplify](https://aws.amazon.com/amplify/) to host the static website with CI/CD build-in and [Amazon Cognito](https://aws.amazon.com/cognito/) to manage users.

Our deployed architecture should reflect the following diagram:

![Section1 Base Architecture](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-blue-car-architecture.png)


Note the following:

1. AWS Amplify hosts static web resources including HTML, CSS, JavaScript, and image files which are loaded in the user's browser.

2. Amazon Cognito provides user management and authentication functions to secure the backend API.

3. Amazon DynamoDB provides a persistence layer where data can be stored by the API's Lambda function.

4. JavaScript executed in the browser sends and receives data from a public backend API built using Lambda and API Gateway.


To deploy the template for the base infrastructure complete the following steps:

### 1.1. Application Deployment using Cloud9 as the IDE.

For our application deployment, we will use [AWS Cloud9](https://aws.amazon.com/cloud9/) as our IDE, where our prebuilt script will be automatically cloned.

You can get the CloudFormation template [here.](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Code/templates/section1/section1-oncall-health-sample-app.yaml "Section1 template")


#### Console:

If you need detailed instructions on how to deploy CloudFormation stacks from within the console, please follow this [guide.](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-create-stack.html)

1. Sign in to the **AWS Management Console** and open the CloudFormation console at [https://console.aws.amazon.com/cloudformation](https://console.aws.amazon.com/cloudformation/).

![Section1 Select Region](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-cf-console.png)

2. Select the stack template which you downloaded earlier, and create a stack:

![Section1 Create Stack](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-create-stack.png)

3. For the stack name use **cloud9-stack** and click the **Next** button.
![Section1 Specify Details](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-specify-details.png)

4. Click **Next** button.
![Section1 Stack Option](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-stack-option.png)

5. Scroll down to the bottom of the stack creation page and acknowledge the IAM resources creation by **selecting all the check boxes**. Then launch the stack. It may take 4-5 minutes to complete this deployment.
![Section1 IAM Capabilities](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-IAM-Capabilities.png)

6. Click **cloud9-stack** and go to the **Outputs** section of the CloudFormation stack. Then, click **Cloud9URL** to set up your IDE environment.
![Section1 Output](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-output.png)


### 1.2. Deploy The Blue Car Application.

1. Launch Cloud9 from the AWS Console. The repository where all of the CloudFormation templates are stored will be automatically cloned. Go to **aws-well-architected-labs/static/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Code/oncall-health-sample-app** directory path and run **bash build_script.sh**. It may take 9-10 minutes to complete this deployment.

```
cd aws-well-architected-labs/static/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Code/oncall-health-sample-app
bash build_script.sh
```

![Section1 Cloud9](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-cloud9.png)

2. In the CloudFormation console, you will see a new stack called **oncall-health-amplify**. Click **oncall-health-amplify** and go to the **Outputs** section of the CloudFormation stack. Then, click **AppURL** to access the application.

![Section1 Oncall Health Amplify](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-oncall-health-amplify.png)

3. You should see the Blue Car application landing page as show below, then click **START HERE**.

![Section1 Application Ready](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-application-ready.png)

4. Click **Create account** to create a new user.

![Section1 Create Account](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-create-account.png)

5. Provide a Username, Password, Email, and Phone number, then click **CREATE ACCOUNT**

![Section1 User Information](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-user-information.png)

6. Retrieve the **Confirmation code** from your email which you entered previously and click **CONFIRM**

![Section1 Confirm](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-confirm.png)

7. You should now be able to log into Blue Car Application.

![Section1 Logged In](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-logged-in.png)

8. The application will default to a map of Melbourne as shown.

![Section1 Map](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-map.png)

9. Click a location on the map and click the **Set Pickup** button to request a blue ambulance car.

![Section1 Call Blue Car](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section1/section1-call-blue-car.png)

___
**END OF SECTION 1**
___
