---
title: "Viewing and downloading the report"
date: 2020-12-17T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

### Overview
You can generate a workload report for a lens. The report contains your responses to the workload questions, your notes, and the current number of high and medium risks identified.

### 1. Gather pillar and risk data for a workload
1. Using the [get-lens-review API](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/get-lens-review.html), you can retrieve the pillar review summaries for the workload:
    ```
    aws wellarchitected get-lens-review --workload-id "<WorkloadId>" --lens-alias "wellarchitected"
    ```
1. This will return a summary of the workload review summaries for each pillar.  
    ![Report1](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/5/Report1.png)

### 1. Generate and download workload PDF
1. Using the [get-lens-review-report](https://awscli.amazonaws.com/v2/documentation/api/latest/reference/wellarchitected/get-lens-review-report.html), you can retrieve the pillar review report in PDF format:
    ```
    aws wellarchitected get-lens-review-report --workload-id "<WorkloadId>" --lens-alias "wellarchitected" --query 'LensReviewReport.Base64String' --output text | base64 --decode > WAReviewOutput.pdf
    ```
1. This will export the object into a PDF report file.  
    ![Report2](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/5/Report2.png)
    ![Report3](/watool/200_Using_AWSCLI_To_Manage_WA_Reviews/Images/5/Report3.png)



{{< prev_next_button link_prev_url="../4_save_milestone/" link_next_url="../6_programmatic/" />}}
