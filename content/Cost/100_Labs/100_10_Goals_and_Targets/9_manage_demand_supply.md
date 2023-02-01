---
title: "Manage Demand & Supply Resources"
date: 2021-02-18T26:16:08-04:00
chapter: false
weight: 9
pre: "<b>9. </b>"
---


## Manage Demand, and Supply Resources

### Supply resources dynamically
#### Demand vs Supply
 - **Goal**: Minimize unused resources
 - **Target**: Workload resourcing should only deviate by a maximum of $x from workload demand
 - **Best Practice**: [Dynamic-based supply](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/dynamic-supply.html)
  - **Measures**: Deviation % and $
 - **Good/Bad**: Good
 - **Why? When does it work well or not?**: Ensure there is not an excess of resources compared to the workload demand, and if there is variable demand that the resourcing follows this closely.
 - **Contact/Contributor**: costoptimization@amazon.com


### Supply resources
#### Supply vs business/demand
 - **Goal**: Minimize unused resources
 - **Target**: Non-production or development/test workloads must not have more than 5% (by cost) of resources available outside of business hours
 - **Best Practice**: [Time-based supply](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/dynamic-supply.html)
  - **Measures**: Deviation %
 - **Good/Bad**: Good
 - **Why? When does it work well or not?**: Can be hard to track when development/test activities occur outside of defined hours.
 - **Contact/Contributor**: costoptimization@amazon.com



---


### Manage demand
#### Supply vs business/demand
 - **Goal**: Minimize unused resources
 - **Target**: Workload demand should not vary by more than 10% on any single day. 
 - **Best Practice**: [Manage Demand](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/manage-demand.html)
  - **Measures**: Deviation %
 - **Good/Bad**: Good
 - **Why? When does it work well or not?**: Will be unachievable when demand cannot be altered. Works well when demand can be throttled or buffered to smooth out the peaks.
 - **Contact/Contributor**: costoptimization@amazon.com



{{< prev_next_button link_prev_url="../8_data_transfer/" link_next_url="../10_evaluate_new_services/" />}}

