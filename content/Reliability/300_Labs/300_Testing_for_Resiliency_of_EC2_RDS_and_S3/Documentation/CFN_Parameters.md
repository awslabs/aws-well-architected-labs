---
title: "CloudFormation Parameters"
date: 2020-04-24T11:16:09-04:00
chapter: false
hidden: true
---

_All entries are **Case-Sensitive**_

## **single region** stack

|Parameter|Default Value|
|---|:---|
|`CreateTheAutoScalingServiceRole`|`true`|
|`CreateTheELBServiceRole`|`true`|
|`CreateTheRDSServiceRole`|`true`|
|`LambdaFunctionsBucket`|`aws-well-architected-labs-ohio`|
|`RDSLambdaKey`|`Reliability/RDSLambda.zip`|
|`VPCLambdaKey`|`Reliability/Reliability/VPCLambda.zip`|
|`WaitForStackLambdaKey`|`Reliability/WaitForStack.zip`|
|`WebAppLambdaKey`|`Reliability/WebAppLambda.zip`|

## **multi region** stack

|Parameter|Default Value|
|---|:---|
|`CreateTheAutoScalingServiceRole`|`true`|
|`CreateTheELBServiceRole`|`true`|
|`CreateTheRDSServiceRole`|`true`|
|`DMSLambdaKey`|`Reliability/DMSLambda.zip`|
|`LambdaFunctionsBucket`|`aws-well-architected-labs-ohio`|
|`RDSLambdaKey`|`Reliability/RDSLambda.zip`|
|`RDSRRLambdaKey`|`Reliability/RDSReadReplicaLambda.zip`|
|`VPCLambdaKey`|`Reliability/Reliability/VPCLambda.zip`|
|`WaitForStackLambdaKey`|`Reliability/WaitForStack.zip`|
|`WebAppLambdaKey`|`Reliability/WebAppLambda.zip`|

---
