---
title: "Teardown"
date: 2020-12-17T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---

## Summary
You have learned how to use the various AWS CLI commands to work with the AWS Well-Architected Tool.

<!-- ## Additional Tasks -->
## Optional - Python code to perform the same lab steps
The lab uses AWS CLI to perform all of the tasks, but you can also use the Boto3 Python library to perform the same steps. As a reference, you can [download the LabExample.py code](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Code/LabExample.py) that would perform all of the same steps.


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


{{< prev_next_button link_prev_url="../5_view_report/"  title="Congratulations!" final_step="true" >}}
{{< /prev_next_button >}}
