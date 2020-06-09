---
title: "Sort and filter the RI CSV files"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

RI purchases should be done frequently (bi-weekly or monthly), so for each cycle we want: **low risk** and **high return** purchases, and purchase the top 50-75% of those high quality recommendations. This will ensure you have sufficiently high coverage, while minimizing the risk of unused RIs.

### Filter out low risk, and high return RIs
1. To get the lowest risk, we sort by **Fully Paid Day** smallest to largest, as these will be fully paid off in the shortest amount of time. You can see that some of the RI's below are fully paid off in around 7months, so if they are used for 7 months - they have paid themselves off completely.
![Images/RI_Proc3.png](/Cost/200_3_Pricing_Models/Images/RI_Proc3.png)


2. We will separate the very low, low, and medium risk recommendations. Add in some empty lines before a **Fully Paid Day** of 8, and a fully paid day of 10, also copy the header line across:
![Images/RI_Proc4.png](/Cost/200_3_Pricing_Models/Images/RI_Proc4.png)


3. We have categorized the risk, so we will now look for the highest return recommendations in each category. Sort each of the three groups by **Estimated Monthly Savings**, **largest to smallest**:
![Images/RI_Proc5.png](/Cost/200_3_Pricing_Models/Images/RI_Proc5.png)


4. Depending on your usage and business, chose a minimum estimated monthly savings - a typical value for customers is in the range of $50-100. A recommendation with a saving lower than this may not save enough. Aim for the top 50-70% of recommendations.  We have chosen $100, in each of the three groups grey out anything less than this:
![Images/RI_Proc6.png](/Cost/200_3_Pricing_Models/Images/RI_Proc6.png)

### Filter out usage patterns
It would be a large amount of effort to view the daily usage patterns over the month for every recommendation - checking for declining usage or erratic usage, but we can do this programatically. By looking at the columns, we can assess the underlying usage pattern.

1. If the **Max hourly usage** is close to **Min hourly usage**, within 75-100% - then the usage would be relatively flat, with low variance.  Go through and highlight these cells green.  You could do this with a formula, but a very fast judgment is ok:
![Images/RI_Proc7.png](/Cost/200_3_Pricing_Models/Images/RI_Proc7.png)

2. If the **Average hourly usage** is close to the **Max hourly usage**, then the minimum was only a small duration, so highlight anything green where the **Average** is roughly within 75-100% of the **Max**:
![Images/RI_Proc8.png](/Cost/200_3_Pricing_Models/Images/RI_Proc8.png)

4. Now we look for a declining usage pattern. If the recommendation for the last 7 days is less than the 30 days, usage is declining - and you should consult your business to determine if usage will continue to fall. If the **7day Recommended Instance Quantity** is equal or more than the **30day Recommended Instance Quantity** then highlight the cell green:
![Images/RI_Proc10.png](/Cost/200_3_Pricing_Models/Images/RI_Proc10.png)

5. Now we will see if the recommendation is close to the average, if its not then usage is varying. If the recommendation is **NOT** above, equal or close to the average (within 10%) then remove the highlighting from the recommendation column:
![Images/RI_Proc11.png](/Cost/200_3_Pricing_Models/Images/RI_Proc11.png)


The processed sample files are available here:
- [Combined_EC2_RI_Rec.xls](/Cost/200_3_Pricing_Models/Code/Combined_EC2_RI_Rec.xlsx)


### Making recommendations
We now go through the spreadsheet and apply business rules to make the best low risk & high return purchases that are right for the business. We look at each of the risk categories as follows:

1. Low risk and very low risk - this is the first group of recommendations (fully paid below 8)
 - For any recommendations that are highlighted in the **7Day** column, recommend the lowest of the **30Day** or **7Day** Columns.
 - For any recommendations that were not highlighted in the **7Day** column but are highlighted in the **Average hourly usage**, select a percentage of either the **30Day** or **7Day** column (which ever is lower).


2. Medium risk - this is the second group of recommendations (fully paid below 10)

- From the recommendations highlighted in the **7Day** column, select a portion of these on a case by case basis based on business knowledge  


Other suggestions for recommendations that do not fall into the categories above, and are not greyed out:

- Re-evaluate in another 7-14 days to observe the usage trend
- Purchase a lower percentage of the average hourly
- Purchase a higher percentage of the minimum hourly


{{% notice tip %}}
You have successfully processed all the recommendations. You now have the right low risk and high return recommendations, based on your usage patterns. Take the recommendations, and purchase the quantity required in the correct accounts.
{{% /notice %}}


