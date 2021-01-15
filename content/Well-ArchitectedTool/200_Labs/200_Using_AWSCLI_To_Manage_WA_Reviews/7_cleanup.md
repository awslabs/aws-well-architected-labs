---
title: "Teardown"
date: 2021-01-15T11:16:09-04:00
chapter: false
pre: "<b>7. </b>"
weight: 7
---

## Summary
You have learned how to use the various AWS CLI commands to work with the AWS Well-Architected Tool.

## Remove all the resources
1. Using the [delete-workload API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/delete-workload.html), you can remove the workload from the WA Tool.
    ```
    aws wellarchitected delete-workload --workload-id "<WorkloadId>"
    ```
    ![Remove1](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/6/Remove1.png)


## References & useful resources
* [AWS CLI - wellarchitected](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/index.html)
* [AWS Well-Architected Tool Documentation](https://docs.aws.amazon.com/wellarchitected/)
* [AWS Well-Architected Boto3 Reference](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/wellarchitected.html)
* [AWS Well-Architected API Reference](https://docs.aws.amazon.com/wellarchitected/latest/APIReference/Welcome.html)


{{< prev_next_button link_prev_url="../6_programmatic/"  title="Congratulations!" final_step="true" >}}
{{< /prev_next_button >}}
