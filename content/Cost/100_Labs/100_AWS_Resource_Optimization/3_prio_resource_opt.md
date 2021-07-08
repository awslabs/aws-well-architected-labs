---
title: "Prioritizing Rightsizing Recommendations"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

Now that you understand how AWS Cost Explorer Rightsizing recommendations work let's run an example and find how to prioritize quick wins.

#### 1. Download the **Rightsizing recommendations** report
![Images/ResourceOpt09.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt09.png?classes=lab_picture_small)

If you don’t have any Rightsizing recommendations, use the file below as a reference.

[Sample Rightsizing recommendations file (.csv)](/Cost/100_AWS_Resource_Optimization/Code/WALAB-ec2-rightsizing-recommendations.csv)

#### 2. Let’s filter out instances that are either too small or were only running for a few hours since the analysis was made

By doing so, we minimize the time required to perform rightsizing modifications that would otherwise result in minimal savings.

![Images/ResourceOpt10.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt10.png?classes=lab_picture_small)

**NOTE**: Depending on how many cost allocation tags you have enabled on your account the columns may differ from the example. Try to match the formulas using the screenshots below and the default column names.

Insert a new column to the right of the *Recommended Action* column. The first row will be the label for the column “TooSmall”. In each row below the label, paste the following formula:
```
=IF(X2<25,1,0)
```
Where *Column X = Recommended Instance Type 1 Estimated Savings*

That formula will flag with a “1” any instance that will fail to deliver more than $25/month in savings (or $300/year). Feel free to adjust the threshold for your organization own savings expectation. If you prefer to do the analysis based on specific instance sizes instead of potential savings you can use the following formula to exclude smaller instances from the recommendations as well.
```
=IF(N2="Modify",IF(SUMPRODUCT(--(NOT(ISERR(SEARCH({"nano","micro","small","medium"},F2)))))>0,"1","0"),"0")
```
Where *Column N = Recommended action* and *Column F = Instance Type*

#### 3. Now let’s flag EC2 instances that belong to old generations (C4, M3, etc).

Since you are investing engineer time on rightsizing let's make sure you are also leveraging the newest technology available. Newer EC2 generations have a superior performance increasing the changes of success for the rightsizing exercise, they also generally cost less than previous generations providing a higher cost vs benefit.

![Images/ResourceOpt11.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt11.png?classes=lab_picture_small)

Insert a new column **Old Gen** to the right of the *Instance Type* field, and paste the following formula:
```
=IF(SUMPRODUCT(--(NOT(ISERR(SEARCH({"t1","m1","c1","m2","i2","g2","c3","m3","r3","c4","m4","r4","cr1","hs1"},F2)))))>0,"1","0")
```
*Column F = Instance Type*

That formula will flag with a "1" instances from old generations.

#### 4. Sort the recommendations by low complexity and higher savings.

##### **Group 1:** Idle EC2 resources

Filter the data on **Recommended Action = "Terminate"**

Sort the data by **Recommended Instance Type 1 Estimated Savings = Largest to smallest**

Start filtering the idle resources or instances where CPU utilization <1%, it is likely these instances were launched and forgotten so the potential savings might represent the entire cost of running that instance.

![Images/ResourceOpt12.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt12.png?classes=lab_picture_small)

The resulting filtered list should be where you start rightsizing discussions with application owners. Perform an investigation to understand why these instance were launched in the first place and validate their usage with the resource owner. Don't forget to review the column **Total running hours** to separate idle resources that were recently launched vs the ones who are running uniterruptedly over the past 14 days.

If you are using the rightsizing CSV file provided in this lab exercise, you will notice that we filtered down from an original **1,051 recommendations to 17** and **identified $2,859 per month in potential savings**. You will also find in the example some instances showing 0 estimated savings, that's because they were running under Savings Plan (SP) or Reserved Instances (RI). On these cases AWS will not estimate savings, but if these instances can be terminated the committed SP/RI hours might float to On Demand usage within your account depending on the RI/SP scope.

##### **Group 2:** Previous generation instances

Filter the data on **Recommended Actions = “Modify”** AND **OldGen = “1”** AND **TooSmall = “0”**

Sort the data by **Recommended Instance Type 1 Estimated Savings = Largest to smallest**

This list will focus on the underutilized resources (>1% CPU) that belongs to previous generations and can either be downsized within the same family (column P below) or modernized to the newest generation.

![Images/ResourceOpt13.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt13.png?classes=lab_picture_small)

Moving to a new generation will require additional investment in the form of more testing hours compared to instances identified on Group 1, but depending on the case it can maximize savings and performance. Refer to the [EC2 previous generation](https://aws.amazon.com/ec2/previous-generation/) page for information on upgrade paths to current generation instance families.

> As AWS continues to innovate, new instance types become available often with a cheaper hourly cost and better performance versus current generation instances. Review the [Amazon EC2 Instance Types](https://aws.amazon.com/ec2/instance-types/) to see current instance families. For example, the new [Graviton](https://aws.amazon.com/ec2/graviton/) instances offer even more savings and performance but require additional testing because they use a different processor architecture (ARM).

If you are using the rightsizing CSV file provided in this lab exercise, you will notice that we filtered down from originally **1,051 recommendations to 15** with **$7,089 per month in potential savings**.

##### **Group 3:** Current generation instances

Filter the data on **Recommended Actions = “Modify”** AND **OldGen = “0”** AND **TooSmall = “0”**

Sort the data by **Recommended Instance Type 1 Estimated Savings = Largest to smallest**

This will select underutilized resources from the current, most modern generation. We recommend sorting them by potential savings to make sure you are prioritizing the instances that will provide larger savings first.

![Images/ResourceOpt14.png](/Cost/100_AWS_Resource_Optimization/Images/ResourceOpt14.png?classes=lab_picture_small)

Also, do not forget to check the other recommended instance types. Rightsizing recommendations will recommend up to 3 instances for each resource moving from a more conservative recommendation (the first recommendation) to a more aggressive and higher savings recommendation (second and third recommendations).

If you are using the rightsizing CSV file provided in this lab exercise, you will notice that we filtered down from originally **1,051 recommendations to 37** with **$18,728 per month in potential savings**.

#### Conclusions

During this lab exercise, we learned how to prioritize the rightsizing recommendations with the goal of identifying low complexity and high savings recommendations. We initially **started with 1,051 recommendations** with a potential **saving of $29,603** but we managed to identify the **top 69 cases** with lowest complexity that together add up to **$28,676** of the overall potential saving.

**Group 1 (Idle)** and **Group 2 (Previous Generation)** are the less complex cases where you may want to start the rightsizing exercises for your organization. As you gain more confidence and learn how to develop a regular process for rightsizing, your organization will be able to rapidly act on **Group 3 (Current/modern generation)** and other cases.

{{< prev_next_button link_prev_url="../2_resource_opt/" link_next_url="../4_other_rs_tools/" />}}
