---
title: "Explore your Deployed Infrastructure"
menutitle: "Explore Deployment"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

Here you will explore the CloudFormation stack you deployed in the previous step.

### How many resources were created?

![CFNIamResources.png](/Reliability/200_Deploy_and_Update_CloudFormation/Images/CFNIamResources.png)

1. From the CloudFormation console, click the **Resources** tab for the **CloudFormationLab** stack.
   * The listing shows all the resources that were created.
1. Now, look at the `simple_stack.yaml` template (in your text editor) and compare. How many resources are defined there?
1. Investigate:
   * Why did the deployment not create all of the resources?
   * You may click below for the answer. Try to figure this out before continuing.

{{%expand "click here for answer:" %}}
The deployed stack only has one resource, the VPC. But the CloudFormation Template contains many more in its **Resources** section.  Why are these different?
* The **Condition** `PublicEnabled` is set using the **Parameter** `PublicEnabledParam`
* Similarly the **Condition** `EC2SecurityEnabled` is set using the **Parameter** `EC2SecurityEnabledParam`
* The Default value for both of these **Parameters** is `false`
* And therefore both conditions  `PublicEnabled` and `EC2SecurityEnabled` evaluate to `false`
* Look in the template at how the `PublicEnabled` and `EC2SecurityEnabled` **Conditions** are used

```yaml
  IGWAttach:
    Condition: PublicEnabled
    #https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpc-gateway-attachment.html
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref SimpleVPC
      InternetGatewayId: !Ref IGW
```

* The `Condition: <Condition_Name>` statement on a resource means
    * If this condition is `true`
        * then create this resource
    * else
        * do not create this resource
* All resources _except_ the VPC have a `Condition` statement. Since the conditions were `false` only the VPC was created
{{% /expand%}}

### Complare the CloudFormation template to the VPC resource that was created

1. Return to the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation)
1. Click the **Resources** tab for the **CloudFormationLab** stack. The listing shows all the resources that were created. In this case just the VPC
1. Note the **Logical ID** for the VPC is _SimpleVPC_. Look at the CloudFormation template file and determine where this name came from
1. Under the **Resources** tab click on the **Physical ID** link for _SimpleVPC_
    * This takes you to the VPC console where you can see the VPC you created
    * Select the checkbox next to your VPC (if not already selected)
    * Look at the VPC attributes under the **Description** tab.  How do these compare to the CloudFormation template?

* For more information see the [syntax and properties for a VPC in Cloudformation here](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-vpc.html).