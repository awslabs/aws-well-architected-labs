---
title: "Handle failure of service dependencies"
menutitle: "Dependency failure"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

### 2.1 System dependency initially healthy

1. You already observed that all three EC2 instances are successfully serving requests
1. In a new tab navigate to ELB Target Groups console
      * By [clicking here to open the AWS Management Console](http://console.aws.amazon.com/ec2/v2/home?region=us-east-2#TargetGroups:)
      * _or_ navigating through the AWS Management Console: **Services** > **EC2** > **Load Balancing** > **Target Groups**
      * Leave this tab open as you will be referring back to it multiple times
1. Click on the **Targets** tab (bottom half of screen)
1. Under **Registered Targets** observe the three EC2 instances serving your web service
1. Note that they are all _healthy_ (see **Status** and **Description**)
      * In this state the ELB will route traffic to any of the three servers

    ![TargetGroupAllHealthy](/Reliability/300_Health_Checks_and_Dependencies/Images/TargetGroupAllHealthy.png)

1. From the **Target Groups** console, now click on the the **Health checks** tab
      * Note here that the **Path** is configured to `/healthcheck`
1. Copy the URL of the web service to a new tab and append `/healthcheck` to the end of the URL
      * The new URL should look like:

            http://healt-alb1l-<...>.elb.amazonaws.com/healthcheck

      * Refresh several times and observe the health check on the three servers
      * Note the check is successful

1. The EC2 servers receive user requests (for a TV show recommendation) on the path `/` and they receive health check requests from the Elastic Load Balancer on the path `/healthcheck`
      * The health check always returns an http 200 code for any request to it.
      * The server code running on each EC2 instance [can be viewed here](/Reliability/300_Health_Checks_and_Dependencies/Code/Python/server_basic.py), or you can view the health check code excerpt below:

<details>
<summary>Click here to see the health check code excerpt</summary>

```python
# Healthcheck request - will be used by the Elastic Load Balancer
elif self.path == '/healthcheck':

      # Return a healthy code
      self.send_response(200)
      self.send_header('Content-type', 'text/html')
      self.end_headers()
```

</details>

### 2.2 Simulate dependency not available

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

The **RecommendationServiceEnabled** parameter is used only for this lab. The server code reads its value, and simulates a failure in **RecommendationService** (all reads to the DynamoDB table simulating the service will fail) when it is **false**.

#### 2.2.2 Observe behavior when dependency not available

1. Refresh the test web service multiple times
      * Note that it fails with _502 Bad Gateway_
      * For each request one of the servers receiving the request attempts to call the **RecommendationService** but catastrophically fails and fails to return a reply (empty reply) to the load balancer, which in turn presents this as a http 502 failure.
1. You can observe this by opening a new tab and navigating to ELB Load Balancers console:
      * By [clicking here to open the AWS Management Console](http://console.aws.amazon.com/ec2/v2/home?region=us-east-2#LoadBalancers:)
      * _or_ navigating through the AWS Management Console: **Services** > **EC2** > **Load Balancing** > **Load Balancers**
1. Click on the **Monitoring** tab (bottom half of screen)
      * Observe the **ELB 5XXs (Count)** and **HTTP 502s (Count)** errors for the load balancer
      * It will take a minute for the metrics to show up.  Make sure you refresh the web service page multiple times in your browser
      * These are the error codes the _load balancer_ returns on every request during this simulated outage

      ![502LoadBalancerMetrics](/Reliability/300_Health_Checks_and_Dependencies/Images/502LoadBalancerMetrics.png)

1. Compare these metrics to those for the target group (the EC2 servers themselves)
      * Return to the **Target Groups** console and click the **Monitoring** tab there
      * Observe **HTTP 5XXs ( Count )** errors shows no data
      * The servers themselves are _not_ returning actual http error codes, they are failing to return any data at all

      ![502TargetGroupMetrics](/Reliability/300_Health_Checks_and_Dependencies/Images/502TargetGroupMetrics.png)

      * We need to update the server code to handle when the dependency is not available

### 2.3 Update server code to handle dependency not available

The **getRecommendation** API is actually a `get_item` call on a DynamoDB table. Examine the server code to see how errors are currently handled

1. The server code running on each EC2 instance [can be viewed here](/Reliability/300_Health_Checks_and_Dependencies/Code/Python/server_basic.py)
1. Search for the call to the **RecommendationService**. It looks like this:

        response = call_getRecommendation(self.region, user_id)

    * What happens if this call fails?
1. Choose _one_ of the options below (**Option 1 - Expert** or **Option 2 - Assisted**) to improve the code and handle the failure

#### 2.3.1 Option 1 - Expert option: make and deploy your changes to the code

You may choose this option, or skip to **Option 2 - Assisted option**

This option requires you have access to place a file in a location accessible via https/https via a URL. For example a public readable S3 bucket, [gist](https://gist.github.com) (use the **raw** option to get the URL), or your private webserver.

1. Download the existing server code from here: [server_basic.py](/Reliability/300_Health_Checks_and_Dependencies/Code/Python/server_basic.py)
1. Modify the code to handle the call to the **RecommendationService**
1. When the call to **RecommendationService** fails then instead of using the response data you requested and did not get, return a static response:
      * Instead of user first name return **Valued Customer**
      * Instead of a personalized recommended TV show, return **I Love Lucy**
      * Try to also return some diagnostic information on the cause of the error
1. Put your updated server code in a location where it can be downloaded via its URL using **wget**
1. In the AWS Console go the **HealthCheckLab** CloudFormation stack and **Update** it:
      * Leave **Use current template** selected and click **Next**
      * Find the **ServerCodeUrl** parameter and enter the URL for your new code
      * When stack **status** is _CREATE_COMPLETE_ (about four minutes) then continue

If you completed the **Option 1 - Expert option**, then skip the **Option 2 - Assisted option** section and continue with **2.3.3 Error handling code**

#### 2.3.2 Option 2 - Assisted option: deploy workshop provided code

1. The new server code including error handling [can be viewed here](/Reliability/300_Health_Checks_and_Dependencies/Code/Python/server_errorhandling.py)
1. Search for `Error handling` in the comments (occurs twice). What will this code do now if the dependency call fails?

##### Deploy the new error handling code

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

#### 2.3.3 Error handling code

This is the error handling code from [server_errorhandling.py](/Reliability/300_Health_Checks_and_Dependencies/Code/Python/server_errorhandling.py). The **Option 2 - Assisted option** uses this code. If you used the **Option 1 - Expert option**, you can consult this code as a guide.

**Code**:
{{% expand "Click here to see the code:" %}}

```python
# Error handling:
# surround the call to RecommendationService in a try catch
try:

    # Call the getRecommendation API on the RecommendationService
    response = call_getRecommendation(self.region, user_id)

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
# and report diagnostic information
except Exception as e:
    message += recommendation_message ('Valued Customer', 'I Love Lucy', False)
    message += '<br><br><br><h2>Diagnostic Info:</h2>'
    message += '<br>We are unable to provide personalized recommendations'
    message += '<br>If this persists, please report the following info to us:'
    message += str(traceback.format_exception_only(e.__class__, e))
```
{{% /expand %}}

</details>

#### 2.3.4 Observe behavior of web service with added error handling

1. After the new error-handling code has successfully deployed, refresh the test web service page multiple times. Observe:
      * It works. It no longer returns an error
      * All three EC2 instances and Availability Zones are being used
      * A default recommendation for **Valued Customer** is displayed instead of a user-personalized one
      * There is now **Diagnostic Info**. What does it mean?

1. Refer back to the newly deployed code to understand why the website behaves this way now

The Website is working again, but in a degraded capacity since it is no longer serving personalized recommendations. While this is less than ideal, it is much better than when it was failing with http 502 errors. The **RecommendationService** is not available, so the app instead returns a _static response_ (the default recommendation) instead of the data it would have obtained from **RecommendationService**.

|Well-Architected for Reliability: Best practice|
|:--:|
|**Implement graceful degradation to transform applicable hard dependencies into soft dependencies**: When a component's dependencies are unhealthy, the component itself can still function, although in a degraded manner. For example, when a dependency call fails, instead use a predetermined static response.|
