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

4. Enter a crawler name of **OrgGlueCrawler** and click **Next**:


5. Ensure **Data stores** is the source type, click **Next**:


6. Click the folder icon to list the S3 folders in your account:


7. Expand the bucket which contains your pricing folders, and select the folder name **organisation-data**, click **Select**:


8. Click **Next**:


9. Click **Next**:


10. **Create an IAM role** with a name of **AWS-Organization-Data-Glue-Crawler**, click **Next**:


11. Leave the frequency as **Custom**, and click **Next**:


12. Click on **Add database**:


13. Enter a database name of **managementcur**, and click **Create**:


14. Click **Next**:


15. Click **Finish**:


16. Select the crawler **OrgGlueCrawler** and click **Run crawler**:

17. Once its run, you should see tables created:


18.	Go to the **Athena** service page

![Images/Athena.png](/Cost/300_Organization_Data_CUR_Connection/Images/Athena.png)

19. Run the below query, to view your data in Amazon S3. As you can see, we have the account number, the name, when it was created and the current status of that account.

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
