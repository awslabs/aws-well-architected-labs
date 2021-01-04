---
title: "Create a Well-Architected Workload"
date: 2020-12-17T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

## Overview
Well-Architected Reviews are conducted per workload . A workload identifies a set of components that deliver business value. The workload is usually the level of detail that business and technology leaders communicate about.

## Creating a workload
1. We will start with creating a Well-Architected workload to use throughout this lab.
1. Using the [create-workload API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/create-workload.html), you can create a new Well-Architected workload:
    ```
    aws wellarchitected create-workload --workload-name "WA Lab Test Workload" --description "Test Workload for WA Lab" --review-owner "John Smith" --environment "PRODUCTION" --aws-regions "us-east-1" --lenses "wellarchitected" "serverless"
    ```
    * The following are the required parameters for the command:
      * **workload-name** - This is a uniquie identifier for the workload. Must be between 3 and 100 characters.
      * **description** - A brief description of the workload to document its scope and intended purpose. Must be between 3 and 250 characters.
      * **review-owner** - The name, email address, or identifier for the primary individual or group that owns the review process. Must be between 3 and 255 characters.
      * **environment** - The environment in which your workload runs. This must either be PRODUCTION or PREPRODUCTION
      * **aws-regions** - The aws-regions in which your workload runs (us-east-1, etc).
      * **lenses** - The list of lenses associated with the workload. All workloads must include the "wellarchitected" lens as a base, but can include additional lenses. For this lab, we are also including the serverless lens.
        * Using the [list-lenses API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/list-lenses.html) you can get a list of lenses:
          `aws wellarchitected list-lenses`
1. Once the command is run, you should get a response that contains the workload json structure. This will include the following items:
    ![CreateWorkload1](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/2/CreateWorkload1.png)
    * **WorkloadId** - The ID assigned to the workload. This ID is unique within an AWS Region.
    * **WorkloadArn** - The [ARN](https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html) for the workload.

## Finding your WorkloadId
1. Assume you created a new workload, but you did not write down the WorkloadId to use in subsequent API calls.
1. Using the [list-workloads API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/clist-workloads.html), you can find the WorkloadId by using a search for the workload name prefix:
    `aws wellarchitected list-workloads --workload-name-prefix "WA Lab"`
1. You should get back a response that includes the WorkloadId along with other information about the workload that starts with "WA Lab"
![FindWorkloadId1](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/2/FindWorkloadId1.png)
1. If you want to only return the WorkloadId, you can use the AWS CLI query parameter to query for the value:
    `aws wellarchitected list-workloads --workload-name-prefix "WA Lab" --query 'WorkloadSummaries[].WorkloadId' --output text`
    ![FindWorkloadId2](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/2/FindWorkloadId2.png)


## Using WorkloadId to remove and add lenses
1. In the first step, we added the serverless lens to our new workload. Next, we will remove and then re-add this lens to the workload.
1. Make sure you have the WorkloadId from the previous step and replace **WorkloadId** with it
1. Using the [get-workload API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/get-workload.html), lets check which lenses are associated with our workload.
    `aws wellarchitected get-workload --workload-id "<WorkloadId>" --query 'Workload.Lenses[]'`
    ![AddRemoveLens1](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/2/AddRemoveLens1.png)
1. You should see serverless listed as a lens.
1. Using the [disassociate-lenses API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/disassociate-lenses.html) we will remove the serverless lens.
    `aws wellarchitected disassociate-lenses --workload-id "<WorkloadId>" --lens-aliases "serverless"`
{{% notice warning %}}
When you use disassociate-lenses, it will be destructive and irreversible to any questions you have answered if you have not saved a milestone. Saving a milestone is recommended before you use the disassociate-lenses API call.
{{% /notice %}}
1. You will not get a response to this command, but using the [get-workload API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/get-workload.html) you can verify that the lens was removed.
    `aws wellarchitected get-workload --workload-id "<WorkloadId>"`
1. You should see a response such as this, showing that you no longer have serverless listed.
    ![AddRemoveLens2](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/2/AddRemoveLens2.png)
1. Using the [associate-lenses API]() we can add the serverless lens back into the workload.
    `aws wellarchitected associate-lenses --workload-id "<WorkloadId>" --lens-aliases "serverless"`
1. Again, you will not see a response to this command, but we can verify that it was added by doing another [get-workload](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/get-workload.html)
    `aws wellarchitected get-workload --workload-id "<WorkloadId>"`
    ![AddRemoveLens3](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/2/AddRemoveLens3.png)


{{< prev_next_button link_prev_url="../1_configure_env/" link_next_url="../3_perform_review/" />}}
