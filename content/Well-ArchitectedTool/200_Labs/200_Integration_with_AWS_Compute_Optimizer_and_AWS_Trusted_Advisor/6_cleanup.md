---
title: "Teardown"
date: 2021-01-15T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---
 
## Summary
You have learned how to use the various AWS CLI commands to work with the AWS Well-Architected Tool.
 
## Remove all the resources
1. Delete the stack
    ```
    aws cloudformation delete-stack --stack-name STACK_NAME
    ```
2. Confirm the stack has been deleted
    ```
    aws cloudformation list-stacks --query "StackSummaries[?contains(StackName,'STACK_NAME')].StackStatus"
    ```
## References & useful resources
* [AWS CLI - wellarchitected](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/index.html)
* [AWS Well-Architected Tool Documentation](https://docs.aws.amazon.com/wellarchitected/)
* [AWS Well-Architected Boto3 Reference](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/wellarchitected.html)
* [AWS Well-Architected API Reference](https://docs.aws.amazon.com/wellarchitected/latest/APIReference/Welcome.html)
 
{{< prev_next_button link_prev_url="../4_perform_review/"  title="Congratulations!" final_step="true" >}}
{{< /prev_next_button >}}
 
