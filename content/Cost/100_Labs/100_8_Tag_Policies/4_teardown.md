---
title: "Teardown"
date: 2021-05-20T11:16:08-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

The following resources were created in this lab:
- Created a Tag Policy (Cost Allocation)
- Created Tagged and Untagged EC2 Resources


1. Navigate to the AWS Organizations service using the navigation bar and click the link for the account in which you applied the policy

![Images/AWSTagPol21.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol21.png)

2. Select “Policies” beneath the Account details box. Underneath Tag policies, within “Attached policies” you should see the name of the tag policy you created. Select the radio button next to the name of the tag policy, and click “Detach”

![Images/AWSTagPol22.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol22.png)

3. In the left-hand panel navigate to Policies and select Tag Policies

![Images/AWSTagPol23.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol23.png)

4. Click the box next to the tag policy you created. Under actions select “Delete policy”

![Images/AWSTagPol24.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol24.png)

5. Navigate to the EC2 console, select the EC2 instances you created and select "Terminate instance"

![Images/AWSTagPol25.png](/Cost/100_8_Tag_Policies/Images/AWSTagPol25.png)

{{< prev_next_button link_prev_url="../3_compliance_report/"  title="Congratulations!" final_step="true"  />}}
Now that you have completed the lab, if you have implemented this knowledge in your environment,
you should re-evaluate the questions in the Well-Architected tool. This lab specifically helps you with
[COST3 - "How do you monitor usage and cost?"](https://docs.aws.amazon.com/wellarchitected/latest/framework/a-expenditure-and-usage-awareness.html)
{{< prev_next_button />}}
