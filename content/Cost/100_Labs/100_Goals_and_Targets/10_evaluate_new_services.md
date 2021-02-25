---
title: "Evaluate New Services"
date: 2021-02-18T26:16:08-04:00
chapter: false
weight: 10
pre: "<b>10. </b>"
---


## Evaluate new services

#### Develop a workload review process
 - **Goal**: Perform Well-Architected reviews throughout a workloads lifecycle
 - **Target**: For Tier1 workloads each stage has a full review, for Tier2 and below workloads the minimum requirement is: In the development stage review Security, Reliability and Operational Excellence. In Performance test review Performance Efficiency and Cost Optimization.
 - **Best Practice**: [Optimize Over Time](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/optimize-over-time.html)
  - **Measures**: % of workloads reviewed in each stage
 - **Good/Bad**: Good
 - **Why? When does it work well or not?**: Ensures the correct level review is performed inline with organization requirements. It also allows for tradeoffs if the organization is prioritizing speed to market for some workloads.
 - **Contact/Contributor**: natbesh@amazon.com



---

#### Review and analyze this workload regularly
 - **Goal**: Perform Well-Architected reviews regularly on active workloads
 - **Target**: Tier1 workloads will have milestones with all pillars completed at least every 3 months, for Tier2 workloads milestones with all pillars are completed at least every 6 months, all other workloads are to have milestones with all pillars completed yearly.
 - **Best Practice**: [Optimize Over Time](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/optimize-over-time.html)
  - **Measures**: Number of milestones completed, number of teams delivering
 - **Good/Bad**: Good
 - **Why? When does it work well or not?**: Ensures workloads are actively maintained and inline with best practices. Will result in higher operational costs if there are minimal changes in the workload, and no additional services/features available.
 - **Contact/Contributor**: natbesh@amazon.com



{{< prev_next_button link_prev_url="../9_manage_demand_supply/"  title="Congratulations!" final_step="true" >}}
Now that you have completed the lab, if you have implemented this knowledge in your organization,
you should complete a milestone in the Well-Architected tool. This lab specifically helps you with
[COST2 - "How do you govern usage?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-expenditure-and-usage-awareness.html)
{{< /prev_next_button >}}




