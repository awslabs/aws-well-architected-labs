---
title: "Setup AWS Glue with CloudFormation"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

#### Create the CloudFormation Stack

The next step is to setup an AWS Glue Crawler for a single Cost and Usage Report that will scan the CUR files and create a Glue Catalog from delivered parquet files. If new months or a new version of a CUR is delivered, they will be automatically added to the database.

The Cost and Usage Report automatically generates a YML file that can be used with CloudFormation to automatically create the resources needed. The CloudFormation script will create the Glue crawler with a Lambda function that will be used to start the crawler. It will also setup an S3 event that will trigger the Lambda function whenever new files are delivered to the CUR bucket. You can also setup the crawler manually [here]({{< ref "#setup-crawler-manually" >}}) if you are not able to use CloudFormation.

We will use Athena to access and view our Glue Catalog as an Athena database. Athena is a serverless solution that is able to execute SQL queries across large amounts of data. With Athena you are only charged for data that is scanned, and there are no ongoing costs if data is not being queried, unlike a traditional database solution.

{{% notice info %}}
Please review the CloudFormation template with your security team.
{{% /notice %}}

The CloudFormation script builds the following architecture:
![Images/0.0-CrawlerArchitecture.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/0.0-CrawlerArchitecture.png)

1. In the S3 console open the bucket that is used to store your Cost and Usage Report. Navigate two levels down until you are in the folder/prefix that contains your **crawler-cfn.yml** file. In the example below the file is located in (BucketName)/CUR/LabsCUR/. 

- **Select** the **crawler-cfn.yml** file to open the object properties.
![Images/2.0-LocateYMLFile.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.0-LocateYMLFile.png?classes=lab_picture_small)

2. Under "Object URL" select the "copy" icon to copy the full object URL.
![Images/2.1-YMLObjectProperties.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.1-YMLObjectProperties.png?classes=lab_picture_small)

