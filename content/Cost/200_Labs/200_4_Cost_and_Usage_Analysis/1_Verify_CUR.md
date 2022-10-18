---
title: "Verify your CUR files are being delivered"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

{{% notice note %}}
Prerequisite:
You must have configured Cost and Usage Reports in the [AWS Account Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup" >}}) lab. It can take up to 24 hours for AWS to deliver the first report to your Amazon S3 bucket. However if you are doing this Lab as part of an AWS workshop, or do not have substantial or interesting usage, follow [these steps]({{< ref "#use-sample-data" >}}) at the bottom of this lab to create an Amazon S3 bucket and use sample files.
{{% /notice %}}

We will verify the CUR files are being delivered, they are in the correct format and the region they are in.

1. Log into the console via SSO.

2. Get the bucket name which contains your Cost and Usage Report (CUR) files in the management/payer account. Modify the following address and replace **(bucket name)** with your bucket:

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

### Use Sample Data

{{%expand "Click here to use sample CUR data" %}}

1. Follow the Amazon Simple Storage Service [documentation page](https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html) to create an S3 bucket
2. Select your new S3 bucket and click the **Create folder** button, enter `cur` for your folder name, and click **Create folder**
3. Click on your new `cur` folder to enter it, and follow the same process to create further folders until you have a folder structure which resembles **(bucket name)/cur/WorkshopCUR/WorkshopCUR/year=2018**
4. Then create three further folders within the **year=2018** folder (**month=10**, **month=11**, **month=12**)
5. Download the three parquet files below

- [October 2018 Usage](/Cost/200_4_Cost_and_Usage_Analysis/Code/Oct2018-WorkshopCUR-00001.snappy.parquet)
- [November 2018 Usage](/Cost/200_4_Cost_and_Usage_Analysis/Code/Nov2018-WorkshopCUR-00001.snappy.parquet)
- [December 2018 Usage](/Cost/200_4_Cost_and_Usage_Analysis/Code/Dec2018-WorkshopCUR-00001.snappy.parquet)

6. Upload each months file into the corresponding folder, (so upload  October's parquet file to **(bucket name)/cur/WorkshopCUR/WorkshopCUR/year=2018/month=10/**

{{% /expand%}}

{{< prev_next_button link_prev_url="../" link_next_url="../2_setup_athena/" />}}
