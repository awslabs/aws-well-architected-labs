---
title: "Query the workload data"
date: 2021-03-24T15:16:08+10:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

Although structured data remains the backbone of many data platforms, unstructured or semi structured data is used to enrich existing information or to create new insights. Amazon Athena enables you to analyze a variety of data, including:

-   Tabular data in comma-separated value (CSV) or Apache Parquet files
-   Data extracted from log files using regular expressions
-   JSON-formatted data

Athena is serverless, so there is no infrastructure to manage, and you pay only for the queries that you run. The AWS WA Tool data is represented as a nested JSON object. For example, running a simple SELECT query on the JSON data in Amazon Athena returns the following, where the underlying report_answers field is selected, but still represented in JSON format.

```
SELECT workload_id, workload_owner, report_answers
FROM "YOUR_DATABASE_NAME"."workloadreports"
LIMIT 4;

```


![report_answers](/Well-ArchitectedTool/300_Labs/300_Building_custom_AWS_Well-Architected_reports_with_Amazon_Athena_and_Amazon_QuickSight/Images/fig-7-report-answers.png)


#### Create a view for the workload answers data

Follow these steps to create a view in Amazon Athena to present the JSON data as a tabular view for reporting and visualizing. A view in Amazon Athena is a logical, not physical table. The query that defines a view runs each time the view is referenced in a query. From within the Amazon Athena console, open a new query tab and execute the following query:

```
CREATE OR REPLACE VIEW well_architected_reports_view AS
SELECT workload_id,
         workload_name,
         workload_owner,
CAST(from_iso8601_timestamp(workload_lastupdated) AS timestamp) AS "timestamp",
         answers.questionid,
         answers.QuestionTitle,
         answers.LensAlias,
         answers.pillarid,
         answers.risk
FROM "workloadreports"
CROSS JOIN unnest(report_answers) AS t(answers)
```

The SQL statement, UNNEST, takes the report_answers column from the original table as a parameter. It creates a new dataset with the new column answers, which is later cross-joined. The enclosing SELECT statement can then reference the new answers column directly. You can quickly query the view to see the result to understand how the report_answers are now represented.

```
SELECT workload_id, workload_owner, questionid, pillarid
FROM "YOUR_DATABASE_NAME"."well_architected_reports_view"
 LIMIT 4;

```

![well_architected_reports_view](/Well-ArchitectedTool/300_Labs/300_Building_custom_AWS_Well-Architected_reports_with_Amazon_Athena_and_Amazon_QuickSight/Images/fig-8-well-arch-reports-view.png)


#### Create a view for the workload risk counts data

Now create a view for a summary of risks associated with each lens for each workload.  Open a new query tab and execute the following query:

```
CREATE
        OR REPLACE VIEW well_architected_workload_lens_risk_view AS
SELECT workload_id,
         workload_name,
         lens.LensAlias,
         lens_pillar_summary.PillarId,
         lens_pillar_summary.RiskCounts.UNANSWERED,
         lens_pillar_summary.RiskCounts.HIGH,
         lens_pillar_summary.RiskCounts.MEDIUM,
         lens_pillar_summary.RiskCounts.NONE,
         lens_pillar_summary.RiskCounts.NOT_APPLICABLE
FROM "workloadreports"
CROSS JOIN unnest(lens_summary) AS t(lens)
CROSS JOIN unnest(lens.PillarReviewSummaries) AS tt(lens_pillar_summary)
```

Previewing the newly created well_architected_workload_risk_view:

```
SELECT *
FROM "YOUR_DATABASE_NAME"."well_architected_workload_risk_view"
LIMIT 4;
```

![well_architected_workload_risk_view](/Well-ArchitectedTool/300_Labs/300_Building_custom_AWS_Well-Architected_reports_with_Amazon_Athena_and_Amazon_QuickSight/Images/fig-9-well-arch-workload-risk-view.png)


#### Create a view for the workload's milestone data

A milestone records the state of a workload at a particular point in time. As a workload changes, you can add more milestones to measure progress. To enable visualization of this improvement across all workloads, create a view for a workload milestone.  Open a new query tab and execute the following query:

```
CREATE
        OR REPLACE VIEW well_architected_workload_milestone_view AS
SELECT CAST(from_iso8601_timestamp(milestone.RecordedAt) AS timestamp) AS "timestamp",
         workload_id,
         workload_name,
         workload_owner,
         milestone.MilestoneName,
         milestone.MilestoneNumber,
         milestone.WorkloadSummary.ImprovementStatus,
         milestone.WorkloadSummary.RiskCounts.HIGH,
         milestone.WorkloadSummary.RiskCounts.MEDIUM,
         milestone.WorkloadSummary.RiskCounts.UNANSWERED,
         milestone.WorkloadSummary.RiskCounts.NONE,
         milestone.WorkloadSummary.RiskCounts.NOT_APPLICABLE
FROM "workloadreports"
CROSS JOIN unnest(milestones) AS t(milestone)
```

Previewing the newly created well_architected_workload_risk_view:

```
SELECT *
FROM "YOUR_DATABASE_NAME"."well_architected_workload_milestone_view"
 LIMIT 4;

```

![well_architected_workload_milestone_view](/Well-ArchitectedTool/300_Labs/300_Building_custom_AWS_Well-Architected_reports_with_Amazon_Athena_and_Amazon_QuickSight/Images/fig-10-well-arch-workload-milestone-view.png)


{{< prev_next_button link_prev_url="../" link_next_url="../4_visualize/" />}}
