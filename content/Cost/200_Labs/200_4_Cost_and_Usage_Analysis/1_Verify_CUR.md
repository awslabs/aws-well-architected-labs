---
title: "Verify your CUR files are being delivered"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
We will verify the CUR files are being delivered, they are in the correct format and the region they are in.

1. Log into the console via SSO.

2. Get the bucket name which contains your Cost and Usage Report (CUR) files in the master/payer account. Modify the following address and replace **(bucket name)** with your bucket:

        https://s3.console.aws.amazon.com/s3/buckets/(bucket name)/
    
![Images/AWSBillingAnalysis_0.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/AWSBillingAnalysis_0.png)

3. You should see a **aws-programmatic-access-test-object** which was put there to verify AWS can deliver reports, and also the folder which is the report prefix - **cur**. Click on the folder name for the **prefix** (here it is cur):
![Images/AWSBillingAnalysis_3.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/AWSBillingAnalysis_3.png)

5. Click on the **folder name** which is also part of the prefix (here it is WorkshopCUR):
![Images/AWSBillingAnalysis_4.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/AWSBillingAnalysis_4.png)

6. Click on the **prefix** folder, here it is WorkshopCUR, then drill down in the current year and month:
![Images/AWSBillingAnalysis_5.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/AWSBillingAnalysis_5.png)

7. You can see the delivered CUR file, it is in the **parquet** format:
![Images/AWSBillingAnalysis_7.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/AWSBillingAnalysis_7.png)

{{% notice tip %}}
You have successfully verified that you have access to the CUR files, and they are being delivered in the correct format.
{{% /notice %}}



**Sample Files**
You may not have substantial or interesting usage, in this case there are sample files below. Create a folder structure, such as (bucket name)/cur/WorkshopCUR/WorkshopCUR/year=2018/month=x and copy the parquet files below into each months folder:

- [October 2018 Usage](/Cost/200_4_Cost_and_Usage_Analysis/Code/Oct2018-WorkshopCUR-00001.snappy.parquet)
- [November 2018 Usage](/Cost/200_4_Cost_and_Usage_Analysis/Code/Nov2018-WorkshopCUR-00001.snappy.parquet)
- [December 2018 Usage](/Cost/200_4_Cost_and_Usage_Analysis/Code/Dec2018-WorkshopCUR-00001.snappy.parquet)
