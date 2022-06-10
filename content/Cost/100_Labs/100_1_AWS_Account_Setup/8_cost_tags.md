---
title: "Enable AWS-Generated Cost Allocation Tags"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>8. </b>"
weight: 8
---

Enabling AWS-Generated Cost Allocation Tags, generates a cost allocation tag containing resource creator information. This is automatically applied to resources that are created, and allows you to view and allocate costs based on who created a resource.

1. Log in to your **Management Account** as an IAM user with the required permissions, and go to the **Billing** console:
![Images/AWSBillTag0.png](/Cost/100_1_AWS_Account_Setup/Images/AWSBillTag0.png)

2. Select **Cost Allocation Tags** from the left menu:
![Images/AWSBillTag1.png](/Cost/100_1_AWS_Account_Setup/Images/AWSBillTag1.png)

3. Click on **AWS-generated cost allocaiton tags**:
![Images/AWSBillTag2.png](/Cost/100_1_AWS_Account_Setup/Images/AWSBillTag2.png)

4. Select *aws:createdBy* tag key and click on **Activate** to enable the tag:
![Images/AWSBillTag3.png](/Cost/100_1_AWS_Account_Setup/Images/AWSBillTag3.png)

5. Click on **Activate** to confirm that you want to activate the tag:
![Images/AWSBillTag4.png](/Cost/100_1_AWS_Account_Setup/Images/AWSBillTag4.png)
 
6. You will see that it is activated:
![Images/AWSBillTag5.png](/Cost/100_1_AWS_Account_Setup/Images/AWSBillTag5.png)

{{< prev_next_button link_prev_url="../7_cost_explorer/" link_next_url="../9_monthly_report/" />}}
