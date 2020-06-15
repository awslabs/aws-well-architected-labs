---
title: "Create the Data Sources"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---
We first need to create data sources containing the application logs, and the cost and usage reports. In this lab we provide sample files, it is recommended you use these files initially, then use your own files after you are familiar with the requirements and process.

We place both logs into S3, crawl them with Glue and then use Athena to confirm a database is created that we can use.

### Copy files into S3
We will create a bucket and folders in S3, then copy the sample application log files, and cost and usage reports into the folders.

**NOTE** Please read the steps carefully, as the naming is critical and any mistakes will require you to rebuild the lab or make significant and repetitive changes.

1. Log into the AWS console via SSO:
![Images/consolelogin_IAMUser.png](/Cost/200_Workload_Efficiency/Images/consolelogin_IAMUser.png)

2. Make sure you run everything in a single region

3. Go to the **S3 console**, Create a new **S3 Bucket**, it can have any name, but make it start with **costefficiencylab** to make it identifiable.

4. Create a folder in the new bucket with a name: **applogfiles_workshop**.
 **NOTE**: You MUST name the folder **applogfiles_workshop**
 ![Images/s3-createbucket.png](/Cost/200_Workload_Efficiency/Images/s3-createbucket.png)

5. Upload the application log file to the folder:
 [Step1_access_log.gz](/Cost/200_Workload_Efficiency/Code/Step1AccessLog.gz)


6. {{%expand "Click here - if using your own log files" %}}

If you will be using your own application log files, systems manager can be used to run
commands across your environment and copy files from multiple servers to S3.

Depending on your operating system, you can execute CLI on your application servers to
copy the **application log files** to your **S3 bucket**. The following Linux sample
will copy all access logs from the httpd log directory to the s3 bucket created above
using the hostname to separate each servers logs:

        HOSTNAME=$(hostname)
        aws s3 cp --recursive /var/log/httpd/ s3://applogfiles-workshop/$HOSTNAME --exclude "*" --include "access_log*"

{{% /expand%}}

7. Create a folder named **costusagefiles_workshop**, inside the same bucket.

    **NOTE**: You MUST name the folder **costusagefiles_workshop**, this will make pasting the code faster.

8. Copy the sample file to your bucket into the **costusagefiles_workshop** folder:
    - [Step1CUR.gz](/Cost/200_Workload_Efficiency/Code/Step1CUR.gz)



### Create applicaton log file data source with Glue
We will create a database with the uploaded application logs, with AWS Glue. For the application log files, we show you how to write a custom classifier, so you can handle **any** log file format from any application.

