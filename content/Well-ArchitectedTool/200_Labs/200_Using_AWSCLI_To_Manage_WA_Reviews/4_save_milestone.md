---
title: "Saving a milestone"
date: 2020-12-17T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

### Overview
A milestone records the state of a workload at a particular point in time.

Save a milestone after you initially complete all the questions associated with a workload. As you change your workload based on items in your improvement plan, you can save additional milestones to measure progress.

A best practice is to save a milestone when you first do a new W-A review, or every time you make improvements to a workload.

### 1. Create a Milestone
1. Using the [create-milestone API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/create-milestone.html) we will save our current progress as our first milestone
    ```
    aws wellarchitected create-milestone --workload-id "<WorkloadId>" --milestone-name Rev1
    ```
1. The return value will be the WorkloadId and the Milestone number assigned.
    ![Milestone1](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/4/Milestone1.png?classes=lab_picture_auto)

### 2. List all milestones
1. If we want to see all milestones associated with a workload
1. Using the [list-milestones API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/list-milestones.html) you can see all milestones associated with a workload
    ```
    aws wellarchitected list-milestones --workload-id "<WorkloadId>" --max-results 50
    ```
1. This will return a summary of the milestones you have created for the workload.
    ![Milestone2](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/4/Milestone2.png?classes=lab_picture_auto)

### 3. Retrieve the results from a milestone
1. Using the [get-milestone API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/get-milestone.html), you can see all of the metadata for a specific milestone:
    ```
    aws wellarchitected get-milestone --workload-id "<WorkloadId>" --milestone-number 1
    ```
1. This will return the complete workload information for the workload milestone (such as when it was created and what lenses were included)
    ![Milestone3](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/4/Milestone3.png?classes=lab_picture_auto)

### 4. List all question answers based from a milestone
1. If you want to see all of the best practices for when the milestone was created, you can use
1. Using the [list-answers API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/list-answers.html), you can see all of the best practices for when the milestone was created:
    ```
    aws wellarchitected list-answers --workload-id "<WorkloadId>" --lens-alias "wellarchitected" --milestone-number 1
    ```
1. This will return a large json structure with all of the questions and best practices for each pillar.
    ![Milestone4](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/4/Milestone4.png?classes=lab_picture_auto)

{{< prev_next_button link_prev_url="../3_perform_review/" link_next_url="../5_view_report/" />}}
