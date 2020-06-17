---
title: "Explore the CloudFormation Template"
menutitle: "Explore CloudFormation"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

In this section you will explore the CloudFormation template and learn how you were able to deploy the web application infrastructure using it

* Go to the AWS CloudFormation console at <https://console.aws.amazon.com/cloudformation>
   1. Click on the **CloudFormation** stack that you deployed
   1. Click on the **Template** tab
   ![CFNViewTemplate](/Reliability/100_Deploy_CloudFormation/Images/CFNViewTemplate.png)

* _Alternate_: You previously downloaded the CloudFormation Template _staticwebapp.yaml_. You can also view it in the text editor of your choice

The template is written in a format called [YAML](https://yaml.org/), which is commonly used for configuration files. CloudFormation templates can also be written in JSON.

Look through the template. You will notice several sections:

* The [Parameters section](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html) is used to prompt for inputs that can be used elsewhere in the template. The template is asking for several inputs, but also provides default values for each one. 
   * Look through these and start to reason about what some are used for.
   * For example `InstanceType` is a parameter where the user can choose that Amazon EC2 instance type to deploy for the servers used in this Web App.
   * Search the file for `!Ref InstanceType`.  `!Ref!` is a built-in function that refrences the value of a parameter.  Here you can see it is used to provide a value to the Auto Scaling Launch Configuration, which is used to laucnh new EC2 instances.

* The [Conditions section](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/conditions-section-structure.html) is where you can setup _if/then_-like control of what happens during template deployment. It defines the circumstances under which entities are created or configured.

* The [Resources section](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/resources-section-structure.html) is the "heart" of the template. It is where you define the infrastructure to be deployed. Look at the _first_ resource defined.
   * It is the Amazon DynamoDB table used as the mock for the **RecommendationService**
   * It has a _logical ID_ which in this case is `DynamoDBServiceMockTable`. This logical ID is how we refer to the DynamoDB table resource within the CloudFormation template.
   * It has a `Type` which tells CloudFormation which type of resource to create. In this case a `AWS::DynamoDB::Table`
   * And it has `Properties` that define the values used to create the VPC

* The [Outputs section](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/outputs-section-structure.html) is used to display selective information about resources in the stack.
   * In this case it uses the built-in function `!GetAtt` to get the DNS Name for the Application Load Balancer.
   * This URL is what you used to access the WebApp

* The [Metadata section](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/metadata-section-structure.html) here is used to group and order how the CloudFormation parameters are displayed when you deploy the template using the AWS Console
