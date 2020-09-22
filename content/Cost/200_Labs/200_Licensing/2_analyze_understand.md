---
title: "Analyze and Understand Licensing"
date: 2020-08-30T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---




### Analyze and understand licensing costs in your workload
We will analyze the CUR file for any software that includes licensing. First we will see what columns
could give us the information we need. Then we look for the amount we are spending on items containing licenses, and how much we are spending on the actual licenses by comparing to a similar non-licensed option.

We take this information and decide if the effort required to make the change will be less than what we save, and if the required functionality is still met.



{{% notice note %}}
The queries below are for the provided data set created previously. If you use your own CUR you will need to modify these queries accordingly.
{{% /notice %}}


### Analyze CUR columns
The first step is to understand what information we may have that can show us costs associated with licenses.

1. Go to the **Athena** Console:

2. Select the **costmaster** database, you should see the **before** and **after** tables

3. We want to see all the columns available, and some sample data, so paste the following command and click **Run query**:
        
        SELECT * FROM "costmaster"."before" limit 10;

4. You can see each column and 10 rows of data below. There are over 100 columns - take a minute or two and slowly scroll through them and view the data.

5. The supplied datasource has multiple workloads in it, we want to ensure we are only looking at costs for our **ordering** workload. There is a column at the far right **resource_tags_user_application**, this contains the tags we put on our resources. Lets limit our search to costs tagged with **ordering**. Run the query:
 
        SELECT * FROM "costmaster"."before" 
        where resource_tags_user_application like 'ordering'
        limit 30

6. Now we will look for EC2 Operating System licenses. Look through the data and see if you can find a column which indicates the operating system used.

7. There are multiple columns we can use, look at the columns **line_item_line_item_description** and **product_operating_system**. **Note**: columns are close to alphabetical order.

8. We will focus on **line_item_line_item_description**, you can see **Linux**, **Windows** and **RHEL**. We will get the costs of RHEL licensing and compare it to a similar operating system, AWS Linux. To get a sample of the RHEL costs, paste the following query and click **Run query**:
 
        SELECT * FROM "costmaster"."before"
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%RHEL%'
        limit 30

9. We will now get the costs for each hour for running RHEL. We dont need 100+ columns, so we'll focus on just the following columns: **line_item_usage_start_date**, **linte_item_line_item_description**, **line_item_unblended_cost**. We will sum the **unblended_cost** column, and group it by **usage_start_date**, this will give us cost per hour. The **order by** line orders the output by date. Run the following query:

        SELECT line_item_usage_start_date, line_item_line_item_description, sum(line_item_unblended_cost) as cost FROM "costmaster"."before"
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%RHEL%'
        group by line_item_usage_start_date, line_item_line_item_description
        order by line_item_usage_start_date asc

10. You can see that the cost per hour of running the RHEL instances was **0.8128000000000001** per hour. To get the pricing for a non-licensed operating system we will need the instance size and location. We will use the **line_item_usage_type** and **line_item_availability_zone** columns to get this, run the following query:

        SELECT line_item_usage_type, line_item_availability_zone, sum(line_item_unblended_cost) as cost FROM "costmaster"."before"
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%RHEL%'
        group by line_item_usage_type, line_item_availability_zone
        limit 30

11. Look at the columns: **line_item_usage_type**, **line_item_availability_zone**, you will see the values **BoxUsage:t3.medium** and **us-east-1a/b**:

12. We see that we are running t3.medium RHEL instances in us-east-1. Open the pricing pages in a new tab: https://aws.amazon.com/ec2/pricing/on-demand/


{{% notice note %}}
Pricing is correct as of August 2020, we may have had a price drop since then and the prices below may be higher than what is currently in the console.
Please disregard and proceed through the lab.
{{% /notice %}}


13. Ensure the **Linux** tab is selected, and the region is **US East (N. Virginia)**. The pricing for a **t3.medium** with AWS Linux is: **$0.0416 per hour**. Now click the **RHEL** tab:

14. The pricing will change, the price for **RHEL** is: **$0.1016**. 

15. Lets see exactly how many hours of usage we were running in total (**line_item_usage_amount**), and the price. In the **Athena console** paste the following query:

        SELECT line_item_line_item_description, sum(line_item_usage_amount) usage_hours, sum(line_item_unblended_cost) as cost FROM "costmaster"."before"
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%RHEL%'
        group by line_item_line_item_description

16. You can see we consumed **176** instance hours of licensed RHEL ($0.1016 an hour), for a total cost of **$17.8815999...**.

17. Our sample CUR is less than a month, to get monthly costs - lets see how many instances we are running with RHEL. We will get the resource IDs and how long they ran for with the following query. In the **Athena Console** paste the following:

        SELECT distinct line_item_resource_id, sum(line_item_usage_amount) as Hours_ran  FROM "costmaster"."before"
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%RHEL%'
        group by line_item_resource_id

18. We are running **8 instances** of RHEL at a cost of **$0.1016 per hour**. If we changed these to AWS Linux at a cost of **$0.0416 per hour**, we would save **$0.06 each hour, per instance**.

19. **8 Instances** at saving of **$0.06 per hour**, for an average of **730 hours** each month, is a monthly saving of **$350.4**.

