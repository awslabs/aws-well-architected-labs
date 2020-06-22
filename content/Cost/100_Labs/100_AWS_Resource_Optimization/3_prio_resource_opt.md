---
title: "Download the Amazon EC2 Resource Optimization CSV File and sort it to find quick wins"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

1. Download the **Amazon EC2 Resource Optimization** report:
![Images/ResourceOpt06b.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt06b.png)

2. If you don’t have any Amazon EC2 Resource Optimization recommendation use the file below as a reference.
[Sample Amazon EC2 Resource Optimization file (.csv)](/Cost/100_AWS_Resource_Optimization/Code/ENT206-ec2-rightsizing-recommendations.csv)

3. First let’s exclude instances that are too small or were only running for a few hours from the analysis. By doing so, we minimize the time required to perform rightsizing modifications that would otherwise result in minimal savings.
![Images/ResourceOpt07.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt07.png)

**NOTE**: Depending on how many cost allocation tags you have enabled on your account the columns may differ from the example, that said try to match the formulas using the screenshots below and the default column names.

Insert a new column to the right of the *Recommended Action* column. The first row will be the label for the column “TooSmall”. In each row below the label, paste the following formula:
```
=IF(Q2<25,1,0)
```
Where *Column Q = Recommended Instance Type 1 Estimated Savings*

That formula will flag all EC2 instances with a “1” any instance that will fail to deliver more than $25/month in savings (or $300/year). Feel free to adjust the threshold for your organization own savings expectation. If you prefer to perform the analysis against instance families instead of potential savings you can use the following formula to exclude smaller instances from the recommendations as well.
```
=IF(N2="Modify",IF(SUMPRODUCT(--(NOT(ISERR(SEARCH({"nano","micro","small","medium"},D2)))))>0,"1","0"),"0")
```
Where *Column N = Recommended Action* and *Column D = Instance Type*

4. Next, let’s flag EC2 instances that belong to previous generations (C4, M3, etc), if you are investing engineer time on right sizing let's make sure you are also leveraging the newest technology available. Newer EC2 generations have a superior performance increasing the changes of success for the right sizing exercise, they also generally cost less than previous generations providing a higher cost vs benefit.

![Images/ResourceOpt08.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt08.png)

Insert a new column **Old Gen** to the right of the *Instance Type* field, and paste the following formula:
```
=IF(SUMPRODUCT(--(NOT(ISERR(SEARCH({"c4","c3","c1","m4","m3","m2","m1","r3","r4","i2","cr1","hs1","g2"},D2)))))>0,"1","0")
```
*Column D = Instance Type*

5. Now let’s sort the recommendations by low complexity and higher savings:

**Minimum Effort:** Set the minimum savings required

First we want to only focus on savings that are worth our effort, we will define this as $100. Apply a **number filter** on **Recommended Instance Type 1 Estimated Savings** that is **Greater than 100**

**Group 1:** Idle EC2 resources

Filter the data on **Recommended Action = "Terminate"**

Sort the data by **Recommended Instance Type 1 Estimated Savings = Largest to smallest**

Start filtering the idle resources or instances where CPU utilization <1%, it is likely these instances were launched and forgotten so the potential savings here may represent the entire On Demand cost.

![Images/ResourceOpt09.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt09.png)

The resulting filtered list should be where you start right sizing discussions with application owners; perform an investigation to understand why these instance were launched and validate their usage with the resource owner. If possible, terminate them.

If you are using the Right Sizing CSV file provided in this lab exercise, you will notice that we filtered down from an original *2,534 recommendations to 16* and *identified $3,458 per month in potential savings*.

**Group 2:** Previous generation instances

Filter the data on **Recommended Actions = “Modify”** AND **OldGen = “1”** AND **TooSmall = “0”**

Filter the data on **Recommended Instance Type 1 Projected CPU < 40%**

Sort the data by **Recommended Instance Type 1 Estimated Savings = Largest to smallest**

This will focus on the underutilized resources (<40% CPU) that belongs to previous generations and can either be downsized within the same family (column P below) or modernized to the newest generation.

![Images/ResourceOpt10.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt10.png)

Moving to a modern generation may require additional testing hours compared to instances identified on Group 1, but depending on the case it can maximize savings and performance.

|          | Linux     | vs new gen | Windows   | vs new gen |          | Linux     | vs new gen | Windows   | vs new gen |
| -------- |:---------:| ----------:|:---------:| ----------:| -------- |:---------:| ----------:|:---------:| ----------:|
| c3.large | $0.105/hr |     up 19% | $0.188/hr |      up 5% | m3.large | $0.133/hr |     up 27% | $0.259/hr |     up 27% |
| c4.large | $0.100/hr |     up 15% | $0.192/hr |      up 7% | m4.large | $0.100/hr |      up 4% | $0.192/hr |      up 2% |
| c5.large | $0.985/hr |         0% | $0.177/hr |         0% | m5.large | $0.096/hr |         0% | $0.188/hr |         0% |

*prices are from US-Virginia (Nov 2019)*

If you are using the Right Sizing CSV file provided in this lab exercise, you will notice that we filtered down from originally *2,534 recommendations to 22* with *$6,362 per month in potential savings*.

**Group 3:** Current generation instances

Filter the data on **Recommended Actions = “Modify”** AND **OldGen = “0”** AND **TooSmall = “0”**

The filter on **Recommended Instance Type 1 Projected CPU < 40%** should still be in place.

Sort the data by **Recommended Instance Type 1 Estimated Savings = Largest to smallest**

This will select underutilized resources from the current, most modern generation. We recommend sorting them by potential savings to make sure you are prioritizing the instances that will provide larger savings first.

![Images/ResourceOpt11.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt11.png)

Also, do not forget to check the other recommended instance types (columns U to AD); Amazon EC2 Resource Optimization will recommend up to 3 instances for each resource moving from a more conservative recommendation (the first recommendation) to a more aggressive and higher savings recommendation (second and third recommendations).

If you are using the Right Sizing CSV file provided in this lab exercise, you will notice that we filtered down from originally *2,534 recommendations to 22* with *$4,879.56 per month in potential savings*.
