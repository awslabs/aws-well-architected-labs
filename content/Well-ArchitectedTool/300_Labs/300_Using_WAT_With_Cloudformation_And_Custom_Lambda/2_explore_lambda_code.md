---
title: "Exploring AWS Lambda code"
menutitle: "Explore Lambda code"
date: 2020-03-08T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

## Overview
There are two AWS Lambda functions that you deployed in the previous step. Both of them utilize the [AWS SDK for Python (Boto3)](https://aws.amazon.com/sdk-for-python/) library along with the [Lambda Powertools Python](https://awslabs.github.io/aws-lambda-powertools-python/) via a Lambda layer to perform the [Well-Architected Tool](https://aws.amazon.com/well-architected-tool/) API access.

## Deployed AWS Lambda functions
* [CreateWAWorkloadLambda]({{< relref "#CreateWAWorkloadLambda" >}})
* [UpdateWAQuestionLambda]({{< relref "#UpdateWAQuestionLambda" >}})

## CreateWAWorkloadLambda.py {#CreateWAWorkloadLambda}
### Python Code
{{< readfile file="/static/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Code/Python/CreateWAWorkloadLambda.py" code="true" lang="python" >}}

### IAM Privileges
Using the concept of least privileges for each AWS Lambda function, we create an IAM role for this function that only allows certain access to the Well-Architected Tool (CreateWorkload and UpdateWorkload specifically) as well as the ability to create log file entries.
```yaml
CreateWAlambdaIAMRole:
  Type: AWS::IAM::Role
  Properties:
    AssumeRolePolicyDocument:
      Version: 2012-10-17
      Statement:
        - Action:
            - sts:AssumeRole
          Effect: Allow
          Principal:
            Service:
              - lambda.amazonaws.com
    Policies:
      - PolicyDocument:
          Version: 2012-10-17
          Statement:
            - Action:
                - logs:CreateLogGroup
                - logs:CreateLogStream
                - logs:PutLogEvents
              Effect: Allow
              Resource:
                - !Sub arn:aws:logs:${AWS::Region}:${AWS::AccountId}:log-group:/aws/lambda/${CreateWALambdaFunctionName}:*
        PolicyName: lambda
      - PolicyDocument:
          Version: 2012-10-17
          Statement:
            - Action:
                - wellarchitected:CreateWorkload
                - wellarchitected:GetWorkload
                - wellarchitected:List*
                - wellarchitected:TagResource
                - wellarchitected:UntagResource
                - wellarchitected:UpdateWorkload
              Effect: Allow
              Resource: '*'
        PolicyName: watool
```

## UpdateWAQuestionLambda.py {#UpdateWAQuestionLambda}
{{< readfile file="/static/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Code/Python/UpdateWAQuestionLambda.py" code="true" lang="python" >}}

### IAM Privileges
Using the concept of least privileges for each AWS Lambda function, we create an IAM role for this function that only allows certain access to the Well-Architected Tool (UpdateAnswer specifically) as well as the ability to create log file entries.
```yaml
UpdateWAQlambdaIAMRole:
  Type: AWS::IAM::Role
  Properties:
    AssumeRolePolicyDocument:
      Version: 2012-10-17
      Statement:
        - Action:
            - sts:AssumeRole
          Effect: Allow
          Principal:
            Service:
              - lambda.amazonaws.com
    Policies:
      - PolicyDocument:
          Version: 2012-10-17
          Statement:
            - Action:
                - logs:CreateLogGroup
                - logs:CreateLogStream
                - logs:PutLogEvents
              Effect: Allow
              Resource:
                - !Sub arn:aws:logs:${AWS::Region}:${AWS::AccountId}:log-group:/aws/lambda/${UpdateWAQLambdaFunctionName}:*
        PolicyName: lambda
      - PolicyDocument:
          Version: 2012-10-17
          Statement:
            - Action:
                - wellarchitected:GetAnswer
                - wellarchitected:GetWorkload
                - wellarchitected:List*
                - wellarchitected:TagResource
                - wellarchitected:UntagResource
                - wellarchitected:UpdateAnswer
              Effect: Allow
              Resource: '*'
        PolicyName: watool
```
