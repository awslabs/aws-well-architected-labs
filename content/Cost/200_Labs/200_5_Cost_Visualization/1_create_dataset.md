---
title: "Create a data set"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---


We will create a data set so that QuickSight can access our Athena data set, and visualize our CUR data.


1. Log on to the console via SSO, go to the **QuickSight** service, Enter your email address and click **Continue**:
![Images/QuickSight_email.png](/Cost/200_5_Cost_Visualization/Images/QuickSight_email.png)

2. Click **Manage data** in the top right:
![Images/AWSQuicksight13.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight13.png)

3. Click **New data set**:
![Images/AWSQuicksight14.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight14.png)

4. Click **Athena**:
![Images/AWSQuicksight15.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight15.png)

5. Enter a **Data source name**, and click **Create data source**:
![Images/AWSQuicksight16.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight16.png)

6. Select the **costmaster** database, and then the CUR table you created in Athena, and click **Select**:
![Images/AWSQuicksight17.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight17.png)

7. Select **Directly query your data**, and click **Visualize**:
![Images/AWSQuicksight74.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight74.png)


{{% notice tip %}}
You have now configured a dataset to be able to create visualizations.
{{% /notice %}}



