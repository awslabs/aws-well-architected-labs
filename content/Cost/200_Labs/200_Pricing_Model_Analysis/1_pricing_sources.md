---
title: "Create Pricing Data Sources"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### Create S3 Bucket and Folders
Create a **single S3 bucket** that contains **two folders** - **od_pricedata** and **sp_pricedata**, these will contain the on-demand pricing data and the Savings Plans pricing data.

1. Log into the console via SSO, go to the **S3** service page:
![Images/home_s3-dashboard.png](/Cost/200_Pricing_Model_Analysis/Images/home_s3-dashboard.png)

2. Click **Create bucket**:

3. Enter a **Bucket name** starting with **cost** (we have used cost-sptool-pricingfiles, you will need to use a unique bucket name) and click **Create bucket**:
![Images/s3_bucketdetails-create.png](/Cost/200_Pricing_Model_Analysis/Images/s3_bucketdetails-create.png)

4. Click on the **(bucket name)**:
![Images/s3_select-bucket.png](/Cost/200_Pricing_Model_Analysis/Images/s3_select-bucket.png)

5. Click **Create folder**:
![Images/s3_createfolder.png](/Cost/200_Pricing_Model_Analysis/Images/s3_createfolder.png)

6. Enter a folder name of **od_pricedata**, click **Save**:
![Images/s3_createfolder-save.png](/Cost/200_Pricing_Model_Analysis/Images/s3_createfolder-save.png)

7. Click **Create folder**:
![Images/s3_createfolder.png](/Cost/200_Pricing_Model_Analysis/Images/s3_createfolder.png)

8. Enter a folder name of **sp_pricedata**, click **Save**:
![Images/s3_createfolder-save2.png](/Cost/200_Pricing_Model_Analysis/Images/s3_createfolder-save2.png)

You have now setup the S3 bucket with the two folders that will contain the OnDemand and Savings Plans pricing data.
![Images/s3_bucket-complete.png](/Cost/200_Pricing_Model_Analysis/Images/s3_bucket-complete.png)


### Create IAM Role and Policies
1. Go to the **IAM Console**

2. Select **Policies** and **Create Policy**
![Images/IAM_policiescreate.png](/Cost/200_Pricing_Model_Analysis/Images/IAM_policiescreate.png)

3. Edit the following policy and replace **(S3 pricing bucket)** with your bucket name, on the **JSON** tab, enter the following policy, click **Review policy**:

       {
           "Version": "2012-10-17",
           "Statement": [
               {
                   "Sid": "S3SPTool",
                   "Effect": "Allow",
                   "Action": [
                       "s3:PutObject",
                       "s3:DeleteObjectVersion",
                       "s3:DeleteObject"
                   ],
                   "Resource": "arn:aws:s3:::(S3 pricing bucket)/*"
               }
           ]
       }

4. **Policy Name** S3PricingLambda, **Description** Access to S3 for Lambda SPTool function, click **Create policy**:
![Images/IAMReviewpolicy_create.png](/Cost/200_Pricing_Model_Analysis/Images/IAMReviewpolicy_create.png)

5. Select **Roles**, click **Create role**:
![Images/IAM_rolescreate.png](/Cost/200_Pricing_Model_Analysis/Images/IAM_rolescreate.png)

6. Select **Lambda**, click **Next: Permissions**:
![Images/IAMRole_lambdapermissions.png](/Cost/200_Pricing_Model_Analysis/Images/IAMRole_lambdapermissions.png)

7. Select the **S3PricingLambda** policy, click **Next: Tags**:
![Images/IAMRole_policiestags.png](/Cost/200_Pricing_Model_Analysis/Images/IAMRole_policiestags.png)

8. Click **Next: Review**

9. **Role name** SPToolS3Lambda, click **Create role**:
![Images/IAMRole_complete.png](/Cost/200_Pricing_Model_Analysis/Images/IAMRole_complete.png)





### Setup On-Demand Pricing Lambda Function
Create the On-Demand Lambda function to get the pricing information, and extract the required parts from it.