3. With the URL copied you can now open the [CloudFormation console](https://console.aws.amazon.com/cloudformation) to run the YML CloudFormation script.
![Images/2.2-OpenCloudFormation.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.2-OpenCloudFormation.png?classes=lab_picture_small)

4. Select the **Create stack** button in the upper right hand corner and then select **With new resources (standard)**.
![Images/2.3-CreateStack.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.3-CreateStack.png?classes=lab_picture_small)

5. On the "Create stack" page, paste the URL in the "Amazon S3 URL" field and then select the **Next** button. 
![Images/2.4-PasteURL.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.4-PasteURL.png?classes=lab_picture_small)

{{% notice note %}}
If you have an issue with the S3 URL in CloudFormation, you can also download the crawler-cfn.yml script to your hard drive and upload it into CloudFormation.
{{% /notice %}}	

6. On the "Specify stack details" page, input `CUR-Glue-Crawler` in the "Stack Name" field and then select the **Next** button.
![Images/2.5-StackName.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.5-StackName.png?classes=lab_picture_small)

7. On the "Configure stack options" page, leave everything as default and select the **Next** button.

8. On the "Review CUR-Glue-Crawler" page, scroll to the bottom of the page and put a **check** in the box next to "I acknowledge that AWS CloudFormation might create IAM resources." and then select the **Submit** button.
![Images/2.6-CFN-IAM.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.6-CFN-IAM.png?classes=lab_picture_small)

9. Your CloudFormation script will now start creating resources. It doesn't always refresh on its own, you will need to occasionally select the manual refresh button. When the "Logical ID" status of the **CUR-Glue-Crawler** says **CREATE_COMPLETE** your CloudFormation script is finished.
![Images/2.7-StackComplete.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.7-StackComplete.png?classes=lab_picture_small)

10. Navigate to the [Amazon Athena service page](https://console.aws.amazon.com/athena/home) and select **Query editor**. Select your database from the "Database" dropdown menu. Your database may have a different name then the one pictured below.
![Images/2.8-AthenaQueryEditor.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.8-AthenaQueryEditor.png?classes=lab_picture_small)

#### Setup Crawler Manually

**(Optional)** - Move on to Step 11 if you setup the crawler via the CloudFormation Template.

{{%expand "Instructions to setup the Glue Crawler manually" %}}

Below are the steps to manually setup an AWS Glue crawler that will run on a daily schedule. 

1.  Go to the **Glue** console:
![Images/2.9-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.9-Glue.png?classes=lab_picture_small)

2. Click on **Get started** if you have not used Glue before.

3. Ensure you are in the region where your CUR files are being delivered. From the left hand menu under "Data Catalog" click on **Crawlers** and select the **Create crawler** button:
![Images/2.10-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.10-Glue.png?classes=lab_picture_small)

4. Under "Crawler details" enter a **Name** starting with "Cost", and click **Next**:
![Images/2.11-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.11-Glue.png?classes=lab_picture_small)

5. Under "Data source configuration" select **Not yet** and select the **Add a data source** button:
![Images/2.12-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.12-Glue.png?classes=lab_picture_small)

6. Select **S3** as your "Data source", the "Location of S3 data" is **In this account**, and then select the **Browse S3** button to select your bucket. Make sure that **Crawl all sub-folders** is selected and put a check in the **Exclude files matching pattern** box. Enter the following exclusion patterns one line at a time (See below) and click the **Add an S3 data source** button when finished:

- `**.json`
- `**.yml`
- `**.sql` 
- `**.csv` 
- `**.gz`
- `**.zip` 
- `**/cost_and_usage_data_status/*` 
- `aws-programmatic-access-test-object`

{{% notice note %}}
If your CUR bucket is located in another account make sure you select **In a different account** instead of **In this account**. You will need to copy and paste the name of your CUR bucket from the other account.
{{% /notice %}}			

![Images/2.13-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.13-Glue.png?classes=lab_picture_small)

7. With the S3 data source now added to the configuration, select the **Next** button:
![Images/2.14-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.14-Glue.png?classes=lab_picture_small)

8. Under IAM role, select the **Create new IAM role** button:
![Images/2.15-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.15-Glue.png?classes=lab_picture_small)

9. Under "Enter new IAM role" add `Cost_Crawler` to the end of **AWSGlueServiceRole-**, and click **Create**:
![Images/2.16-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.16-Glue.png?classes=lab_picture_small)

10. With the successful creation of the IAM role, select the **Next** button:
![Images/2.17-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.17-Glue.png?classes=lab_picture_small)

11. Under "Output configuration" click on the **Add database** button, this will open a new tab in the browser:
![Images/2.18-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.18-Glue.png?classes=lab_picture_small)

12. Under "Database details" enter the "Name" `cost_optimization_labs_cur` and then select the **Create database** button:
![Images/2.19-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.19-Glue.png?classes=lab_picture_small)

13. Return to the "Set output and scheduling" page in your previous browser tab. Select the "Target database" refresh button and select the **cost_optimization_labs_cur** database you just created.

Select the arrow next to "Advanced options" and select the following options:
- Select **Create a single schema for each S3 path**
- Select **Add new columns only**
- Select **Ignore the change and don't update the table in the data catalog**

Under "Crawler schedule" select the "Frequency" as **Daily** and enter your desired start hour and minute. (See below) When finished select the **Next** button.
![Images/2.20-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.20-Glue.png?classes=lab_picture_small)

14. On the "Review and create" page, review all the setting and then select the **Create crawler** button:
![Images/2.21-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.21-Glue.png?classes=lab_picture_small)

15. You will now be on the "Cost_CUR_Crawler" crawler detail page, now click on the **Run crawler** to start the initial crawl of your Cost and Usage Report:
![Images/2.22-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.22-Glue.png?classes=lab_picture_small)

16. The crawler's status will change to "Running", when the status to changes to "Completed" it should show that there has been "Table changes":
![Images/2.23-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.23-Glue.png?classes=lab_picture_small)

17. From the left-hand menu select **Databases** and then select the new database named **cost_optimization_labs_cur**.
![Images/2.24-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.24-Glue.png?classes=lab_picture_small)

18. Select the newly created table created by the Glue crawler: (Should be the same name as your CUR S3 bucket)
![Images/2.25-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.25-Glue.png?classes=lab_picture_small)

19. In the "Table details" you should see a schema has been created. If you do not see a schema or your "recordCount" under "Advanced properties" is **0**, please go back and verify all the previous steps.
![Images/2.26-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.26-Glue.png?classes=lab_picture_small)

20. For the next step, open the [Amazon Athena service page](https://console.aws.amazon.com/athena/home):
![Images/2.27-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.27-Glue.png?classes=lab_picture_small)

21. Under "Database" select the drop down arrow and select the new database named **cost_optimization_labs_cur**:
![Images/2.28-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.28-Glue.png?classes=lab_picture_small)

22. You will now see the table we reviewed in step 19 that is named after the S3 CUR bucket. We will now load the partitions by clicking on the **Menu with 3 dots** and selecting **Load partitions**:
![Images/2.29-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.29-Glue.png?classes=lab_picture_small)

23. You will see it execute the command **MSCK REPAIR TABLE**, and in the results it **may** add partitions to the meta store for each month that has a billing file:
![Images/2.30-Glue.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.30-Glue.png?classes=lab_picture_small)

{{% notice note %}}
NOTE: It may or may not add partitions and show the messages above.
{{% /notice %}}

**You have completed the manual setup of the Glue crawler**

---

---

---

{{% /expand%}}

11.  We will now preview the data.  Click on the **Menu with 3 dots** and select **Preview table**:
![Images/2.31-PreviewTable.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.31-PreviewTable.png?classes=lab_picture_small)

27. It will execute a **Select * from** query, and in the results you will see the first 10 lines of your CUR file:
![Images/2.32-QueryResults.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/2.32-QueryResults.png?classes=lab_picture_small)

{{% notice tip %}}
You have successfully setup your CUR file to be analyzed. You can now run SQL queries against your AWS Cost and Usage Report.
{{% /notice %}}

{{< prev_next_button link_prev_url="../" link_next_url="../3_multiple_curs/" />}}
