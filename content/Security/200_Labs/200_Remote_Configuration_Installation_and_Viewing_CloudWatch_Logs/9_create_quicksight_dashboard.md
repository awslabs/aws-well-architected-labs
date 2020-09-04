---
title: "Create a QuickSight Visualization"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 9
pre: "<b>9. </b>"
---

Amazon QuickSight is a Business Intelligence service that allows you to streamline delivery of data insights. Prior to building out a dashboard, you need to prepare QuickSight by creating an account and linking your table from Athena. Using QuickSight, you will build out a dashboard to display responses to site visits on your website.

1. Open the [QuickSight console](https://quicksight.aws.amazon.com/).
2. If this is your first time accessing QuickSight, you will need to create your QuickSight account.
   1. You may be prompted to sign up for QuickSight - click **Sign up for QuickSight**. Ensure that the **AWS Account** number shown matches your AWS Account. If not, click the **log in again** link to sign in with the correct account.
   2. Choose the edition you would like to use. For this lab, the **Standard** edition is sufficient.
   3. On the next screen, you will need to configure some options.
      1. First, select the **QuickSight region**. This should be the same region you have been operating in for the rest of the lab.
      2. Enter a **QuickSight account name** and **Notification email address.**
      3. Ensure that the **Amazon Athena** box is checked. This allows QuickSight to access Athena databases.
      4. Check the **Amazon S3** box, on the screen that follows. Click the tick box next to the bucket you created for this lab, likely called `wa-lab-<your-last-name>-<date>`, also select the **Write permission for Athena Workgroup** tick box for that bucket. This gives permissions for QuickSight to access data in the S3 bucket and write to the Athena Workgroup used for querying.
      5. Click **Finish**.
   4. Click **Finish.** On the next screen, click **Go to QuickSight**.

![quicksight-1](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/quicksight-1.png)

3. If this is not your first time using QuickSight, you will need to give QuickSight permission to access log files from your S3 bucket.
   1. Click on your user icon in the top right corner of the screen.
   2. Click **Manage QuickSight**.
   3. Click **Security & Permissions**. QuickSight may prompt you to change your region to N. Virginia to do so. Click on the user icon and change your region if needed.
   4. Under **QuickSight access to AWS Services**, click **Add or remove**.
   5. Tick the tick box next to Amazon Athena. This allows QuickSight to access Athena databases.
   6. Tick the tick box next to Amazon S3. If S3 is already ticked, click **Details **and then **Select S3 buckets.**
   7. Click the tick box next to the bucket you created for this lab, likely called `wa-lab-<your-last-name>-<date>`, also select the **Write permission for Athena Workgroup** tick box for that bucket. This gives permissions for QuickSight to access data in the S3 bucket and write to the Athena Workgroup used for querying.
   8. Click **Finish**.
   9. Click **Update**.
   10. Click on the QuickSight logo in the top right corner of the page to return to the QuickSight homepage.
   11. If you changed your region to N. Virginia to change permissions, switch it back to the region you have been operating in for this lab.
4. Now you can create your analysis dashboard. Click the **New analysis** button in the top left corner of the screen.
5. Click the **New dataset** button in the top left corner of the screen to link your Athena database to QuickSight.
6. On the screen that appears, click **Athena**
7. Enter a **Data source name**, such as `security-lab-log-data`. Leave the **Athena workgroup** as `[ primary ]`.  Click **Create data source**.
8. In the **Choose your table screen**, click the dropdown menu and select `security_lab_logs`, the database you created in Athena. In the table selection menu that appears, select `security_lab_apache_access_logs`. Click **Select**.

![quicksight-2](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/quicksight-2.png)

9. In the **Finish data set creation screen**, select the **Directly query your data** radio bubble. Click **Visualize**.
10. You should now see a screen similar to the one below.

![quicksight-3](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/quicksight-3.png)

11. Now, you will create a bar graph showing frequency of response types by day. To do so, click on the **Vertical bar chart** in the **Visual types** section in the bottom left.
12. You will see three **Field wells** at the top of the page. You will set these fields by dragging and dropping fields from the left side menu into the field wells.
    1. Set **X axis** to `request_date`.
    2. Set the **Value** and **Group/Color**  to `response_code`.

![quicksight-4](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/quicksight-4.png)

13. Your graph should be created similar to the one above. You have now created a graph that displays the count of each response type your page received each day. Since this architecture was deployed for this lab, your graph will be very simple - with only one date on the X Axis.
14. Now, you can publish this analysis into a QuickSight dashboard. Click the **Share** button in the top right corner of the screen. In the dropdown menu, click **Publish dashboard**.
15. Select **Publish new dashboard as** in the pop-up menu. Enter a name, such as `Security-Lab-CW-Apache-Responses`. Click **Publish dashboard**.

![quicksight-5](/Security/200_Remote_Configuration_Installation_and_Viewing_CloudWatch_Logs/Images/quicksight-5.png)

16. This will take you to your new dashboard with a pop-up window to share the dashboard with users. This allows you to send the dashboard to other people. For the purposes of this lab, you can close out of this window by clicking the **X** in the top right corner.
17. You should now see your QuickSight dashboard. This dashboard will be very simple, only containing the one graph created in your analysis. However, this should elucidate the purpose of QuickSight. You are able to communicate important information about your website to a broad audience, all without directly touching the data needed.

**Recap**: In this section, you built out a QuickSight visualization to display the responses generated by hits on your website. In doing this, you create a digestible source of data and information that anyone can understand. This also demonstrates the security best practices of “analyzing logs centrally” and “keeping people away from data”, as your log files are centrally graphed in QuickSight and the source log data is abstracted from viewers on many levels.

{{< prev_next_button link_prev_url="../8_query_from_athena/" link_next_url="../10_recap/" />}}
