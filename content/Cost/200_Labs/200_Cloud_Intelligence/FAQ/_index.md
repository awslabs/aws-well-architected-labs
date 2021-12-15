---
title: "FAQ"
#menutitle: "Lab #1"
date: 2020-09-07T11:16:08-04:00
chapter: false
weight: 8
hidden: false
---
#### Last Updated
November 2021

If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: cloud-intelligence-dashboards@amazon.com

## How do I setup the dashboards on top of multiple payer accounts?

This scenario allows customers with multiple payer (management) accounts to deploy all the CUR dashboards on top of the aggregated data from multiple payers. To fulfill prerequisites customers should set up CUR S3 bucket replication to S3 bucket in separate Governance account.
{{%expand "Click here to expand step by step instructions" %}}

![Images/CUDOS_multi_payer.png](/Cost/200_Cloud_Intelligence/Images/CUDOS_multi_payer.png?classes=lab_picture_small)

**NOTE: These steps assume you've already setup the CUR to be delivered in each payer (management) account.**

#### Setup S3 CUR Bucket Replication

1. Create S3 bucket with enabled versioning in the **region where QuickSight is available.**
2. Open S3 bucket and apply following S3 bucket policy with replacing respective placeholders {PayerAccountA}, {PayerAccountB} and {BucketName}. You can add more payer accounts to the policy if needed.

		{
		"Version": "2008-10-17",
		"Id": "PolicyForCombinedBucket",
		"Statement": [
    		{
        		"Sid": "Set permissions for objects",
        		"Effect": "Allow",
        		"Principal": {
            		"AWS": ["{PayerAccountA}","{PayerAccountB}"]
        		},
        		"Action": [
            		"s3:ReplicateObject",
            		"s3:ReplicateDelete"
        		],
        		"Resource": "arn:aws:s3:::{BucketName}/*"
    		},
    		{
        		"Sid": "Set permissions on bucket",
        		"Effect": "Allow",
        		"Principal": {
        		    "AWS": ["{PayerAccountA}","{PayerAccountB}"]
        		},
        		"Action": [
         		   "s3:List*",
         		   "s3:GetBucketVersioning",
         		   "s3:PutBucketVersioning"
        		],
        		"Resource": "arn:aws:s3:::{BucketName}"
    		},
    		{
        		"Sid": "Set permissions to pass object ownership",
        		"Effect": "Allow",
        		"Principal": {
        		    "AWS": ["{PayerAccountA}","{PayerAccountB}"]
        		},
        		"Action": [
            		"s3:ReplicateObject",
            		"s3:ReplicateDelete",
            		"s3:ObjectOwnerOverrideToBucketOwner",
            		"s3:ReplicateTags",
            		"s3:GetObjectVersionTagging",
            		"s3:PutObject"
        		],
        		"Resource": "arn:aws:s3:::{bucket name}/*"
    		}
		]
		}

This policy supports objects encrypted with either SSE-S3 or not encrypted objects. For SSE-KMS encrypted objects additional policy statements and replication configuration will be needed: see https://docs.aws.amazon.com/AmazonS3/latest/userguide/replication-config-for-kms-objects.html

#### Set up S3 bucket replication from each Payer (Management) account to S3 bucket in Governance account

This step should be done in each payer (management) account.

1. Open S3 bucket with CUR
2. On Properties tab under Bucket Versioning section click Edit and set bucket versioning to Enabled
3. On Management tab under Replication rules click on Create replication rule.
4. Specify rule name 

![Images/s3_bucket_replication_1.png](/Cost/200_Cloud_Intelligence/Images/s3_bucket_replication_1.png?classes=lab_picture_small)

5. Select Specify a bucket in another account and provide Governance account id and bucket name in Governance account
6. Select Change object ownership to destination bucket owner checkbox
7. Select Create new role under IAM Role section 

![Images/s3_bucket_replication_2.png.png](/Cost/200_Cloud_Intelligence/Images/s3_bucket_replication_2.png?classes=lab_picture_small)

8. Leave rest of the settings by default and click Save.

#### Copy existing objects from CUR S3 bucket to S3 bucket in Governance account

This step should be done in each payer (management) account.

Sync existing objects from CUR S3 bucket to S3 bucket in Governance account

	aws s3 sync s3://{curBucketName} s3://{GovernanceAccountBucketName} --acl bucket-owner-full-control

After performing this step in each payer (management) account S3 bucket in Governance account will contain CUR data from all payer accounts under respective prefixes.

#### Prepare Glue Crawler 

These actions should be done in Governance account

