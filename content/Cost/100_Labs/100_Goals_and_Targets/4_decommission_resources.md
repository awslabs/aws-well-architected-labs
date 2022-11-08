---
title: "Decommission Resources"
date: 2021-02-18T26:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---


## Decommission resources

### Decommission resources automatically
#### 
 - **Goal**: Reduce decommission costs of workloads
 - **Target**: All workloads are to have automatic decommission of non-ephemeral storage resources.
 - **Best Practice**: [Decommission resources automatically](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/decommission-resources.html)
  - **Measures**: % of workloads with automatic decommission, cost of non-decommissioned resources
 - **Good/Bad**: Good
 - **Why? When does it work well or not?**: Reduce cost of manual decommission work
 - **Contact/Contributor**: costoptimization@amazon.com

---

#### 
 - **Goal**: Reduce waste
 - **Target**: Reduce waste by x%
 - **Best Practice**: [Decommission resources](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/decommission-resources.html)
  - **Measures**: amount of waste removed
 - **Good/Bad**: Bad
 - **Why? When does it work well or not?**: Does not work long term as it requires waste to always exist, but it could be possibly used as a short term goal. Instead, set a positive goal of minimizing waste creation - such as having waste not exceed a set $ amount.
 - **Contact/Contributor**: costoptimization@amazon.com



{{< prev_next_button link_prev_url="../3_monitor_cost_usage/" link_next_url="../5_select_services/" />}}


