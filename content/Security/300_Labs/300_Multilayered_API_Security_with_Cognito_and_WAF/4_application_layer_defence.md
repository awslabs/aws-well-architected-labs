---
title: "Application layer defence"
date: 2021-05-31T11:16:08-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

In this section we will tighten security using AWS WAF further to mitigate the risk of vulnerabilities such as SQL Injection, Distributed denial of service (DDoS) and other common attacks. WAF allows you to create your own custom rules to decide whether to block or allow HTTP requests before they reach your application.

### 4.1. Identify the risk of vulnerabilities.

A SQL Injection attack consists of insertion of a SQL query via the input data to the application. A successful SQL injection exploit can be capable or reading sensitive data from a database, or in extreme cases data modification/deletion. 

Our current API retrieves data from RDS for MySQL and relies on the user interacting via CloudFront. However, it is still possible for malicious SQL code to be injected into a web request, which could result in unwanted data extraction.

As a simple example, simply add **'or 1=1'** at the end of your CloudFront domain name as shown:

```
https://Your_CloudFront_Domain_Name/?id=1 or 1=1
```


As you can see from the output, using this simple SQL injection could result in an attacker gaining access to all the data in our database:

![Section4 Access through CloudFront](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section4/section4-sql_injection.png)

This section of the lab will focus on some techniques which work to block web requests that contain malicious SQL code or SQL injection using AWS WAF.

### 4.2. Working with SQL injection match conditions.

1. From CloudFormation, locate the second stack which you deployed. On the stack **Outputs** tab, click **WAFWebACLG** to go to **Web ACLs** to review Rules in WAF. This web ACL is associated with CloudFront.

![Section4 Output WAF](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section4/section4-waf_global_cloudfront.png)

2. Go to the **Rules** tab and select **add managed rule groups** as shown:

![Section4 Add AWS Managed Rule](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section4/section4-add_aws_managed_rule.png)

3. Expand the **AWS managed rule groups** section and enable the **SQL database** rules as shown: 
![Section4 Enable SQL database](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section4/section4-enable_sql_database.png)

By doing this we are adding rules that allow you to block request patterns associated with exploitation specific to SQL databases, such as SQL injection attacks. Make sure you select **Add rules** at the bottom of the screen to proceed to the next stage.

4. It is possible to assign priorities based on the rules which you specify. As you only have one rule at this moment, we can skip this configuration. Click **Save**:

![Section4 Set Rule Priority](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section4/section4-set_rule_priority.png)

5. You should now be able to see the **AWS-AWSManagedRulesSQLiRuleSet** added to web ACL as shown:

![Section4 AWS AWSManagedRulesSQLiRuleSet](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section4/section4-AWS-AWSManagedRulesSQLiRuleSet.png)

6. We can now rerun our test again, which should hopefully produce a different output. 

Use your **CloudFrontEndpoint** to run the same query as before, inclusive of the injection attack at the end. This can be done in either a web-browser or your Cloud9 IDE environment using the script that we have provided previously:

![Section4 Block SQL Injection](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section4/section4-block_sql_injection.png)

If your configuration is correct, you should now see a **Response code: 403**. This means that WAF has **blocked** this request as malicious code has been detected in the input.


7. We can now check that the blocked request has registered in our ACL metrics. To do this, go to the **Overview** in WAF console to see the metrics of ACL. You can confirm your request was blocked by WAF from this metrics. Click **AWS-AWSManagedRulesSQLiRuleSet BlockedRequests** to see only blocked request by SQL database. Note that your output may differ from the screenshot below depending on the amount of blocked requests that you sent.

![Section4 SQL Injection MetricGblocked Requests](/Security/300_Multilayered_API_Security_with_Cognito_and_WAF/Images/section4/section4-sql_injection_metricGblocked_requests.png)
___
**END OF SECTION 4**
___

