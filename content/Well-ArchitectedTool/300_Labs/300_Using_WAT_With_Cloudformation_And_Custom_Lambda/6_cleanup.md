---
title: "Teardown"
date: 2021-03-25T11:16:09-04:00
chapter: false
weight: 6
pre: "<b>6. </b>"
---

### Cleanup of CloudFormation
1. In the AWS Management Console, navigate to the [AWS CloudFormation console](https://console.aws.amazon.com/cloudformation/)
1. Select the stack `WALabDemoApp`, and delete it. Wait for that stack to full delete before moving on to the next step
1. Select the stack `WALambdaHelpers`, and delete it.

### Remove the WA Review
1. In the AWS Management Console, navigate to the [Well-Architected Tool Console](https://console.aws.amazon.com/wellarchitected/home)
1. Select the radio button next to the workload `APIGWLambda - walabs-api - WALabsSampleLambdaFunction`
1. Click the Delete button at the top page.

## References & useful resources
1. [Well-Architected Tool API](https://docs.aws.amazon.com/wellarchitected/latest/APIReference/Welcome.html)
1. [CloudFormation custom resource type.](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-custom-resources.html)
1. [Lambda Powertools Python](https://awslabs.github.io/aws-lambda-powertools-python/)

{{< prev_next_button link_prev_url="../6_programmatic/"  title="Congratulations!" final_step="true" >}}
{{< /prev_next_button >}}
