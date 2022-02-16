---
title: "Utilize Organization Data Source"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Create Glue Crawler
We will prepare the organization data source which we will use to join with the CUR. 

1. Go to the **Glue** Service page:
![Images/home_glue.png](/Cost/200_Pricing_Model_Analysis/Images/home_glue.png)

2. Click **Crawlers** from the left menu:
![Images/glue_crawlers.png](/Cost/200_Pricing_Model_Analysis/Images/glue_crawlers.png)

3. Click **Add crawler**:
![Images/glue_addcrawler.png](/Cost/200_Pricing_Model_Analysis/Images/glue_addcrawler.png)

4. Enter a crawler name of **Org_Glue_Crawler** and click **Next**:
![Images/Crawler_info.png](/Cost/300_Organization_Data_CUR_Connection/Images/Crawler_info.png)

5. Ensure **Data stores** is the source type, click **Next**:
![Images/crawler_source_type.png](/Cost/300_Organization_Data_CUR_Connection/Images/crawler_source_type.png)

6. Click the folder icon to list the S3 folders in your account and find your S3 bucket and find the **organisation-data** folder and click **Next**:
![Images/s3_source.png](/Cost/300_Organization_Data_CUR_Connection/Images/s3_source.png)

7. **Create an IAM role** with a name of **AWS-Organization-Data-Glue-Crawler**, click **Next**:
![Images/crawler_iam.png](/Cost/300_Organization_Data_CUR_Connection/Images/crawler_iam.png)

8. Change the frequency as **Custom** and put in 0 8 ? * MON *, and click **Next**:
![Images/Schedule.png](/Cost/300_Organization_Data_CUR_Connection/Images/Schedule.png)

9. Click on **Add database**.  Enter a database name of your CUR database **managementcur**, and click **Next**:
![Images/crawler_output.png](/Cost/300_Organization_Data_CUR_Connection/Images/crawler_output.png)

10. Click **Finish**:
![Images/crawler_finish.png](/Cost/300_Organization_Data_CUR_Connection/Images/crawler_finish.png)

11. Select the crawler **OrgGlueCrawler** and click **Run crawler**:
![Images/run_crawler.png](/Cost/300_Organization_Data_CUR_Connection/Images/run_crawler.png)

12. Once its run, you should see tables created.

13.	Go to the **Athena** service page

![Images/Athena.png](/Cost/300_Organization_Data_CUR_Connection/Images/Athena.png)

14. Run the below query, to view your data in Amazon S3. As you can see, we have the account number, the name, when it was created and the current status of that account.

		SELECT * FROM "managementcur"."organisation_data" limit 10;

![Images/Athena_Preview.png](/Cost/300_Organization_Data_CUR_Connection/Images/Athena_Preview.png)
		

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
			 name,
			sum(line_item_unblended_cost) AS line_item_unblended_cost_cost
		FROM "managementcur"."cur" cur
		JOIN  "managementcur"."organisation_data"
		ON "cur".line_item_usage_account_id = organisation_data.id
		WHERE month = '10'
				AND year = '2020'
		GROUP BY  line_item_usage_account_id,  name, line_item_product_code
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
			ON ("cur"."line_item_usage_account_id" = "organisation_data"."id")) 
			


2. Going forward you will now be able to run your queries from this view and have the data connected to your Organizations data. To see a preview where your org data is, which is at the end of the returned data, run the below query.

		SELECT * FROM "managementcur"."org_cur" limit 10;

{{% notice tip %}}
Having run these queries, you can now see how the Organization data connects to your Cost and Usage Report. 
{{% /notice %}}


{{< prev_next_button link_prev_url="../2_create_automation_resources_source/" link_next_url="../4_visualize_organization_data_in_quicksight/" />}}
