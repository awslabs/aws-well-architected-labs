---
title: "Deploy Web Application and Infrastructure using CloudFormation"
menutitle: "Deploy Application"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

Wait until the VPC CloudFormation stack **status** is _CREATE_COMPLETE_, then continue. This will take about four minutes.

* Download the CloudFormation template: [_staticwebapp.yaml_](/Reliability/Common/Code/CloudFormation/staticwebapp.yaml)
  * You can right-click then choose **Save link as**; or you can right click and copy the link to use with `wget`

{{% common/CreateNewCloudFormationStack stackname="CloudFormationLab" templatename="staticwebapp.yaml" /%}}

