---
title: "How to utilize AWS Lambda-backed custom resources in CloudFormation"
menutitle: "Use Lambda in CloudFormation"
date: 2020-03-08T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Overview
In order to utilize the two Lambda-backed custom resources in CloudFormation, you will need the pass the Lambda ARN along with expected parameters to the Lambda. Below are examples for creating a new workload as well as updating two questions in the [Operational Excellence pillar.](https://docs.aws.amazon.com/wellarchitected/latest/operational-excellence-pillar/welcome.html)

## Example Workload Creation
When you use this custom function, it will either create the WA Workload (if it doesn't exist) or update the given parameters if it already does exist.

### Expected passed parameters
The AWS Lambda function expects the following parameters to be passed from CloudFormation:
* **WorkloadName** - Name of the Workload
* **WorkloadDesc** - Short description of the Workload
* **WorkloadOwner** - Team or person who owns this Workload
* **WorkloadEnv** - Environment for the workload. Must either be PRODUCTION or PREPRODUCTION
* **WorkloadRegion** - Region where the workload will live. **Must be a valid AWS region short name.**
* **WorkloadLenses** - A list of Lenses you want to apply to the Workload. Must be a valid WA Review Lens name.
* **Tags** - This can be any tag pair you wish to pass along

### Example AWS CloudFormation YAML
```yaml {linenos=table}
CreateWAWorkload:
  Type: Custom::createWAWorkloadHelperFunction
  Properties:
    ServiceToken: "arn:aws:lambda:us-east-2:123456789012:function:CreateNewWAFRFunction"
    WorkloadName: "My Workload Name"
    WorkloadDesc: "This is my new workload"
    WorkloadOwner: "Eric Pullen"
    WorkloadEnv: "PRODUCTION"
    WorkloadRegion: "us-east-2"
    WorkloadLenses:
      - "wellarchitected"
      - "serverless"
    Tags:
      WorkloadType: "ECSWebApp"
      WorkloadName: "ACMECustomerPortal"
```

### Update specific questions in a given pillar
Once you have a given Workload created, you can specify a set of questions and best practices you wish to select. This function requires the WorkloadId to be passed along, but it can be returned from the CreateWAWorkload function above.

### Expected passed parameters
The AWS Lambda function expects the following parameters to be passed from CloudFormation:
* **WorkloadId** - WorkloadId number that you wish to answer the question
* **Pillar** - The Well-Architected pillar you want to answer the question within. **Must be a valid WA Review Lens name.**
* **Lens** - The Well-Architected Lens you want to answer the question within. **Must be a valid WA Review Lens name.**
* **QuestionAnswers** - A List of questions and best practices you wish to answer. **These must match the text strings within the Well-Architected Tool**
  * **You can answer multiple questions within one pillar and lens with one call**

### Example AWS CloudFormation YAML
```yaml {linenos=table}
SECWAWorkloadQuestions:
  Type: Custom::AnswerSECWAWorkloadQuestionsHelperFunction
  Properties:
    ServiceToken: "arn:aws:lambda:us-east-2:123456789012:function:UpdateWAQFunction"
    WorkloadId: !GetAtt CreateWAWorkload.WorkloadId
    Pillar: "operationalExcellence"
    Lens: "wellarchitected"
    QuestionAnswers:
      - "How do you determine what your priorities are": # OPS1
        - "Evaluate governance requirements"
        - "Evaluate compliance requirements"
      - "How do you reduce defects, ease remediation, and improve flow into production": #OPS5
        - "Use version control"
        - "Perform patch management"
        - "Use multiple environments"
```

## Now that you understand the various parameters, let's deploy a sample application to show how this works.
