---
title: "Well-Architected Insights"
date: 2021-05-31T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

Well-Architected Insights provides serverless developers with insights and recommendations to continually improve their applications and keep them secure, compliant, optimized, and efficient.

The second section of the lab will demonstrate how to automatically create a role in your AWS account, delegating read-only access to various services in your AWS account. Follow these steps to complete the configuration:

### 2.1. Account Onboarding to Dashbird.

If you are new to Dashbird, sign up for a free account in [Dashbird.io](https://dashbird.io/).
If you already have an account in Dashbird, go to 2.2.

{{%expand "Click here for Onboarding to Dashbird"%}}

1. Click **New to Dashbird? Create an account**

![Section2 New Account](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section2/section2-new-account.png)

2. Provide your Company/Organization name and click **Next**.

![Section2 Organization](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section2/section2-organization.png)

3. Select one of the benefits that you are expecting to get out of Dashbird and click **Next**.

![Section2 Account Name](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section2/section2-account-name.png)

4. Click **Add Dashbird CloudFormation stack to AWS** to create an IAM role. This will allow Dashbird to collect logs, metrics and permission resource listing under your AWS account. This will redirect you to AWS Console.

![Section2 Add Dashbird CloudFormation Stack](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section2/section2-add-dashbird-cloudformation-stack.png)

5. Scroll down to the bottom of the stack creation page and acknowledge the IAM resources creation by selecting all of the check boxes. Click the **Next** button. The stack name will be **dashbird-delegation** by default.

![Section2 Create IAM](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section2/section2-create-iam.png)

6. Click **dashbird-delegation** stack in CloudFormation Console and go to **Outputs** to get the **ARN** of **DashbirdDelegationRole**. This will be required at a later stage in the lab.

![Section2 Get ARN](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section2/section2-get-arn.png)

7. If you want to see the details of IAM role that Dashbird created, go to the [IAM Console](https://console.aws.amazon.com/iamv2/home?#/roles) and search for **DashbirdDelegationRole**

![Section2 IAM Role Details](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section2/section2-iam-role-details.png)

8. From the Dashbird console, provide the **ARN** of **DashbirdDelegationRole** which you noted previously. Click **Submit Arn** and click **Next**.

![Section2 Provide ARN](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section2/section2-provide-arn.png)

9. Dashbird will scan your AWS account to collect logs, metrics, listing resources. This process may take 4-5 minutes to complete.

![Section2 Scan AWS Account](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section2/section2-scan-aws-account.png)

10. All done! You should now have end-to-end observability within Dashbird Console.

![Section2 All Done](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section2/section2-all-done.png)

{{% /expand%}}


### 2.2. Well-Architected Insights

From the Dashbird console, you can now access the Well-Architected Insights. From here, you should be able to see the Well-Architected best practices broken down by six pillars of Well-Architected Framework.

1. Click **Well-Architected Lens** on the left panel to see your workload performance against each one of six pillars.

![Section2 Well-Architected Lens](/wapartners/100_Automating_Serverless_Best_Practices_with_Dashbird/Images/section2/section2-well-architected-lens.png)

___
**END OF SECTION 2**
___
