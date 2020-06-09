---
title: "Create VPC Stack"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>1. </b>"
---
<!--
    The content of this page is rendered via a Hugo shortcode: https://gohugo.io/content-management/shortcodes/

    Therefore the contents are actually in this file
        https://github.com/awslabs/aws-well-architected-labs/blob/master/layouts/shortcodes/common/Create_VPC_Stack.md

    If you wish to make edits, pull requests or issues are welcome
-->
This step will create the VPC and all components using the example CloudFormation template.

1. Download the latest version of the CloudFormation template here: [vpc-alb-app-db.yaml](/Common/Create_VPC_Stack/Code/vpc-alb-app-db.yaml)

{{% common/CreateNewCloudFormationStack stackname="WebApp1-VPC" templatename="vpc-alb-app-db.yaml" %}}
    * Leave all parameters as their default values unless you are experimenting.
{{% /common/CreateNewCloudFormationStack %}}


Now that you have a new VPC, check out [200_Automated_Deployment_of_EC2_Web_Application]({{< ref "../200_Automated_Deployment_of_EC2_Web_Application" >}}) to deploy an example web application inside it.
