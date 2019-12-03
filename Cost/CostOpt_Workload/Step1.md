# Environment Setup

## Authors
- Nathan Besh, Cost Lead Well-Architected


## Feedback
If you wish to provide feedback on this lab, there is an error, or you want to make a suggestion, please email: costoptimization@amazon.com


## Goals
- Setup a data source for your application log files
- Setup a data source with your Cost and Usage Reports



# Table of Contents
1. [Setup Athena](#setup_data)
2. [Setup QuickSight](#setup_quicksight)
3. [Tear Down](#tear_down)
4. [Rate Lab](#rate_lab) 


<a name="setup_data"></a>
## 1. Setup Athena data sources 
We need to setup our data sources in Athena. This will allow us to query and analyze our application log files and Cost and Usage reports. To set up our data sources, we place our application log files into S3 and then we use Glue to crawl them and create a database. Athena can then be used to run queries against them.

Sample log & CUR files are provided within this lab, we recommend using these log files initially, then once you are familiar with the lab, use your own application and CUR files for your workload. The provided application log files are Apache webserver logfiles, which are automatically recognized by Glue, however we will show you the techniques to be able to use any file format.

**NOTE:** If you use your own log files, you will need to modify the queries in subsequent steps.


### 1.1 Copy application log files into S3
The first step is to get the application log files into Athena to be analyzed. For the provided files, you will copy the sample files to your S3 bucket. To get the files from your own workload, we will show you how to use AWS Systems Manager to do this easily at scale. 

1. Log into the AWS console as an IAM user with the required permissions:
![Images/consolelogin_IAMUser.png](Images/consolelogin_IAMUser.png)

2. Create an **S3 Bucket** with a folder **applogfiles_reinventworkshop** which will contain your application log files. You MUST name the folder **applogfiles_reinventworkshop**, this will make pasting the code faster:
![Images/s3-createbucket.png](Images/s3-createbucket.png)

3. To use the sample log files, copy the following file into your S3 bucket into the **applogfiles** folder, and move onto the next section - **Crawl log files with Glue**. It is recommended you **read** (only READ - dont do) the following steps to understand how you could get your own application log files efficiently in your environment.
    - [Step1_access_log.gz](Code/Step1AccessLog.gz)

4. If you will be using your own application log files, systems manager can be used to run commands across your environment and copy files from multiple servers to S3. Go to **Systems Manager**, and into **Run Command**:
![Images/systemsmanager-runcommand.png](Images/systemsmanager-runcommand.png)

5. Depending on your operating system, you can execute some CLI on your application servers to copy the **application log files** to your **S3 bucket**. The following Linux sample will copy all access logs from the httpd log directory to the s3 bucket created above using the hostname to separate each servers logs:

        HOSTNAME=$(hostname)
        aws s3 cp --recursive /var/log/httpd/ s3://applogfiles-reinventworkshop/$HOSTNAME --exclude "*" --include "access_log*"

6. Select **AWS-RunShellScript**:
![Images/runcommand-runshellscript.png](Images/runcommand-runshellscript.png)

7. Paste in the required commands to be executed on your instances:
![Images/runcommand-commandparameters.png](Images/runcommand-commandparameters.png)

8. You should now have files in S3 for each of your servers, separated into folders by hostname:
![Images/s3-appfolders.png](Images/s3-appfolders.png)

9. In each folder will be the application files:
![Images/s3-appfiles.png](Images/s3-appfiles.png)


### 1.2 Crawl log files with Glue
With the application log files now in S3, we need to create a database we can use to analyze them, we will use AWS Glue for this. The challenge you may have is that your application log files may have a format that is not recognized, so we will show you how to write a custom classifier, which will customize the interpreter to work with any log files.

For our Apache web server log files, the in-bulit AWS Glue classifier **COMBINEDAPACHELOG** will recognize the timestamp (example: 30/Sep/2019:04:14:27 +0000) as a single string. We will customize the interpreter to break this up into a date column, timestamp column and timezone column. This will demonstrate how to write a customer classifier. The reference for classifiers is here: https://docs.aws.amazon.com/glue/latest/dg/custom-classifier.html

A sample log file line is:

        10.0.1.80 - - [26/Nov/2019:00:00:07 +0000] "GET /health.html HTTP/1.1" 200 55 "-" "ELB-HealthChecker/2.0"

The columns would usually be:

    - Client IP
    - Ident
    - Auth
    - HTTP Timestamp*
    - Request
    - Response
    - Bytes
    - Referrer
    - Agent

We will make it build the following columns

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
![Images/glue-classifiers.png](Images/glue-classifiers.png)

2. Click **Add classifier** and create it with the following details:
    - Classifier name: WebLogs
    - Classifier type: Grok
    - Classification: Logs
    - Grok pattern: 

            %{IPORHOST:clientip} %{USER:ident} %{USER:auth} \[%{DATE:logdate}\:%{TIME:logtime} %{INT:tz}\] "(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion})?|%{DATA:rawrequest})" %{NUMBER:response} (?:%{Bytes:bytes=%{NUMBER}|-}) %{QS:referrer} %{QS:agent}

    - Custom patterns:
 
            DATE %{MONTHDAY}/%{MONTH}/%{YEAR}

3. Click **Create**

    A classifier tells Glue how to interpret the log file lines, and how to create columns.  Each column is contained within %{}, and has the **pattern**, the **separator ':'**, and the **column name**.

    By using the custom classifier, we have separated the single column timestamp into 3 columns of logdate, logtime and tz. You can compare the custom classifier we wrote with the COMBINEDAPACHELOG classifier:

        Custom - %{IPORHOST:clientip} %{USER:ident} %{USER:auth} \[%{DATE:logdate}\:%{TIME:logtime} %{INT:tz}\] "(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion})?|%{DATA:rawrequest})" %{NUMBER:response} (?:%{Bytes:bytes=%{NUMBER}|-}) %{QS:referrer} %{QS:agent}

        Builtin - %{IPORHOST:clientip} %{USER:ident} %{USER:auth} \[%{HTTPDATE:timestamp}\] "(?:%{WORD:verb} %{NOTSPACE:request}(?: HTTP/%{NUMBER:httpversion})?|%{DATA:rawrequest})" %{NUMBER:response} (?:%{Bytes:bytes=%{NUMBER}|-}) %{QS:referrer} %{QS:agent}


4. Next we will create a crawler to read the log files, and build a database. Click on **Crawlers** and click **Add crawler**:
![Images/glue-crawleraddcrawler.png](Images/glue-crawleraddcrawler.png)

5. **Crawler name** will be **ApplicationLogs**, expand **Tags, description..** and add the **Custom classifier** we just created, click **Next**:
![Images/glue-crawlercreate1.png](Images/glue-crawlercreate1.png)

6. **Crawler source type** is Data stores, click **Next**:
![Images/glue-crawlercreate2.png](Images/glue-crawlercreate2.png)

7. Click the **folder icon** and select your S3 bucket **and folder** with the log files, click **Select**, then click **Next**. Make sure you select the folder **applogfiles_reinventworkshop**.

8. Do **Not** add another data store

9. **Create an IAM role** named **AWSGlueServiceRole-WebLogs** and click **Next**:
![Images/glue-crawlercreate5.png](Images/glue-crawlercreate5.png)

10. **Frequency** will be run on demand, click **Next**

11. **Add a database** you MUST name it **webserverlogs**, for **Grouping behaviour for S3 data** create a single schema and click **Next**:
![Images/glue-crawlercreate6.png](Images/glue-crawlercreate6.png)

12. Click **Finish**

13. Select and **Run crawler**, this will create a single database and table with our log files, lets confirm. We need to **wait until** the crawler has **finished**, this will take 1-2 minutes. Click refresh to check if its done.

14. Go to **Databases** and click on the database **webserverlogs**, you may need to click **refresh**:
![Images/glue-databaseswebserverlogs.png](Images/glue-databaseswebserverlogs.png)

15. Click **Tables in webserverlogs**, and click the table **applogfiles_...**

16. You can see the table is created, the **Name**, the **Location**, and the **recordCount** has a large number of records in it:
![Images/glue-databasestablewebserverlogs.png](Images/glue-databasestablewebserverlogs.png)

17. Scroll down and you can see the columns, and that they are all **string**. This will be a small hurdle for columns like bytes if you want to perform a function on it:

18. Go to the **Athena** console, and select the **webserverlogs** database:
![Images/athena-dbwebserverlogs.png](Images/athena-dbwebserverlogs.png)

19. Click the **three dots** and click **Preview table**:
![Images/athena-dbpreview.png](Images/athena-dbpreview.png)

20. View the results which will show 10 lines of your log. Note how there are separate columns **logdate** **logtime** and **tz** that we created. The default classifier would have had a single column of text for the timestamp.
![Images/athena-dbresults.png](Images/athena-dbresults.png)


### 1.3 Create a database of your cost files
To measure efficiency we need to know the cost of the workload, so we will use the Cost and Usage Report.

If you are using your own Cost and Usage Reports, you will need to have them already configured and delivered as per this lab: https://wellarchitectedlabs.com/Cost/Cost_Fundamentals/200_4_Cost_and_Usage_Analysis/README.html

To use the files from this lab, follow the steps below:

1. Go to the S3 Console and create a **S3 Bucket** with a folder **costusagefiles-reinventworkshop** which will contain your cost and usage files. You MUST name the folder **costusagefiles_reinventworkshop**, this will make pasting the code faster.

2. Copy the sample file to your bucket:
    - [Step1CUR.gz](Code/Step1CUR.gz)

3. Go into the **Glue** console and **Add crawler**

4. Use the crawler name **CostUsage** and do not specify a classifier

5. Specify **Data stores** as the crawler source type, click **Next**

6. Select the S3 folder created above as the data store

7. Do **not** add another data store, click **Next**

8. Create an **IAM role** named **AWSGlueServiceRole-costusage**

9. Set the frequency to **run on demand**, click **Next**

10. **Add database** it MUST be named **CostUsage**, click **Next**

11. Review and click **Finish**

12. Run the crawler, then check the database was created and has records in it as per the previous step.

13. Go into **Databases**, select the **costusage** database,  and then select the table.  Click **Edit Schema**:
![Images/costtablefix01.png](Images/costtablefix01.png)

14. Make sure the column **line_item_unblended_cost** has a data type of **double**, you may need to change it from string:
![Images/costtablefix02.png](Images/costtablefix02.png)

15. Also change or confirm the following columns:
    - line_item_usage_start_date: timestamp
    - line_item_usage_end_date: timestamp
    - line_item_usage_amount: double

16. Click on **save**, and confirm it is of the correct type.


<a name="setup_quicksight"></a>
## 2 Setup QuickSight - Optional for Visualization
We will use QuickSight as the analysis tool to visualize data. You could query the data in Athena and export the results to be used in a spreadsheet application for graphs, however QuickSight offers the advantages of being the specific tool for the job, and you can easily create additional data fields from existing fields for analysis.

### 2.1 Application files
We will create a data set from the application log files.

1. Go into **QuickSight**

2. Click on your user in the top right, and click **Manage QuickSight**:
![Images/quicksight-manage.png](Images/quicksight-manage.png)

3. Click on **Security and permissions** and click **Add or remove**:
![Images/quicksight-manage2.png](Images/quicksight-manage2.png)

4. Under **Amazon S3** click **Details**:
![Images/quicksight-manage3.png](Images/quicksight-manage3.png)

5. Click **Select S3 buckets**:
![Images/quicksight-manage4.png](Images/quicksight-manage4.png)

6. Select the buckets that have the application log files and the cost and usage files, click **Select buckets**

7. Select **Amazon Athena** and click **Update**:
![Images/quicksight-manage6.png](Images/quicksight-manage6.png)

8. From the **QuickSight home page**, click **Manage data**:
![Images/quicksight-managedata.png](Images/quicksight-managedata.png)

9. Click **New data set**:
![Images/quicksight-newdataset.png](Images/quicksight-newdataset.png)

10. Click **Athena**:
![Images/quicksight-newdatasetathena.png](Images/quicksight-newdatasetathena.png)

12. Enter the **Data source name** AppLogs and click **Create data source**

13. Select the **WebserverLogs Database** and the **Table** and click **Select**

14. Select **Directly query your data** and click **Edit/Preview data**

15. Make sure there is data in the bottom pane. You can see that we have separated our date and time and they are in separate columns with a string data type. What we will now do is create a custom datetime column with the right data type, this will show how you can build custom fields and types for your log files:
![Images/quicksight-datasourcecheck.png](Images/quicksight-datasourcecheck.png)

16. First we will combine the **logdate** and **logtime** columns into a single value separated by a space. Click **Add calculated field**: 
![Images/quicksight-addcalcfield.png](Images/quicksight-addcalcfield.png)

17. To do this we will use the **concat** function. Lets call the field **DateTime**, click **Create**:

        concat({logdate}, ' ', {logtime})

18. You will now see a new column with the correct text on the far right:
![Images/quicksight-datetime2.png](Images/quicksight-datetime2.png)

19. Next we will convert it into the right data type so we can treat it like a timestamp in QuickSight. We will use the **parseDate** function, on the output of the concatenate function. So we will put the concatenate function inside the parseDate function.  Select the **down arrow** next to the calculated field, and select **Edit DateTime**:
![Images/quicksight-datetime3.png](Images/quicksight-datetime3.png)

20. Change the formula to the one below. It puts the parseDate function around the concatenate and we specify the date format so that it is correctly recognized. Click **Apply changes**:

        parseDate(concat({logdate}, ' ', {logtime}), 'dd/MMM/yyyy HH:mm:ss')

    ![Images/quicksight-datetime4.png](Images/quicksight-datetime4.png)       

21. You should see the column on the far right is now of the **Date** data type.  You can do this with any field, for example converting the bytes column to a number by removing and replacing the '-' character with a '0' using the if function.
![Images/quicksight-datetime5.png](Images/quicksight-datetime5.png)  

22. Click **Save & visualize**:
![Images/quicksight-savevisualize.png](Images/quicksight-savevisualize.png)       




### 2.1 Cost and Usage data

1. From the **QuickSight homepage**, click **Manage data**:
![Images/quicksight-homemanagedata.png](Images/quicksight-homemanagedata.png)  

2. Click **New data set**

3. Select **Athena**

4. Name the datasource **WorkloadCost**, click **Create**

5. Select the **costusage database** and **table** that contains your cost data you setup in Glue, and click **Edit/Preview data**:

6. Verify you have cost data, click **Save**, and you will see your new data set next to the existing one:
![Images/quicksight-workloadcost3.png](Images/quicksight-workloadcost3.png)  



<a name="tear_down"></a>
## 3. Tear down
Complete the teardown only after you have finished all steps in this lab
1. Remove the Data Sets in QuickSIght
2. Delete cost and application log databases in Glue
3. Delete S3 buckets containing the application and CUR files
4. Delete the IAM roles that were created to allow Glue access to S3
 
 

