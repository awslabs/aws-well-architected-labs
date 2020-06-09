---
title: "Implement deep health checks"
menutitle: "Deep health checks"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

### 3.1 Re-enable the dependency service

For the next part of the lab restore access to the **getRecommendation** API on the **RecommendationService**

1. Return to the **AWS Systems Manager** > **Parameter Store** on the AWS Management Console
2. Set the value of **RecommendationServiceEnabled** back to **true** and **Save changes**
3. Confirm the web service is now returning "personalized" recommendations again

### 3.2 Inject fault on a single server {#change_role}

Previously you simulated a failure of the service dependency. Now you will simulate a failure on a single server (of the three servers running). You will simulate a fault on this server that prevents only it from calling the otherwise healthy service dependency.

1. Navigate to the [EC2 Instances console](https://console.aws.amazon.com/ec2/v2/home?LoadBalancers:&region=us-east-2#Instances:)
      * There should be three EC2 instances with **Instance State** _running_, one in each Availability Zone (they will have **Name** _WebApp1_)
      * Click the gear icon in the upper-right and select **IAM Instance Profile Name** (in addition to what is already selected)
1. Select only the EC2 instance in **Availability Zone** _us-east-2c_
1. Click **Action** > **Instance Settings** > **Attach/Replace IAM Role**
1. From **IAM role**, click **WebApp1-EC2-noDDB-Role-HealthCheckLab**

      ![ReplaceIAMRole](/Reliability/300_Health_Checks_and_Dependencies/Images/ReplaceIAMRole.png)

1. Click **Apply**
1. Click **Close**
1. This will return you to the EC2 Instances console. Observe under **IAM Instance Profile Name** (it is one of the displayed columns) which IAM roles each EC2 instance has attached

The IAM role attached to an EC2 instance determines what permissions it has to access AWS resources. You changed the role of the us-east-2c instance to one that is almost the same as the other two, except it does not have access to DynamoDB. Since DynamoDB is used to mock our service dependency, the us-east-2c server no longer has access to the service dependency (**RecommendationService**). Stale credentials is an actual fault that servers might experience. Your actions above simulate stale (invalid) credentials on the us-east-2c server.

### 3.4 Observe application behavior and determine how to fix it

* Observe the website behavior now
    * Refresh the website multiple times noting which Availability Zone the serving the request
    * The servers in us-east-2a and us-east-2b continue to function normally
    * The server in us-east-2c still succeeds, but it uses the static response. Why is this?
* The service dependency **RecommendationServiceEnabled** is still healthy
* It is the server in us-east-2c that is unhealthy - it has stale credentials
    * Return to the **Target Groups** and under the **Targets** tab observe the results of the ELB health checks
    * They are all **Status** _healthy_, and are therefore all receiving traffic. Why does the server in us-east-2c show _healthy_ for this check?
* The service would deliver a _better experience_ if it:
    * Identified the us-east-2c server as unhealthy and did not route traffic to it
    * Replaced this server with a healthy one

    |Well-Architected for Reliability: Best practices|
    |:---:|
    |**Make services stateless where possible**: Services should either not require state, or should offload state such that between different client requests, there is no dependence on locally stored data on disk or in memory. This enables servers to be replaced at will without causing an availability impact. Amazon ElastiCache or Amazon DynamoDB are good destinations for offloaded state.|
    |**Automate healing on all layers**: Upon detection of a failure, use automated capabilities to perform actions to remediate. _Ability to restart_ is an important tool to remediate failures. As discussed previously for distributed systems, a best practice is to make services stateless where possible. This prevents loss of data or availability on restart. In the cloud, you can (and generally should) replace the entire resource (for example, EC2 instance, or Lambda function) as part of the restart. The restart itself is a simple and reliable way to recover from failure. Many different types of failures occur in workloads. Failures can occur in hardware, software, communications, and operations. Rather than constructing novel mechanisms to trap, identify, and correct each of the different types of failures, map many different categories of failures to the same recovery strategy.  An instance might fail due to hardware failure, an operating system bug, memory leak, or other causes. Rather than building custom remediation for each situation, treat any of them as an instance failure. Terminate the instance, and allow AWS Auto Scaling to replace it. Later, carry out the analysis on the failed resource out of band.|

* From the **Target Groups** console click on the  the **Health checks** tab
    * The ELB health check is configured to return _healthy_ when it receives an http 200 response on the `/healthcheck` path
    * Since the healthcheck code simply always returns http 200, the _bad_ server still returns http 200 and is seen as _healthy_.

### 3.4 Create a deep healthcheck to identify bad servers

* Update server code to add a deep health check response
    * You will create and configure a new health check that will include a check on whether the server can access its dependency
    * This is a _deep health check_ -- it checks the actual function of the server including the ability to call service dependencies
* This will be implemented by updating the server code on the `/healthcheck` path

Choose _one_ of the options below (**Option 1 - Expert** or **Option 2 - Assisted**) to improve the code and add the deep health check.

#### 3.4.1 Option 1 - Expert option: make and deploy your changes to the code

You may choose this option, or skip to **Option 2 - Assisted option**

This option requires you have access to place a file in a location accessible via https/https via a URL. For example a public readable S3 bucket, [gist](https://gist.github.com) (use the **raw** option to get the URL), or your private webserver.

1. Start the existing server code that you added error handling to, or alternatively download the lab sample code from here: [server_errorhandling.py](/Reliability/300_Health_Checks_and_Dependencies/Code/Python/server_errorhandling.py)
1. Calls to `/healthcheck` should in turn make a test call to **RecommendationService**  using _User ID_ **0**
      * If the **RecommendationService** returns the string **test** for both _Result_ and _UserName_ then it is healthy
      * If it is healthy then return http code 200 (OK)
      * If it is not healthy then return http code 503 (Service Unavailable)
      * Also return the same EC2 meta-data that is returned on the call to the `/` path
1. Put your updated server code in a location where it can be downloaded via its URL using **wget**
1. In the AWS Console go the **HealthCheckLab** CloudFormation stack and **Update** it:
      * Leave **Use current template** selected and click **Next**
      * Find the **ServerCodeUrl** parameter and enter the URL for your new code
      * When stack **status** is _CREATE_COMPLETE_ (about four minutes) then continue

If you completed the **Option 1 - Expert option**, then skip the **Option 2 - Assisted option** section and continue with **3.4.3 Health check code**

#### 3.4.2 Option 2 - Assisted option: deploy workshop provided code

1. The new server code including error handling [can be viewed here](/Reliability/300_Health_Checks_and_Dependencies/Code/Python/server_healthcheck.py)
1. Search for `Healthcheck request` in the comments. What will this code do now if called on this health check URL?

##### Deploy the new health check code

1. Navigate to the AWS CloudFormation console
1. Click on the **HealthCheckLab** stack
1. Click **Update**
1. Leave **Use current template** selected and click **Next**
1. Find the **ServerCodeUrl** parameter and enter the following:

        https://aws-well-architected-labs-ohio.s3.us-east-2.amazonaws.com/Healthcheck/Code/server_healthcheck.py

1. Click **Next** until the last page
1. At the bottom of the page, select **I acknowledge that AWS CloudFormation might create IAM resources with custom names**
1. Click **Update stack**
1. Click on **Events**, and click the refresh icon to observe the stack progress
      * New EC2 instances running the error handling code are being deployed
      * When stack **status** is _CREATE_COMPLETE_ (about four minutes) then continue

#### 3.4.3 Health check code

This is the health check code from [server_healthcheck.py](/Reliability/300_Health_Checks_and_Dependencies/Code/Python/server_healthcheck.py). The **Option 2 - Assisted option** uses this code. If you used the **Option 1 - Expert option**, you can consult this code as a guide.

**Code**:
{{% expand "Click here to see the code:" %}}

```python
# Healthcheck request - will be used by the Elastic Load Balancer
elif self.path == '/healthcheck':

    is_healthy = False
    error_msg = ''
    TEST = 'test'

    # Make a request to RecommendationService using a predefined
    # test call as part of health assessment for this server
    try:
        # call RecommendationService using the test user
        user_id = str(0)
        response = call_getRecommendation(self.region, user_id)

        # Parses value of recommendation from DynamoDB JSON return value
        tv_show = response['Item']['Result']['S']
        user_name = response['Item']['UserName']['S']

        # Server is healthy of RecommendationService returned the expected response
        is_healthy = (tv_show == TEST) and (user_name == TEST)

    # If the service dependency fails, capture diagnostic info
    except Exception as e:
        error_msg += str(traceback.format_exception_only(e.__class__, e))

    # Based on the health assessment
    # If it succeeded return a healthy code
    # If it failed return a server failure code
    message = ""
    if (is_healthy):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

        message += "<h1>Success</h1>"

        # Add metadata
        message += get_metadata()

    else:
        self.send_response(503)
        self.send_header('Content-type', 'text/html')
        self.end_headers()

        message += "<h1>Fail</h1>"
        message += "<h3>Error message:</h3>"
        message += error_msg

        # Add metadata
        message += get_metadata()

    self.wfile.write(
        bytes(
            html.format(Title="healthcheck", Content=message),
            "utf-8"
        )
    )
```
{{% /expand %}}

</details>

#### 3.4.4 Verify Elastic Load Balancer (ELB) is configured to use the new deep health check

1. From the **Target Groups** console click on the the **Health checks** tab
1. For **Path** verify the value is `/healthcheck`
1. Click the **Targets** tab so you can monitor health check status

#### 3.4.5 Observe behavior of web service with added deep health check

* Continue the lab after the **HealthCheckLab** CloudFormation stack is complete.

The CloudFormation stack update reset the EC2 instance IAM roles, so the system is back to its original no-fault state. You will re-introduce the single-server fault and observe the new behavior.

1. Refresh the web service multiple times and note all three servers are functioning without error
1. Copy the URL of the web service to a new tab and append `/healthcheck` to the end of the URL
      * The new URL should look like:

            http://healt-alb1l-<...>.elb.amazonaws.com/healthcheck

      * Refresh several times and observe the health check on the three servers
      * Note the check is successful - the check now includes a call to the **RecommendationService** (the DynamoDB table)
      * Go to the **Target Groups** console click on the **Targets** tab and note the health status as per the ELB health checks.
1. To re-introduce the stale credentials fault, again change the IAM role for the EC2 instance in us-east-2c to **WebApp1-EC2-noDDB-Role-HealthCheckLab**
      * See [3.2 Inject fault on one of the servers](#change_role) if you need a reminder of how to do this.
1. Go to the **Target Groups** console click on the **Targets** tab and note the health status as per the ELB health checks (remember to refresh)
      * Note that the server in us-east-2c is now failing the health check with a http code 503 Service Not Available
          * With an **Interval** of _15_ seconds, and a **Healthy threshold** of _2_, it can take up to 30 seconds to see the status update.
      * The ELB has identified the us-east-2c server as unhealthy and will not route traffic to it
      * This is known as _fail-closed_ behavior

          ![OneUnhealthy503](/Reliability/300_Health_Checks_and_Dependencies/Images/OneUnhealthy503.png)

1. Refresh the web service multiple times and note it is however still functioning without error
      * And unlike before it is no longer returning a static response - it only returns personalized recommendations
      * Note that only the servers in us-east-2a and us-east-2b are serving requests

    |Well-Architected for Reliability: Best practices|
    |:--:|
    |**Monitor all components of the workload to detect failures**: Continuously monitor the health of your workload so that you and your automated systems are aware of degradation or complete failure as soon as they occur.|
    |**Failover to healthy resources**: Ensure that if a resource failure occurs, that healthy resources can continue to serve requests.|

    |Well-Architected for Reliability: Health Checks|
    |:---:|
    |The load balancer will only route traffic to healthy application instances. The health check needs to be at the data plane/application layer indicating the capability of the application on the instance. This check should not be against the control plane. A health check URL for the web application will be present and configured for use by the load balancer|

##### Repair the server

1. Navigate to the EC2 Instances console and select only the instance in us-east-2c
1. Click **Action** > **Instance State** > **Terminate**
1. Click **Yes, Terminate**
      * The EC2 instance will shut down
      * Amazon EC2 Auto Scaling will recognize there are less then the three Desired Capacity and will start up a new EC2 instance
      * The new instance replaces the one with the stale credentials fault, and loads fresh credentials
1. From the **Target Groups** console **Targets** tab note the health check status of the new server in us-east-2c
      * The new instance in us-east-2c will first show **Description** _Target registration is in progress_
      * Then **Description** is _This target is currently passing target group's health checks_, then you may continue the workshop
      * (The **Description** may show _Health checks failed with these codes: [502]_, before getting to a healthy state. This is expected as the server initializes)
      * From the time you terminate the EC2 instance, it will take four to five minutes to get the new EC2 instance up and in a healthy state
1. Refresh the web service multiple times and note that personalized recommendations are once again being served from all three servers
