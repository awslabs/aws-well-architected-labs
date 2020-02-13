# Level 300: Implementing Health Checks and Managing Dependencies to Improve Reliability

## Author

* Seth Eliot, Reliability Lead, Well-Architected, AWS

## Amazon Builders' Library

* This lab follows best practices as described in the Amazon Builders' Library article: [Implementing health checks](https://aws.amazon.com/builders-library/implementing-health-checks/) and in the [Well-Architected](https://aws.amazon.com/architecture/well-architected/) Reliability pillar.

## Table of Contents

1. [Deploy the Application](#deploy_app)
1. [Handle Failure of Service Dependencies](#handle_dependency)
1. [Implement Deep Health Check](#deep_healthcheck)
1. [Fail Open when Appropriate](#fail_open)
1. [Tear down this lab](#tear_down)

## 1. Deploy the Application <a name="deploy_app"></a>

You will create a multi-tier architecture using AWS and run a simple service on it. The service is a web server running on Amazon EC2 fronted by an Elastic Load Balancer reverse-proxy, with a dependency on Amazon DynamoDB.

**Note**: The concepts covered by this lab apply whether your service dependency is an AWS resource like Amazon DynamoDB, or another service called via API. The DynamoDB dependency therefore acts as a _mock_ for the **RecommendationService** (**getRecommendation** API) dependency that is used in this lab.

![ThreeTierArchitecture](Images/InsertImageHere.png)

### 1.1 Log into the AWS console <a name="awslogin"></a>

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

* Follow the instructions [here for accessing your AWS account](../../common/documentation/Workshop_AWS_Account.md)

@TODO: if we do not need credentials, remove the following

* **Note**: As part of these instructions you are directed to copy and save **AWS credentials** for your account. Please do so as you will need them later

**If you are using your own AWS account**:

* Sign in to the AWS Management Console as an IAM user who has PowerUserAccess or AdministratorAccess permissions, to ensure successful execution of this lab.
* You will need the AWS credentials, `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`, of this IAM user for later use in this lab.
    * If you do not have this IAM user's credentials or you wish to create a new IAM user with needed permissions, follow the [instructions here to create them](Documentation/Self_AWS_Account.md)

### 1.2 Deploy the application using an AWS CloudFormation template

You will the service infrastructure including simple service code and some sample data.

@TODO: update raw github links to master branch after merge

1. It is recommended that you use the **Ohio** region.  This region is also known as **us-east-2**, which you will see referenced throughout this lab.
![SelectOhio](Images/SelectOhio.png)
      * If you choose to use a different region, you will need to ensure future steps are consistent with your region choice.

#### 1.2.1 Deploy the VPC infrastructure

* If you are comfortable deploying a CloudFormation stack, then use the **express steps** listed immediately below.
* If you need additional guidance in how to deploy a CloudFormation stack, then follow the directions for the [Automated Deployment of VPC](../../Security/200_Automated_Deployment_of_VPC/Lab_Guide.md) lab, and then return here for the next step: **1.2 Deploy the WebApp infrastructure and service**

##### Express Steps (Deploy the VPC infrastructure)

1. Download the [_vpc-alb-app-db.yaml_](https://raw.githubusercontent.com/awslabs/aws-well-architected-labs/master/Security/200_Automated_Deployment_of_VPC/Code/vpc-alb-app-db.yaml) CloudFormation template
1. Create a CloudFormation stack uploading this CloudFormation Template
1. For **Stack name** use **`WebApp1-VPC`** (case sensitive)
1. Leave all  CloudFormation Parameters at their default values
1. Click **Next** until the last page
1. At the bottom of the page, select **I acknowledge that AWS CloudFormation might create IAM resources with custom names**
1. Click **Create stack**

#### 1.2.2 Deploy the WebApp infrastructure and service

Wait until the VPC CloudFormation stack **status** is _CREATE_COMPLETE_, then continue.

* If you are comfortable deploying a CloudFormation stack, then use the **express steps** listed immediately below.
* If you need additional guidance in how to deploy a CloudFormation stack, then follow the directions for the [Create an AWS CloudFormation Stack from a template](../Documentation/CFNCreateStack.md) lab, and then return here for the next step: **1.3 XXXXXXXXXX**

##### Express Steps (Deploy the WebApp infrastructure and service)

1. Download the [_staticwebapp.yaml_](https://raw.githubusercontent.com/awslabs/aws-well-architected-labs/healthchecklab/Reliability/300_Health_Checks_and_Dependencies/Code/CloudFormation/staticwebapp.yaml) CloudFormation template
1. Create a CloudFormation stack uploading this CloudFormation Template
1. For **Stack name** use **`HealthCheckLab`**
1. Leave all  CloudFormation Parameters at their default values
1. Click **Next** until the last page
1. At the bottom of the page, select **I acknowledge that AWS CloudFormation might create IAM resources with custom names**
1. Click **Create stack**

### 1.3 View website for test web service <a name="website"></a>

1. Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation>.
      * Wait until **HealthCheckLab** stack **status** is _CREATE_COMPLETE_ before proceeding. This should take about four minutes
      * Click on the **HealthCheckLab** stack
      * Click on the "Outputs" tab
      * For the Key **WebsiteURL** copy the value.  This is the URL of your test web service.
          * _Hint_: it will end in _`<aws region>.elb.amazonaws.com`_

1. Click the URL and it will bring up the website:  
      ![DemoWebsite](Images/DemoWebsite.png)

1. The website simulates a recommendation engine making personalized suggestions for classic television shows. PlYou should note:
      * Area A shows the personalized recommendation
          * It shows first name of the user and the show that was recommended
          * The workshop simulation is simple. On every request it chooses a user at random, and shows a recommendation statically mapped to that user. The user names, show names, and this mapping are in a DynamoDB table, which is simulating the **RecommendationService**
      * Area B shows metadata which is useful to you during the lab
          * The **instance_id** and **availability_zone** enable you to see which EC2 server and Availability Zone were used for each request
          * There is one EC2 instance deployed per Availability Zone
          * Refresh the website several times, note that the EC2 instance and Availability Zone change from among the three available
          * This is Elastic Load Balancing (ELB) distributing these stateless requests among the available EC2 server instances across Availability Zones

    |Well-Architected for Reliability: Elastic Load Balancing (ELB)|
    |:---:|
    |Provides load balancing across Availability Zones, performs Layer 7 routing, integrates with AWS WAF, and integrates with Auto Scaling to help create a self-healing infrastructure and absorb increases in traffic while releasing resources when traffic decreases.|

    |Well-Architected for Reliability: Best practices|
    |:--:|
    |**Implement loosely coupled dependencies**: Dependencies such as queuing systems, streaming systems, workflows, and load balancers are loosely coupled|
    |**Deploy the workload to multiple locations**: Distribute workload load across multiple Availability Zones and AWS Regions. These locations can be as diverse as needed.|

## 2. Handle Failure of Service Dependencies <a name="handle_dependency"></a>

### 2.1 System initially healthy

1. You already observed that all three EC2 instances are serving requests
1. In a new tab navigate to ELB Target Groups console
      * By [clicking here to open the AWS Management Console](http://console.aws.amazon.com/ec2/v2/home?region=us-east-2#TargetGroups:)
      * _or_ navigating through the AWS Management Console: **Services** > **EC2** > **Load Balancing** > **Target Groups**
      * Leave this tab open as you will be referring back to it multiple times
1. Click on the **Targets** tab (bottom half of screen)
1. Under **Registered Targets** observe the three EC2 instances serving your Web App
1. Note that they are all _healthy_ (see **Status** and **Description**)
      * In this state the ELB will route traffic to any of the three servers

    ![TargetGroupAllHealthy](Images/TargetGroupAllHealthy.png)

### 2.2 Dependency not available - All servers fail

#### 2.2.1 Disable RecommendationService

You will now simulate a complete failure of the **RecommendationService**. Every request in turn makes a (simulated) call to the **getRecommendation** API on this service. These will all fail for every request on every server.

1. In a new tab, navigate to the Parameter Store on the AWS Systems Manager console
      * By [clicking here to open the AWS Management Console](https://console.aws.amazon.com/systems-manager/parameters)
      * _or_ navigating through the AWS Management Console: **Services** > **Systems Manager** > **Parameter Store**
      * Leave this tab open as you will be referring back to it one additional time
1. Click on **RecommendationServiceEnabled**
1. Click **Edit**
1. In the **Value** box, type **false**
1. Click **Save Changes**
      * A status message should say _Edit parameter request succeeded_

The **RecommendationServiceEnabled** parameter is used only for this lab. The server code reads its value, and simulates a failure in **RecommendationService** (fails to read the DynamoDB table simulating the service) when it is **false**.

#### 2.2.2 Observe behavior when dependency not available

1. Refresh the test web service multiple times
      * Note that it fails with _502 Bad Gateway_
      * For each request one of the servers receiving the request attempts to call the **RecommendationService** but catastrophically fails and fails to return a reply (empty reply) to the load balancer, which interprets it as a http 502 failure.
      * You can observe this by opening a new tab and navigating to ELB Load Balancers console:
          * By [clicking here to open the AWS Management Console](http://console.aws.amazon.com/ec2/v2/home?region=us-east-2#LoadBalancers:)
          * _or_ navigating through the AWS Management Console: **Services** > **EC2** > **Load Balancing** > **Load Balancers**
1. Click on the **Monitoring** tab (bottom half of screen)
1. Observe that ELB 5XXs (Count) errors corresponds to the same HTTP 502s (Count) errors

      ![AllUnhealthy502](Images/AllUnhealthy502.png)

1. Return to the tab with the ELB Target Groups console.  Note that all instances are _unhealthy_ with **Description** _Health checks failed with these codes: \[502\]_
1. From here click on the **Health checks** tab.  The health check returns _healthy_ when it received a http 200 response on the same port and path as our browser requests.

### 2.3 Update server code to handle dependency not available

The **getRecommendation** API is actually a `get_item` call on a DynamoDB table. Examine the server code to see how errors are currently handled

1. The server code running on each EC2 instance [can be viewed here](https://github.com/awslabs/aws-well-architected-labs/blob/healthchecklab/Reliability/300_Health_Checks_and_Dependencies/Code/Python/server_basic.py) (@TODO update to master branch)
1. Search for `get_item`. What happens if this call fails?
1. Choose _one_ of the options below (**Option 1 - Expert** or **Option 2 - Assisted**) to improve the code and handle the failure

#### 2.3.1 Option 1 - Expert option: make and deploy your changes to the code

@TODO instructions on how to update and deploy the code to a http/https readable location

If you completed the **Expert option**, then skip the **Assisted option** section

#### 2.3.2 Option 2 - Assisted option: deploy workshop provided code

1. The new server code including error handling [can be viewed here](https://github.com/awslabs/aws-well-architected-labs/blob/healthchecklab/Reliability/300_Health_Checks_and_Dependencies/Code/Python/server_errorhandling.py) (@TODO update to master branch)
1. Search for `Error handling` in the comments (occurs twice). What will this code do now if the dependency call fails?

##### Deploy the new code

1. Navigate to the AWS CloudFormation console
1. Click on the **HealthCheckLab** stack
1. Click **Update**
1. Leave **Use current template** selected and click **Next**
1. Find the **ServerCodeUrl** parameter and enter the following:

        https://aws-well-architected-labs-ohio.s3.us-east-2.amazonaws.com/Healthcheck/Code/server_errorhandling.py

1. Click **Next** until the last page
1. At the bottom of the page, select **I acknowledge that AWS CloudFormation might create IAM resources with custom names**
1. Click **Update stack**
1. Click on **Events**, and click the refresh icon to observe the stack progress
      * New EC2 instances running the error handling code are being deployed
      * When stack **status** is _CREATE_COMPLETE_ (about four minutes) then continue

@TODO consider server_errorhandling.py link to read from raw github instead of S3

#### 2.3.3 Error handling code

This is the error handling code from [_server_errorhandling.py_](https://github.com/awslabs/aws-well-architected-labs/blob/healthchecklab/Reliability/300_Health_Checks_and_Dependencies/Code/Python/server_errorhandling.py). The **Assisted option** uses this code. If you used the **Expert option**, you can consult this code as a guide.

<details>
<summary>Click here to see code</summary>

      # Error handling:
      # surround the get_item call in a try catch

      try:
          # Call the recommendation service 
          response = ddb_client.get_item(
              TableName=table_name,
              Key={
                  'ServiceAPI': {
                      'S': 'getRecommendation',
                  },
                  'UserID': {
                      'N': userId,
                  }
              }
          )

          # Parses value of recommendation from DynamoDB JSON return value
          # {'Item': {
          #     'ServiceAPI': {'S': 'getRecommendation'}, 
          #     'UserID': {'N': '1'}, 
          #     'Result': {'S': 'M*A*S*H'},  ...
          tv_show = response['Item']['Result']['S']
          user_name = response['Item']['UserName']['S']
          message += recommendation_message (user_name, tv_show, True)

      # Error handling:
      # If the service dependency fails, and we cannot make a personalized recommendation
      # then give a pre-selected (static) recommendation
      except Exception as e:
          message += recommendation_message ('Valued Customer', 'I Love Lucy', False)
          message += '<br><br><br><h2>Diagnostic Info:</h2>'
          message += '<br>We are unable to provide personalized recommendations'
          message += '<br>If this persists, please report the following info to us:'
          message += str(traceback.format_exception_only(e.__class__, e))
</details>

#### 2.3.4 Observe how web service now behaves with error handling

1. After new code has successfully deployed, refresh the test web service multiple times. Observe:
      * It works. It no longer returns an error
      * All three EC2 instances and Availability Zones are being used
      * A default recommendation for **Valued Customer** is displayed instead of a user personalized one
      * There is now **Diagnostic Info**. What does it mean?
      * Check health status on the ELB Target Groups console. What do those health checks now show?
1. Refer back to the newly deployed code to understand why the website behaves this way now

The Website is working again, but in a degraded capacity, no longer serving personalized recommendations. While this is less then ideal, it is much better than when it was failing with http 502 errors. The **RecommendationService** is not available, so the app instead returns a _static response_ (the default recommendation).

|Well-Architected for Reliability: Best practice|
|:--:|
|**Implement graceful degradation to transform applicable hard dependencies into soft dependencies**: When a component's dependencies are unhealthy, the component itself does not report as unhealthy. It can continue to serve requests in a degraded manner.|

## 3. Implement Deep Health Check <a name="deep_healthcheck"></a>

### 3.1 Re-enable the dependency service

For the next part of the lab restore access to the **getRecommendation** API on the **RecommendationService**

1. Return to the **AWS Systems Manager** > **Parameter Store** on the AWS Management Console
2. Set the value of **RecommendationServiceEnabled** back to **true** and **Save changes**
3. Confirm the web service is now returning "personalized" recommendations again

### 3.2 Inject fault on one of the servers

Previously you simulated a failure of the service dependency. Now you will simulate a failure on a single server (of the three servers running). You will simulate a fault on this server that prevents only it from calling the otherwise healthy service dependency.

1. Navigate to the [EC2 Instances console](https://console.aws.amazon.com/ec2/v2/home?LoadBalancers:&region=us-east-2#Instances:)
      * There should be three EC2 instances with **Instance State** _running_, one in each Availability Zone (they will have **Name** _WebApp1_)
      * Click the gear icon in the upper-right and select **IAM Instance Profile Name** (in addition to what is already selected)
1. Select only the EC2 instance in **Availability Zone** _us-east-2c_
1. Click **Action** > **Instance Settings** > **Attach/Replace IAM Role**
1. From **IAM role**, click the role starting with **WebApp1-EC2-noDDB-Role**. Make sure you select the one including **noDDB**  
1. Click **Apply**
1. This will return you to the EC2 Instances console. Observe under **IAM Instance Profile Name** which IAM roles each EC2 instance has attached

The IAM role attached to an EC2 instance determines what authorizations it has to access AWS resources. You changed the role of the us-east-2c instance to one that is almost the same as the other two, except it does not have access to DynamoDB. Recall that DynamoDB is used to mock our service dependency, therefore the us-east-2c server no longer has access to the service dependency. Stale credentials is an actual fault that servers might experience. Your actions above simulate stale (invalid) credentials on the us-east-2c server.

### 3.4 Observe application behavior and determine how to fix it

* Observe the website behavior now
      * Refresh the website multiple times noting which Availability Zone the serving the request
      * The servers in us-east-2a and us-east-2b continue to function normally
      * The server in us-east-2c still succeeds, but it uses the static response. Why is this?
* The service dependency (**RecommendationServiceEnabled**) is still healthy
* It is the server in us-east-2c that is unhealthy - it has stale credentials
      * Return to the **Target Groups** and under the **Targets** tab observe the results of the ELB health checks
      * They are all **Status** _healthy_, and are therefore all receiving traffic
* The service would deliver a better experience if it:
      * Identified the us-east-2c server as unhealthy and did not route traffic to it
      * Replaced this server with a healthy one

    |Well-Architected for Reliability: Recovery-Oriented Computing (ROC)|
    |:---:|
    |In systems that apply a recovery-oriented approach, many different categories of failures are mapped to the same recovery strategy.  An instance may fail due to hardware failure, operating system bug, memory leak, or other causes. Rather than building custom remediation for each, treat any as an instance failure, terminate the instance, and replace the instance.|

* From the **Target Groups** console click on the  the **Health checks** tab
      * The ELB healthheck returns _healthy_ when it received a http 200 response on the same port and path as our browser requests
      * Since the server code handles the dependency access error, the server returns http 200 (with its default static response)

### 3.4 Create a deep healthcheck to identify bad servers

* Update server code to add a deep health check response
      * You will create and configure a new health check that will include a check on whether the server can access its dependency
      * This is a _deep health check_ -- it checks the actual function of the server including the ability to call service dependencies
* This will be implemented in two steps:
      1. Update the server code
      1. Reconfigure Elastic Load Balancer (ELB) to use the new deep health check 

Choose _one_ of the options below (**Option 1 - Expert** or **Option 2 - Assisted**) to improve the code and add the deep health check.  Then continue to the next step [Reconfigure Elastic Load Balancer (ELB)](#reconfigure_elb).

#### 3.4.1 Option 1 - Expert option: make and deploy your changes to the code

@TODO instructions on how to update and deploy the code to a http/https readable location

If you completed the **Expert option**, then skip the **Assisted option** section

#### 3.4.2 Option 2 - Assisted option: deploy workshop provided code

1. The new server code including error handling [can be viewed here](https://github.com/awslabs/aws-well-architected-labs/blob/healthchecklab/Reliability/300_Health_Checks_and_Dependencies/Code/Python/server_healthcheck.py) (@TODO update to master branch)
1. Search for `Error handling` in the comments (occurs twice). What will this code do now if the dependency call fails?

##### Deploy the new code

1. Navigate to the AWS CloudFormation console
1. Click on the **HealthCheckLab** stack
1. Click **Update**
1. Leave **Use current template** selected and click **Next**
1. Find the **ServerCodeUrl** parameter and enter the following:

        https://aws-well-architected-labs-ohio.s3.us-east-2.amazonaws.com/Healthcheck/Code/server_errorhandling.py

1. Click **Next** until the last page
1. At the bottom of the page, select **I acknowledge that AWS CloudFormation might create IAM resources with custom names**
1. Click **Update stack**
1. Click on **Events**, and click the refresh icon to observe the stack progress
      * New EC2 instances running the error handling code are being deployed
      * When stack **status** is _CREATE_COMPLETE_ (about four minutes) then continue

@TODO consider server_errorhandling.py link to read from raw github instead of S3

#### 2.3.3 Error handling code

This is the error handling code from [_server_errorhandling.py_](https://github.com/awslabs/aws-well-architected-labs/blob/healthchecklab/Reliability/300_Health_Checks_and_Dependencies/Code/Python/server_errorhandling.py). The **Assisted option** uses this code. If you used the **Expert option**, you can consult this code as a guide.

<details>
<summary>Click here to see code</summary>

#### 3.4.1 Reconfigure Elastic Load Balancer (ELB) to use the new deep health check <a name="reconfigure_elb"></a>


|Well-Architected for Reliability: Best practice|
|:--:|
|**Automate healing on all layers**: Use automated capabilities upon detection of failure to perform an action to remediate.|
|**Monitor all layers of the workload to detect failures**: Continuously monitor the health of your system and report degradation as well as complete failure.|

## 4. Fail Open when Appropriate<a name="fail_open"></a>

## 5. Tear down this lab <a name="tear_down"></a>

**If you are attending an in-person workshop and were provided with an AWS account by the instructor**:

* There is no need to tear down the lab. Feel free to continue exploring. Log out of your AWS account when done.

**If you are using your own AWS account**:

* You may leave these resources deployed for as long as you want. When you are ready to delete these resources, see the following instructions

### Remove manually provisioned resources

Some resources were created by the failure simulation scripts. You need to remove these first

@TODO

### Remove AWS CloudFormation provisioned resources

@TODO First stack, then VPC, then Flow Logs Log Group

#### How to delete an AWS CloudFormation stack

1. Go to the AWS CloudFormation console: <https://console.aws.amazon.com/cloudformation>
1. Select the CloudFormation stack to delete and click **Delete**

    ![DeletingWebServers](Images/DeletingWebServers.png)

1. In the confirmation dialog, click **Delete stack**
1. The _Status_ changes to **DELETE_IN_PROGRESS**
1. Click the refresh button to update and status will ultimately progress to **DELETE_COMPLETE**
1. When complete, the stack will no longer be displayed. To see deleted stacks use the drop down next to the Filter text box.

    ![ShowDeletedStacks](Images/ShowDeletedStacks.png)

1. To see progress during stack deletion
      * Click the stack name
      * Select the Events column
      * Refresh to see new events

### Delete workshop CloudFormation stacks

* Since AWS resources deployed by AWS CloudFormation stacks may have dependencies on the stacks that were created before, then deletion must occur in the opposite order they were created
* Stacks with the same ordinal can be deleted at the same time. _All_ stacks for a given ordinal must be **DELETE_COMPLETE** before moving on to the next ordinal


---

## References & useful resources

* [Patterns for Resilient Architecture — Part 3](https://medium.com/@adhorn/patterns-for-resilient-architecture-part-3-16e8601c488e)
* Amazon Builders' Library: [Implementing health checks](https://aws.amazon.com/builders-library/implementing-health-checks/)
* [Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) (see the Reliability pillar)
* [Well-Architected best practices for reliability](https://wa.aws.amazon.com/wat.pillar.reliability.en.html)
* @TODO more
---

## License

### Documentation License

Licensed under the [Creative Commons Share Alike 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license.

### Code License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

<https://aws.amazon.com/apache2.0/>

or in the ["license" file](../../LICENSE-Apache) accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
