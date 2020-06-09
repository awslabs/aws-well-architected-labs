---
title: "Format the Recommendation Dashboard"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

We will format the recommendation dashboard, this will improve its appearance, and also includes some business rules.

1. Click on **Themes**, then click on **Midnight**:
![Images/quicksight_themes.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_themes.png)

2. Select the **Recommendations** table, click the **three dots**, click **Conditional formatting**:
![Images/quicksight_conditional_formatting1.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_conditional_formatting1.png)

3. Column: **PayOffMonth**, **Add background color**:
![Images/quicksight_conditional_formatting2.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_conditional_formatting2.png)

4. Enter the formatting:
    - Condition: Greater than
    - Value: 9
    - Color: red
    - Click **Apply**, click **Close**:
![Images/quicksight_conditional_formatting3.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_conditional_formatting3.png)

5. Using the same process, add formatting for the column **discountrate**:
    - Type: Background color
    - Condition: Less than
    - Value: 10 **NOTE** adjust this for your business rules, speak with your finance teams
    - Color: red
    - Click **Apply**, click **Close**

6. Under the **discountrate** formatting, Click **Add text color**:
    - Condition: Greater than
    - Value: 20
    - Color: Green
    - Click **Apply**, click **Close**

6. Using the same process, add formatting for the column **HoursRun**:
    - Type: **Add text color**
    - Condition: Less than
    - Value: 0.6
    - Color: Red
    - Click **Add condition**
    - Condition#2: Less than
    - Value: 0.85
    - Color: Orange
    - Click **Apply**, click **Close**

7. Add formatting for the column **SavingsPlanReco**:
     - Type: Add background color
     - Format field based on: PayOffMonth
     - Condition: Greater than
     - Value: 9
     - Color: Red
     - Click **Apply**, click **Close**
     - Click **Add text color**
     - Format field based on: discountrate
     - Aggregation: Average
     - Condition: greater than
     - Value: 20
     - Color: Green
     - Click **Apply**, click **Close**

8. Click **SavingsPlanReco**, **Sort by Descending**:   
![Images/quicksight_conditional_formatting4.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_conditional_formatting4.png)

9. Select the **Trends** table, select conditional formatting, Column **instancecount**:
    - Type: Add background color
    - Condition: Less than
    - Value: 5, speak with your team to set this at the appropriate level
    - Color: red
    - Click **Add condition**
    - Condition #2: Less than
    - Value: 10
    - Color: Orange
    - Click **Apply**, click **Close**

10. Using the process above on the **Trends** table, Select the **Trend** column:
    - Type: Add background color
    - Condition: Less than
    - Value 0
    - Color: Red
    - Click **Apply**, click **Close**
    - Click **Add text color**
    - Condition: Greater than
    - Value: 0
    - Color: Green
    - Click **Apply**, Click **Close**

11. Add the same formatting to the **TrendAvg** column as the **Trend** column.


{{% notice tip %}}
Congratulations - you now have an analytics dashboard for Savings Plan recommendations!
{{% /notice %}}