For our sample application logs, we have supplied Apache web server log files. The in-bulit AWS Glue classifier **COMBINEDAPACHELOG** will recognize these files, for example, it will read the timestamp as a single string. We will customize the interpreter to break this up into a date column, timestamp column, and timezone column. This will demonstrate how to write a customer classifier. The reference for classifiers is here: [https://docs.aws.amazon.com/glue/latest/dg/custom-classifier.html](https://docs.aws.amazon.com/glue/latest/dg/custom-classifier.html)

A sample log file line is:

        10.0.1.80 - - [26/Nov/2019:00:00:07 +0000] "GET /health.html HTTP/1.1" 200 55 "-" "ELB-HealthChecker/2.0"

The original columns are:

    - Client IP
    - Ident
    - Auth
    - HTTP Timestamp*
    - Request
    - Response
    - Bytes
    - Referrer
    - Agent

Using the custom classifier, we will make it build the following columns instead:

    - Client IP
    - Ident
    - Auth
    - Date*
    - Time*
    - Timezone*
    - Request
    - Response
    - Bytes
    - Referrer
    - Agent

1. Go to the **Glue console** and click **Classifiers**:
![Images/glue-classifiers.png](/Cost/200_Workload_Efficiency/Images/glue-classifiers.png)

2. Click **Add classifier** and create it with the following details:
    - Classifier name: WebLogs
    - Classifier type: Grok
    - Classification: Logs
    - Grok pattern:

          %{IPORHOST:clientip} %{USER:ident} %{USER:auth} \[%{DATE:logdate}\:%{TIME:logtime} %{INT:tz}\] "(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion})?|%{DATA:rawrequest})" %{NUMBER:response} (?:%{Bytes:bytes=%{NUMBER}|-}) %{QS:referrer} %{QS:agent}

    - Custom patterns:

          DATE %{MONTHDAY}/%{MONTH}/%{YEAR}

3. Click **Create**
![Images/glue-classifier1.png](/Cost/200_Workload_Efficiency/Images/glue-classifier1.png)

    A classifier tells Glue how to interpret the log file lines, and how to create columns.  Each column is contained within %{}, and has the **pattern**, the **separator ':'**, and the **column name**.

    By using the custom classifier, we have separated the column timestamp into 3 columns of logdate, logtime and tz. You can compare the custom classifier we wrote with the COMBINEDAPACHELOG classifier:

        Custom - %{IPORHOST:clientip} %{USER:ident} %{USER:auth} \[%{DATE:logdate}\:%{TIME:logtime} %{INT:tz}\] "(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion})?|%{DATA:rawrequest})" %{NUMBER:response} (?:%{Bytes:bytes=%{NUMBER}|-}) %{QS:referrer} %{QS:agent}

        Builtin - %{IPORHOST:clientip} %{USER:ident} %{USER:auth} \[%{HTTPDATE:timestamp}\] "(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion})?|%{DATA:rawrequest})" %{NUMBER:response} (?:%{Bytes:bytes=%{NUMBER}|-}) %{QS:referrer} %{QS:agent}


4. Next we will create a crawler to read the log files, and build a database. Click on **Crawlers** and click **Add crawler**:
![Images/glue-crawleraddcrawler.png](/Cost/200_Workload_Efficiency/Images/glue-crawleraddcrawler.png)

5. Configure the crawler:
    - **Crawler name** will be **ApplicationLogs**
    - Expand **Tags, description..** next to our **Weblogs** classifier, cilck **Add**
    - Click **Next**:
![Images/glue-crawlercreate1.png](/Cost/200_Workload_Efficiency/Images/glue-crawlercreate1.png)

6. **Crawler source type** is Data stores, click **Next**:
![Images/glue-crawlercreate2.png](/Cost/200_Workload_Efficiency/Images/glue-crawlercreate2.png)

7. Click the **folder icon** and expand your bucket created above, select the radio button next to the **applogfiles_workshop**.  Do **NOT** select the actual file or bucket, select the folder.  Click **Select**.
![Images/glue-crawler1.png](/Cost/200_Workload_Efficiency/Images/glue-crawler1.png)

8. Click **Next**

9. Select **No** to not add another data store, click **Next**

10. **Create an IAM role** named AWSGlueServiceRole-**CostWebLogs** and click **Next**:
![Images/glue-crawlercreate5.png](/Cost/200_Workload_Efficiency/Images/glue-crawlercreate5.png)

11. **Frequency** will be run on demand, click **Next**

12. Click **Add database**, you MUST name it **webserverlogs**, click **Create**.

13. Click **Next**:
![Images/glue-crawlercreate6.png](/Cost/200_Workload_Efficiency/Images/glue-crawlercreate6.png)

14. Click **Finish**

15. Select and **Run crawler**, this will create a single database and table with our log files. We need to **wait until** the crawler has **finished**, this will take 1-2 minutes. Click refresh to check if it has finished.

16. We will confirm the database has built correctly. Click **Databases** on the left, and click on the database **webserverlogs**, you may need to click **refresh**:
![Images/glue-databaseswebserverlogs.png](/Cost/200_Workload_Efficiency/Images/glue-databaseswebserverlogs.png)

17. Click **Tables in webserverlogs**, and click the table **applogfiles_workshop**

18. You can see the table is created, the **Name**, the **Location**, and the **recordCount** has a large number of records in it (the number may be different to the image below):
![Images/glue-databasestablewebserverlogs.png](/Cost/200_Workload_Efficiency/Images/glue-databasestablewebserverlogs.png)

19. Scroll down and you can see the columns, and that they are all **string**. This will be a small hurdle for non-string columns like bytes if you want to perform a mathematical function on it.  We will work around this with Athena in our example.

20. {{%expand "Click here - if using your own log files" %}}

If using your own application files, you may wish to adjust the field
types here. This will typically be anything numerical that
you would do mathematical operations on, like a sum or average.

{{% /expand%}}


21. Go to the **Athena** service console, and select the **webserverlogs** database


22. Click the **three dots** next to the table **applogfiles_workshop**, and click **Preview table**:
![Images/athena-dbwebserverlogs.png](/Cost/200_Workload_Efficiency/Images/athena-dbwebserverlogs.png)

23. View the results which will show 10 lines of your log. Note how there are separate columns **logdate**, **logtime** and **tz** that we created. The default classifier would have had a single column of text for the timestamp.
![Images/athena-dbresults.png](/Cost/200_Workload_Efficiency/Images/athena-dbresults.png)



### Create cost and usage data source with Glue
To measure efficiency we need to know the cost of the workload, so we will use the Cost and Usage Report. We will follow the process above to create

1. {{%expand "READ ONLY - If using your own CUR files" %}}
If you are using your own Cost and Usage Reports, you will need to have them already configured and delivered as [per this lab]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}}). The rest of this section is not required, as the Cost and Usage data will be correctly setup.
{{% /expand%}}

2. To use the files from this lab, follow the steps below:

3. Go into the **Glue** console, click **Crawlers**, and click **Add crawler**

4. Use the crawler name **CostUsage** and click **Next**

5. Select **Data stores** as the crawler source type, click **Next**

6. Click the **folder icon**, Select the **S3 folder** created above **costefficiency** and select the **costusagefiles-workshop** folder, make sure you dont select the bucket or file.

7. Click **Select**, then click **Next**

7. Select **No** do not another data store, click **Next**

8. Create an **IAM role** named AWSGlueServiceRole-**Costusage**, click **Next**

9. Set the frequency to **run on demand**, click **Next**

10. Cilck **Add database**, it MUST be named **CostUsage**, and click **Create**

11. click **Next**

11. Review and click **Finish**

12. Run the crawler **CostUsage**, then use Athena to check the database **costusage** was created and has records in the table **costusagefiles_workshop**, as per the Application logs database setup above.

{{% notice tip %}}
You now have both the application and cost data sources setup, ready to create an efficiency metric.
{{% /notice %}}
