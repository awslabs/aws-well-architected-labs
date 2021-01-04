---
title: "Utilize Organization Data Source"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

### Create the Organisations Data Table
In this section we will create the AWS Organizations table in Amazon Athena. This can then be used to connect to the AWS Cost & Usage Report (CUR) or other data sets you have, to show you the names and emails of your accounts.

1.	Go to the **Athena** service page

![Images/Athena.png](/Cost/300_Organization_Data_CUR_Connection/Images/Athena.png)

2.  We are going to create the Organizations table. This can be done in any of the databases that holds your Cost & Usage Report. Copy and paste the below query replacing the **( bucket-name)** with the S3 bucket name which holds the Organizations data, into the query box. Click **Run query**.

		CREATE EXTERNAL TABLE IF NOT EXISTS managementcur.organisation_data (
		`account_number` string,
		`account_name` string,
		`creation_date` string,
		`status` string 
		)
		ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
		WITH SERDEPROPERTIES (
		'serialization.format' = ',',
		'field.delim' = ','
		) LOCATION 's3://(bucket-name)/organisation-data/'
		TBLPROPERTIES ('has_encrypted_data'='false'); 

![Images/Athena_Table.png](/Cost/300_Organization_Data_CUR_Connection/Images/Athena_Table.png)

3.	Athena should report ‘Query Successful’. Run the below query, to view your data in Amazon S3. As you can see, we have the account number, the name, when it was created and the current status of that account.

		SELECT * FROM "managementcur"."organisation_data" limit 10;

{{% notice info %}}
You have now created your Athena table that will query the organization data in the S3 Bucket. 
{{% /notice %}}


### Join with Cost and Usage Report

We will be running an example query on how you can connect your CUR to this Organizations data as a one off. In this query you will see the service costs split by account names. 

1.	In the **Athena** service page run the below query to join the Organizations data with the CUR table. Make the below changes as needed:

- Change managementcur if your named your database differently
- month = **Chosen Month**
- year = **Chosen Year**

		SELECT line_item_usage_account_id,
			line_item_product_code,
			 account_name,
			sum(line_item_unblended_cost) AS line_item_unblended_cost_cost
		FROM "managementcur"."cur" cur
		JOIN  "managementcur"."organisation_data"
		ON "cur".line_item_usage_account_id = organisation_data.account_number
		WHERE month = '10'
				AND year = '2020'
		GROUP BY  line_item_usage_account_id,  account_name, line_item_product_code
		limit 10;

![Images/Join.png](/Cost/300_Organization_Data_CUR_Connection/Images/Join.png)

2. The important part of this query is the join. The **line_item_usage_account_id** from your Cost & Usage Report should match a **account_number** from the Organizations data. You can now see the account name in your data.

![Images/Athena_Example.png](/Cost/300_Organization_Data_CUR_Connection/Images/Athena_Example.png)

### Create a View with Cost and Usage Report

If you would like to always have your Organizations data connected to your CUR then we can create a view. 

1.	In the Athena service page run the below query to join the Organizations data with the CUR table as a view. 

		CREATE OR REPLACE VIEW org_cur AS
		SELECT *
		FROM ("managementcur"."cur" cur
		INNER JOIN "managementcur"."organisation_data"
			ON ("cur"."line_item_usage_account_id" = "organisation_data"."account_number")) 
			


2. Going forward you will now be able to run your queries from this view and have the data connected to your Organizations data. To see a preview where your org data is, which is at the end of the returned data, run the below query.

		SELECT * FROM "managementcur"."org_cur" limit 10;

{{% notice tip %}}
Having run these queries you can now see how the Organization data connects to your Cost and Usage Report. 
{{% /notice %}}


{{< prev_next_button link_prev_url="../2_create_automation_resources_source/" link_next_url="../4_visualize_organization_data_in_quicksight/" />}}
