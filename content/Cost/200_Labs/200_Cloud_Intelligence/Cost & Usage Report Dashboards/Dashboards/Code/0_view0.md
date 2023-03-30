---
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 999
hidden: FALSE
---


## View 0 - Account Map
The Cost & Usage Report data doesn't contain account names and other business or organization specific mapping so the first view you will create is a view that enhances your CUR data. There are a few options you can leverage to create your account_map view to provide opportunities to leverage your existing mapping tables, organization information, or other business mappings allows for deeper insights.  This view will be used to create the **Account_Map** for your dashboards.

{{% notice tip %}}
You can update your account_map view or change options at a future time. If you are unsure of what option to use we suggest starting with Option 1. If you are creating AWS Accounts frequently, we suggest using Option 3-A   
{{% /notice %}}

### Option 1: Placeholder Account Map data
The Account Map placeholder option is a quick way to create your view if you do not use AWS Organizations, have an existing account mapping document, or are looking to quickly create the dashboards for a proof of concept. 
- {{%expand "Click here - to create using placeholder data manually" %}}

Modify the following SQL query for View0 - Account Map: 
 - On line 5, replace **(database.table_name)** with your Cost & Usage Report database and table name

		CREATE OR REPLACE VIEW account_map AS
		SELECT DISTINCT
			"line_item_usage_account_id" "account_id", "line_item_usage_account_id" "account_name"
		FROM
			(database.table_name)
			
{{% /expand%}}

- {{%expand "Click here - to create using placeholder data with cid-cmd tool" %}}

		cid-cmd map --account-map-source dummy

{{% /expand%}}


### Option 2: Account Map CSV file using your existing AWS account mapping data
Many organizations already maintain their account mapping outside of AWS. You can leverage your existing mapping data by creating a csv file with your account mapping data including any additional organization attributes. 

- {{%expand "Click here - to create using an your own account mapping csv and Amazon S3" %}}

#### Create your account_map csv file
This example will show you how to create using a sample account_map csv file

1. Create an account_map csv file locally, you can use the sample here and requirements below as a starting point:
[account_map.csv](/Cost/200_Cloud_Intelligence/account_map.csv)

2. Update your account_map csv with your account mapping data


#### Upload your account_map csv file to Amazon S3

1. Navigate to **Amazon S3**

2. Select **Create Bucket**

    ![view0_create_bucket](/Cost/200_Cloud_Intelligence/Images/cur/view0_create_bucket.png?classes=lab_picture_small)
	
3. Name your bucket, we recommend **cost-account-map-<account_id>** to easily locate

    ![view0_name_bucket](/Cost/200_Cloud_Intelligence/Images/cur/view0_name_bucket.png?classes=lab_picture_small)
	

4. Scroll to the bottom and select **Create Bucket**

    ![view0_save_bucket](/Cost/200_Cloud_Intelligence/Images/cur/view0_save_bucket.png?classes=lab_picture_small)
	
5. Navigate to your newly created s3 bucket

    ![view0_select_bucket](/Cost/200_Cloud_Intelligence/Images/cur/view0_select_bucket.png?classes=lab_picture_small)

5. Select **Create folder**

    ![view0_create_folder](/Cost/200_Cloud_Intelligence/Images/cur/view0_create_folder.png?classes=lab_picture_small)

6. Name your folder **account-map** and select **Create folder**

    ![view0_name_folder](/Cost/200_Cloud_Intelligence/Images/cur/view0_name_folder.png?classes=lab_picture_small)

7. Click on your newly created **account-map** folder

    ![view0_select_folder](/Cost/200_Cloud_Intelligence/Images/cur/view0_select_folder.png?classes=lab_picture_small)

8. Select **Upload**

    ![view0_upload](/Cost/200_Cloud_Intelligence/Images/cur/view0_upload.png?classes=lab_picture_small)

9. In your newly created folder, **drag and drop** your account_map.csv file then select **Upload**

    ![view0_upload_csv](/Cost/200_Cloud_Intelligence/Images/cur/view0_upload_csv.png?classes=lab_picture_small)
	
