# Level 200: Automated Deployment of VPC

## Authors
- Ben Potter, Security Lead, Well-Architected
# Table of Contents
1. [Create VPC Stack](#create_vpc_stack)
2. [Tear Down](#tear_down)

## 1. Create VPC Stack <a name="create_vpc_stack"></a>
This step will create the VPC and all components using the example CloudFormation template.
1. Download the latest version of the CloudFormation template from [/Code](Code/) to your computer.
2. Sign in to the AWS Management Console, select your preferred region, and open the CloudFormation console at [https://console.aws.amazon.com/cloudformation/](https://console.aws.amazon.com/cloudformation/).
3. Click Create Stack.  
![cloudformation-createstack-1](Images/cloudformation-createstack-1.png)  
4. Click **Upload a template file** and then click **Choose file**.  
![cloudformation-createstack-2](Images/cloudformation-createstack-2.png)  
5. Choose the CloudFormation template you downloaded in step 1, return to the CloudFormation console page and click **Next**.
5. Enter the following details:
  * Stack name: The name of this stack. For this lab, use *WebApp1-VPC* and match the case.
  The parameters may be left as defaults, you can find out more in the description for each. If you change the default name take note as you will need to use it for other labs including "Automated Deployment of EC2 Web Application".
![cloudformation-vpc-params](Images/cloudformation-vpc-params.png)  
6. At the bottom of the page click **Next**.  
7. In this lab, we won't add any tags or other options. Click Next. Tags, which are key-value pairs, can help you identify your stacks. For more information, see [Adding Tags to Your AWS CloudFormation Stack](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide//cfn-console-add-tags.html).
8. Review the information for the stack. When you're satisfied with the configuration, check **I acknowledge that AWS CloudFormation might create IAM resources with custom names** then click **Create stack**.  
![cloudformation-vpc-createstack-final](Images/cloudformation-vpc-createstack-final.png)  
9. After a few minutes the final stack status should change from *CREATE_IN_PROGRESS* to *CREATE_COMPLETE*.
You have now created the VPC stack (well actually CloudFormation did it for you).

***

### 2. Tear down this lab
The following instructions will remove the resources that you have created in this lab.

Delete the VPC CloudFormation stack:
1. Sign in to the AWS Management Console, select your preferred region, and open the CloudFormation console at [https://console.aws.amazon.com/cloudformation/](https://console.aws.amazon.com/cloudformation/).
2. Click the radio button on the left of the *WebApp1-VPC* stack.
3. Click the **Actions** button then click **Delete stack**.
4. Confirm the stack and then click **Delete** button.

Delete the CloudWatch Logs:
1. Sign in to the AWS Management Console, select your preferred region, and open the CloudFormation console at [https://console.aws.amazon.com/cloudwatch/](https://console.aws.amazon.com/cloudwatch/).
2. Click **Logs** in the left navigation.
3. Click the radio button on the left of the **WebApp1-VPCFlowLog**.
4. Click the **Actions Button** then click **Delete Log Group**.
5. Verify the log group name then click **Yes, Delete**.

***

## References & useful resources:
[AWS CloudFormation User Guide](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/Welcome.html)  
[Amazon VPC User Guide](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)  


***

## License
Licensed under the Apache 2.0 and MITnoAttr License. 

Copyright 2019 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file except in compliance with the License. A copy of the License is located at

    http://aws.amazon.com/apache2.0/

or in the "license" file accompanying this file. This file is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
