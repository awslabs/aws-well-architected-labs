---
title: "Control access to API"
date: 2021-05-31T11:16:08-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---
In this section we will be building API Access Control with [Amazon Cognito](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-integrate-with-cognito.html). This will extend our architecture to ensure that only identified users are permitted access to the API.

### 5.1. Identify the risk of vulnerabilities.
Even though we have controlled traffic at multiple layers, anyone who knows your CloudFront Domain Name can access your API. Furthermore we do not know who accessed your API, so the owner of the traffic remains anonymous. Ideally we should ensure that only legitimate users who we are aware of are permitted access. This will mean that a successful API call will have to be both identified as well as authorized.

In this lab we will build out our architecture using Amazon Cognito. This addition will allow a user to sign in to a user pool which we create, obtain an identity or access token and then call the API method with one of the tokens. These tokens are typically set to the request's Authorization header.

### 5.2. Sign up with Amazon Cognito user pools.

The second CloudFormation template which you have already deployed already contains an Amazon Cognito User Pool. We will start by obtaining the **App client secret** of Cognito, which we will use to generate an ID token at later points in the lab.

{{%expand "Click here for for SignUp instructions for Amazon Cognito"%}}

1. Go to the **Outputs** section of the current cloudformation stack and locate the **CognitoSignupURL**. Click on the link as shown:

![Section5 Output Cognito](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-output_cognito.png)

2. Select the **Sign up** link with Cognito user pools.
![Section5 Sign up](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-sign_up.png)

3. Provide your valid email address and password. You will receive an email from **<no-reply@verificationemail.com>** with a link to confirm your email address is valid.
![Section5 Provide Username Password](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-provide_username_password.png)

4. Once you click the link in email, you will see the following confirmation.
![Section5 Confirmed Registration](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-confirmed_registration.png)

5. Go to **Amazon Cognito** in AWS Console and click **Manage User Pools**
![Section5 Cognito Console](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-cognito_console.png)

6. Select your user pools.
![Section5 Output WAF](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-select_user_pools.png)

7. Select **Users and groups** under **General settings** in the left panel. Note that your account status should now be shown as **CONFIRMED**:

![Section5 Output WAF](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-check_account_statue.png)

8. Select **App clients** under **General settings** in the left panel and click **Show Details**.
![Section5 Output WAF](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-select_app_client.png)

9. Record the **App client secret**. We will need this secret to generate an ID Token that will be made temporarily available for 60 minutes by default. You can customize this later if needed.
![Section5 Output WAF](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-get_app_client_secret.png)

{{% /expand%}}
{{% notice note %}}
Take note of **App client secret**. Other required values such as **user pool ID** and **App client ID** are available in the **Output** section of the current cloudformation stack. Record these before moving to the next step.
{{% /notice %}}

### 5.3. Create Cognito user pools as Authorizer in API Gateway Console.

Amazon Cognito user pools are used to control who can invoke REST API methods. We now need to integrate the API with the Amazon Cognito user pool.

1. Go to **API Gateway** in the AWS console and select API called **wa-lab-rds-api**.
![Section5 API without Authorizer](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-api_without_authorizer.png)

2. From the main navigation pane, choose **Authorizers** and click **Create New Authorizer** button.
* Type an authorizer name in Name.
* Select **Cognito** as Authorizer Type.
* Select your Cognito user pool (this should start with WAUserPool).
* For Token source, type **Authorization** as the header name to pass the identity or access token.

Your configuration should be similar to the screenshot below:

![Section5 Create New Authorizer](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-create_new_authorizer.png)

* When you have completed the configuration, click on **Create**.

3. You have now successfully added an **Authorizer**:

![Section5 Output WAF](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-authorizer.png)

4. From the main navigation pane, choose **Resource** to configure a COGNITO_USER_POOLS authorizer on methods.

{{% notice note %}}
**Before you click Method Request, ensure that you refresh your browser**. If you do not do this, our new **Authorizer** will not appear when trying to associate with Method Request.
{{% /notice %}}

Select **Method Request** as shown:

