---
title: "Pricing Models"
date: 2021-02-18T26:16:08-04:00
chapter: false
weight: 7
pre: "<b>7. </b>"
---


## Pricing Models

### Savings Plans
#### Purchasing Savings Plans
 - **Goal**: Minimize resource cost by using Savings Plans
 - **Target**: Unpurchased Savings Plans offering more than 10% discount not to exceed $100
 - **Best Practice**: [Commitment Discounts - Savings Plans](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/select-the-best-pricing-model.html)
 - **Measures**: $ value of unpurchased plans above 10% discount
 - **Good/Bad**: Good
 - **Why? When does it work well or not?**: Maximizes high quality, low risk SP consumption, & ensures SP's that dont make business sense are not purchased
 - **Contact/Contributor**: costoptimization@amazon.com


#### Purchasing Savings Plans
 - **Goal**: Minimize resource cost by using Savings Plans
 - **Target**: Ensure 80% of my on-demand usage is covered with Savings Plans
 - **Best Practice**: [Commitment Discounts - Savings Plans](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/select-the-best-pricing-model.html)
 - **Measures**: Coverage %
 - **Good/Bad**: Bad
 - **Why? When does it work well or not?**: It ignores the return on investment in SP & the risk. If you run <100% uptime or small resources with licensed operating systems and/or software, there can be low returns & also high risks. It can force a purchase which would be a bad business decision
 - **Contact/Contributor**: costoptimization@amazon.com

---

### Reserved Instances
#### Purchase Reserved Instances
 - **Goal**: Minimize resource cost by using Reserved Instances
 - **Target**: Unpurchased Reserved Instances offering more than 10% discount, with a pay-off period of less than 9 months must not exceed $300
 - **Best Practice**: [Commitment Discounts - Reserved Instances](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/select-the-best-pricing-model.html)
  - **Measures**: $ value of unpurchased RI's above 10% discount that pay off in less than 9 months
 - **Good/Bad**: Good
 - **Why? When does it work well or not?**: Maximizes high quality, low risk RI consumption, & ensures RI's that dont make business sense are not purchased
 - **Contact/Contributor**: costoptimization@amazon.com


#### Purchase Reserved Instances
 - **Goal**: Maximize discounts by maximizing use of purchased Reserved Instances
 - **Target**: Have cost of low RI utilization below $100 for any purchased RI
 - **Best Practice**: [Commitment Discounts - Reserved Instances](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/select-the-best-pricing-model.html)
  - **Measures**: Wasted $ per RI
 - **Good/Bad**: Good
 - **Why? When does it work well or not?**: Minimizes waste from unused RI's, it ensures you only act when it makes business sense & effort can be recovered by making a change.
 - **Contact/Contributor**: costoptimization@amazon.com


#### Purchase Reserved Instances
 - **Goal**: Maximize discounts by maximizing use of purchased Reserved Instances
 - **Target**: Have RI utilization above 80%
 - **Best Practice**: [Commitment Discounts - Reserved Instances](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/select-the-best-pricing-model.html)
  - **Measures**: RI utilization %
 - **Good/Bad**: Bad
 - **Why? When does it work well or not?**: High amounts of effort required to know whether you're actually losing money, and how much money. It can work in environments that have only a few different resource types running. This target can lead to large effort resulting in minimal gains or even a loss.
 - **Contact/Contributor**: costoptimization@amazon.com


{{< prev_next_button link_prev_url="../6_resource_type_size_number/" link_next_url="../8_data_transfer/" />}}

