---
title: "Resource Type, Size & Number"
date: 2021-02-18T26:16:08-04:00
chapter: false
weight: 6
pre: "<b>6. </b>"
---


## Resource Type, Size, & Number

### Resource Size
#### Over-provisioning
 - **Goal**: Minimize waste due to over-provisioning
 - **Target**: Waste due to compute over-provisioing in the 1st tier of production workloads not to exceed 10% of tier compute cost, as reported by tool X. Waste due to compute over-provisioining in the 2nd tier of production workloads not to exceed 5% of tier compute cost.
 - **Best Practice**: [Data-based selection](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/select-the-correct-resource-type-size-and-number.html)
  - **Measures**: % of over provisioning
 - **Good/Bad**: Good
 - **Why? When does it work well or not?**: Provides a $ amount, allows headroom for demand spikes & time to scale
 - **Contact/Contributor**: natbesh@amazon.com

---


{{< prev_next_button link_prev_url="../5_select_services/" link_next_url="../7_pricing_models/" />}}


