This step will create the VPC and all components using the example CloudFormation template.

1. Download the latest version of the CloudFormation template here: [vpc-alb-app-db.yaml](/Common/Create_VPC_Stack/Code/vpc-alb-app-db.yaml)
2. Sign in to the AWS Management Console, select your preferred region, and open the CloudFormation console at [https://console.aws.amazon.com/cloudformation/](https://console.aws.amazon.com/cloudformation/).
3. Click **Create Stack**, then **With new resources (standard)**.

![cloudformation-createstack-1](/Common/Create_VPC_Stack/Images/cloudformation-createstack-1.png)

4. Click **Upload a template file** and then click **Choose file**.

![cloudformation-createstack-2](/Common/Create_VPC_Stack/Images/cloudformation-createstack-2.png)

5. Choose the CloudFormation template you downloaded in step 1, return to the CloudFormation console page and click **Next**.
6. Enter the following details:
   * **Stack name**: The name of this stack. For this lab, use **{{ .Get "stackname" }}** and match the case.
   * **Parameters**: Parameters may be left as defaults, you can find out more in the description for each.

![cloudformation-vpc-params](/Common/Create_VPC_Stack/Images/cloudformation-vpc-params.png)

7. At the bottom of the page click **Next**.
8. In this lab, we use tags, which are key-value pairs, that can help you identify your stacks. Enter *Owner* in the left column which is the key, and your email address in the right column which is the value. We will not use additional permissions or advanced options so click **Next**. For more information, see [Setting AWS CloudFormation Stack Options](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide//cfn-console-add-tags.html).
9. Review the information for the stack. When you're satisfied with the configuration, at the bottom of the page check **I acknowledge that AWS CloudFormation might create IAM resources with custom names** then click **Create stack**.

![cloudformation-vpc-createstack-final](/Common/Create_VPC_Stack/Images/cloudformation-vpc-createstack-final.png)

10. After a few minutes the final stack status should change from *CREATE_IN_PROGRESS* to *CREATE_COMPLETE*. You can click the **refresh** button to check on the current status.
You have now created the VPC stack (well actually CloudFormation did it for you).