10. Copy down the **S3 Destination** of the account-map.csv. You will need this to create your Athena table

    ![view0_copy](/Cost/200_Cloud_Intelligence/Images/cur/view0_copy.png?classes=lab_picture_small)

#### Create your account_mapping Athena table 

1. Navigate to **Amazon Athena**

2. Modify the following SQL query with your account_map.csv information
 - Replace the **<S3 Destination> in row 15** with your account-map S3 destination from step 8 of the last section (i.e. s3://cost-account-map-123456789012)

		CREATE EXTERNAL TABLE `account_mapping`(
		  `account_id` string, 
		  `account_name` string, 
		  `business_unit` string, 
		  `team` string, 
		  `cost_center` string
		  )
		ROW FORMAT DELIMITED 
		  FIELDS TERMINATED BY ',' 
		STORED AS INPUTFORMAT 
		  'org.apache.hadoop.mapred.TextInputFormat' 
		OUTPUTFORMAT 
		  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
		LOCATION
		  '<S3 Destination>'
		TBLPROPERTIES (
		  'has_encrypted_data'='false',
		  'skip.header.line.count'='1')

**NOTE:** Validate rows **2-5** match your csv columns. If you removed one of the fields in the csv you will need to remove it in the SQL query. If you added any additional fields you will need to add the attribute to the SQL query. 
    ------------ | -------------

#### Create your account_map Athena view 
The account_map Athena view ensures any new accounts are not missed in your dashboard by creating a view off of your CUR table and account_mapping Athena table. 

Modify the following SQL query with your table names:
 - Replace (database).(tablename) in line 13 with your CUR database and table name
 - Replace (database).(tablename) in line 23 with your account_mapping database and table name 

		CREATE OR REPLACE VIEW account_map AS 
		SELECT DISTINCT
		a.line_item_usage_account_id "account_id"
		, b.account_name
		, b.business_unit
		, b.team
		, b.cost_center
		FROM
		  ((
		   SELECT DISTINCT
			 line_item_usage_account_id
		   FROM
			 (database).(tablename)
		)  a
		LEFT JOIN (
		   SELECT DISTINCT
			 "lpad"("account_id", 12, '0') "account_id"
		   , account_name
		   , business_unit
		   , team
		   , cost_center
		   FROM
		   (database).(tablename)
		)  b ON (b.account_id = a.line_item_usage_account_id))

{{% /expand%}}

- {{%expand "Click here - to one-time update account map from CSV data with cid-cmd tool" %}}

		cid-cmd map --account-map-source csv --account-map-file FILE.CSV

{{% /expand%}}

- {{%expand "Click here - to one-time update account map from AWS Organizations data data with cid-cmd tool" %}}

		cid-cmd map --account-map-source organization

{{% /expand%}}

### Option 3: Leverage your existing AWS Organizations account mapping (recommended)
This option allows your to bring in your AWS Organizations data including OU grouping

- {{%expand "Click here to expand" %}}

You will need an additional Lab. This can collects multiple types of data across accounts and AWS Organization, including Trusted Advisor and Compute Optimizer Data. For Account Names you will need only one module **AWS Organization Module**, but we recommend to explore other modules of this lab as well.

- [Click to navigate to Level 300 Optimization Data Collection/]({{< ref "/Cost/300_Labs/300_optimization_data_collection" >}})

After succesful deployment create or update your account_map view by running the following query in Athena Query Editor. 

		CREATE OR REPLACE VIEW account_map AS
		SELECT DISTINCT
			"id" "account_id", 
			"name" "account_name",
	                ' ' parent_account_id,
	                ' ' account_email_id 
		FROM
			"optimization_data"."organization_data"

{{% /expand%}}


### Final Steps
Once you update and tested the account_map view in Ahtena, you need to make sure QuickSight has access to the bucket of Optimization Data Collection and then refresh summary_view dataset in QuickSight. 
