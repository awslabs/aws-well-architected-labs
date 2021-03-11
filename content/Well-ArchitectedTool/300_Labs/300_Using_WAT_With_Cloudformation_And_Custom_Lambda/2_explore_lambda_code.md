---
title: "Exploring AWS Lambda code"
menutitle: "Explore Lambda code"
date: 2020-03-08T11:16:08-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

## Overview
There are two AWS Lambda functions that you deployed in the previous step. Both of them utilize the [AWS SDK for Python (Boto3)](https://aws.amazon.com/sdk-for-python/) library along with the [Lambda Powertools Python](https://awslabs.github.io/aws-lambda-powertools-python/) via a Lambda layer to perform the [Well-Architected Tool API](https://docs.aws.amazon.com/wellarchitected/latest/APIReference/Welcome.html) access.

## Deployed AWS Lambda functions
Click on each link to understand how each Lambda function works.
* [CreateWAWorkloadLambda]({{< relref "#CreateWAWorkloadLambda" >}})
  * [Overview]({{< relref "#CreateWAWorkloadLambda_Overview" >}})
  * [Python Code]({{< relref "#CreateWAWorkloadLambda_Code" >}})
  * [Example Lambda Event]({{< relref "#CreateWAWorkloadLambda_ExampleEvent" >}})
  * [IAM Role]({{< relref "#CreateWAWorkloadLambda_IAM" >}})
* [UpdateWAQuestionLambda]({{< relref "#UpdateWAQuestionLambda" >}})
  * [Overview]({{< relref "#UpdateWAQuestionLambda_Overview" >}})
  * [Python Code]({{< relref "#UpdateWAQuestionLambda_Code" >}})
  * [Example Lambda Event]({{< relref "#UpdateWAQuestionLambda_ExampleEvent" >}})  
  * [IAM Role]({{< relref "#UpdateWAQuestionLambda_IAM" >}})

## CreateWAWorkloadLambda.py {#CreateWAWorkloadLambda}
### Overview {#CreateWAWorkloadLambda_Overview}
This Lambda function will create or update the workload and is idempotent based on the WorkloadName. The parameters for the workload are:
* **WorkloadName** - The name of the workload. The name must be unique within an account within a Region. Spaces and capitalization are ignored when checking for uniqueness.
* **WorkloadDesc** - The description for the workload.
* **WorkloadOwner** - The review owner of the workload. The name, email address, or identifier for the primary group or individual that owns the workload review process.
* **WorkloadEnv** - The environment for the workload. Valid Values: PRODUCTION | PREPRODUCTION
* **WorkloadRegion** - The list of AWS Regions associated with the workload, for example, us-east-2, or ca-central-1. Maximum number of 50 items.
* **WorkloadLenses** - The list of lenses associated with the workload. Each lens is identified by its LensAlias.
* **Tags** - The tags to be associated with the workload. Maximum number of 50 items.


### Python Code {#CreateWAWorkloadLambda_Code}
{{< readfile file="/static/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Code/Python/CreateWAWorkloadLambda.py" code="true" lang="python" highlightopts="linenos=table" >}}

### Example incoming Lambda event {#CreateWAWorkloadLambda_ExampleEvent}
This is an Lambda test event you can use to see if the Lambda function works as expected:
```json
{
  "RequestType": "Create",
  "ResponseURL": "http://pre-signed-S3-url-for-response",
  "StackId": "arn:aws:cloudformation:us-east-1:123456789012:stack/MyStack/guid",
  "RequestId": "unique id for this create request",
  "ResourceType": "Custom::CreateNewWAFRFunction",
  "LogicalResourceId": "CreateNewWAFRFunction",
  "ResourceProperties": {
    "ServiceToken": "arn:aws:lambda:us-east-1:123456789012:function:CreateNewWAFRFunction",
    "WorkloadName": "Lambda WA Workload Test",
    "WorkloadOwner": "Lambda Script",
    "WorkloadDesc": "Test Lambda WA Workload",
    "WorkloadRegion": "us-east-1",
    "WorkloadLenses": [
      "wellarchitected",
      "serverless"
    ],
    "WorkloadEnv": "PRODUCTION",
    "Tags": {
      "TestTag3": "TestTagValue4",
      "TestTag": "TestTagValue"
    }
  }
}
```


### IAM Privileges {#CreateWAWorkloadLambda_IAM}
Using the concept of least privileges for each AWS Lambda function, we create an IAM role for this function that only allows certain access to the Well-Architected Tool (CreateWorkload and UpdateWorkload specifically) as well as the ability to create log file entries (lines 29-34).
```yaml {linenos=table,hl_lines=["29-34"]}
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

### Overview {#UpdateWAQuestionLambda_Overview}
This Lambda function will update the answer to a specific question in a workload review. The parameters for the workload are:
* **WorkloadId** - The ID assigned to the workload. This ID is unique within an AWS Region.
* **Lens** - The alias of the lens, for example, wellarchitected or serverless.
* **Pillar** - The ID used to identify a pillar, for example, security.
* **QuestionAnswers** - An array of pillar Questions and associated best practices you wish to mark as selected.

### Python Code {#UpdateWAQuestionLambda_Code}
{{< readfile file="/static/watool/300_Using_WAT_With_Cloudformation_And_Custom_Lambda/Code/Python/UpdateWAQuestionLambda.py" code="true" lang="python" >}}


### Example incoming Lambda event {#UpdateWAQuestionLambda_ExampleEvent}
This is an Lambda test event you can use to see if the Lambda function works as expected:
```json
{
  "RequestType": "Create",
  "ServiceToken": "arn:aws:lambda:us-east-1:123456789012:function:UpdateWAQFunction",
  "ResponseURL": "http://pre-signed-S3-url-for-response",
  "StackId": "arn:aws:cloudformation:us-east-1:123456789012:stack/MyStack/guid",
  "RequestId": "unique id for this create request",
  "LogicalResourceId": "UpdateWAQFunction",
  "ResourceType": "Custom::UpdateWAQFunction",
  "ResourceProperties": {
    "ServiceToken": "arn:aws:lambda:us-east-1:123456789012:function:UpdateWAQFunction",
    "QuestionAnswers": [
      {
        "How do you determine what your priorities are": [
          "Evaluate governance requirements",
          "Evaluate compliance requirements"
        ]
      },
      {
        "How do you reduce defects, ease remediation, and improve flow into production": [
          "Use version control",
          "Perform patch management",
          "Use multiple environments"
        ]
      }
    ],
    "Pillar": "operationalExcellence",
    "Lens": "wellarchitected",
    "WorkloadId": "d1a1d1a1d1a1d1a1d1a1d1a1d1a1d1a1"
  }
}
```
### IAM Privileges {#UpdateWAQuestionLambda_IAM}
Using the concept of least privileges for each AWS Lambda function, we create an IAM role for this function that only allows certain access to the Well-Architected Tool (UpdateAnswer specifically) as well as the ability to create log file entries (lines 29-34).

```yaml {linenos=table,hl_lines=["29-34"]}
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
{{< prev_next_button link_prev_url="../1_deploy_cfn/" link_next_url="../3_how_to_use_in_cfn/" />}}
