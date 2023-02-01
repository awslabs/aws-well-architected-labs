---
title: "Monitor Cost and Usage"
date: 2021-02-18T26:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---


## Monitor Cost and Usage

### Allocate costs based on workload metrics
#### Measure efficiency
 - **Goal**: Measure workload efficiency
 - **Target**: Within 6 months all Tier1 workloads must have efficiency dashboards, within 12months all Tier2 workloads must have efficiency dashboards.
 - **Best Practice**: [Allocate costs based on workload metrics](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/monitor-cost-and-usage.html)
  - **Measures**: % of workloads with dashboards
 - **Good/Bad**: Good
 - **Why? When does it work well or not?**: Ensures the organization is focusing on the correct metric (efficiency), and not the bill.
 - **Contact/Contributor**: costoptimization@amazon.com

---

### Costs
####
 - **Goal**: Reduction in bill
 - **Target**: Reduce the bill by x% in the next billing cycle
 - **Best Practice**: [Decommission Resources](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/decommission-resources.html)
  - **Measures**: Reduction in bill
 - **Good/Bad**: Bad
 - **Why? When does it work well or not?**: Does not drive improvement or capability building, can stifle innovation and positive growth. Does not factor in outcomes - ignores efficiency. Can have false positives - goal can be achieved by doing nothing if next months usage decreases, or impossible to achieve if next months usage is significantly higher
 - **Contact/Contributor**: costoptimization@amazon.com

---

### Assign business value to costs & usage
#### Tagging
 - **Goal**: Add tags to all of our bill (where possible)
 - **Target**: No more than $100 a month of taggable spend, is to be un-tagged
 - **Best Practice**: [Assign organization meaning to cost and usage](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/monitor-cost-and-usage.html)
  - **Measures**: % of tag-able bill untagged
 - **Good/Bad**: Good
 - **Why? When does it work well or not?**: Helps add meaning to cost and usage, allows for adjustment between effort/reward with the % of bill approach, instead of using resource count.
 - **Contact/Contributor**: costoptimization@amazon.com



{{< prev_next_button link_prev_url="../2_govern_usage/" link_next_url="../4_decommission_resources/" />}}


