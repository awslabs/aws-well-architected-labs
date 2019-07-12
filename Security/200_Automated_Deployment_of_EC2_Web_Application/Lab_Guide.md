# Level 200: Automated Deployment of EC2 Web Application

## Authors

- Ben Potter, Security Lead, Well-Architected
- Rodney Lester, Reliability Lead, Well-Architected

## Table of Contents

1. [Overview](#overview)
2. [Create Web Stack](#create_web_stack)
3. [Knowledge Check](#knowledge_check)
4. [Further Considerations](#further_considerations)
5. [Tear Down](#tear_down)

## 1. Overview <a name="overview"></a>

Overview of wordpress stack architecture:
![architecture](Images/architecture.png)

## 2. Create Web Stack <a name="create_web_stack"></a>

Please note a prerequisite to this lab is that you have deployed the CloudFormation VPC stack in the lab [Automated Deployment of VPC](../200_Automated_Deployment_of_VPC/README.md) with the default parameters and recommended stack name.

This step will create the web application and all components using the example CloudFormation template, inside the VPC you have created previously. An SSH key is not configured in this lab, instead [AWS Systems Manager](https://docs.aws.amazon.com/systems-manager/latest/userguide/what-is-systems-manager.html) should be used to manage the EC2 instances as a more secure and scalable method.

1. Choose the version of the CloudFormation template and download to your computer or by [cloning](https://help.github.com/en/articles/cloning-a-repository) this repository:
   * [wordpress.yaml](https://raw.githubusercontent.com/awslabs/aws-well-architected-labs/master/Security/200_Automated_Deployment_of_EC2_Web_Application/Code/wordpress.yaml) to create a WordPress site, including an RDS database.
   * [staticwebapp.yaml](https://raw.githubusercontent.com/awslabs/aws-well-architected-labs/master/Security/200_Automated_Deployment_of_EC2_Web_Application/Code/staticwebapp.yaml) to create a static web application that simply displays the instance ID for the instance it is running upon.
2. Sign in to the AWS Management Console, select your preferred region, and open the CloudFormation console at [https://console.aws.amazon.com/cloudformation/](https://console.aws.amazon.com/cloudformation/). Note if your CloudFormation console does not look the same, you can enable the redesigned console by clicking **New Console** in the **CloudFormation** menu.
3. Click Create Stack.

![cloudformation-createstack-1](Images/cloudformation-createstack-1.png)

4. Click **Upload a template file** and then click **Choose file**.

![cloudformation-createstack-2](Images/cloudformation-createstack-2.png)

5. Choose the CloudFormation template you downloaded in step 1, return to the CloudFormation console page and click **Next**.
5. Enter the following details:
  * Stack name: The name of this stack. For this lab, for the WordPress stack use *WebApp1-WordPress* or for the static web stack use *WebApp1-Static* and match the case.
  ![cloudformation-wp-params](Images/cloudformation-wp-params.png)
  * ALBSGSource: Your current IP address in CIDR notation which will be allowed to connect to the application load balancer, this secures your web application from the public while you are configuring and testing.
  ![cloudformation-wp-params-2](Images/cloudformation-wp-params-2.png)
  The remaining parameters may be left as defaults, you can find out more in the description for each.
6. At the bottom of the page click **Next**.
7. In this lab, we won't add any tags or other options. Click **Next**. Tags, which are key-value pairs, can help you identify your stacks. For more information, see [Adding Tags to Your AWS CloudFormation Stack](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide//cfn-console-add-tags.html).
8. Review the information for the stack. When you're satisfied with the configuration, check **I acknowledge that AWS CloudFormation might create IAM resources with custom names** then click **Create stack**.

![cloudformation-wp-createstack-final](Images/cloudformation-wp-createstack-final.png)

9. After a number of minutes the final stack status should change from *CREATE_IN_PROGRESS* to *CREATE_COMPLETE*.

 ![cloudformation-wp-createstack-complete](Images/cloudformation-wp-createstack-complete.png)

You have now created the WordPress stack (well actually CloudFormation did it for you).

10. In the stack click the **Outputs** tab, and open the *WebsiteURL* value in your web browser, this is how to access what you just created.

## 3. Knowledge Check <a name="knowledge_check"></a>

The security best practices followed in this lab are: <a name="best_practices"></a>

* [Grant access through roles or federation:](https://wa.aws.amazon.com/wat.question.SEC_3.en.html) A role is attached to the auto-scaled instances.
* [Implement dynamic authentication:](https://wa.aws.amazon.com/wat.question.SEC_3.en.html) The role attached to the auto-scaled instances dynamically acquires credentials.
* [Grant least privileges:](https://wa.aws.amazon.com/wat.question.SEC_3.en.html) The role attached to the auto-scaled instances uses minimum privileges to accomplish the task.
* [Implement new security services and features:](https://wa.aws.amazon.com/wat.question.SEC_5.en.html) New features including secrets manager have been adopted.
* [Limit exposure:](https://wa.aws.amazon.com/wat.question.SEC_6.en.html) Security groups restrict network traffic to a minimum.
* [Automate configuration management:](https://wa.aws.amazon.com/wat.question.SEC_6.en.html) CloudFormation is being used to deploy the application automatically.
* [Control traffic at all layers:](https://wa.aws.amazon.com/wat.question.SEC_6.en.html) Traffic is controlled in multiple tiers, using subnets with different route tables.
* [Reduce attack surface:](https://wa.aws.amazon.com/wat.question.SEC_7.en.html) Instances do not allow for SSH, instead Systems Manager may be used for administration.
* [Implement managed services:](https://wa.aws.amazon.com/wat.question.SEC_7.en.html) Managed services are utilized including Secrets Manager, Aurora serverless.
* [Implement secure key management:](https://wa.aws.amazon.com/wat.question.SEC_9.en.html) AWS Key Management Service is used for key management of Aurora database.
* [Provide mechanisms to keep people away from data:](https://wa.aws.amazon.com/wat.question.SEC_9.en.html) SSH to the instances is not allowed, Systems Manager may be used to control access and CloudFormation is used to deploy and update all infrastructure to reduce human error.

## 4. Further considerations: <a name="further_considerations"></a>

* Enable TLS (SSL) on application load balancer to encrypt communications, using Amazon Certificate Manager.
* WordPress that is deployed stores the database password in clear text in a configuration file and is not rotated, best practice if supported would be to encrypt and automatically rotate preferably accessing the Secrets Manager API.
* Encrypting the EC2 AMI for the web instances would automatically enable encrypted volumes.
* Implementing a Web Application Firewall such as AWS WAF, and a content delivery service such as Amazon CloudFront.
* Create an automated process for patching the AMI's and scanning for vulnerabilities before updating in production.
* Create a pipeline that verifies the CloudFormation template for misconfigurations before creating or updating the stack.

***

### 5. Tear down this lab <a name="tear_down"></a>

The following instructions will remove the resources that you have created in this lab.

Delete the WordPress or Static Web Application CloudFormation stack:

1. Sign in to the AWS Management Console, select your preferred region, and open the CloudFormation console at [https://console.aws.amazon.com/cloudformation/](https://console.aws.amazon.com/cloudformation/).
2. Click the radio button on the left of the *WebApp1-WordPress* or *WebApp1-Static* stack.
3. Click the **Actions** button then click **Delete stack**.
4. Confirm the stack and then click **Delete** button.
5. Access the Key Management Service (KMS) console [https://console.aws.amazon.com/cloudformation/](https://console.aws.amazon.com/cloudformation/)

***

## References & useful resources

[AWS CloudFormation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)
[Amazon EC2 User Guide for Linux Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/concepts.html)

***

## License

Licensed under the Apache 2.0 and MITnoAttr License.

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    https://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
