---
title: "Prioritizing Amazon EC2 Resource Optimization recommendations"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 4
pre: "<b>4. </b>"
---

Now that you understand how Amazon EC2 Resource Optimization works let's run an example and find how to prioritize quick wins.

#### 1. Download the **Amazon EC2 Resource Optimization** report:
![Images/ResourceOpt09.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt09.png)

If you don’t have any Amazon EC2 Resource Optimization recommendation use the file below as a reference.

[Sample Amazon EC2 Resource Optimization file (.csv)](/Cost/100_AWS_Resource_Optimization/Code/ENT206-ec2-rightsizing-recommendations.csv)

#### 2. Let’s filter out instances that are either too small or were only running for a few hours since the analysis was made.

By doing so, we minimize the time required to perform rightsizing modifications that would otherwise result in minimal savings.

![Images/ResourceOpt10.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt10.png)

**NOTE**: Depending on how many cost allocation tags you have enabled on your account the columns may differ from the example, that said try to match the formulas using the screenshots below and the default column names.

Insert a new column to the right of the *Recommended Action* column. The first row will be the label for the column “TooSmall”. In each row below the label, paste the following formula:
```
=IF(X2<25,1,0)
```
Where *Column X = Recommended Instance Type 1 Estimated Savings*

That formula will flag all EC2 instances with a “1” any instance that will fail to deliver more than $25/month in savings (or $300/year). Feel free to adjust the threshold for your organization own savings expectation. If you prefer to perform the analysis against instance families instead of potential savings you can use the following formula to exclude smaller instances from the recommendations as well.
```
=IF(N2="Modify",IF(SUMPRODUCT(--(NOT(ISERR(SEARCH({"nano","micro","small","medium"},E2)))))>0,"1","0"),"0")
```
Where *Column V = Recommended Action* and *Column E = Instance Type*

#### 3. Now let’s flag EC2 instances that belong to old generations (C4, M3, etc).

Since you are investing engineer time on right sizing let's make sure you are also leveraging the newest technology available. Newer EC2 generations have a superior performance increasing the changes of success for the right sizing exercise, they also generally cost less than previous generations providing a higher cost vs benefit.

![Images/ResourceOpt12.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt11.png)

Insert a new column **Old Gen** to the right of the *Instance Type* field, and paste the following formula:
```
=IF(SUMPRODUCT(--(NOT(ISERR(SEARCH({"c4","c3","c1","m4","m3","m2","m1","r3","r4","i2","cr1","hs1","g2"},E2)))))>0,"1","0")
```
*Column E = Instance Type*

That formula will flag with a "1" instances from old generations.

#### 4. Sort the recommendations by low complexity and higher savings.

##### **Group 1:** Idle EC2 resources

Filter the data on **Recommended Action = "Terminate"**

Sort the data by **Recommended Instance Type 1 Estimated Savings = Largest to smallest**

Start filtering the idle resources or instances where CPU utilization <1%, it is likely these instances were launched and forgotten so the potential savings here may represent the entire On Demand cost.

![Images/ResourceOpt13.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt12.png)

The resulting filtered list should be where you start right sizing discussions with application owners; perform an investigation to understand why these instance were launched and validate their usage with the resource owner. If possible, terminate them.

If you are using the Right Sizing CSV file provided in this lab exercise, you will notice that we filtered down from an original **2,534 recommendations to 16** and **identified $3,458 per month in potential savings**.

##### **Group 2:** Previous generation instances

Filter the data on **Recommended Actions = “Modify”** AND **OldGen = “1”** AND **TooSmall = “0”**

Sort the data by **Recommended Instance Type 1 Estimated Savings = Largest to smallest**

This will focus on the underutilized resources (>1% CPU) that belongs to previous generations and can either be downsized within the same family (column P below) or modernized to the newest generation.

![Images/ResourceOpt11.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt13.png)

Moving to a modern generation may require additional testing hours compared to instances identified on Group 1, but depending on the case it can maximize savings and performance.

|   Type    | Linux     | vs new gen      | Windows   | vs new gen     |  Type     | Linux     | vs new gen      | Windows   | vs new gen      |
| --------- |:---------:| ---------------:|:---------:| --------------:| ----------|:---------:| ---------------:|:---------:| ---------------:|
| c3.large  | $0.105/hr | 19% to 26% less | $0.188/hr | 5% to 10% less | m3.large  | $0.133/hr | 28% to 35% less | $0.259/hr | 27% to 31% less |
| c4.large  | $0.100/hr | 15% to 23% less | $0.192/hr | 7% to 12% less | m4.large  | $0.100/hr |  4% to 14% less | $0.192/hr |   2% to 7% less |
| c5.large  | $0.085/hr |       9% less** | $0.177/hr |     4% less ** | m5.large  | $0.096/hr |      10% less** | $0.188/hr |       5% less** |
| c5a.large | $0.077/hr |              NA | $0.169/hr |             NA | m5a.large | $0.086/hr |              NA | $0.178/hr |              NA |


*prices are from US-Virginia (Nov 2019)* 

** *Using AMD EPYC™ processors*

If you are using the Right Sizing CSV file provided in this lab exercise, you will notice that we filtered down from originally **2,534 recommendations to 22** with **$6,362 per month in potential savings**.

##### **Group 3:** Current generation instances

Filter the data on **Recommended Actions = “Modify”** AND **OldGen = “0”** AND **TooSmall = “0”**

Sort the data by **Recommended Instance Type 1 Estimated Savings = Largest to smallest**

This will select underutilized resources from the current, most modern generation. We recommend sorting them by potential savings to make sure you are prioritizing the instances that will provide larger savings first.

![Images/ResourceOpt11.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt14.png)

Also, do not forget to check the other recommended instance types (columns AB to AK on the provided template); Amazon EC2 Resource Optimization will recommend up to 3 instances for each resource moving from a more conservative recommendation (the first recommendation) to a more aggressive and higher savings recommendation (second and third recommendations).

If you are using the Right Sizing CSV file provided in this lab exercise, you will notice that we filtered down from originally **2,534 recommendations to 22** with **$4,879.56 per month in potential savings**.

#### Conclusions

During this lab exercise, we learned how to prioritize the right sizing recommendations with the goal of identifying low complexity and high savings recommendations. We initially **started with 2,534 recommendations** with a potential **saving of $86,627** but we managed to identify the **top 60 cases** with lowest complexity that together add up to **$14,699.56** of the overall potential saving.

**Group 1 (Idle)** and **Group 2 (Previous Generation)** are the less complex cases where you may want to start the right sizing exercises for your organization. As you gain more confidence and learn how to develop a regular process for right sizing, your organization will be able to rapidly act on **Group 3 (Current/modern generation)** and other cases.

{{< prev_next_button link_prev_url="../3_resource_opt/" link_next_url="../5_other_rs_tools/" />}}