1. Open AWS Glue Service in AWS Console in the same region where S3 bucket with aggregated CUR data is located and go to Crawlers section
2. Click Add Crawler
3. Specify Crawler name and click Next
4. In Specify crawler source type leave settings by default. Click Next

![Images/glue_1.png](/Cost/200_Cloud_Intelligence/Images/glue_1.png?classes=lab_picture_small)

5. In Add a data store select S3 bucket name with aggregated CUR data and add following exclusions **.zip, **.json, **.gz, **.yml, **sql, **csv, **/cost_and_usage_data_status/*. Click Next

![Images/glue_2.png](/Cost/200_Cloud_Intelligence/Images/glue_2.png?classes=lab_picture_small)

6. In Add another data store leave No by default. Click Next

7. In Choose an IAM role select Create an IAM role and provide role name. Click Next

![Images/glue_1.png](/Cost/200_Cloud_Intelligence/Images/glue_1.png?classes=lab_picture_small)

8. In Create a schedule for this crawler select Daily and specify Hour and Minute for crawler to run

9. In Configure the crawler’s output choose Glue Database in which you’d like crawler to create a table or add new one. Select Create a single schema for each S3 path checkbox. Select Add new columns only and Ignore the change and don’t update the table in the data catalog in Configuration options. Click Next 

*Please make sure Database name doesn’t include ‘-’ character*

![Images/glue_4.png](/Cost/200_Cloud_Intelligence/Images/glue_4.png?classes=lab_picture_small)

10. Crawler configuration should look as on the screenshot below. Click Finish

11. Resume deployment methodoly of choice from previous page. 

{{% /expand%}}

## How do I limit access to the data in the Dashboards by account ID using row level security? 

Do you want to give access to the dashboards to someone within your organization, but you only want them to see data from accounts or business units associated with their role or position? You can use row level seucirty in QuickSight to accomplish limiting access to data by user. In these steps below, we will define specific Linked Account IDs against individual users. Once the Row-Level Security is enabled, users will continue to load the same Dashboards and Analyses, but will have custom views that restrict the data to only the Linked Account IDs defined. 
{{%expand "Click here to expand step by step instructions" %}}

**Considerations:**

* The permissions dataset can't contain duplicate values. Duplicates are ignored when evaluating how to apply the rules.

* Each user or group specified can see only the rows that match the field values in the dataset rules.

* If you add a rule for a user or group and leave all other columns with no value (NULL), you grant them access to all the data.

* If you don't add a rule for a user or group, that user or group can't see any of the data.
	* If the userbase of QuickSight will be changing frequently, consider storing your csv in S3 rather than a local file.

* The full set of rule records that are applied per user must not exceed 999. This applies to the total number of rules that are directly assigned to a user name plus any rules that are assigned to the user through group names.

* If a field includes a comma (,) Amazon QuickSight treats each word separated from another by a comma as an individual value in the filter. For example, in ('AWS', 'INC'), AWS,INC is considered as two strings: AWS and INC. To filter with AWS,INC, wrap the string with double quotation marks in the permissions dataset.

#### Create a CSV file defining users and Linked Account IDs

Create a CSV file that looks something like this:

	username,account_id
	user1@amazon.co.uk,"123456123456"
	user1@amazon.co.uk,"987654987654"
	user2@amazon.fr,"123456123456"
	user3@amazon.com,"789123456123"

Any Account IDs that you wish the given user to see should be defined in the account_id field of the CSV. Create a separate row for a single username having access to multiple account IDs. Ensure there are no spaces after your final quote character. Name this file something similar to CUDOS_Dataset_rules.csv

If you want to use QuickSight groups the CSV input file is slightly different.  Instead of UserName as the initial field you have to use GroupName.  Also, you can only use Users or Groups in the input file, not both. [This page](https://docs.aws.amazon.com/quicksight/latest/user/restrict-access-to-a-data-set-using-row-level-security.html#create-data-set-rules-for-row-level-security) provides more details. QuickSight groups can only be created and managed via the QuickSight CLI. There is no UI for this in the QuickSight console.

You now have 2 options on how to proceed:

1. Keep your CSV file local and create a new Dataset by Uploading a File as the Data Source
2. Upload your CSV to S3 and create a new Dataset with an S3 Manifest file as the Data Source

#### Using a local CSV file as the data source

Create a new Dataset using the CSV file above as the Data Source: Click New Dataset and select Upload a file. Locate your CUDOS_Dataset_rules.csv and a Preview will appear.

![Images/rowlevelsec1.PNG](/Cost/200_Cloud_Intelligence/Images/rowlevelsec1.PNG?classes=lab_picture_small)

Click Edit settings and prepare data. Verify that the account_id field is a String data type. If it appears as an Integer, change the data type for account_id to String.

![Images/ChangeDataType.png](/Cost/200_Cloud_Intelligence/Images/ChangeDataType.png?classes=lab_picture_small)

The reason we need to do this is that we will lose any leading or trailing zeroes on an Account ID if it remains as an Integer value. This is also the same Data Type used for the account_id field in all the CUDOS Datasets.

Save the CUDOS_Dataset_rules.csv dataset.

1. Select the dataset name
2. Click Row-level security
![Images/RLS.png](/Cost/200_Cloud_Intelligence/Images/RLS.png?classes=lab_picture_small)
3. Select CUDOS_Dataset_rules.csv
![Images/ChooseDataset.png](/Cost/200_Cloud_Intelligence/Images/ChooseDataset.png?classes=lab_picture_small)
4. Click Apply dataset
5. Click Apply dataset again
6. Wait until you see Selected dataset rules populate with CUDOS_Dataset_rules
![Images/AppliedDataset.png](/Cost/200_Cloud_Intelligence/Images/AppliedDataset.png?classes=lab_picture_small)
7. Click x to exit
8. Click x to exit
9. Repeat steps for all CUDOS-related datasets (See below for a list of current Dataset Names)

Once you have applied the CUDOS_Dataset_rules S3 Dataset to all your CUDOS datasets, visit the CUDOS Dashboard as a user who is defined in the csv file, and confirm the Account IDs shown are only the ones specified in that file.

#### Use S3 as the data source

Upload your csv file to the Athena query location bucket. eg. aws-athena-query-results-123456123456-us-east-1

Create an S3 manifest file that looks something like this:

	{
  	"entries": [
    	{"url":"s3://aws-athena-query-results-123456123456-us-east-1/CUDOS_Dataset_rules.csv", 	"mandatory":true},
 	 ]
	}

This manifest file can be saved locally, or uploaded to the same S3 bucket where the csv file is stored. Save this file as something similar to CUDOS_manifest.json.

Back in the QuickSight Admin Console, click New Dataset and select S3. Name the Dataset CUDOS_Dataset_rules and locate your CUDOS_manifest.json file either by entering the S3 URL where it is stored, or choosing to upload from your local machine.

![Images/S3-URL.png](/Cost/200_Cloud_Intelligence/Images/S3-URL.png?classes=lab_picture_small)

Click Edit/preview data.

![Images/S3-EditPreview.png](/Cost/200_Cloud_Intelligence/Images/S3-EditPreview.png?classes=lab_picture_small)

Verify that the account_id field is a String data type. If it appears as an Integer, change the data type for account_id to String.

![Images/S3-ChangeDataType.png](/Cost/200_Cloud_Intelligence/Images/S3-ChangeDataType.png?classes=lab_picture_small)

Save the CUDOS_Dataset_rules dataset.

On each of the datasets that the CUDOS dashboard is using, define Row Level Security by following these steps:

1. Select the dataset name
2. Click Row-level security

![Images/RLS.png](/Cost/200_Cloud_Intelligence/Images/RLS.png?classes=lab_picture_small)

3. Select CUDOS_Dataset_rules

![Images/S3-ChooseDataset.png](/Cost/200_Cloud_Intelligence/Images/S3-ChooseDataset.png?classes=lab_picture_small)

4. Click Apply dataset
5. Click Apply dataset again
6. Wait until you see Selected dataset rules populate with CUDOS_Dataset_rules

![Images/S3-AppliedDataset.png](/Cost/200_Cloud_Intelligence/Images/S3-AppliedDataset.png?classes=lab_picture_small)

7. Click x to exit
8. Click x to exit
9. Repeat steps for all CUDOS-related datasets (See below for a list of current Dataset Names)

Once you have applied the CUDOS_Dataset_rules S3 Dataset to all your CUDOS datasets, visit the CUDOS Dashboard as a user who is defined in the csv file, and confirm the Account IDs shown are only the ones specified in that file.

{{% /expand%}}

## How do I create scalable, customized access with QuickSight groups and row-level security?

Customers may wish to share Cloud Intelligence Dashboards across their organization but need to limit access based on a user's department/role or to a specific set of AWS account Ids or AWS services. QuickSight [Row-Level Security (RLS)](https://docs.aws.amazon.com/quicksight/latest/user/restrict-access-to-a-data-set-using-row-level-security.html) allows us to restrict access by user group to specific CUDOS datasets attributes such account id or service.
{{%expand "Click here to expand answer" %}}
Goal of Customising Access with QuickSight Groups and RLS

arrow_right The use of groups allows customers to quickly rollout CUDOS to a larger set of users and simplifies permission management going forward. A customer can have 1 CUDOS dashboard with many, many groups, each seeing *only* the data relevant to them.

In example below, we will demonstrate restricting CUDOS access by user group to specific AWS account ids. The process includes creating a comma separated value (CSV) file that contains AWS account ids with related user groups (ie permissions) and uploading to S3. We then associate our CUDOS datasets with the CSV file containing permissions. Lastly, we use the AWS CLI to place users into QuickSight groups that correspond with the CSV groups.

### Create Your Groups and Upload to S3

1. Create a CSV similar to the following, saving as CUDOS_permissions.csv. For additional detail, see [here](https://docs.aws.amazon.com/quicksight/latest/user/restrict-access-to-a-data-set-using-row-level-security.html) for example rules and how permissions are applied.

		GroupName,linked_account_id
		Finance,"123456789123,123456789124"
		All,
		Engineering,123456789123

2. Upload CUDOS_permissions.csv to an S3 bucket in the same AWS account and region where you use QuickSight.
3. Create a manifest file, saving as CUDOS_permissions_manifest.json, with the following format.

		{
  		"entries": [
    		{"url":"s3://REPLACE_WITH_BUCKET_NAME/CUDOS_permissions.csv", "mandatory":true},
  		]
		}

### Configure a Permissions Dataset for Use with QuickSight

4. From the [QuickSight Dataset console](https://us-east-1.quicksight.aws.amazon.com/sn/start/data-sets), click “New Dataset”.
5. Select “S3”, provide a “Data source name” of CUDOS_permissions, select “Upload” to add the CUDOS_permissions_manifest.json file, and click “Connect”.
6. At the following “Finish dataset creation” prompt, click “Edit/Preview data”.
7. We need to verify the linked_account_id value is of type “String”. If it is not, change as depicted, and click “Save”.

![Images/cudos-linked_account_id-string.png](/Cost/200_Cloud_Intelligence/Images/cudos-linked_account_id-string.png?classes=lab_picture_small)

### Set the CUDOS_permissions Dataset to Update on a Schedule

8. From the [QuickSight Dataset console](https://us-east-1.quicksight.aws.amazon.com/sn/start/data-sets), click on the “CUDOS_permissions” dataset and "Schedule a refresh".
9. Click "Create".
10. Review the "Create a Schedule" settings. Leave as default for "Daily" refresh at the end of the day in the local timezone (Choose "Hourly" if the customer anticipates frequent changes to the CUDOS_permissions.csv file. Note changes to the CSV file only need to occur when the customer is modifying account id assignments for groups, removing groups, or creating new groups, not when assigning users to groups. Therefore needing "Hourly" updates may not necessary. Customers can also manually refresh the CUDOS_permissions dataset while testing or making bulk changes via the [QuickSight Dataset console](https://us-east-1.quicksight.aws.amazon.com/sn/start/data-sets). Click "Create".
11. Click the "x" to close the "Schedule a refresh" window and again to close the "CUDOS_permissions" window.
Add the linked_account_id Attribute to the cudos_cur Dataset

12. The cudos_cur dataset does not include the linked_account_id field used to apply row-level security. From the [QuickSight Dataset console](https://us-east-1.quicksight.aws.amazon.com/sn/start/data-sets), click on the “cudos_cur” dataset and select “Edit dataset”. Note, depending on which implementation of CUDOS being used, datasets may have different naming. See Considerations below for additional details.
13. On the left side of the page, click “Add calculated field”.
14. Under “Name”, type “linked_account_id”. On the right side of the page, double-click the “line_item_usage_account_id” field to add the field to the calculation window. This will set our new “linked_account_id” field equal to the “line_item_usage_account_id” for each row in the cudos_cur dataset. Click “Save”.

![Images/cudos-calculated-usage_account_id.png](/Cost/200_Cloud_Intelligence/Images/cudos-calculated-usage_account_id.png?classes=lab_picture_small)

15. Click “Save” again on the main cudos_cur edit page.

### Apply Row-Level Security to the CUDOS Datasets

16. From the [QuickSight Dataset console](https://us-east-1.quicksight.aws.amazon.com/sn/start/data-sets), click “cudos_summary_view” to open the dataset’s settings. Note, depending on which implementation of CUDOS being used, datasets may have different naming. See Considerations below for additional details.
17. Click “Row-level security”.
18. Select CUDOS_permissions, and click “Apply dataset”. Click “Apply dataset” once more.
19. After a moment, the CUDOS_permissions are applied. To confirm, you’ll see “Selected dataset rules: CUDOS_permissions” in the window.
20. Exit out of the open window.
21. Repeat steps 3.1 through 3.5 for the remaining CUDOS datasets; cudos_compute_savings_plan_eligible_spend / cudos_ec2_running_cost / cudos_s3_view / cudos_cur
22. You will now see a lock icon next to each of the CUDOS datasets (except cudos_permissions).

![Images/cudos-datasets-restricted-permissions.png](/Cost/200_Cloud_Intelligence/Images/cudos-datasets-restricted-permissions.png?classes=lab_picture_small)

23. From the [CloudShell console](https://console.aws.amazon.com/cloudshell/home), run the following command to create each of the groups in your CSV as a corresponding QuickSight group.

		aws quicksight create-group --aws-account-id INSERT_ACCOUNT_ID --namespace default --group-name INSERT_GROUP_NAME_FROM_CSV

24. Add your [QuickSight users](https://us-east-1.quicksight.aws.amazon.com/sn/admin) to each group.

		aws quicksight create-group-membership --aws-account-id INSERT_ACCOUNT_ID --namespace default --group-name INSERT_GROUP_NAME_FROM_CSV --member-name INSERT_QUICKSIGHT_USERNAME

OPTIONAL - You can review groups created and group members via additional QuickSight commands. The full list of operations available to update, delete, and list user/group details can be found here. Common examples include:

		View all QuickSight groups ->
		aws quicksight list-groups --aws-account-id INSERT_ACCOUNT_ID --namespace default

		View all groups for a user ->
		aws quicksight list-user-groups --aws-account-id INSERT_ACCOUNT_ID --namespace default --user-name INSERT_QUICKSIGHT_USERNAME

		Remove a user from a group ->
		aws quicksight delete-group-membership --aws-account-id INSERT_ACCOUNT_ID --namespace default --group-name INSERT_GROUP_NAME --member-name INSERT_QUICKSIGHT_USERNAME

		View all members of a group ->
		aws quicksight list-group-memberships --aws-account-id INSERT_ACCOUNT_ID --namespace default --group-name INSERT_GROUP_NAME

Finished! You now have a customised dashboard for use with multiple groups. Know this process can be modified to limit permissions by service, service/account, and more as helpful.

### Considerations

If you create rule for a group and leave all other columns with no value(s) (Null), you grant that group access to ALL data.
Users can belong to more than one QuickSight group. Access is aggregated across group memberships.
The permissions dataset can't contain duplicate values. Duplicates are ignored when evaluating how to apply the rules.
Avoid spaces in the CSV file. Terms with spaces inside them need to be delimited with quotation marks. QuickSight treats spaces as literal values.
Row-level security works only for fields containing textual data (string, char, varchar, and so on). It doesn't currently work for dates or numeric fields.
Anomaly detection visuals ignore row-level security, so be mindful adding those type of visuals to a dashboard that uses row-level security.
Depending on which implementation of CUDOS being used, datasets may have different naming as follows (There are future plans to align dataset naming).

Dataset Names - compute_savings_plan_eligible_spend, customer_all, ec2_running_cost, s3_view, summary_view

For additional considerations, view the QuickSight row-level security documentation here.

{{% /expand%}}

## How do I fix the COLUMN_GEOGRAPHIC_ROLE_MISMATCH error? 

When attempting to deploy the dashboard manually, some users get an error that states COLUMN_GEOGRAPHIC_ROLE_MISMATCH. 
{{%expand "Click here to expand answer" %}}

This error is caused by there being too many [data source connectors](https://docs.aws.amazon.com/quicksight/latest/user/working-with-data-sources.html) in QuickSight with the same name. To check how many data source connectors you have, visit QuickSight datasets and click on **new datasets**. Scroll to the bottom and note how many Athena data connectors there are with the same name. 

![Images/Sduplicatedataset.png](/Cost/200_Cloud_Intelligence/Images/duplicatedataset.png?classes=lab_picture_small)

Unless you know which datasets are tied to which data sources, it is faster to simply delete all the Cloud Intelligence Dashboards data sources and data sets from QuickSight, and start adding them again, this time only using a single data source. This is described in detail in [this lab under the manual deployment option](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/2a_cost_intelligence_dashboard/) as step 22. You should only have one data source for all your Cloud Intelligence Dashboard datasets, including customer_all. If you wish to use separate data sources, they must not have the same name. 

{{% /expand%}}



{{% notice tip %}}
This page will be updated regularly with new answers. If you have a FAQ you'd like answered here, please reach out to us here cloud-intelligence-dashboards@amazon.com. 
{{% /notice %}}