{{% notice note %}}
As with all optimization opportunities, weigh up the savings gained from making the change, against the effort required to change. Is $350 each month worth making the change? How long before you pay off your effort? How long will the workload run? What if your instance usage increases or decreases - does the answer change?
{{% /notice %}}


## Understand the costs of running licensed software in your workload <a name="cost_licensed"></a>
There can be associated costs with running licensed software. Additional resources may be mandated by the software in addition to a base configuration. We will continue our example by looking at operating systems.

We will now see if additional resources are required to run RHEL compared to AWS Linux, and the cost of these additional resources.


{{% notice note %}}
If you do not have the additional privileges the EC2 console you will have to read through first 10 steps below.
{{% /notice %}}

1. Go into the EC2 console, and click **Launch Instance**, then **Launch instance**

2. Select the **Amazon Linux 2 AMI**

3. Select a **t3.medium** instance size, and click **Next: Configure Instance Details**

4. Click **Next: Add Storage**

5. You can see that the default configuration is for **8GiB GP2** of EBS storage. Click **Cancel**.
![Images/ec2_addstorageLinux.png](/Cost/200_Licensing/Images/ec2_addstorageLinux.png)

6. From the **EC2 Console** click **Launch Instance**, then **Launch instance**

7. Select the **Red Hat Enterprise Linux** AMI:

8. Select a **t3.medium** instance and click **Next: Configure Instance Details**:

9. Click **Next: Add Storage**

10. You will see that there is **10GiB GP2** of storage required for RHEL as a default. Click **Cancel**.
![Images/ec2_addstorageRHEL.png](/Cost/200_Licensing/Images/ec2_addstorageRHEL.png)

11. Confirm how much storage we are using and the cost:

         SELECT line_item_usage_start_date, line_item_line_item_description, sum(line_item_unblended_cost) as cost, sum(line_item_usage_amount) as amount FROM "costmaster"."before"
        where resource_tags_user_application like 'ordering' and line_item_usage_type like '%EBS%' and resource_tags_user_tier like 'front'
        group by line_item_usage_start_date, line_item_line_item_description
        order by line_item_usage_start_date asc
        limit 5

12. Each hour we are consuming **0.111111** for a cost of **$0.011111**.

13. You need an **additional 2Gb of GP2 storage per instance**. Go to the EBS pricing page here: https://aws.amazon.com/ebs/pricing/ 

14. The price in **US East(N. Virginia)** is **$0.1 per GB-month** for SSD gp2 volumes. We will now calculate the storage savings across our workload.

15. Lets see how many instances we are running with RHEL. We will get the resource IDs and how long they ran for with the following query. In the **Athena Console** paste the following:

        SELECT distinct line_item_resource_id, sum(line_item_usage_amount) as Hours_ran  FROM "costmaster"."before"
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%RHEL%'
        group by line_item_resource_id

16. We are running **8 instances**, which each require an **additional 2GB GP2**. This is **16GB-month** of storage (at $0.10 per GB-month), which is **an additional cost of $1.60** each month on our workload.

17. We have total additional monthly costs due to licensing of **$350.4 (licenses)** + **$1.60 (storage)** = **$352**

{{% notice note %}}
We have total monthly savings due to licensing. Lets think long term, whats the impact if our workload grows over time? whats the saving?
{{% /notice %}}




<a name="validation"></a>
## Simulate the change and validate 
We have performed the change in our environment and created new Cost and Usage Reports. We will now analyze the **after** table which contains these changes.

1. Lets see the amount and cost of our new AWS Linux instances, and the price. In the **Athena console** paste the following query:

        SELECT distinct line_item_resource_id, line_item_line_item_description,  sum(line_item_usage_amount) as Hours_ran,  sum(line_item_unblended_cost) as cost   FROM "costmaster"."after"
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%t3.medium%' and resource_tags_user_tier like 'front'
        group by line_item_resource_id,  line_item_line_item_description


2. You can see we ran **8 Linux instances** in a sample of 23hrs at a cost of **$0.09568** for each instance.

3. The total cost for 8 instances over **730** hours ($0.9568 / 23 * 730 * 8), would be **$242.944**.  Our original cost was **$593.344**, and we predicted a saving of **$350.4**, our final cost of **$242.944** verifies this prediction.


4. Lets analyze the storage with the following query:

        SELECT line_item_usage_start_date, line_item_line_item_description, sum(line_item_unblended_cost) as cost, sum(line_item_usage_amount) as amount FROM "costmaster"."after"
        where resource_tags_user_application like 'ordering' and line_item_usage_type like '%EBS%' and resource_tags_user_tier like 'front'
        group by line_item_usage_start_date, line_item_line_item_description
        order by line_item_usage_start_date asc
        limit 5

8. You can see there was an hourly amount of **0.088888** and an hourly cost of **$0.008888**, which is 8/10 of the original amount of **0.111111** and cost of **0.011111**, which validates changing to 8Gb volumes from 10Gb volumes. This validates our $1.60 saving prediction.



{{% notice note %}}
In this step you discovered your Licensing costs, and associated additional resource costs. You analyzed them to make sure it was worth the effort to make a change, then verified the savings after making (simulating) the change.
{{% /notice %}}


