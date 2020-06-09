---
title: "Create the efficiency data source"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---
We will now build the efficiency data source, by combining the application logs with the cost data. When using your own application logs, you need to look through the logs and discover what the application is doing, and capture the log messages that indicate its various outputs, and what could consume resources of the system - as this will potentially indicate cost and usage of the system. Things to look for:

 - Successful requests: Valid requests that produce an output
 - Unsuccessful requests: Requests that require processing and resources, but dont produce an output
 - Errors: Do not procduce an output, but consume application resources
 - Types of requests: Different requests may require different resourcing, and costs
 - Data transfer: Similar to types of requests, the data going into a system may indicate processing requirements or cost


### Review application logs
We will use Athena to analyze the application logs, and discover the relevant data and fields.

1. Go into Athena console

2. Run the following query to see a sample of all data available:

        SELECT * FROM "webserverlogs"."applogfiles_workshop" limit 10;

3. We can see interesting fields could be: **request**, **response**, **bytes**, as these indicate requests to the workload and could indicate the amount of processing the workload performs.

4. Run the following query to see the different types of **requests**:

        SELECT distinct request, count(*) FROM "webserverlogs"."applogfiles_workshop"
        group by request
        order by count(*) desc
        limit 1000;

5. We can see there are: **health checks**, **errors**, **image_file requests**, **index.html requests**. Successful requests should make up most of the work and cost, however errors may also consume resources and costs.

6. Run the following query to see the different types of responses:

        SELECT distinct response, count(*) FROM "webserverlogs"."applogfiles_workshop"
        group by response
        limit 100;

7. We can see most are **200 - success**, but there are a lot of **400 series** which are client errors. So there could be considerable load from errors on the workload.

8. Data transfer also contributes to cost, so lets look at bytes. A large total amount of bytes may come from small numbers of large byte requests, **or** large numbers of small byte requests. Lets look at the distribution and run the following query:

        SELECT distinct bytes, count(*) FROM "webserverlogs"."applogfiles_workshop"
        group by bytes
        order by count(*) desc
        limit 100;

9. We have both lots of small requests (55, 91 byets) and some large sized requests also.

10. We will choose the following fields for our efficiency data:
    - Request
    - Response
    - Bytes



### Review the Cost and Usage Reports
We already know how to analyse the Cost and Usage reports, so lets use Athena to discover the relevant data and fields.

1. Go into Athena console

2. Run the following query to see a sample of all data available:

        SELECT * FROM "costusage"."costusagefiles_workshop" limit 10;

3. We know we need the unblended cost, the usage date and time, and also ensure that it is only costs for this specific workload. We tagged our resources,  so include the tag: **user application = ordering**

4. Run the following query to get a sample of our cost data for the application:

        SELECT line_item_usage_start_date, sum(try_cast(line_item_unblended_cost as double)) as cost FROM "costusage"."costusagefiles_workshop"
        where resource_tags_user_application like 'ordering'
        group by line_item_usage_start_date
        limit 10

5. We now have our workload hourly costs, so lets combine that with our application logs and create an efficiency table.


### Create the efficiency data source
We will combine the application logs and the hourly cost data with a view, to get an efficiency data source. First we'll create an hourly cost data set, then combine this with the application logs in another view.

1. Run the following query in Athena to create the hourly cost view:

        create view costusage.hourlycost as
        SELECT line_item_usage_start_date, sum(try_cast(line_item_unblended_cost as double)) as cost FROM "costusage"."costusagefiles_workshop"
        where resource_tags_user_application like 'ordering'
        group by line_item_usage_start_date

2. Lets confirm its setup correctly & sample it, run the following query:

        select * from costusage.hourlycost


3. We can see the workload cost for every hour

4. We will combine the hourly cost table and the application log table using a union. This will basically copy the lines together in a single table. However, the columns wont match between the tables, so we will add NULL values where required.  We will also divide the bytes by **1048576** to get a more readable MBytes value. Copy the following query into Athena to create the efficiency table:

        create view costusage.efficiency AS
        SELECT date_parse(concat(logdate, ' ', logtime), '%d/%b/%Y %H:%i:%S') as Datetime, request, response, try_cast(bytes as double)/1048576 as MBytes, NULL AS Cost from webserverlogs.applogfiles_workshop
        union
        select date_parse(line_item_usage_start_date, '%Y-%m-%d %H:%i:%s') as Datetime, NULL AS request, NULL AS response, NULL AS MBytes, Cost from costusage.hourlycost

5. Lets check our new efficiency table. Run the following query:

        SELECT * FROM "costusage"."efficiency"
        order by datetime asc
        limit 100;

6. We have our efficiency data source:
![Images/athena-efficiency_table.png](/Cost/200_Workload_Efficiency/Images/athena-efficiency_table.png)

The first line is from our cost table, note the NULL values for requets, response and MBytes. The remaining lines will be from our application logs, and contain the data we need to measure efficiency.
