---
title: "Add an Amazon EC2 Instance to the Stack"
menutitle: "Add EC2 Instance"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

In this task, your objective is to add an Amazon EC2 instance to the template, then update the stack with the revised template.

Whereas the bucket definition was rather simple (just two to four lines), defining an Amazon EC2 instance is more complex because it needs to use associated resources, such as an AMI, security group and subnet.

For this exercise we wil assume you now know how to edit your CloudFormation template and update your CloudFormation stack with the updated template

### 4.1 Get the latest AMI to use for your EC2 instance

In the **Parameters** section of your template, look at the **LatestAmiId** parameter.

    LatestAmiId:
      Description: Gets the latest AMI from Systems Manager Parameter store
      Type: 'AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>'
      Default: '/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2'

This is a special parameter. This parameter uses the **AWS Systems Manager Parameter Store** to retrieve the latest AMI (specified in the *Default* parameter, which in this case is *Amazon Linux 2*) for the stack's region. This makes it easy to deploy stacks in different regions without having to manually specify an AMI ID for every region.

* Go to the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation)
    * Click on **Stacks**
    * Click on the **CloudFormationLab** stack
    * Click on the **Parameters** tab
* Look at the **Value** and **Resolved value** for **LatestAmiId**
    * You see here how it resolves to an AMI ID

For more details of this method, see: [AWS Compute Blog: Query for the latest Amazon Linux AMI IDs using AWS Systems Manager Parameter Store](https://aws.amazon.com/blogs/compute/query-for-the-latest-amazon-linux-ami-ids-using-aws-systems-manager-parameter-store/)

### 4.2 Add the EC2 instance resource to your CloudFormation template and deploy it

1. Edit the CloudFormation Template, adding a new resource for an EC2 instance

    Use this documentation page for assistance:
        [AWS::EC2::Instance](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-ec2-instance.html)

    * Use the YAML format
    * For **Logical ID** (the line above **Type**) use `MyEC2Instance`

    You _only_ need to specify these six properties:

    * **IamInstanceProfile:** Refer to `Web1InstanceInstanceProfile`, which is defined elsewhere in the template
    * **ImageId:** Refer to `LatestAmiId`, which is the parameter discussed previously
    * **InstanceType:** Refer to `InstanceType`, another parameter
    * **SecurityGroupIds:** Refer to `PublicSecurityGroup`, which is defined elsewhere in the template
    * **SubnetId:** Refer to `PublicSubnet1`, which is defined elsewhere in the template
    * **Tags:** Use this YAML block:

            Tags:
              - Key: Name
                Value: Simple Server

    Remember

    * When referring to other resources in the same template, use `!Ref`. See the `BucketName` example you already implemented
    * When referring to **SecurityGroupIds**, the template is actually expecting a _list_ of security groups. You therefore need to list the security group like this:

            SecurityGroupIds:
              - !Ref PublicSecurityGroup

    * **Not sure what to do???**
      * To download a sample solution, right-click and download this link:
    [simple_stack_plus_s3_ec2.yaml](/Reliability/200_Deploy_and_Update_CloudFormation/Code/CloudFormation/simple_stack_plus_s3_ec2.yaml)
      * _Or_ click below to see exactly what to add to your CloudFormation template.

    {{% expand "Click here to see YAML for adding your EC2 instance:" %}}

      MyEC2Instance:
        Type: AWS::EC2::Instance
        Properties:
          IamInstanceProfile: !Ref Web1InstanceInstanceProfile
          ImageId: !Ref LatestAmiId
          InstanceType: !Ref InstanceType
          SecurityGroupIds:
            - !Ref PublicSecurityGroup
          SubnetId: !Ref PublicSubnet1
          Tags:
            - Key: Name
              Value: Simple Server

    {{% /expand %}}

1. Once you have edited the template, update the stack deployment with your revised template file.
    * On the **Parameters** screen of the CloudFormation update switch **EC2SecurityEnabledParam** to `true`

        | Important |
        |:---|
        |Change **EC2SecurityEnabledParam** to `true`|
        |This will tell the template to create resources your EC2 instance will need such as the Security Group and IAM Role|

    * This deployment of the CloudFormation stack will take about three minutes
    * The instance will now be displayed in the **Resources** tab.

1. Go to the EC2 console to see the *Simple Server* that was created. Explore the properties of this EC2 instance.

The final deployment is now represented by this architecture diagram:

![SimpleVpcEverything](/Reliability/200_Deploy_and_Update_CloudFormation/Images/SimpleVpcEverything.png)

### 4.3 [Optional bonus task] Add a web server to the EC2 instance

In this task you will update your CloudFormation template to modify the deployed EC2 instance so that it runs a simple web server

1. Modify the EC2 resource in the template
    * Delete the following properties form the EC2 resource
        * `SecurityGroupIds`
        * `SubnetId`
    * Add the following properties using the YAML below
        * `NetworkInterfaces`: adds an external IP address (and DNS name) for the EC2 instance
        * `UserData`: a simple bash script to install and run an Apache web server. This runs on EC2 instance creation only.

    * Visually the diff for this looks like:

         ![AddServerDiff](/Reliability/200_Deploy_and_Update_CloudFormation/Images/AddServerDiff.png)

    * The final EC2 instance resource should look like this:

              MyEC2Instance:
                Type: AWS::EC2::Instance
                Properties:
                  IamInstanceProfile: !Ref Web1InstanceInstanceProfile
                  ImageId: !Ref LatestAmiId
                  InstanceType: !Ref InstanceType
                  Tags:
                    - Key: Name
                      Value: Simple Server
                  NetworkInterfaces:
                    - AssociatePublicIpAddress: "true"
                      DeviceIndex: "0"
                      GroupSet:
                        - Ref: PublicSecurityGroup
                      SubnetId:
                        Ref: PublicSubnet1
                  UserData:
                    Fn::Base64: |
                      #!/bin/bash
                      yum -y update
                      sudo yum install -y httpd
                      sudo systemctl start httpd

1. Add an output value so you can easily find the public DNS of the EC2 instance
    * Insert the following YAML under the **Outputs** section of your CloudFormation template

            PublicServerDNS:
              Value: !GetAtt MyEC2Instance.PublicDnsName

    * Use the other entry under **Outputs** to ensure your new entry has the right indentation
    * The `!GetAtt` function can return various attributes of the resource. In this case the public DNS name of the EC2 instance.
    * NOTE: if you used a Logical ID _other_ than `MyEC2Instance` when you added your EC2 resource, then you should use that name here
    * To download a sample solution, right-click and download this link:
    [simple_stack_plus_s3_ec2_server.yaml](/Reliability/200_Deploy_and_Update_CloudFormation/Code/CloudFormation/simple_stack_plus_s3_ec2_server.yaml)

1. Update the CloudFormation stack using the modified template
1. After deployment is complete, click on the **Outputs** tab for the CloudFormation stack
    * Click on the public DNS name

![ClickPublicDns](/Reliability/200_Deploy_and_Update_CloudFormation/Images/ClickPublicDns.png)

You should see the Apache HTTP server Test Page, indicating your EC2 instance is running the web server and is accessible from the Internet.
