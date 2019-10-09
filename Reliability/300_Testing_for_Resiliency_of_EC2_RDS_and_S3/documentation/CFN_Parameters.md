# CloudFormation Parameters

## **single region** stack

|Parameter|Default Value|
|---|---|
|`CreateTheAutoScalingServiceRole`|`true`|
|`CreateTheELBServiceRole`|`true`|
|`CreateTheRDSServiceRole`|`true`|
|`LambdaFunctionsBucket`|`aws-well-architected-labs-ohio`|
|`RDSLambdaKey`|`Reliability/RDSLambda.zip`|
|`VPCLambdaKey`|`Reliability/Reliability/VPCLambda.zip`|
|`WaitForStackLambdaKey`|`Reliability/WaitForStack.zip`|
|`WebAppLambdaKey`|`Reliability/WebAppLambda.zip`|


## **multi region** stack

    1. For the two region deployment:

         1. Stack name: “DeployResiliencyWorkshop” <-No spaces!
         2. DMSLambdaKey: “Reliability/DMSLambda.zip” <-Case sensitive!
         3. EnableAutoScalingServiceRole: “false” or “true,” depending on whether it exists. In the example, this will be false since it already exists.
         4. EnableELBServiceRole: “false” or “true,” depending on whether it exists. In the example, this will be true because it does not exist.
         5. EnableRDSServiceRole: “false” or “true,” depending on whether it exists. In the example, this will be true because it does not exist.
         6. LambdaFunctionsBucket: “aws-well-architected-labs-ohio” <-Case sensitive!
         7. RDSLambdaKey: “Reliability/RDSLambda.zip” <-Case sensitive!
         8. RDSRRLambdaKey: "Reliability/RDSReadReplicaLambda.zip" <-Case sensitive!
         9. VPCLambdaKey: “Reliability/VPCLambda.zip” <-Case sensitive!
         10. WaitForStackLambdaKey: “Reliability/WaitForStack.zip” <-Case sensitive!
         11. WebAppLambdaKey: “Reliability/WebAppLambda.zip” <-Case sensitive!
      ![CFNParameters-2Region](Images/CFNParameters-2Region.png)  
