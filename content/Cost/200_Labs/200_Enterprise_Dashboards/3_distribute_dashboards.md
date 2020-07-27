---
title: "Distribute Dashboards"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

## Authors
- Nathan Besh, Cost Lead Well-Architected  (AWS)

You now have a set of dashboards to provide insight and assist with analysis. The most effective way to allow users to access and work with the dashboards is to create users in QuickSight, and provide access to the dashboard. This will provide full access to all the most recent data, enable the use of features such as filters to dive deep into the data and perform analysis work..

This step will look at ways to distribute the content to users, which can be an effective reminder - for example, weekly updates to ensure people are checking their dashboards and tracking progress towards goals.


### Configure email reports
We will configure a weekly email report of the Cost Intelligence dashboard. This will ensure that all relevant parties within your organization have the access and visibility to the information they need.

{{% notice note %}}
An email report sends the first page of a dashboard only. You can change the front page of an analysis, re-save it as a dashboard, and then create the report to send out different reports via email.
{{% /notice %}}

1. Login to QuickSight

2. Select **All dashboards** and click on the **Cost Intelligence** dashboard

3. Click on **Share**, then **Share dashboard**
![Images/QSDashboard_share.png](/Cost/200_Enterprise_Dashboards/Images/QSDashboard_share.png)

4. Ensure all the required users have access to the dashboard:
![Images/QSShare_users.png](/Cost/200_Enterprise_Dashboards/Images/QSShare_users.png)

5. Click on **Share**, then **Email report**:
![Images/QSDashboard_shareemail.png](/Cost/200_Enterprise_Dashboards/Images/QSDashboard_shareemail.png)

6. Create the **Schedule**, the **Text and report preferences**, add **recipients** and click **Save report**:
![Images/QSreport_details.png](/Cost/200_Enterprise_Dashboards/Images/QSreport_details.png)

7. If required, modify the analysis and re-save it as a dashboard, and create additional email reports.


{{% notice tip %}}
You have successfully created an email report.
{{% /notice %}}