1. Go to the **Lambda** service page:
![Images/home_lambda-dashboard.png](/Cost/200_Pricing_Model_Analysis/Images/home_lambda-dashboard.png)

2. Click **Create function**:
![Images/lambda_createfunction.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_createfunction.png)

3. Enter the following details:
    - Select: **Author from scratch**
    - Function name: **Cost_SPTool_ODPricing_Download**
    - Runtime: **Python** (Latest)
    - Execution Role: **Use an existing role**
    - Role name: **SPToolS3Lambda**

4. Click **Create function**
![Images/lambda_createfunction-details.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_createfunction-details.png)

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
![Images/lambda_editcode.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_editcode.png)

7. Edit **Basic settings** below:
    - Memory: **2688MB**
    - Timeout: **2min**
    - Click **save**
![Images/lambda_basicsettings.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_basicsettings.png)

8. Scroll to the top and click **Test**
![Images/lambda_test.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_test.png)

9. Enter an **Event name** of **Test**, click **Create**:
![Images/lambda_testcreate.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_testcreate.png)

10. Click **Save**:
![Images/lambda_save.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_save.png)


11. Click **Test**:
![Images/lambda_testrun.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_testrun.png)

12. The function will run, it will take a minute or two given the size of the pricing files and processing required, then return success. Click **Details** and verify there is headroom in the configured resources and duration to allow any increases in pricing file size over time:
![Images/lambda_runsuccess.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_runsuccess.png)

13. Go to your S3 bucket and into the **od_pricedata** folder and you should see a gz file of non-zero size is in it:
![Images/s3_verify.png](/Cost/200_Pricing_Model_Analysis/Images/s3_verify.png)


### Setup Savings Plan Pricing Lambda Function
Create the Savings Plan Lambda function to get the pricing information, and extract the required parts from it.

1. Go to the **Lambda** service page:
![Images/home_lambda-dashboard.png](/Cost/200_Pricing_Model_Analysis/Images/home_lambda-dashboard.png)

2. Click **Create function**:
![Images/lambda_createfunction.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_createfunction.png)

3. Enter the following details:
    - Select: **Author from scratch**
    - Function name: **Cost_SPTool_SPPricing_Download**
    - Runtime: **Python** (Latest)
    - Execution Role: **Use an existing role**
    - Role name: **SPToolS3Lambda**

4. Click **Create function**
![Images/lambda_createfunction-details2.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_createfunction-details2.png)

5. Copy and paste the following code into the **Function code** section:

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


6. Edit the pasted code, replacing **bucket_name** with the name of your bucket:
![Images/lambda_editcode2.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_editcode2.png)

7. Edit Basic settings below:
    - Memory: **1280MB**
    - Timeout: **2min**
    - Click **save**
![Images/lambda_basicsettings2.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_basicsettings2.png)

8. Scroll to the top and click **Test**
![Images/lambda_test.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_test.png)

9. Enter an **Event name** of **Test**, click **Create**:
![Images/lambda_testcreate.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_testcreate.png)

10. Click **Save**:
![Images/lambda_save.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_save.png)

11. Click **Test**:
![Images/lambda_testrun.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_testrun.png)

12. The function will run, it will take a minute or two given the size of the pricing files and processing required, then return success. Click **Details** and verify there is headroom in the configured resources and duration to allow any increases in pricing file size over time:
![Images/lambda_runsuccess2.png](/Cost/200_Pricing_Model_Analysis/Images/lambda_runsuccess2.png)

13. Go to your S3 bucket and into the **sp_pricedata** folder and you should see a gz file of non-zero size is in it:
![Images/s3_verify2.png](/Cost/200_Pricing_Model_Analysis/Images/s3_verify2.png)


### CloudWatch Events Setup
We will setup a CloudWatch Event to periodically run the Lambda functions, this will update the pricing and include any newly released instances.

1. Go to the CloudWatch service page:
![Images/home_cloudwatch.png](/Cost/200_Pricing_Model_Analysis/Images/home_cloudwatch.png)

