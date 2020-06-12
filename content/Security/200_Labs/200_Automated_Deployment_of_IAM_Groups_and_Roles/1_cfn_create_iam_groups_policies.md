---
title: "AWS CloudFormation to Create Groups, Policies and Roles with MFA Enforced"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

Using [AWS CloudFormation](https://aws.amazon.com/cloudformation/) we are going to deploy a set of groups, roles, and managed policies that will help with your security "baseline" of your AWS account.

### 1.1 Create AWS CloudFormation Stack

1. Sign in to the AWS Management Console, select your preferred region, and open the CloudFormation console at https://console.aws.amazon.com/cloudformation/.
2. Click **Create stack**.

![cloudformation-createstack-1](/Security/200_Automated_Deployment_of_IAM_Groups_and_Roles/Images/cloudformation-createstack-1.png)

3. Enter the following **Amazon S3 URL**: `https://s3-us-west-2.amazonaws.com/aws-well-architected-labs/Security/Code/baseline-iam.yaml` and click **Next**.

![cloudformation-createstack-s3](/Security/200_Automated_Deployment_of_IAM_Groups_and_Roles/Images/cloudformation-createstack-s3.png)

4. Enter the following details:
  * Stack name: The name of this stack. For this lab, use `baseline-iam`.
  * AllowRegion: A single region to restrict access, enter your preferred region.
  * BaselineExportName: The CloudFormation export name prefix used with the resource name for the resources created, for example, Baseline-PrivilegedAdminRole.
  * BaselineNamePrefix: The prefix for roles, groups, and policies created by this stack.
  * IdentityManagementAccount: (optional) AccountId that contains centralized IAM users and is trusted to assume all roles, or blank for no cross-account trust. Note that the trusted account needs to be appropriately secured.
  * OrganizationsRootAccount: (optional) AccountId that is trusted to assume Organizations role, or blank for no cross-account trust. Note that the trusted account needs to be appropriately secured.
  * ToolingManagementAccount: AccountId that is trusted to assume the ReadOnly and StackSet roles, or blank for no cross-account trust. Note that the trusted account needs to be appropriately secured.
5. At the bottom of the page click **Next**.
6. In this lab, we won't add any tags or other options. Click Next. Tags, which are key-value pairs, can help you identify your stacks. For more information, see [Adding Tags to Your AWS CloudFormation Stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-console-add-tags.html).
7. Review the information for the stack. When you're satisfied with the configuration, check **I acknowledge that AWS CloudFormation might create IAM resources with custom names** then click **Create stack**.

![cloudformation-createstack-final](/Security/200_Automated_Deployment_of_IAM_Groups_and_Roles/Images/cloudformation-createstack-final.png)

8. After a few minutes the stack status should change from *CREATE_IN_PROGRESS* to *CREATE_COMPLETE*.
9. You have now set up a number of managed polices, groups, and roles that you can test to improve your AWS security!
