---
title: "Use AWS Glue to enable access to CUR files via Amazon Athena"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---
We will use AWS Glue and setup a scheduled Crawler, which will run each day. This crawler will scan the CUR files and create a database and tables for the delivered files. If there are new versions of a CUR, or new months delivered - they will be automatically included.

We will use Athena to access and view our CUR files via SQL. Athena is a serverless solution to be able to execute SQL queries across very large amounts of data. Athena is only charged for data that is scanned, and there are no ongoing costs if data is not being queried, unlike a traditional database solution.



1.  Go to the **Glue** console:
![Images/Glue0.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue0.png?classes=lab_picture_small)

2. Click on **Get started** if you have not used Glue before

3. Ensure you are in the region where your CUR files are delivered, click on **Crawlers** and click **Add crawler**:
![Images/Glue1.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue1.png?classes=lab_picture_small)

4. Enter a **Crawler name** starting with **Cost**, and click **Next**:
![Images/Glue2.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue2.png?classes=lab_picture_small)

5. Select **Data stores**, and click **Next**:
![Images/Glue3.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue3.png?classes=lab_picture_small)

6. Ensure you select **Specified path in another account**, and enter the S3 path of your bucket **s3://(CUR bucket)**, expand **Exclude patterns**, enter the following patterns one line at a time and click next:

            **.json, **.yml, **.sql, **.csv, **.gz, **.zip, **/cost_and_usage_data_status/*, aws-programmatic-access-test-object

{{% notice note %}}
If you replicated the objects to the Cost Management Account or if using in the same account select **Specified path my account** instead of Specified path in another account.
{{% /notice %}}			

![Images/Glue4.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue4.png?classes=lab_picture_small)

7. Add another data store, click **Next**:
![Images/Glue7.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue7.png?classes=lab_picture_small)

8. Select **Create an IAM role**, enter a **role name** of **Cost_Crawler**, and click **Next**:
![Images/Glue8.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue8.png?classes=lab_picture_small)

9. Click the **Down arrow**, and select a **Daily** Frequency:
The CUR refreshes multiple times a day. You can adjust your frequency if you would like to run it more than once a day.
![Images/Glue9.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue9.png?classes=lab_picture_small)

10. Enter in a **Start Hour** and **Start Minute**, then click **Next**:
![Images/Glue10.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue10.png?classes=lab_picture_small)

11. Click **Add database**:
![Images/Glue11.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue11.png?classes=lab_picture_small)

12. Enter a **Database name** of **cost**, and click **Create**:
![Images/Glue12.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue12.png?classes=lab_picture_small)

**NOTE:** Your Database name cannot contain **-**
    ------------ | -------------

13. Configure the Crawler's output by **updating the following fields** then select **Next:
	- Select Create a single schema for each S3 path
	- Select Add new columns only
	- Select Ignore the Change and don't update the table in the data catalog
![Images/Glue13.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue13.png?classes=lab_picture_small)

14. Review the crawler and click **Finish**:
![Images/Glue14.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue14.png?classes=lab_picture_small)

15. Select the checkbox next to the crawler, click **Run crawler**:
![Images/Glue15.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue15.png?classes=lab_picture_small)

16. You will see the Crawler was successful and created a table:
![Images/Glue16.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue16.png?classes=lab_picture_small)

17. Click **Databases**
![Images/Glue20.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue20.png?classes=lab_picture_small)

18. Select the **cost** database that Glue created:
![Images/Glue21.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue21.png?classes=lab_picture_small)

19. Click **Tables in cost**:
![Images/Glue22.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue22.png?classes=lab_picture_small)

20. Click the table name:
![Images/Glue23.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue23.png?classes=lab_picture_small)

21. Verify the **recordCount** is not zero, if it is - go back and verify the steps above:
![Images/Glue24.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue24.png?classes=lab_picture_small)

22. Go to the **Athena** Console:
![Images/Glue17.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue17.png?classes=lab_picture_small)

23. Select the drop down arrow, and click on the new database:
![Images/Glue18.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/Glue18.png?classes=lab_picture_small)

24. A new table will have been created (named after the CUR), we will now load the partitions. Click on the **3 dot menu** and select **Load partitions**:
![Images/AWSBillingAnalysis_14.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/AWSBillingAnalysis_14.png?classes=lab_picture_small)

25. You will see it execute the command **MSCK REPAIR TABLE**, and in the results it **may** add partitions to the metastore for each month that has a billing file:
![Images/AWSBillingAnalysis_15.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/AWSBillingAnalysis_15.png?classes=lab_picture_small)

{{% notice note %}}
NOTE: It may or may not add partitions and show the messages above.
{{% /notice %}}

If you are using the supplied files for this lab, check:
- The folder names **year** and **month** are in S3 and the case matches
- There are parquet files in each of the month folders

26.  We will now preview the data.  Click on the **3 dot menu** and select **Preview table**:
![Images/AWSBillingAnalysis_16.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/AWSBillingAnalysis_16.png?classes=lab_picture_small)

27. It will execute a **Select * from** query, and in the results you will see the first 10 lines of your CUR file:
![Images/AWSBillingAnalysis_17.png](/Cost/200_4_Cost_and_Usage_Analysis/Images/AWSBillingAnalysis_17.png?classes=lab_picture_small)

{{% notice tip %}}
You have successfully setup your CUR file to be analyzed. You can now query your usage and costs via SQL.
{{% /notice %}}

{{< prev_next_button link_prev_url="../1_verify_cur/" link_next_url="../3_cur_analysis/" />}}