![Section5 Method Request](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-method_request.png)

5. Choose the pencil icon next to **Authorization**. You should be able to see the **Authorizer** we created in the drop-down list.
* To save the settings, choose the check mark icon
![Section5 Select Authorizer](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-select_new_authorizer.png)

6. Since we made a change, we need to re-deploy the API. Complete the following steps:

* Choose **Action**.
* **Deploy API**.
![Section5 Deploy API](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-deploy_API.png)

7. Select Development stage as **Dev** from the drop-down list. Click Deploy.
![Section5 Select Stage](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-select_stage.png)

8. Your API is now using COGNITO_USER_POOLS as Authorizer. Only users registered in COGNITO_USER_POOLS can access your API.
![Section5 Authorizer Association](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-authorizer_association.png)

### 5.4. Add Authorization header in CloudFront.
By default, CloudFront doesn't consider headers when caching your objects in edge locations. Now your request must have an **Authorization** header with a valid ID Token to access API. Therefore, we need to configure CloudFront to forward headers to the API Gateway. Further details on this can be found [here](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/header-caching.html)

1. Go to **CloudFront** in the AWS console and select your CloudFront distribution.
* From within the distribution, select the **Behaviors** tab.
* Select Cache Behavior associated with our API Gateway using the tick box.
* Click **Edit**.

![Section5 Forward Header](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-forward_header.png)

2. Select **Authorization** from the list of available headers and choose **Add**. To forward a custom header, enter the name of the header in the field, and choose Add Custom. Click **Yes,Edit**.
![Section5 Whitelist Headers](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-whitelist_header.png)

{{% notice note %}}
If you test out without Authorization header now, you will still see data being returned as it's served from CloudFront edge caches. Let's invalidate files to prevent this from happening.
{{% /notice %}}

3. Invalidate files from CloudFront edge.
* Select **Invalidation** tab.
* Select **Create Invalidation**
* Type /* , then click Invalidate button.
![Section5 Whitelist Headers](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-invalidate_files.png)


### 5.5. Generate an ID Token and send a request with ID Token.
After successful completing authentication, Amazon Cognito returns user pool tokens to your app. You can use these tokens to grant your users access to the API Gateway. Amazon Cognito user pools implements ID, access, and refresh tokens as defined by the OpenID Connect (OIDC) open standard. 

In this lab, we will use an ID Token that is a JSON Web Token (JWT) that contains claims about the identity of the authenticated user such as name, email, and phone_number.

1. In **Cloud9**, we will test with both CloudFrontEndpoint and APIGatewayURL to see the difference.

* Execute the script called sendRequest.py with the argument of your **CloudFrontEndpoint**.
```
python sendRequest.py 'CloudFrontEndpoint'
```
You will get **"Unauthorized"** response with **401 response code**.

![Section5 Test API Cloud9](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-test_api_cloud9.png)

{{% notice note %}}
You must send Authorization header with valid ID token to access API now.
{{% /notice %}}

2. Let's generate an ID token with your username and password, Cognito user pool ID, App client ID, and App secret.
We took note of **App client secret** when we signed up with Cognito.
Other required values such as **user pool ID, App client ID** are available in **Output** section of the current cloudformation stack
```
 python getIDtoken.py <username> <user_password> <user_pool_id> <app_client_id> <app_client_secret>
```
You should be able to generate ID Token successfully. This will be valid for 60 minutes.
![Section5 Generate cognito ID Token](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-generate_cognito_id_token.png)

3. Copy your **ID Token** you generate above. Send a request with this valid ID Token.
```
python sendRequest.py 'CloudFrontEndpoint' ID_Token
```
You should be seeing your data as expected with a **200 response code**. Now you must have provided an ID Token as the Authorization header to access your API only through CloudFront.

![Section5 Send Request With Cognito ID Token](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section5/section5-send_request_with_cognito_id_token.png)

{{% notice note %}}
Ensure that you complete the tear down instructions in the final section to remove resources created in this lab.
{{% /notice %}}
___
**END OF SECTION 5**
___