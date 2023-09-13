---
title: "Teardown"
date: 2020-06-09T12:00:00-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---
In this lab, you created two different EC2 instances and tested gettime system calls to each on to test the performance for each clocksource type.  You were able to set a new clocksource for a Xen based instance type and see a dramatic improvement in the time it takes for these kinds of system calls.


## Remove all the resources via CloudFormation
In order to remove the lab, go into the CloudFormation console, select the deployed template, click the drop down next to “Create Stack” and then click “Delete Stack”.  This should remove all components created for this Lab.

![Teardown1](/Performance/100_Clock_Source_Performance/Images/Teardown1.png)



## References & useful resources
* [AWS Systems Manager](https://aws.amazon.com/systems-manager/)
* [Nitro](https://aws.amazon.com/ec2/nitro/)
* [How to manage the clock source for EC2 instances running Linux](https://aws.amazon.com/premiumsupport/knowledge-center/manage-ec2-linux-clock-source/)


{{< prev_next_button link_prev_url="../3_change_clock/" title="Congratulations!" final_step="true"  />}}
Now that you have completed the lab, if you have implemented this knowledge in your environment, you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with [PERF2 - "Understand the available compute configuration options."](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-selection.html)
{{< prev_next_button />}}
