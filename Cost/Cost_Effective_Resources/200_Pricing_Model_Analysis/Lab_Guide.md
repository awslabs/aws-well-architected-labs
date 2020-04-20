# Level 200: Pricing Model Analysis

## Authors
- Nathan Besh, Cost Lead, Well-Architected (AWS)
- Nataliya Godunok, Technial Account Manager (AWS)

## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com



# Table of Contents
1. [Create Pricing Data Sources](#pricing_sources)
2. [Create the Usage Data Source](#usage_source)
3. [Setup QuickSight Dashboard](#quicksight_setup)
4. [Create the Recommendation Dashboard](#recommendation_dashboard)
5. [Format the Recommendation Dashboard](#format_dashboard)
6. [Teardown](#tear_down)
7. [Rate this Lab](#rate_lab)


<a name="pricing_sources"></a>
## 1. Create Pricing Data Sources
Create S3 bucket with folders, lambda functions, CloudWatch event, table in Athena


### 1.1. Create S3 Bucket and Folders
Create a **single S3 bucket** that contains **two folders** - **od_pricedata** and **sp_pricedata**, these will contain the on-demand pricing data and the Savings Plans pricing data.

1. Log into the console as an IAM user with the required permissions, go to the **S3** service page:
![Images/home_s3-dashboard.png](Images/home_s3-dashboard.png)

2. Click **Create bucket**:

3. Enter a **Bucket name** (we have used sptool-pricingfiles, you will need to use a unique bucket name) and click **Create bucket**:
![Images/s3_bucketdetails-create.png](Images/s3_bucketdetails-create.png)

4. Click on the **(bucket name)**:
![Images/s3_select-bucket.png](Images/s3_select-bucket.png)

5. Click **Create folder**:
![Images/s3_createfolder.png](Images/s3_createfolder.png)

6. Enter a folder name of **od_pricedata**, click **Save**:
![Images/s3_createfolder-save.png](Images/s3_createfolder-save.png)

7. Click **Create folder**:
![Images/s3_createfolder.png](Images/s3_createfolder.png)

8. Enter a folder name of **sp_pricedata**, click **Save**:
![Images/s3_createfolder-save2.png](Images/s3_createfolder-save2.png)

You have now setup the S3 bucket with the two folders that will contain the OnDemand and Savings Plans pricing data.
![Images/s3_bucket-complete.png](Images/s3_bucket-complete.png)



### 1.2. Setup On-Demand Pricing Lambda Function
Create the On-Demand Lambda function to get the pricing information, and extract the required parts from it.

1. Go to the **Lambda** service page:
![Images/home_lambda-dashboard.png](Images/home_lambda-dashboard.png)

2. Click **Create function**:
![Images/lambda_createfunction.png](Images/lambda_createfunction.png)

3. Enter the following details:
    - Select: **Author from scratch**
    - Function name: **SPTool_ODPricing_Download**
    - Runtime: **Python** (Latest)
    - Execution Role: **Create a new role**
    - Role name: **SPTool_Lambda**

4. Click **Create function**
![Images/lambda_createfunction-details.png](Images/lambda_createfunction-details.png)

5. Copy and paste the following code into the **Function code** section:

    <details>
    <summary> Click here to see the function code</summary>
    
        # Lambda Function Code - SPTool_OD_pricing_Download
        # Function to download OnDemand pricing, get out the required lines & upload it to S3 as a zipped file
        # It will find 'OnDemand' and 'Compute Instance', and write to a file
        # Written by natbesh@amazon.com
        # Please reachout to costoptimization@amazon.com if there's any comments or suggestions
        import boto3
        import gzip
        import urllib3

        def lambda_handler(event, context):

            # Create the connection
            http = urllib3.PoolManager()

            try:
                # Get the EC2 OnDemand pricing file, its huge >1GB
                r = http.request('GET', 'https://pricing.us-east-1.amazonaws.com/offers/v1.0/aws/AmazonEC2/current/index.csv')

                # Put the response data into a variable & split it into an array line by line
                plaintext_content = r.data
                plaintext_lines = plaintext_content.splitlines()

                # Varaible to hold the OnDemand pricing data
                pricing_output = ""

                # Go through each of the pricing lines to find the ones we need
                for line in plaintext_lines:

                    # If the line contains 'OnDemand' or 'Compute Instance' then add it to the output string
                    if ((str(line).find('OnDemand') != -1) and (str(line).find('RunInstances') != -1)):
                        pricing_output += str(line.decode("utf-8"))
                        pricing_output += "\n"

                # Add the output to a local temporary file & zip it
                with gzip.open('/tmp/od_pricedata.txt.gz', 'wb') as f:
                    f.write(pricing_output.encode())

                # Upload the zipped file to S3
                s3 = boto3.resource('s3')

                # Specify the local file, the bucket, and the folder and object name - you MUST have a folder and object name
                s3.meta.client.upload_file('/tmp/od_pricedata.txt.gz', 'bucket_name', 'od_pricedata/od_pricedata.txt.gz')

            # Die if you cant get the pricing file                
            except Exception as e:
                print(e)
                raise e

            # Return happy
            return {
                'statusCode': 200
            }
    </details>

6. Edit the pasted code, replacing **bucket_name** with the name of your bucket:
![Images/lambda_editcode.png](Images/lambda_editcode.png)

7. Edit **Basic settings** below:
    - Memory: **2688MB**
    - Timeout: **5min**
    - Click **save**
![Images/lambda_basicsettings.png](Images/lambda_basicsettings.png)

8. Scroll to the top and click **Test**
![Images/lambda_test.png](Images/lambda_test.png)

9. Enter an **Event name** of **Test**, click **Create**:
![Images/lambda_testcreate.png](Images/lambda_testcreate.png)

10. Click **Save**:
![Images/lambda_save.png](Images/lambda_save.png)

11. Click on **Permissions**:
![Images/lambda_permissions.png](Images/lambda_permissions.png)

12. Right-click(open link in new tab) **View the SPTool_Lambda role** to open the role in the IAM Service page:
![Images/lambda_viewrole.png](Images/lambda_viewrole.png)

13. Click on **Attach policies**:
![Images/IAM_attach-policies.png](Images/IAM_attach-policies.png)

14. Click on **Create policy**:
![Images/IAM_Createpolicy.png](Images/IAM_Createpolicy.png)

15. Create a policy to allow object write to your S3 bucket created, and click **Review policy**:
![Images/IAM_reviewpolicy.png](Images/IAM_reviewpolicy.png)

16. Name the policy **s3_pricing_lambda**, optionally and add a description, click **Create policy**:
![Images/IAM_namecreatepolicy.png](Images/IAM_namecreatepolicy.png)

17. Click on **Roles**:
![Images/IAM_roles.png](Images/IAM_roles.png)

18. Click on the role **SPTool_Lambda**:
![Images/IAM_roleSPTool.png](Images/IAM_roleSPTool.png)

19. Click **Attach policies**:
![Images/IAM_attach-policies.png](Images/IAM_attach-policies.png)

20. Click **Filter Policies** and select **Customer managed**:
![Images/IAM_filterpolicies.png](Images/IAM_filterpolicies.png)

21. Select the **S3_pricing_lambda** policy and click **Attach policy**:
![Images/IAM_selectpolicy.png](Images/IAM_selectpolicy.png)

22. Go back to the **Lambda** service page and click **Test**:
![Images/lambda_testrun.png](Images/lambda_testrun.png)

23. The function will run, it will take a minute or two given the size of the pricing files and processing required, then return success. Click **Details** and verify there is headroom in the configured resources and duration to allow any increases in pricing file size over time:
![Images/lambda_runsuccess.png](Images/lambda_runsuccess.png)

24. Go to your S3 bucket and into the **od_pricedata** folder and you should see a gz file of non-zero size is in it:
![Images/s3_verify.png](Images/s3_verify.png)


### 1.3. Setup Savings Plan Pricing Lambda Function
Create the Savings Plan Lambda function to get the pricing information, and extract the required parts from it.

1. Go to the **Lambda** service page:
![Images/home_lambda-dashboard.png](Images/home_lambda-dashboard.png)

2. Click **Create function**:
![Images/lambda_createfunction.png](Images/lambda_createfunction.png)

3. Enter the following details:
    - Select: **Author from scratch**
    - Function name: **SPTool_SPPricing_Download**
    - Runtime: **Python** (Latest)
    - Execution Role: **Use an existing role**
    - Role name: **SPTool_Lambda**

4. Click **Create function**
![Images/lambda_createfunction-details2.png](Images/lambda_createfunction-details2.png)

5. Copy and paste the following code into the **Function code** section:

    <details>
    <summary> Click here to see the function code</summary>

        # Lambda Function Code - SPTool_SP_pricing_Download
        # Function to download SavingsPlans pricing, get out the required lines & upload it to S3 as a zipped file
        # It will get each regions pricing file in CSV, find 'Usage' and '1yr', and write to a file
        # Written by natbesh@amazon.com
        # Please reachout to costoptimization@amazon.com if there's any comments or suggestions
        import boto3
        import gzip
        import urllib3
        import json

        def lambda_handler(event, context):

            # Create the connection
            http = urllib3.PoolManager()

            try:
                # Get the SavingsPlans pricing index file, so you can get all the region files, which have the pricing in them
                r = http.request('GET', 'https://pricing.us-east-1.amazonaws.com/savingsPlan/v1.0/aws/AWSComputeSavingsPlan/current/region_index.json')

                # Load the json file into a variable, and parse it
                sp_regions = r.data
                sp_regions_json = (json.loads(sp_regions))

                # Variable to hold all of the pricing data, its large at over 150MB
                sp_pricing_data = ""

                # Cycle through each regions pricing file, to get the data we need
                for region in sp_regions_json['regions']:

                    # Get the CSV URL
                    url = "https://pricing.us-east-1.amazonaws.com" + region['versionUrl']
                    url = url.replace('.json', '.csv')

                    # Create a connection & get the regions pricing data CSV file
                    http = urllib3.PoolManager()
                    r = http.request('GET', url)
                    spregion_content = r.data

                    # Split the lines into an array
                    spregion_lines = spregion_content.splitlines()

                    # Go through each of the pricing lines
                    for line in spregion_lines:

                        # If the line has 'Usage' then grab it for pricing data, exclude all others
                        if (str(line).find('Usage') != -1):
                            sp_pricing_data += str(line.decode("utf-8"))
                            sp_pricing_data += "\n"

                # Compress the text into a local temporary file
                with gzip.open('/tmp/sp_pricedata.txt.gz', 'wb') as f:
                    f.write(sp_pricing_data.encode())

                # Upload the file to S3
                s3 = boto3.resource('s3')

                # Specify the local file, the bucket, and the folder and object name - you MUST have a folder and object name
                s3.meta.client.upload_file('/tmp/sp_pricedata.txt.gz', 'bucket_name', 'sp_pricedata/sp_pricedata.txt.gz')

            # Die if you cant get the file
            except Exception as e:
                print(e)
                raise e

            # Return happy
            return {
                'statusCode': 200
            }
    </details>

6. Edit the pasted code, replacing **bucket_name** with the name of your bucket:
![Images/lambda_editcode2.png](Images/lambda_editcode2.png)

7. Edit Basic settings below:
    - Memory: **2688MB**
    - Timeout: **5min**
    - Click **save**
![Images/lambda_basicsettings2.png](Images/lambda_basicsettings2.png)

8. Scroll to the top and click **Test**
![Images/lambda_test.png](Images/lambda_test.png)

9. Enter an **Event name** of **Test**, click **Create**:
![Images/lambda_testcreate.png](Images/lambda_testcreate.png)

10. Click **Save**:
![Images/lambda_save.png](Images/lambda_save.png)

11. Click **Test**:
![Images/lambda_testrun.png](Images/lambda_testrun.png)

12. The function will run, it will take a minute or two given the size of the pricing files and processing required, then return success. Click **Details** and verify there is headroom in the configured resources and duration to allow any increases in pricing file size over time:
![Images/lambda_runsuccess2.png](Images/lambda_runsuccess2.png)

13. Go to your S3 bucket and into the **sp_pricedata** folder and you should see a gz file of non-zero size is in it:
![Images/s3_verify2.png](Images/s3_verify2.png)


### 1.4 CloudWatch Events Setup
We will setup a CloudWatch Event to periodically run the Lambda functions, this will update the pricing and include any newly released instances.

1. Go to the CloudWatch service page:
![Images/home_cloudwatch.png](Images/home_cloudwatch.png)

2. Click on **Events**, then click **Rules**:
![Images/cloudwatch_events.png](Images/cloudwatch_events.png)

3. Click **Create rule**
![Images/cloudwatch_createrule.png](Images/cloudwatch_createrule.png)

4. For the **Event Source** select **Schedule** and set the required period, we have selected **5 days**, click **Add target**:
![Images/cloudwatch_eventsource.png](Images/cloudwatch_eventsource.png)

5. Add the **SPTool_ODPricing_Download** Lambda function, and click **Add target**:
![Images/cloudwatch_addtarget.png](Images/cloudwatch_addtarget.png)

6. Add the **SPTool_SPPricing_Download** Lambda function, and click **Configure details**:
![Images/cloudwatch_addtarget2.png](Images/cloudwatch_addtarget2.png)

7. Add the name **SPTool-pricing**, optionally add a description and click **Create rule**:
![Images/cloudwatch_createrule2.png](Images/cloudwatch_createrule2.png)

You have now successfully configured a CloudWatch event, it will run the two Lambda functions and update the pricing information every 5 days.


### 1.5 Prepare the Pricing Data Source
We will prepare a pricing data source which we will use to join with the CUR. In this example we will take 1 year No Upfront Savings Plans rates and join them to On-Demand pricing. You can modify this part to select 3 year or Partial or All-Upfront rates.

1. Go to the **Glue** Service page:
![Images/home_glue.png](Images/home_glue.png)

2. Click **Crawlers** from the left menu:
![Images/glue_crawlers.png](Images/glue_crawlers.png)

3. Click **Add crawler**:
![Images/glue_addcrawler.png](Images/glue_addcrawler.png)

4. Enter a crawler name of **OD_Pricing** and click **Next**:
![Images/glue_crawlername.png](Images/glue_crawlername.png)

5. Ensure **Data stores** is the source type, click **Next**:
![Images/glue_sourcetype.png](Images/glue_sourcetype.png)

6. Click the folder icon to list the S3 folders in your account:
![Images/glue_includepath.png](Images/glue_includepath.png)

7. Expand the bucket which contains your pricing folders, and select the folder name **od_pricedata**, click **Select**:
![Images/glue_choosepath.png](Images/glue_choosepath.png)

8. Click **Next**:
![Images/glue_adddatastore.png](Images/glue_adddatastore.png)

9. Click **Next**:
![Images/glue_addanother.png](Images/glue_addanother.png)

10. **Create an IAM role** with a name of **SPToolPricing**, click **Next**:
![Images/glue_addrole.png](Images/glue_addrole.png)

11. Leave the frequency as **Run on demand**, and click **Next**:
![Images/glue_schedule.png](Images/glue_schedule.png)

12. Click on **Add database**:
![Images/glue_adddatabase.png](Images/glue_adddatabase.png)

13. Enter a database name of **pricing**, and click **Create**:
![Images/glue_databasename.png](Images/glue_databasename.png)

14. Click **Next**:
![Images/glue_dboutput.png](Images/glue_dboutput.png)

15. Click **Finish**:
![Images/glue_finishcrawler.png](Images/glue_finishcrawler.png)

16. Select the crawler **OD_Pricing** and click **Run crawler**:
![Images/glue_runcrawler.png](Images/glue_runcrawler.png)

17. Once its run, you should see tables created:
![Images/glue_runsuccess.png](Images/glue_runsuccess.png)

18. Repeat **Steps 3 through to 17** with the following details:
    - Crawler name: **SP_Pricing**
    - Include path: **s3://(pricing bucket)/sp_pricedata** (replace pricing bucket)
    - IAM Role: **Choose an existing IAM role** and **AWSGlueServiceRole-SPToolPricing**
    - Database: **pricing**

19. Open the **IAM Console** in a new tab, click **Policies**:
![Images/IAM_policy.png](Images/IAM_policy.png)

20. Click on the **AWSGlueServiceRole-SPToolPricing** role:
![Images/IAM_selectrole.png](Images/IAM_selectrole.png)

21. Type in **SPTool** and click on the policy name **AWSGlueServiceRole-SPTool**:
![Images/IAM_policy.png](Images/IAM_policy.png)

22. Click **Edit policy**:
![Images/IAM_editpolicy.png](Images/IAM_editpolicy.png)

23. Click **JSON**:
![Images/IAM_jsonpolicy.png](Images/IAM_jsonpolicy.png)

24. Edit the **Resource** line by removing the **OD_Pricing** folder to leave the bucket:
![Images/IAM_editjson.png](Images/IAM_editjson.png)

25. Click **Review policy**:
![Images/IAM_reviewjson.png](Images/IAM_reviewjson.png)

26. Click **Save changes**:
![Images/IAM_savejson.png](Images/IAM_savejson.png)

27. Go back to the Glue console, select the **SP_Pricing** crawler, click **Run crawler**:
![Images/glue_runspcrawler.png](Images/glue_runspcrawler.png)

28. Click on **Databases**:
![Images/glue_databases.png](Images/glue_databases.png)

29. Click on **Pricing**:
![Images/glue_databasepricing.png](Images/glue_databasepricing.png)

30. Click **Tables in pricing**:
![Images/glue_pricingtables.png](Images/glue_pricingtables.png)

31. Click **od_pricedata**:
![Images/glue_odpricing.png](Images/glue_odpricing.png)

32.Click **Edit schema**:
![Images/glue_editschema.png](Images/glue_editschema.png)

33. Click **double** next to **col9**:
![Images/glue_col9.png](Images/glue_col9.png)

34. Select **string** and click **Update**:
![Images/glue_col9string.png](Images/glue_col9string.png)

35. Click **Save**:
![Images/glue_schemasave.png](Images/glue_schemasave.png)


<a name="usage_source"></a>
## 2. Create the Usage Data Source
We will combine the pricing information with our Cost and Usage Report (CUR). This will give us a usage data source which contains a summary of your usage at an hourly level, with multiple pricing dimensions.

1. Go to the **Athena** service page:
![Images/home_athena.png](Images/home_athena.png)

2. Run the following query to create a single pricing data source, combining the OD and SP pricing:

    <details>
    <summary> Click here to see the Athena SQL code</summary>

        CREATE VIEW pricing.pricing AS SELECT
        sp.location AS Region,
        sp.discountedoperation AS OS,
        REPLACE(od.col18, '"') AS InstanceType,
        REPLACE(od.col35, '"') AS Tenancy,
        REPLACE(od.col9, '"') AS ODRate,
        sp.discountedrate AS SPRate

        FROM pricing.sp_pricedata sp
        JOIN pricing.od_pricedata od ON
        ((sp.discountedusagetype = REPLACE(od.col46, '"'))
        AND (sp.discountedoperation = REPLACE(od.col47, '"')))

        WHERE od.col9 IS NOT NULL
        AND sp.location NOT LIKE 'Any'
        AND sp.purchaseoption LIKE 'No Upfront'
        AND sp.leasecontractlength = 1
    </details>

3. Next we'll join the CUR file with that pricing source as a view. Edit the following query, replace **cur.curfile** with your existing database name and tablename of your CUR, then run the rollowing query:

    <details>
    <summary> Click here to see the Athena SQL code</summary>

        CREATE VIEW cur.SP_Usage AS SELECT
        cur.line_item_usage_account_id,
        cur.line_item_usage_start_date,
        to_unixtime(cur.line_item_usage_start_date) AS EpochTime,
        cur.product_instance_type,
        cur.product_location,
        cur.product_operating_system,
        cur.product_tenancy,
        SUM(cur.line_item_unblended_cost) AS ODPrice,
        SUM(cur.line_item_unblended_cost*(cast(pr.SPRate AS double)/cast(pr.ODRate AS double))) SPPrice,
        abs(SUM(cast(pr.SPRate AS double)) - SUM (cast(pr.ODRate AS double))) / SUM(cast(pr.ODRate AS double))*100 AS DiscountRate,
        SUM(cur.line_item_usage_amount) AS InstanceCount

        FROM cur.curfile cur
        JOIN pricing.pricing pr ON (cur.product_location = pr.Region)
        AND (cur.line_item_operation = pr.OS)
        AND (cur.product_instance_type = pr.InstanceType)
        AND (cur.product_tenancy = pr.Tenancy)

        WHERE cur.line_item_product_code LIKE '%EC2%'
        AND cur.product_instance_type NOT LIKE ''
        AND cur.product_operating_system NOT LIKE 'NA'
        AND cur.line_item_unblended_cost > 0

        GROUP BY cur.line_item_usage_account_id,
        cur.line_item_usage_start_date,
        cur.product_instance_type,
        cur.product_location,
        cur.product_operating_system,
        cur.product_tenancy

        ORDER BY cur.line_item_usage_start_date ASC,
        DiscountRate DESC
    </details>

4. Verify the data source is setup by editing the following query, replace **cur.** with the name of the database and run the following query:
```SQL
SELECT * FROM cur.sp_usage limit 10;
```

You now have your usage data source setup with your pricing dimensions. You can modify the queries above to add or remove any columns you want in the view, which can later be used to visualize the data, for example tags.


<a name="quicksight_setup"></a>
## 3. Setup QuickSight Dashboard
We will now setup the QuickSight dashboard to visualize your usage by cost, and setup the analysis to provide Savings Plan recommendations.

1. Go to the QuickSight service:
![Images/home_quicksight.png](Images/home_quicksight.png)

2. Click on your username in the top right:
![Images/quicksight_admin.png](Images/quicksight_admin.png)

3. Click **Manage QuickSight**:
![Images/quicksight_manage.png](Images/quicksight_manage.png)

4. Click **Security & permissions**, then click **Add or remove**:
![Images/quicksight_securityperms.png](Images/quicksight_securityperms.png)

5. Click **Details** next to Amazon S3:
![Images/quicksight_s3details.png](Images/quicksight_s3details.png)

6. Click **Select S3 buckets**:
![Images/quicksight_s3selectbucket.png](Images/quicksight_s3selectbucket.png)

7. Select your **pricing bucket** and click **Finish**:
![Images/quicksight_s3bucketfinish.png](Images/quicksight_s3bucketfinish.png)

8. Scroll down and click **Update**:
![Images/quicksight_s3update.png](Images/quicksight_s3update.png)

9. Click on **QuickSight** to go to the home page:
![Images/quicksight_home.png](Images/quicksight_home.png)

10. Click on **Manage data**:
![Images/quicksight_managedata.png](Images/quicksight_managedata.png)

11. Click on **New data set**:
![Images/quicksight_newdataset.png](Images/quicksight_newdataset.png)

12. Click **Athena**:
![Images/quicksight_athenadataset.png](Images/quicksight_athenadataset.png)

13. Enter a Data source name of **SP_Usage** and click **Create data source**:
![Images/quicksight_namedatasource.png](Images/quicksight_namedatasource.png)

14. Select the **cur** database, and the **sp_usage** table, click **Select**:
![Images/quicksight_choosetable.png](Images/quicksight_choosetable.png)

15. Ensure SPICE is selected, click **Visualize**:
![Images/quicksight_datasetfinish.png](Images/quicksight_datasetfinish.png)

16. Click on **QuickSight** to go to the home page:
![Images/quicksight_home.png](Images/quicksight_home.png)

17. Click on **Manage data**:
![Images/quicksight_managedata.png](Images/quicksight_managedata.png)

18. Select the **sp_usage** Dataset:
![Images/quicksight_refresh1.png](Images/quicksight_refresh1.png)

19. Click **Schedule refresh**:
![Images/quicksight_refresh2.png](Images/quicksight_refresh2.png)

20. Click **Create**:
![Images/quicksight_refresh3.png](Images/quicksight_refresh3.png)

21. Enter a schedule, it needs to be refreshed daily, and click **Create**:
![Images/quicksight_refresh4.png](Images/quicksight_refresh4.png)

22. Click **Cancel** to exit: 
![Images/quicksight_refresh5.png](Images/quicksight_refresh5.png)

23. Click the **x** in the top corner:
![Images/quicksight_refresh6.png](Images/quicksight_refresh6.png)


<a name="recommendation_dashboard"></a>
## 4. Create the Recommendation Dashboard

1. Go to the QuickSight service homepage:
![Images/home_quicksight.png](Images/home_quicksight.png)

2. Go to the **sp_usage analysis**: 
![Images/quicksight_sp_analysis.png](Images/quicksight_sp_analysis.png)

3. Create a line chart, add **line_item_usage_start_date** to the **X axis**, aggregate **day**. Add **spprice** to the **Value** and set the aggregate to **min**. Drag the **product_instance_type** to **Colour** field well. Change the title to **Usage in Savings Plan Rates**:
![Images/quicksight_sp_graph.png](Images/quicksight_sp_graph.png)

4. Click **Parameters**, and click **Create one**:
![Images/quicksight_parameter_create.png](Images/quicksight_parameter_create.png)

5. Parameter name **OperatingSystem**, Data type **String**, click **Set a dynamic default**:
![Images/quicksight_parameter_create1.png](Images/quicksight_parameter_create1.png)

6. Select your dataset, and select **product_operating_system** for the columns, click Apply:
![Images/quicksight_parameter_create2.png](Images/quicksight_parameter_create2.png)

7. Click **Create**:
![Images/quicksight_parameter_create3.png](Images/quicksight_parameter_create3.png)

8. Click **Control**:
![Images/quicksight_parameter_create4.png](Images/quicksight_parameter_create4.png)

9. Enter **OperatingSystem** as the display name, style **Single select drop down**, values **Link to a data set field**, dataset **your data set**, column **product_operating_system**, click **Add**:
![Images/quicksight_parameter_create5.png](Images/quicksight_parameter_create5.png)

10. Using the process above, Add the parameter **Region**:
    - Name: Region
    - Data type: String
    - Values: Single value
    - Dyanmic default
    - Dataset: your dataset, product_location, product_location
    - Add as: Control
    - Control Display Name: Region
    - Style: Single select drop down
    - Values: link to data set field
    - Data set: your data set
    - Column: product_location

11. Using the process above, Add the parameter **Tenancy**:
    - Name: Tenancy
    - Data type: String
    - Values: Single value
    - Dyanmic default
    - Dataset: your dataset, product_tenancy, product_tenancy
    - Add as: Control
    - Control Display Name: Tenancy
    - Style: Single select drop down
    - Values: link to data set field
    - Data set: your data set
    - Column: product_tenancy
 
12. Create an **InstanceType** parameter, datatype **String**, **Single value**, Static default value of **.** (a full stop):
![Images/quicksight_parameter_create6.png](Images/quicksight_parameter_create6.png)

13. Click **Control**, 
![Images/quicksight_parameter_create7.png](Images/quicksight_parameter_create7.png)

14. Display name **InstanceType**, style **Text box**, click **Add**:
![Images/quicksight_parameter_create8.png](Images/quicksight_parameter_create8.png)

15. Click **Filter** and click **Create one**, select **product_instance_type**:
![Images/quicksight_filter_create.png](Images/quicksight_filter_create.png)

16. Edit the filter, Filter type: 
    - **All visuals**
    - **Custom filter**
    - **Contains**
    - **Use Parameters**
    - **InstanceType**
    - click **Apply**:
![Images/quicksight_filter_edit.png](Images/quicksight_filter_edit.png)

17. Create a Parameter **DaysToDisplay**:
    - Name: DaysToDisplay
    - Data type: Integer
    - Values: Single value
    - Static default value: 90
    - Click **Create**:
![Images/quicksight_daystodisplay_create.png](Images/quicksight_daystodisplay_create.png)

18. Click **Control**:
![Images/quicksight_daystodisplay_create2.png](Images/quicksight_daystodisplay_create2.png)

19. Enter a Display name **DaysToDisplay**, Style **Text box** and click **Add**: 
![Images/quicksight_daystodisplay_create3.png](Images/quicksight_daystodisplay_create3.png)

20. Click on **Filter**, click **+**, and select **line_item_usage_start_date**:
![Images/quicksight_add_filter.png](Images/quicksight_add_filter.png)

21. Click on the new filter:
![Images/quicksight_add_filter2.png](Images/quicksight_add_filter2.png)

22. Select a filter type of:
    - **All visuals**
    - **Relative dates**
    - **Days**
    - **Last N days**
    - select **Use parameters**, and accept to change the scope of the filter
    - select the parameter **DaysToDisplay**
    - click **Apply**:
![Images/quicksight_add_filter3.png](Images/quicksight_add_filter3.png)

23. Create a filter for **product_operating_system**:
    - **All visuals**
    - Type: Custom filter
    - equals
    - Use parameters, change the scope of this filter: yes
    - Parameter: OperatingSystem
![Images/quicksight_os_filter.png](Images/quicksight_os_filter.png) 

24. Create a filter for **product_location**:
    - **All visuals**
    - Type: Custom filter
    - equals
    - Use parameters, change the scope of this filter: yes
    - Parameter: Region
![Images/quicksight_os_filter.png](Images/quicksight_location_filter.png) 
 
24. Create a filter for **product_tenancy**:
    - **All visuals**
    - Type: Custom filter
    - equals
    - Use parameters, change the scope of this filter: yes
    - Parameter: Tenancy
![Images/quicksight_tenancy_filter.png](Images/quicksight_tenancy_filter.png) 

25. Click on **Visualize**, click **Add**, select **Add calculated field**:
![Images/quicksight_add_calc_field1.png](Images/quicksight_add_calc_field1.png)

26. Field name **HoursDisplayed**, add the formula below and click **Create**:

        distinct_count({line_item_usage_start_date})
![Images/quicksight_add_calc_field2.png](Images/quicksight_add_calc_field2.png)   

27. Create a calculated field **HoursRun**, formula:

        HoursDisplayed / (${DaysToDisplay} * 24)

28. Create a calculated field **PayOffMonth**, formula:

        ifelse(((((sum(spprice) / HoursDisplayed) * 730 * 12) / ((sum(odprice) / (${DaysToDisplay} * 24)) * 730))) < 12,((((sum(spprice) / HoursDisplayed) * 730 * 12) / ((sum(odprice) / (${DaysToDisplay} * 24)) * 730))),12)

29. Create a calculated field **SavingsPlanReco**, formula:

        ifelse(PayOffMonth < 12,percentile(spprice,10),0.00)

30. Create a calculated field **StartSPPrice**, formula:

        lag(min(spprice),[{line_item_usage_start_date} ASC],${DaysToDisplay} - 2,[{product_instance_type}])

31. Create a calculated field **Trend**, formula:

        (min(spprice) - {StartSPPrice}) / min(spprice) 

32. Create a calculated field **First3QtrAvg**, formula:

        windowAvg(avg(spprice),[{line_item_usage_start_date} ASC],${DaysToDisplay},${DaysToDisplay} / 4,[{product_instance_type}])

33. Create a calculated field **LastQtrAvg**, formula: 

        windowAvg(avg(spprice),[{line_item_usage_start_date} ASC],${DaysToDisplay} / 4,1,[{product_instance_type}])

34. Create a calculated field **TrendAvg**, formula:

        (LastQtrAvg- First3QtrAvg) / First3QtrAvg

35. Add a Visual, click **Add**, select **Add visual**:
![Images/quicksight_add_visual1.png](Images/quicksight_add_visual1.png)

36. Select a **Table** visualization, Group by **product_instance_type**, Add the **values**:
    - SavingsPlanReco
    - PayOffMonth
    - discountrate, aggregate: average
    - HoursRun, show as percent
    - Label it **Recommendations**
![Images/quicksight_add_visual2.png](Images/quicksight_add_visual2.png)

37. Add a **Table** visual, Group By: **product_instance_type** and **line_item_usage_start_date aggreate: day**, Add the **values**:
    - instancecount aggregate: average
    - Trend
    - TrendAvg (show as percent)
    - Label it **Trends**,
![Images/quicksight_add_visual3.png](Images/quicksight_add_visual3.png)
 
38. Add a **filter** to **this visual only**:
    - Filter on: StartSPPrice
    - Type: Custom filter
    - Operation: Greater than
    - Value: -1
    - Nulls: Exclude nulls

40. Decrease the width of the date column as much as possible, its not needed


<a name="format_dashboard"></a>
## 5. Format the Recommendation Dashboard
We will format the recommendation dashboard, this will improve its appearance, and also includes some business rules.

1. Click on **Themes**, then click on **Midnight**:
![Images/quicksight_themes.png](Images/quicksight_themes.png)

2. Select the **Recommendations** table, click the **three dots**, click **Conditional formatting**:
![Images/quicksight_conditional_formatting1.png](Images/quicksight_conditional_formatting1.png)

3. Column: **PayOffMonth**, **Add background color**:
![Images/quicksight_conditional_formatting2.png](Images/quicksight_conditional_formatting2.png)

4. Enter the formatting:
    - Condition: Greater than
    - Value: 9
    - Color: red
    - Click **Apply**, click **Close**:
![Images/quicksight_conditional_formatting3.png](Images/quicksight_conditional_formatting3.png)

5. Using the same process, add formatting for the column **discountrate**:
    - Type: Background color
    - Condition: Less than
    - Value: 10 **NOTE** adjust this for your business rules, speak with your finance teams
    - Color: red
    - Click **Apply**, click **Close**

6. Under the **discountrate** formatting, Click **Add text color**:
    - Condition: Greater than
    - Value: 20
    - Color: Green
    - Click **Apply**, click **Close**
      
6. Using the same process, add formatting for the column **HoursRun**:
    - Type: **Add text color**
    - Condition: Less than
    - Value: 0.6
    - Color: Red
    - Click **Add condition**
    - Condition#2: Less than
    - Value: 0.85
    - Color: Orange
    - Click **Apply**, click **Close**
   
7. Add formatting for the column **SavingsPlanReco**:
     - Type: Add background color
     - Format field based on: PayOffMonth
     - Condition: Greater than
     - Value: 9
     - Color: Red
     - Click **Apply**, click **Close**
     - Click **Add text color**
     - Format field based on: discountrate
     - Aggregation: Average
     - Condition: greater than
     - Value: 20
     - Color: Green
     - Click **Apply**, click **Close**
   
8. Click **SavingsPlanReco**, **Sort by Descending**:   
![Images/quicksight_conditional_formatting4.png](Images/quicksight_conditional_formatting4.png)
   
9. Select the **Trends** table, select conditional formatting, Column **instancecount**:
    - Type: Add background color
    - Condition: Less than
    - Value: 5, speak with your team to set this at the appropriate level
    - Color: red
    - Click **Add condition**
    - Condition #2: Less than
    - Value: 10
    - Color: Orange
    - Click **Apply**, click **Close**

10. Using the process above on the **Trends** table, Select the **Trend** column:
    - Type: Add background color
    - Condition: Less than
    - Value 0
    - Color: Red
    - Click **Apply**, click **Close**
    - Click **Add text color**
    - Condition: Greater than
    - Value: 0
    - Color: Green
    - Click **Apply**, Click **Close** 

11. Add the same formatting to the **TrendAvg** column as the **Trend** column.


Congratulations - you now have an analytics dashboard for Savings Plan recommendations!

<a name="tear_down"></a>
## 6. Teardown
Savings Plan analysis is a critical requirement of cost optimization, so there is no tear down for this lab. 

The following resources were created in this lab:

- S3 Bucket: (custom name)
- Lambda Functions: SPTool_ODPricing_Download and SPTool_SPPricing_Download
- IAM Role: SPTool_Lambda
- IAM Policy: s3_pricing_lambda
- CloudWatch Event, Rule: SPTool-Pricing
- Glue Crawlers: OD_Pricing and SP_Pricing
- IAM Role: AWSGlueServiceRole-SPToolPricing
- Glue Database: Pricing
- Athena Views: pricing.pricing and cur.SP_USage
- QuickSight Permissions: your pricing S3 bucket
- QuickSight Dataset: SP_Usage
- QuickSight Analysis: sp_usage analysis

<a name="rate_lab"></a>
## 7. Rate this lab
[![1 Star](../../../common/images/star.png)](http://wellarchitectedlabs.com/Cost_SP_Analysis_1star) [![2 star](../../../common/images/star.png)](http:///wellarchitectedlabs.com/Cost_SP_Analysis_2star) [![3 star](../../../common/images/star.png)](http:///wellarchitectedlabs.com/Cost_SP_Analysis_3star) [![4 star](../../../common/images/star.png)](http:///wellarchitectedlabs.com/Cost_SP_Analysis_4star) [![5 star](../../../common/images/star.png)](http:///wellarchitectedlabs.com/Cost_SP_Analysis_5star)

