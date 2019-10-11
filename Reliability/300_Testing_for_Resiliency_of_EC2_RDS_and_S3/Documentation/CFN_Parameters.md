# CloudFormation Parameters

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
|`LambdaFunctionsBucket`|`aws-well-architected-labs-ohio`|
|`RDSLambdaKey`|`Reliability/RDSLambda.zip`|
|`RDSRRLambdaKey`|`Reliability/RDSReadReplicaLambda.zip`|
|`VPCLambdaKey`|`Reliability/Reliability/VPCLambda.zip`|
|`WaitForStackLambdaKey`|`Reliability/WaitForStack.zip`|
|`WebAppLambdaKey`|`Reliability/WebAppLambda.zip`|

---
**[Click here to return to Lab Instructions](../Lab_Guide.md)**
