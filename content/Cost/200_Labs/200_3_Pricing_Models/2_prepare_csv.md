---
title: "Download and prepare the RI CSV files"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

1. Download the CSV for **both** the 7 day and 30 day recommendation files, by selecting the filter **7 days** or **30 days**, and clicking on **Download CSV**:
![Images/AWSRI5.png](/Cost/200_3_Pricing_Models/Images/AWSRI5.png)

{{% notice info %}}
The next steps MUST be followed carefully, ensure you name everything **exactly** as specified or the formulas will not work.
{{% /notice %}}

2. If you do not have sufficient usage, you can download the two sample files:

Open both files in a spreadsheet application. Paste the 30day recommendations into one worksheet, and the 7day recommendations into another worksheet called **7Day Rec**, in the same spreadsheet.

- [7_day_EC2_R_Rec.csv](/Cost/200_3_Pricing_Models/Code/7_day_EC2_RI_Rec.csv)
- [30_day_EC2_R_Rec.csv](/Cost/200_3_Pricing_Models/Code/30_day_EC2_RI_Rec.csv)


3. Create a new column called **RI ID** to the left of the **Recommended Instance Quantity Purchase** column on **both** 30Day and 7Day sheets, which is a unique identifier of the RI Type, the formula for this cell will concatenate the columns: **Instance Type**, **Location**,**OS** and **Tenancy**. On **row 2** of the sample files, paste the formula below into the first row of data and fill the remaining rows below.

    =CONCATENATE(C2,L2,M2,N2)

![Images/RI_Proc0.png](/Cost/200_3_Pricing_Models/Images/RI_Proc0.png)


4. Add a column in the **30Day** worksheet to the right of the **Recommended Instance Quantity Purchase** column. Label it **7Day recommendation**.  Add a VLOOKUP formula to get the values from the **7Day** worksheet, paste the formula below into the first row of data and fill the remaining rows below.

{{% notice note %}}
If using your own data, modify the **U$48** component to the number of rows in your data.
{{% /notice %}}

    =VLOOKUP(T2,'7Day Rec'!T$2:U$48,2,FALSE)

![Images/RI_Proc1.png](/Cost/200_3_Pricing_Models/Images/RI_Proc1.png)

5. We will now create a **Fully Paid Day** column. This shows us how long it will take to pay off the full term of the RI, and will help to measure risk. The closer to 12months the fully paid day is, the higher the risk. The break even is the wrong measure, as it only shows how quickly you pay off the upfront component, and not the full amount.
Paste the following formula into the last column **z**:

       =(R2+S2*12)/(R2/12+S2+W2)


{{% notice note %}}
The formula for the fully paid day is:
    (yearly RI cost) / (monthly on-demand cost)
{{% /notice %}}


6. Delete the following columns as they are not necessary: 
 - **Recommendation Date**
 - **Size Flexible Recommendation**
 - **Max hourly normalized unit usage in Historical Period**
 - **Min hourly normalized unit usage in Historical Period**
 - **Average hourly normalized unit usage in Historical Period**
 - **Projected RI Utilization**
 - **Payment Option**
 - **Break Even Months**.


{{% notice tip %}}
You have compiled a complete set of recommendations with the required data to be able to analyse and make low risk high return recommendations.
{{% /notice %}}