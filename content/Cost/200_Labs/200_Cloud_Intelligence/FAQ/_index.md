---
title: "FAQ"
#menutitle: "FAQs"
date: 2022-08-31T11:16:08-04:00
chapter: false
weight: 7
hidden: false
---
#### Last Updated
October 2022

If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: cloud-intelligence-dashboards@amazon.com


### General

#### Which dashboards are available for installation?
We have several dashboards- CUDOS, KPI, CID, Compute Optimizer, Trusted Advisor (TAO) and Trends, Full documentation can be found [here](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/#cost-intelligence-dashboard-cid)


#### How can I install Cloud Intelligent Dashboards?
First you need to run [pre-requisite](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/) steps, after that you can follow the instructions [here](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/) for the specific required dashboard

#### What columns are in the Cost and Usage Report (CUR), what do they mean?
CUR documentation can be found [here](https://docs.aws.amazon.com/cur/latest/userguide/cur-user-guide.pdf)

#### Where can I find more info about CUR delivery timelines and any FAQs for CUR?
On average, CURs are updated up to 3 times daily, but that will fluctuate depending on the size of the file/amount of user usage and many other factors. you can monitor your CUR S3 bucket to see the date/time the new month's file is deposited. Within the CUR itself you can see the corresponding usage dates/times to infer which usage is reflected within that file.

#### Do the Cloud Intelligent Dashboards support gzip compression formats or CSV CUR files?
The CUR must be in Parquet (Athena) format. 

#### Do the Cloud Intelligent Dashboards support CUR without resource ids?
The CUR must be have resource ids. 

#### In which regions can Cloud Intelligent Dashboards be deployed?
CID requires QuickSight, Athena and Glue , All regions that support QuickSight, Athena and S3. Cost Usage Reports (CUR) Bucket would also have to be in the same region as those services. CUR bucket can be replicated to the region that supports CIDs via S3 bucket replication.
When using the cid-cmd, you can define the Region to deploy the dashboard in as a parameter eg. cid-cmd --region_name eu-west-2 deploy This is especially helpful when using Cloudshell and the region you want to deploy in,  does not support Cloudshell.


* https://www.aws-services.info/quicksight.html
* https://www.aws-services.info/glue.html
* https://www.aws-services.info/athena.html


#### How long does it take to initially deploy the Cloud Intelligent Dashboards Framework?
Assuming [pre-requisites](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/)were met correctly the automation would take around 5-10 minutes to deploy, manual lab execution can take up to 60 minutes.

#### Do I need to learn any coding skills to customize the analysis?
No, just AWS native BI service QuickSight and customer facing data Cost and Usage Reports structure. Here is public documentation for [QuickSight](https://docs.aws.amazon.com/quicksight/index.html) and [Cost Usage Reports](https://docs.aws.amazon.com/cur/latest/userguide/data-dictionary.html).

#### How do I edit or customize the dashboards?
In order to create an analysis from any of the CUDOS Dashboards, Go edit the newly created dashboard's permissions to enable the “Save As” option:

    Go to your Templated Dashboard.
    Click “Share”
    Click “Share dashboard”
    Enable the "Allow "save as"" next to your username
    Click "Confirm"
    Click the link in the top left corner to Go back to 'LazyMBR'
    You should now see a “Save as” (you might have to refresh browser)
    Click "Save as"
    Name your Analysis
    Once completed, you can then customize the Analysis filters, visuals etc.

You can see an example on [this](https://www.youtube.com/watch?v=dzRKDSXCtAs) video (1:23)


#### How do I setup the dashboards in an account other than my payer account or on top of multiple payer accounts?
This scenario allows customers with multiple payer (management) accounts to deploy all the CUR dashboards on top of the aggregated data from multiple payers. 
To setup the dashboards on top of multi payer accounts, please review [multi-account setup]({{< ref "Cost/200_Labs/200_Cloud_Intelligence/Cost & Usage Report Dashboards/Dashboards/deploy_dashboards.md" >}}) deployment options and instructions.

#### What are the solution limitations?
Amazon QuickSight supports up to 30 visuals in a single sheet, and a limit of 20 sheets per analysis. QuickSight SPICE capacity for Enterprise edition is up to 500 million rows or 500 GB per dataset. Amazon Athena DML query timeout is max 4 hours.

#### How can I share dashboards with other users?
You can share dashboards and visuals with specific users or groups in your account or with everyone in your Amazon QuickSight account. Or you share them with anyone on the internet. You can share dashboards and visuals by using the QuickSight console or the QuickSight API. Access to a shared visual depends on the sharing settings that are configured for the dashboard that the visual belongs to. To share and embed visuals to your website or application, adjust the sharing settings of the dashboard that it belongs to. For more information, see the following:
* [Granting individual Amazon QuickSight users and groups access to a dashboard in Amazon QuickSight](https://docs.aws.amazon.com/quicksight/latest/user/share-a-dashboard-grant-access-users.html)
* [Granting everyone in your Amazon QuickSight account access to a dashboard](https://docs.aws.amazon.com/quicksight/latest/user/share-a-dashboard-grant-access-everyone.html)

#### How Unit Cost is being calculated?
In general- spend in $/usage_quantity
For example for Compute/RDS we take only instances running hours cost and divide by usage, for S3 we take only storage cost and divide by storage size

#### Can we see MarketPlace usage on Cloud Intelligent Dashboards?
Yes, on CUDOS dashboard under MoM Trends tab. You have 2 filters Billing Entity and Legal entity

#### How can I export a dashboard to PDF?
On the right upper corner of the dashboard, click on the Export icon → Generate PDF

#### How can I export a visual to CSV?
Click on a specific visual, click on the 3 dots → Export to CSV

#### How can I change KPI values on KPI dashboard?
On KPI dashboard, under *Set KPI Goals* tab. Choose a specific KPI and adjust the bar according to your KPI value


### Troubleshooting

#### Cost values or other numbers in the Cloud Intelligence Dashboards don’t match what I see in my invoices or in Cost Explorer - what do I do?
{{%expand "Click here to expand answer" %}}

1. Check the QuickSight dataset refreshes – sometimes they error out. They should be scheduled for once a day at least.
1. Cost Explorer does round cost values, so we’ve seen these rounding errors propagate to noticeable differences between Cost Explorer and the CUR/CloudIntelligenceDashboards. The CUR has more accurate cost values.
1. Double check your settings in Cost Explorer for unblended, amortized, net amortized etc. to make sure you're comparing to the same cost values in the dashboards. 
1. A lot of visuals in CUDOS and our other dashboards are about usage, for example S3 costs will be filtered to exclude API requests and data transfers and JUST show the cost of storing those GBs. 
1. In the Cloud Intelligence Dashboards you can always break a spend amount down into its parts, like grouping by operation or usage type, then comparing it to Cost Explorer or your invoices to see what is different.
1. Enterprise Support fees arrive after the 15th of the next month. Exclude ES charges in your comparison. 
2. Taxes, refunds, and credits are excluded from many visuals in CUDOS and the other dashboards. 

{{% /expand%}}

#### I am getting the error "Casting from TimestampTZ to Timestamp is not supported" - what do I do?
{{%expand "Click here to expand answer" %}}

This error is caused by V3 engine of Athena. To fix it, you will need to update your Athena view ri_sp_mapping. Go to Athena, click on the three dots next to the view, select show/edit query, and replace it with one of the following (depending on the scenario). Change the FROM "${cur_table_name} to your CUR table name which you can see in Athena under tables. Click RUN on the query. Then visit QuickSight, and go to your datasets, click edit data set, then click save & publish. 

- [RIs but not SPs](https://raw.githubusercontent.com/aws-samples/aws-cudos-framework-deployment/main/cid/builtin/core/data/queries/cid/ri_sp_mapping_ri.sql)
- [SPs but not RIs](https://raw.githubusercontent.com/aws-samples/aws-cudos-framework-deployment/main/cid/builtin/core/data/queries/cid/ri_sp_mapping_sp.sql)
- [Both RIs and SPs](https://raw.githubusercontent.com/aws-samples/aws-cudos-framework-deployment/main/cid/builtin/core/data/queries/cid/ri_sp_mapping_sp_ri.sql)


{{% /expand%}}

#### When running the summary_view.sql query from Athena, I get the error "Column 'product_database_engine' cannot be resolved". How do I resolve it?
If you get this error it is very likely that none of your accounts have launched an RDS instance. To make this column show up in the CUR, launch a database in the RDS service, let it run for a couple of minutes and then shut it down. In the next iteration of the crawler, the column will appear. Running the query again should now result in success.


#### How do I fix the ‘product_cache_engine’ cannot be resolved error?
This view is dependent on having or historically having an RDS database instance and an ElastiCache cache instance run in your organization. If you get the error that the column product_database_engine or product_deployment_option does not exist, then you do not have any RDS database instances running. There are two options to resolve this.

#### I’m getting an error in QuickSight that is saying Athena timed out?
For very large CUR files, Athena may time out trying to query the data for summary_view. In Athena, find the summary_view view, click the three dots next to it and select show/edit query. Modify the following:

* [Request Athena](https://docs.amazonaws.cn/en_us/athena/latest/ug/service-limits.html?) DML query timeout increase via support case.
* Or, adjust the granularity to monthly, by changing ‘day’ to ‘month’ in row 6.
* Or, adjust the look back from ‘7’ months to desired time-frame in row 75.
* In QuickSight, refresh your dataset.

#### Account list is missing/incorrect, how can I update them?
You can update the account list with the following query:
CREATE OR REPLACE VIEW account_map AS

SELECT account_id,
concat (account_name,': ', account_id) account_name
from acc_metadata_details

#### How do I fix the COLUMN_GEOGRAPHIC_ROLE_MISMATCH error?
When attempting to deploy the dashboard manually, some users get an error that states COLUMN_GEOGRAPHIC_ROLE_MISMATCH. 
{{%expand "Click here to expand answer" %}}

This error is caused by there being too many [data source connectors](https://docs.aws.amazon.com/quicksight/latest/user/working-with-data-sources.html) in QuickSight with the same name. To check how many data source connectors you have, visit QuickSight datasets and click on **new datasets**. Scroll to the bottom and note how many Athena data connectors there are with the same name. 

![Images/Sduplicatedataset.png](/Cost/200_Cloud_Intelligence/Images/duplicatedataset.png?classes=lab_picture_small)

Unless you know which datasets are tied to which data sources, it is faster to simply delete all the Cloud Intelligence Dashboards data sources and data sets from QuickSight, and start adding them again, this time only using a single data source. This is described in detail in [this lab under the manual deployment option](https://wellarchitectedlabs.com/cost/200_labs/200_cloud_intelligence/cost-usage-report-dashboards/dashboards/2a_cost_intelligence_dashboard/) as step 22. You should only have one data source for all your Cloud Intelligence Dashboard datasets, including customer_all. If you wish to use separate data sources, they must not have the same name. 

{{% /expand%}}

#### I’ve deployed the Compute Optimizer Dashboard. If a new linked account is created after deployment, can the dashboard collect the data from the newly created linked account automatically?
{{%expand "Click here to expand answer" %}}

[If the stackset deployment is made via Organizations](https://medium.com/swlh/automatically-deploy-cloudformation-stacks-into-newly-created-accounts-in-aws-organization-a0b80b2fc43e) it will be present on newly created accounts. 

{{% /expand%}}

#### I am getting the following error from my tables associated with the optimization data collection lab; “HIVE_PARTITION_SCHEMA_MISMATCH: There is a mismatch between the table and partition schemas. The types are incompatible and cannot be coerced”.

{{%expand "Click here to expand answer" %}}

Edit your Glue crawler to refresh the metadata from the partitions by following [these steps.](https://aws.amazon.com/premiumsupport/knowledge-center/athena-hive-partition-schema-mismatch/) 

{{% /expand%}}


### Pricing

#### How much does it cost to run the CID Framework?
Cost breakdown using Calculator -
* S3 cost for CUR: < $5-10/mon
* QuickSight Enterprise: < $30/mon/author or $5max/mon/reader
* QuickSight SPICE capacity: < $10-20/mon
* Total: $100-$200 (for Number of working days per month (22), SPICE capacity in gigabytes (GB) (100), Number of authors (3), Number of readers (15), 



### Customization

#### How can I add tagging visuals to CUDOS dashboard?
Step by step can be found on [this](https://www.youtube.com/watch?v=Yc64XsDo30M&t=218s) video 

#### How to get alerts from dashboards?
Step by step can be found on [this](https://www.youtube.com/watch?v=dzRKDSXCtAs&t=194s) video


### Security

#### How do I limit access to the data in the Dashboards using row level security?
Do you want to give access to the dashboards to someone within your organization, but you only want them to see data from accounts or business units associated with their role or position? You can use row level security in QuickSight to accomplish limiting access to data by user. In these steps below, we will define specific Linked Account IDs against individual users. Once the Row-Level Security is enabled, users will continue to load the same Dashboards and Analyses, but will have custom views that restrict the data to only the Linked Account IDs defined.

Step by step instructions can be on [this](https://www.youtube.com/watch?v=EFyWEyeXQlE&t=3s) video

#### We have an encrypted S3 buckets for CUR and Athena query results. Does CID Framework support encrypted S3 buckets?
Yes. QuickSight would require an IAM role and a suitable IAM policy allowing access to KMS.

#### Can I encrypt my CUR buckets in S3?
{{%expand "Click here to expand answer" %}}

For a KMS encrypted bucket, KEY and ROLE policies need to be modified to allow you to use the KMS key that encrypts the S3 bucket. Additional security features like SCP can also be applied in your Organization. For troubleshooting IAM permissions you can use CloudTrail and open support tickets with cloud support engineers. Here is a sample KMS key policy that should be added in cases where the CUR bucket is KMS encrypted. The policy allows QuickSight and Glue roles to decrypt the data encrypted with that KMS key.

IMPORTANT: This statement is to be added to an existing kms key policy and not to replace it, the key could have other policies in place used by other services, like key administrators policy.

 - replace `region` with your region
 - replace `account` with account number
 - replace `crawler-rone` with cur glue crawler IAM role (can be found in crawler config/Service role)
 - replace `key-id` with the id of your KMS key or alias (or use `*`)

    {
        "Sid": "Allow Quicksight and Glue",
        "Action": "kms:Decrypt",
        "Effect": "Allow",
        "Principal":
        {
            "AWS":
            [
                "arn:aws:iam::{account}:role/service-role/aws-quicksight-service-role-v0",
                "arn:aws:iam::{account}:role/{CRAWLER-ROLE}"
            ]
        },
        "Resource": ""arn:aws:kms:{region}:{account}:key/{key-id or *}"
    }
{{% /expand%}}


#### Can I do cross-account queries in Athena instead of replicating CUR buckets?
CUR bucket replication is the preferred method because it is tested and documented. Technically you can use cross-account methods but it is untested. It is true that CUR bucket replication will create more cost as the you will have to store the CUR twice, although you could think of it as a backup in case something happens to the payer accounts. We recommend CUR bucket replication also because the Athena tables are created/updated via a Glue crawler where you get all CUR schema changes handled. Glue crawlers don’t support cross account set up. It also gets significantly more complicated if KMS encryption is used.



{{% notice tip %}}
This page will be updated regularly with new answers. If you have a FAQ you'd like answered here, please reach out to us here cloud-intelligence-dashboards@amazon.com. 
{{% /notice %}}
