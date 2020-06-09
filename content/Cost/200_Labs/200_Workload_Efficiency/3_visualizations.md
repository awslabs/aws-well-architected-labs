---
title: "Create the Visualizations"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

We will now create visualizations of our workload effiency. We will add the new dataset, and then build different visualizations to see what exactly impacts efficiency and where to look to improve it.

### Basic Efficiency visualization
We will create a visualization from the application log files.

1. Go into **QuickSight**

2. Click **Manage data**:
![Images/quicksight-managedata.png](/Cost/200_Workload_Efficiency/Images/quicksight-managedata.png)

3. Click **New data set**:
![Images/quicksight-newdataset.png](/Cost/200_Workload_Efficiency/Images/quicksight-newdataset.png)

4. Click **Athena**:
![Images/quicksight-newdatasetathena.png](/Cost/200_Workload_Efficiency/Images/quicksight-newdatasetathena.png)

5. Enter the **Data source name**: **Efficiency**, and click **Create data source**

6. Select the **costusage Database**, and the **efficiency** Table and click **Select**

7. Select **Spice** and click **Edit/Preview data**

8. Make sure there is data in the bottom pane:

9. Ensure you have data and click **Save & visualize**:

10. Create a **Clustered bar combo chart**. Place **datetime (aggregate hour)** on the x-axis, **cost (sum)** in the bars column, add **request (count)** to the lines field

11. Label the chart **Requests vs Cost**:
![Images/quicksight-requests_cost.png](/Cost/200_Workload_Efficiency/Images/quicksight-requests_cost.png)

12. We can see that it roughly follows the same pattern, however there are times when the trends change. Below you can see the requests increase, but the cost decreases. Also the requests remain the same, and the cost decreases:
![Images/quicksight-anomaly1.png](/Cost/200_Workload_Efficiency/Images/quicksight-anomaly1.png)

13. Maybe it can be explained through something other than request count, lets add **mbytes (sum)** to the lines field well to see if there is correlation there:
![Images/quicksight-requests_cost2.png](/Cost/200_Workload_Efficiency/Images/quicksight-requests_cost2.png)

14. Again, similar trends and anomalies. MBytes remains constant and cost decreases:
![Images/quicksight-anomaly2.png](/Cost/200_Workload_Efficiency/Images/quicksight-anomaly2.png)

15. Lets now create our efficiency visualition. Add a calculated field named **efficiency** with the formula below. Our efficiency metric will be requests per dollar:

        count(request) / sum(cost)

16. Add a visualization, select a **Line chart**. Place **datetime (hour)** in the x-axis, **efficiency** as the value,

17. We now have a chart showing our efficiency over time. Notice how the efficiency changes significantly at the end of the day:
![Images/quicksight-efficiency.png](/Cost/200_Workload_Efficiency/Images/quicksight-efficiency.png)

18. You can now see increases and decreases in efficiency clearly, look when the output increases and cost remains the same, or the cost remains the same and the output decreases:
![Images/quicksight-anomaly3.png](/Cost/200_Workload_Efficiency/Images/quicksight-anomaly3.png)

You now have a baseline efficiency metric. Use this to look for areas of low efficiency of your workload - this will provide areas to cost optimize.


## Request visualization
Lets look deeper into the types of requests to see if we can get better insight into what is driving our costs and efficiency.

1. Lets look at a sample of a successful log request in our application log files:

        /index.php?name=Isabella,user=sponsored,work=26

2. We can see there are the fields:

    - Name
    - User
    - Work

3. Lets create a calculated field **RequestType** with the formula below. This will separate out the types of requests, health checks, image requests and other/errors from the request field:

        ifelse(locate(request,"index.html") > 0,split(request,',',2),ifelse(locate(request,"health.html") > 0,"HealthCheck",ifelse(locate(request,"image_file") > 0,"ImageFile","error")))

4. Create a **Cluster bar combo chart** visualization. Place **datetime (HOUR)** in the x-axis, add **Request (count)** in the bars, add **RequestType** in the Group/Color for bars, add **efficiency** to lines:
![Images/quicksight-request_types.png](/Cost/200_Workload_Efficiency/Images/quicksight-request_types.png)

5. We can see a correlation between the user type and the efficiency, when paid users increase the efficiency goes down, this indicates its more costly to service paid customers. Also look at the efficiency increase when there are large amounts of errors, you may which to filter and exclude low value outputs from the measures of efficiency. These insights can be used to categorize different types of requests in your workload and understand how to charge them back appropriately.
![Images/quicksight-anomaly4.png](/Cost/200_Workload_Efficiency/Images/quicksight-anomaly4.png)

You can use this to increase your efficiency by removing unwanted requests, for example you may use CloudFront to more efficiency handle errors - instead of processing them on the web servers.

{{% notice tip %}}
**Congratulations!**
You have now calculated the efficiency of a workload, you can see how your efficiency changes over time, and look into the types of requests to understand what contributes cost to your workload.

{{% /notice %}}