2. Click on **Events**, then click **Rules**:
![Images/cloudwatch_events.png](/Cost/200_Pricing_Model_Analysis/Images/cloudwatch_events.png)

3. Click **Create rule**
![Images/cloudwatch_createrule.png](/Cost/200_Pricing_Model_Analysis/Images/cloudwatch_createrule.png)

4. For the **Event Source** select **Schedule** and set the required period, we have selected **5 days**, click **Add target**:
![Images/cloudwatch_eventsource.png](/Cost/200_Pricing_Model_Analysis/Images/cloudwatch_eventsource.png)

5. Add the **SPTool_ODPricing_Download** Lambda function, and click **Add target**:
![Images/cloudwatch_addtarget.png](/Cost/200_Pricing_Model_Analysis/Images/cloudwatch_addtarget.png)

6. Add the **SPTool_SPPricing_Download** Lambda function, and click **Configure details**:
![Images/cloudwatch_addtarget2.png](/Cost/200_Pricing_Model_Analysis/Images/cloudwatch_addtarget2.png)

7. Add the name **SPTool-pricing**, optionally add a description and click **Create rule**:
![Images/cloudwatch_createrule2.png](/Cost/200_Pricing_Model_Analysis/Images/cloudwatch_createrule2.png)

{{% notice tip %}}
You have now successfully configured a CloudWatch event, it will run the two Lambda functions and update the pricing information every 5 days.
{{% /notice %}}



### Prepare the Pricing Data Source
We will prepare a pricing data source which we will use to join with the CUR. In this example we will take 1 year No Upfront Savings Plans rates and join them to On-Demand pricing. You can modify this part to select 3 year or Partial or All-Upfront rates.

1. Go to the **Glue** Service page:
![Images/home_glue.png](/Cost/200_Pricing_Model_Analysis/Images/home_glue.png)

2. Click **Crawlers** from the left menu:
![Images/glue_crawlers.png](/Cost/200_Pricing_Model_Analysis/Images/glue_crawlers.png)

3. Click **Add crawler**:
![Images/glue_addcrawler.png](/Cost/200_Pricing_Model_Analysis/Images/glue_addcrawler.png)

4. Enter a crawler name of **OD_Pricing** and click **Next**:
![Images/glue_crawlername.png](/Cost/200_Pricing_Model_Analysis/Images/glue_crawlername.png)

5. Ensure **Data stores** is the source type, click **Next**:
![Images/glue_sourcetype.png](/Cost/200_Pricing_Model_Analysis/Images/glue_sourcetype.png)

6. Click the folder icon to list the S3 folders in your account:
![Images/glue_includepath.png](/Cost/200_Pricing_Model_Analysis/Images/glue_includepath.png)

7. Expand the bucket which contains your pricing folders, and select the folder name **od_pricedata**, click **Select**:
![Images/glue_choosepath.png](/Cost/200_Pricing_Model_Analysis/Images/glue_choosepath.png)

8. Click **Next**:
![Images/glue_adddatastore.png](/Cost/200_Pricing_Model_Analysis/Images/glue_adddatastore.png)

9. Click **Next**:
![Images/glue_addanother.png](/Cost/200_Pricing_Model_Analysis/Images/glue_addanother.png)

10. **Create an IAM role** with a name of **SPToolPricing**, click **Next**:
![Images/glue_addrole.png](/Cost/200_Pricing_Model_Analysis/Images/glue_addrole.png)

11. Leave the frequency as **Run on demand**, and click **Next**:
![Images/glue_schedule.png](/Cost/200_Pricing_Model_Analysis/Images/glue_schedule.png)

12. Click on **Add database**:
![Images/glue_adddatabase.png](/Cost/200_Pricing_Model_Analysis/Images/glue_adddatabase.png)

13. Enter a database name of **pricing**, and click **Create**:
![Images/glue_databasename.png](/Cost/200_Pricing_Model_Analysis/Images/glue_databasename.png)

