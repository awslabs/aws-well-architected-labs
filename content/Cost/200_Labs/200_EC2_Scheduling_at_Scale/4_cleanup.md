---
title: "Teardown"
date: 2022-11-30T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

In this section you will delete all resources related to the lab environment.

#### Deleting the IAM role created by the CloudFormation Stack

1. Click [this link](https://us-east-1.console.aws.amazon.com/iamv2/home?region=us-east-1#/roles) to go the the IAM console.

2. In the search box, type ``walab-l200-scheduling-sample-env``. Then, select the role and click on the **Delete** button. Confirm deletion in the pop-up window.
![section4_1_teardown](/Cost/200_EC2_Scheduling_at_Scale/Images/section4_1_teardown.png)

#### Cleaning up the rest of the CloudFormation Stack resources

1. Click [this link](https://us-east-1.console.aws.amazon.com/cloudformation/home?region=us-east-1#/stacks) to go to CloudFormation in **us-east-1** region.

2. Select the **radio button** left to the Stack named ``InstanceScheduler``, and click the **Delete** button. Click the **Delete stack** button in the pop-up window.
![section4_2_teardown](/Cost/200_EC2_Scheduling_at_Scale/Images/section4_2_teardown.png)
![section4_3_teardown](/Cost/200_EC2_Scheduling_at_Scale/Images/section4_3_teardown.png)

3. Select the **radio button** left to the Stack named ``walab-l200-scheduling-sample-env``, and click the **Delete** button. Click the **Delete stack** button in the pop-up window.
![section4_4_teardown](/Cost/200_EC2_Scheduling_at_Scale/Images/section4_4_teardown.png)
![section4_5_teardown](/Cost/200_EC2_Scheduling_at_Scale/Images/section4_5_teardown.png)

{{< prev_next_button link_prev_url="../3_scheduling_at_scale/"  title="Congratulations!" final_step="true" >}}
You have now completed the lab! Learn more via:

* [COST06-BP03](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/cost_type_size_number_resources_metrics.html) - **Select resource type, size, and number automatically based on metrics**
* [COST09-BP01](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/cost_manage_demand_resources_cost_analysis.html) - **Perform an analysis on the workload demand**
* [COST09-BP03](https://docs.aws.amazon.com/wellarchitected/latest/cost-optimization-pillar/cost_manage_demand_resources_dynamic.html) - **Supply resources dynamically**
{{< /prev_next_button >}}