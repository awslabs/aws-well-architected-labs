---
title: "Setup QuickSight Dashboard"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

We will now setup the QuickSight dashboard to visualize your usage by cost, and setup the analysis to provide Savings Plan recommendations.

1. Go to the QuickSight service:
![Images/home_quicksight.png](/Cost/200_Pricing_Model_Analysis/Images/home_quicksight.png)

2. Click on **Manage data**:
![Images/quicksight_managedata.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_managedata.png)

3. Click on **New data set**:
![Images/quicksight_newdataset.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_newdataset.png)

4. Click **Athena**:
![Images/quicksight_athenadataset.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_athenadataset.png)

5. Enter a Data source name of **SP_Usage** and click **Create data source**:
![Images/quicksight_namedatasource.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_namedatasource.png)

6. Select the **costmaster** database, and the **sp_usage** table, click **Select**:
![Images/quicksight_choosetable.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_choosetable.png)

7. Ensure SPICE is selected, click **Visualize**:
![Images/quicksight_datasetfinish.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_datasetfinish.png)

8. Click on **QuickSight** to go to the home page:
![Images/quicksight_home.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_home.png)

9. Click on **Manage data**:
![Images/quicksight_managedata.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_managedata.png)

10. Select the **sp_usage** Dataset:
![Images/quicksight_refresh1.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_refresh1.png)

11. Click **Schedule refresh**:
![Images/quicksight_refresh2.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_refresh2.png)

12. Click **Create**:
![Images/quicksight_refresh3.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_refresh3.png)

13. Enter a schedule, it needs to be refreshed daily, and click **Create**:
![Images/quicksight_refresh4.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_refresh4.png)

14. Click **Cancel** to exit:
![Images/quicksight_refresh5.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_refresh5.png)

15. Click the **x** in the top corner:
![Images/quicksight_refresh6.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_refresh6.png)

{{% notice tip %}}
You now have your data set setup ready to create a visualization.
{{% /notice %}}