14. Click **Next**:
![Images/glue_dboutput.png](/Cost/200_Pricing_Model_Analysis/Images/glue_dboutput.png)

15. Click **Finish**:
![Images/glue_finishcrawler.png](/Cost/200_Pricing_Model_Analysis/Images/glue_finishcrawler.png)

16. Select the crawler **OD_Pricing** and click **Run crawler**:
![Images/glue_runcrawler.png](/Cost/200_Pricing_Model_Analysis/Images/glue_runcrawler.png)

17. Once its run, you should see tables created:
![Images/glue_runsuccess.png](/Cost/200_Pricing_Model_Analysis/Images/glue_runsuccess.png)

18. Repeat **Steps 3 through to 17** with the following details:
    - Crawler name: **SP_Pricing**
    - Include path: **s3://(pricing bucket)/sp_pricedata** (replace pricing bucket)
    - IAM Role: **Choose an existing IAM role** and **AWSGlueServiceRole-SPToolPricing**
    - Database: **pricing**

19. Open the **IAM Console** in a new tab, click **Policies**:
![Images/IAM_policy.png](/Cost/200_Pricing_Model_Analysis/Images/IAM_policy.png)

20. Click on the **AWSGlueServiceRole-SPToolPricing** role:
![Images/IAM_selectrole.png](/Cost/200_Pricing_Model_Analysis/Images/IAM_selectrole.png)

21. Type in **SPTool** and click on the policy name **AWSGlueServiceRole-SPTool**:
![Images/IAM_policy.png](/Cost/200_Pricing_Model_Analysis/Images/IAM_policy.png)

22. Click **Edit policy**:
![Images/IAM_editpolicy.png](/Cost/200_Pricing_Model_Analysis/Images/IAM_editpolicy.png)

23. Click **JSON**:
![Images/IAM_jsonpolicy.png](/Cost/200_Pricing_Model_Analysis/Images/IAM_jsonpolicy.png)

24. Edit the **Resource** line by removing the **OD_Pricing** folder to leave the bucket:
![Images/IAM_editjson.png](/Cost/200_Pricing_Model_Analysis/Images/IAM_editjson.png)

25. Click **Review policy**:
![Images/IAM_reviewjson.png](/Cost/200_Pricing_Model_Analysis/Images/IAM_reviewjson.png)

26. Click **Save changes**:
![Images/IAM_savejson.png](/Cost/200_Pricing_Model_Analysis/Images/IAM_savejson.png)

27. Go back to the Glue console, select the **SP_Pricing** crawler, click **Run crawler**:
![Images/glue_runspcrawler.png](/Cost/200_Pricing_Model_Analysis/Images/glue_runspcrawler.png)

28. Click on **Databases**:
![Images/glue_databases.png](/Cost/200_Pricing_Model_Analysis/Images/glue_databases.png)

29. Click on **Pricing**:
![Images/glue_databasepricing.png](/Cost/200_Pricing_Model_Analysis/Images/glue_databasepricing.png)

30. Click **Tables in pricing**:
![Images/glue_pricingtables.png](/Cost/200_Pricing_Model_Analysis/Images/glue_pricingtables.png)

31. Click **od_pricedata**:
![Images/glue_odpricing.png](/Cost/200_Pricing_Model_Analysis/Images/glue_odpricing.png)

32. Click **Edit schema**:
![Images/glue_editschema.png](/Cost/200_Pricing_Model_Analysis/Images/glue_editschema.png)

33. Click **double** next to **col9**:
![Images/glue_col9.png](/Cost/200_Pricing_Model_Analysis/Images/glue_col9.png)

34. Select **string** and click **Update**:
![Images/glue_col9string.png](/Cost/200_Pricing_Model_Analysis/Images/glue_col9string.png)

35. Click **Save**:
![Images/glue_schemasave.png](/Cost/200_Pricing_Model_Analysis/Images/glue_schemasave.png)

{{% notice tip %}}
You have successfully setup the pricing data source. We have a database of on demand and Savings Plans rates.
{{% /notice %}}