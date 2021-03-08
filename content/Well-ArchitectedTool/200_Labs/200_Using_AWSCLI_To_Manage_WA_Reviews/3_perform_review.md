---
title: "Performing a review"
date: 2020-12-17T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

## Overview
Now that we have created a workload, we will answer the question **OPS 5. How do you reduce defects, ease remediation, and improve flow into production**. For this question, we will select a subset of the best practices, affirming them as true (turning them from unchecked to checked):
  * Use version control
  * Use configuration management systems
  * Use build and deployment management systems
  * Perform patch management
  * Use multiple environments


### Step 1 - Find the QuestionId and ChoiceID for a particular pillar question and best practice
1. Make sure you have the WorkloadId from the previous step and replace **WorkloadId** with it
1. To find the OPS 5 question listed above, we will search through the pillar for any question that begins with the string of the question.
1. The simplest way to find the QuestionId for a pillar is to search the output from the list-answers API call.
1. Using the [list-answers API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/list-answers.html), we can search the output for the question we want to answer.
    ```
    aws wellarchitected list-answers --workload-id "<WorkloadId>" --lens-alias "wellarchitected" --pillar-id "operationalExcellence" --query 'AnswerSummaries[?starts_with(QuestionTitle, `How do you reduce defects, ease remediation, and improve flow into production`) == `true`].QuestionId'
    ```
1. This will return the value of the QuestionId, in this case **dev-integ**
    ![FindQid1](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/3/FindQid1.png?classes=lab_picture_auto)
1. Next, using the [get-answer API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/get-answer.html) we can find the ChoiceId values of each answer. For this first command, we will get the ChoiceId for "Use version control"
    ```
    aws wellarchitected get-answer --workload-id "<WorkloadId>" --lens-alias "wellarchitected" --question-id "dev-integ" --query 'Answer.Choices[?starts_with(Title, `Use version control`) == `true`].ChoiceId'
    ```
1. This will return the value of the ChoiceId, in this case **ops_dev_integ_version_control**
    ![FindQid2](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/3/FindQid2.png?classes=lab_picture_auto)
1. Now we need to get the rest of the ChoiceID's for each of the best practices we want to select for the question
    ```
    aws wellarchitected get-answer --workload-id "<WorkloadId>" --lens-alias "wellarchitected" --question-id "dev-integ" --query 'Answer.Choices[?starts_with(Title, `Use configuration management systems`) == `true`].ChoiceId'
    ```

    ```
    aws wellarchitected get-answer --workload-id "<WorkloadId>" --lens-alias "wellarchitected" --question-id "dev-integ" --query 'Answer.Choices[?starts_with(Title, `Use build and deployment management systems`) == `true`].ChoiceId'
    ```

    ```
    aws wellarchitected get-answer --workload-id "<WorkloadId>" --lens-alias "wellarchitected" --question-id "dev-integ" --query 'Answer.Choices[?starts_with(Title, `Perform patch management`) == `true`].ChoiceId'
    ```
    ```
    aws wellarchitected get-answer --workload-id "<WorkloadId>" --lens-alias "wellarchitected" --question-id "dev-integ" --query 'Answer.Choices[?starts_with(Title, `Use multiple environments`) == `true`].ChoiceId'
    ```  
1. This will return the rest of the values we need for ChoiceID:
    ```
    ops_dev_integ_conf_mgmt_sys
    ops_dev_integ_build_mgmt_sys
    ops_dev_integ_patch_mgmt
    ops_dev_integ_multi_env
    ```
    <!-- ![FindQid3](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/3/FindQid3.png) -->



### Step 2 - Use the QuestionID and ChoiceID to update the answer in well-architected review
1. After finding the ChoiceID's in the previous step, we can "check" each of those items off as achieved using the CLI as well. The next step will set the choiceID's to true, but leave the rest of the best practices as false (unchecked).
1. Using the [update-answer API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/update-answer.html) we can update the well-architected workload using the the QuestionId and the ChoiceId's we gathered above.
    ```
    aws wellarchitected update-answer --workload-id "<WorkloadId>" --lens-alias "wellarchitected" --question-id "dev-integ" --selected-choices ops_dev_integ_version_control ops_dev_integ_conf_mgmt_sys ops_dev_integ_build_mgmt_sys ops_dev_integ_patch_mgmt ops_dev_integ_multi_env
    ```
1. This will return the JSON object for the question, and at the bottom you will see SelectedChoices is now populated with the answers we have provided. Because we still have have not checked all critical best practices, this question has still been identified as a high risk item (HRI).
![FindQid5](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/3/FindQid5.png?classes=lab_picture_auto)

### OPTIONAL: Repeat steps 1 and 2 but for the other pillar questions and best practices listed below
1. SEC 1. How do you securely operate your workload?
    * Separate workloads using accounts
    * Secure AWS account
    * Keep up to date with security threats
1. REL 2. How do you plan your network topology?
    * Use highly available network connectivity for your workload public endpoints
    * Provision redundant connectivity between private networks in the cloud and on-premises environments
    * Ensure IP subnet allocation accounts for expansion and availability
    * Prefer hub-and-spoke topologies over many-to-many mesh
    * Enforce non-overlapping private IP address ranges in all private address spaces where they are connected
1. PERF 5. How do you configure your networking solution?
    * Understand how networking impacts performance
    * Evaluate available networking features
    * Choose appropriately sized dedicated connectivity or VPN for hybrid workloads
    * Leverage load-balancing and encryption offloading
    * Choose network protocols to improve performance
    * Choose your workload’s location based on network requirements
1. COST 3. How do you monitor usage and cost?
    * Configure detailed information sources
    * Identify cost attribution categories
    * Establish organization metrics
    * Configure billing and cost management tools
    * Add organization information to cost and usage



{{< prev_next_button link_prev_url="../2_create_workload/" link_next_url="../4_save_milestone/" />}}
