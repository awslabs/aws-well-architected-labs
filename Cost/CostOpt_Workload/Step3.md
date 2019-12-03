# Licensing

## Authors
- Nathan Besh, Cost Lead Well-Architected


## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com


## Goals
- Understand the licensing costs in your workload
- Understand the costs of licensing in your workload



# Table of Contents
1. [Understand licensing costs in your workload](#setup_data)
2. [Create an account structure](#cost_licensed)
3. [Simulate the change and validate](#validation)


## 1. Understand licensing costs in your workload <a name="license_costs"></a>
We will analyze the CUR file for any software that includes licensing. First we will see what columns
could give us the information we need. Then we look for the amount we are spending on items containing licenses, and how much we are spending on the actual licenses by comparing to a similar non-licensed option.

We take this information and decide if the effort required to make the change will be less than what we save, and if the required functionality is still met.


### 1.1 Analyze CUR columns
The first step is to understand what information we may have that can show us costs associated with licenses.

1. Log into the AWS console as an IAM user with the required permissions:
![Images/consolelogin_IAMUser.png](Images/consolelogin_IAMUser.png)
 
2. Go to the **Athena** Console:

3. Select the **costusage** database, you should see the **costusagefiles** table


4. We want to see all the columns available, and some sample data, so paste the following command and click **Run query**:
        
        SELECT * FROM "costusage"."costusagefiles_reinventworkshop" limit 10;

5. You can see each column and 10 rows of data below. There are over 100 columns - take a minute or two and slowly scroll through them and view the data.

6. We want to ensure we are only looking at costs for our workload. There is a column at the far right **resource_tags_user_application**, this contains the tags we put on our resources. Lets limit our search to rows containing the value of **ordering**. As all our resources were tagged with this value. Run the query:
 
        SELECT * FROM "costusage"."costusagefiles_reinventworkshop" 
        where resource_tags_user_application like 'ordering'
        limit 30

7. Now we will look for EC2 Operating System licenses. Look through the data and see if you can spot a column which indicates the operating system used.

8. There are multiple columns we can use, look at the columns **line_item_line_item_description** and **product_operating_system**. Note: columns are typically in close to an alphabetical order.

9. We will focus on **line_item_line_item_description**, you can see **Linux**, **Windows** and **RHEL**. We will look to get the costs of RHEL licensing and compare it to a similar operating system, AWS Linux. Paste the following query and click **Run query**:
 
        SELECT * FROM "costusage"."costusagefiles_reinventworkshop" 
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%RHEL%'
        limit 30

10. We will now get the costs for each hour for running RHEL. We dont need 100+ columns, so we'll focus on just the following columns: **line_item_usage_start_date**, **linte_item_line_item_description**, **line_item_unblended_cost**. We will sum the **unblended_cost** column, and group it by **usage_start_date**, this will give us cost per hour. The **order by** line orders the output by date. Paste the following query:

        SELECT line_item_usage_start_date, line_item_line_item_description, sum(line_item_unblended_cost) as cost FROM "costusage"."costusagefiles_reinventworkshop" 
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%RHEL%'
        group by line_item_usage_start_date, line_item_line_item_description
        order by line_item_usage_start_date asc

11. You can see that the cost per hour of running the RHEL was 	0.8128000000000001 per hour. Lets see what instances we were running, so we can find the costs for a comparable instance. Re-run the command:

        SELECT line_item_usage_type, line_item_availability_zone, sum(line_item_unblended_cost) as cost FROM "costusage"."costusagefiles_reinventworkshop"  
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%RHEL%'
        group by line_item_usage_type, line_item_availability_zone
        limit 30

12. Look at the columns: **line_item_usage_type**, **line_item_availability_zone**, you will see the values **BoxUsage:t3.medium** and **us-east-1a/b**:

13. We see that we are running t3.medium RHEL instances in us-east-1. Open the pricing pages in a new tab: https://aws.amazon.com/ec2/pricing/on-demand/

14. Ensure the **Linux** tab is selected, and the region is **US East (N. Virginia)**. The pricing for AWS Linux is: **$0.0416 per hour**. Now click the **RHEL** tab:

15. The pricing will change, the price for **RHEL** is: **$0.1016**. 

16. Lets see exactly how much we were running in total, and the price. In the **Athena console** paste the following query:

        SELECT line_item_line_item_description, sum(line_item_usage_amount) usage_hours, sum(line_item_unblended_cost) as cost FROM "costusage"."costusagefiles_reinventworkshop" 
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%RHEL%'
        group by line_item_line_item_description

17. You can see we consumed **176** instance hours for a total cost of **$17.8815999...**.

18. If we were able to run AWS Linux, it would cost:  **$7.3216** for **176 hours**. Thats a **saving of $10.55999 or 59%** of our instance EC2 costs.

As will all optimization opportunities, weigh up the savings gained from making the change, against the effort required to change. Is 59% of your instance EC2 costs each month worth making the change? How long before you pay off your effort? Is all the required functionality still there?



## 2. Understand the costs of running licensed software in your workload <a name="cost_licensed"></a>
There can be associated costs with running licensed software. Additional resources may be mandated by the software in addition to a base configuration. We will continue our example by looking at operating systems.

We will now see if additional resources are required to run RHEL instead of AWS Linux, and the cost of these additional resources.

1. Go into the EC2 console, and click **Launch Instance**:

2. Select the base **Amazon Linux 2 AMI**

3. Select a **t3.medium** instance size, and click **Next: Configure Instance Details**:

4. Click **Next: Add Storage**

5. You can see that the default configuration is for **8Gb GP2** of EBS storage. Click **Cancel**.

6. From the **EC2 Console** click **Launch Instance**, and select the **Red Hat Enterprise Linux** AMI:

7. Select a **t3.medium** instance and click **Next: Configure Instance Details**:

8. Click **Next: Add Storage**

9. You will see that there is **10Gb GP2** of storage required for RHEL as a default. Click **Cancel**.

10. You need an additional 2Gb of GP2 storage per instance. Go to the EBS pricing page here: https://aws.amazon.com/ebs/pricing/ 

11. The price in **US East(N. Virginia)** is **$0.1 per GB-month**. We will now calculate the storage savings across our workload.

12. From the **Athena Console** paste the following query, which gives us the instance IDs along with how many hours they ran for:

        SELECT distinct line_item_resource_id, sum(line_item_usage_amount)  FROM "costusage"."costusagefiles_reinventworkshop" 
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%RHEL%'
        group by line_item_resource_id

13. You can see that each instance ran for 22hrs, which is what the log file contains. You can confirm the number of hours in your data by running the following query:

        SELECT distinct line_item_usage_start_date FROM "costusage"."costusagefiles_reinventworkshop" 
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%RHEL%'

14. As per the previous query, we are running 8 instances requiring an additional 2Gb GP2. This is 16Gb-mo of storage, which is a cost of $1.60 each month on our workload.

15. To see the impact on our workload, lets look at the total cost of storage in the front tier which contained our RHEL instances. Paste the following query 

        SELECT line_item_usage_start_date, line_item_line_item_description, sum(line_item_unblended_cost) as cost, sum(line_item_usage_amount) as amount FROM "costusage"."costusagefiles_reinventworkshop" 
        where resource_tags_user_application like 'ordering' and line_item_usage_type like '%EBS%' and resource_tags_user_tier like 'front'
        group by line_item_usage_start_date, line_item_line_item_description
        order by line_item_usage_start_date asc

16. You can see each hour the amount was **0.11111111120000003** at a cost of **0.011111111199999999..**. Storage is calculated by **Gb-mo**, so to get storage that was provisioned:

        Hourly amount x 24 x (days in month)
        0.11111111120000003 x 24 x 30
        = 80Gb

17. Lets get the total storage amount and cost for the period with the following query: 

        SELECT line_item_line_item_description, sum(line_item_unblended_cost) as cost, sum(line_item_usage_amount) as amount FROM "costusage"."costusagefiles_reinventworkshop" 
        where resource_tags_user_application like 'ordering' and line_item_usage_type like '%EBS%' and resource_tags_user_tier like 'front'
        group by line_item_line_item_description

18. You can see there was **$0.2628922854999997** of cost and an amount of **2.6289228409999925** in our 22hr of log files. This would be a monthly cost of $8.60 for 80Gb. 

19. So we could save **$1.72** out of a total cost of **$8.60** in a month. That is a **20% reduction in storage costs for the Front Tier**.


All up we save **$10.55** due to OS licensing costs and an additional **$1.72** on storage each month if we were able to switch from RHEL to AWS Linux.  Again weigh up these costs and the benefits of running the software to decide if it is worth changing.


<a name="validation"></a>
## 3. Simulate the change and validate 
We have performed the change in our environment and created new application logs and new Cost and Usage Reports. We will now analyze these new files to validate our analysis.

1. Download the updated CUR and application log files from here: 
    - [Step2CUR.gz](Code/Step2CUR.gz)
    - [Step2access_log.gz](Code/Step2AccessLog.gz)

2. Delete the current CUR and AppLog files in your S3 Buckets.

2. Upload the new files into the **same folders** in S3 that the previous application & cost files were uploaded into.

3. You do not have to re run the crawlers, as the structure and format is the same as the previous files. When you run a query, it now uses the new data files automatically.

4. Lets see exactly how much we were running in total, and the price. In the **Athena console** paste the following query:

        SELECT line_item_line_item_description, sum(line_item_usage_amount) as usage_hours, sum(line_item_unblended_cost) as cost FROM "costusage"."costusagefiles_reinventworkshop"
        where resource_tags_user_application like 'ordering' and line_item_line_item_description like '%t3.medium%' and resource_tags_user_tier like 'front'
        group by  line_item_line_item_description

5. You can see we consumed **112** instance hours for a total cost of **4.6591999**.

6. If we scaled this up to **176** hours (176/112 x $4.659), it would be **$7.3216**.  We have verified we did save the estimated **saving of $10.55 or 59%** (original cost $17.88).


7. Lets analyze the storage with the following query:

        SELECT line_item_usage_start_date, line_item_line_item_description, sum(line_item_unblended_cost) as cost, sum(line_item_usage_amount) as amount FROM "costusage"."costusagefiles_reinventworkshop" 
        where resource_tags_user_application like 'ordering' and line_item_usage_type like '%EBS%' and resource_tags_user_tier like 'front'
        group by line_item_usage_start_date, line_item_line_item_description
        order by line_item_usage_start_date asc

8. You can see there was an hourly amount of **0.0888888888** and an hourly cost of **$0.0088888888**, which is exactly 8/10 of the original amount (original amount 0.11111111120000003) and cost of storage (going to 8Gb from 10Gb volumes).


In this step we discovered Licensing costs, and associated additional resource costs. We analyzed them to make sure it was worth the effort, made the change (simulated) then verified our change.

You have just performed your first Cost Optimization cycle!  Always make sure you **analyze** to make sure the change is worth the effort, and **verify** after you have performed the change to confirm you realized the savings.
