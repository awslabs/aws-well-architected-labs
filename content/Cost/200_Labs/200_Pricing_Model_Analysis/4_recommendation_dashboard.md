---
title: "Create the Recommendation Dashboard"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>4. </b>"
weight: 4
---

1. Go to the QuickSight service homepage:
![Images/home_quicksight.png](/Cost/200_Pricing_Model_Analysis/Images/home_quicksight.png)

2. Go to the **sp_usage analysis**:
![Images/quicksight_sp_analysis.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_sp_analysis.png)

3. Create a line chart, add **line_item_usage_start_date** to the **X axis**, aggregate **day**. Add **spprice** to the **Value** and set the aggregate to **min**. Drag the **product_instance_type** to **Colour** field well. Change the title to **Usage in Savings Plan Rates**:
![Images/quicksight_sp_graph.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_sp_graph.png)

4. Click **Parameters**, and click **Create one**:
![Images/quicksight_parameter_create.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_parameter_create.png)

5. Parameter name **OperatingSystem**, Data type **String**, click **Set a dynamic default**:
![Images/quicksight_parameter_create1.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_parameter_create1.png)

6. Select your dataset, and select **product_operating_system** for the columns, click Apply:
![Images/quicksight_parameter_create2.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_parameter_create2.png)

7. Click **Create**:
![Images/quicksight_parameter_create3.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_parameter_create3.png)

8. Click **Control**:
![Images/quicksight_parameter_create4.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_parameter_create4.png)

9. Enter **OperatingSystem** as the display name, style **Single select drop down**, values **Link to a data set field**, dataset **your data set**, column **product_operating_system**, click **Add**:
![Images/quicksight_parameter_create5.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_parameter_create5.png)

10. Using the process above, Add the parameter **Region**:
    - Name: Region
    - Data type: String
    - Values: Single value
    - Dyanmic default
    - Dataset: your dataset, product_location, product_location
    - Add as: Control
    - Control Display Name: Region
    - Style: Single select drop down
    - Values: link to data set field
    - Data set: your data set
    - Column: product_location

11. Using the process above, Add the parameter **Tenancy**:
    - Name: Tenancy
    - Data type: String
    - Values: Single value
    - Dyanmic default
    - Dataset: your dataset, product_tenancy, product_tenancy
    - Add as: Control
    - Control Display Name: Tenancy
    - Style: Single select drop down
    - Values: link to data set field
    - Data set: your data set
    - Column: product_tenancy

12. Create an **InstanceType** parameter, datatype **String**, **Single value**, Static default value of **.** (a full stop):
![Images/quicksight_parameter_create6.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_parameter_create6.png)

13. Click **Control**,
![Images/quicksight_parameter_create7.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_parameter_create7.png)

14. Display name **InstanceType**, style **Text box**, click **Add**:
![Images/quicksight_parameter_create8.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_parameter_create8.png)

15. Click **Filter** and click **Create one**, select **product_instance_type**:
![Images/quicksight_filter_create.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_filter_create.png)

16. Edit the filter, Filter type:
    - **All visuals**
    - **Custom filter**
    - **Contains**
    - **Use Parameters**
    - **InstanceType**
    - click **Apply**:
![Images/quicksight_filter_edit.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_filter_edit.png)

17. Create a Parameter **DaysToDisplay**:
    - Name: DaysToDisplay
    - Data type: Integer
    - Values: Single value
    - Static default value: 90
    - Click **Create**:
![Images/quicksight_daystodisplay_create.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_daystodisplay_create.png)

18. Click **Control**:
![Images/quicksight_daystodisplay_create2.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_daystodisplay_create2.png)

19. Enter a Display name **DaysToDisplay**, Style **Text box** and click **Add**:
![Images/quicksight_daystodisplay_create3.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_daystodisplay_create3.png)

20. Click on **Filter**, click **+**, and select **line_item_usage_start_date**:
![Images/quicksight_add_filter.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_add_filter.png)

21. Click on the new filter:
![Images/quicksight_add_filter2.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_add_filter2.png)

22. Select a filter type of:
    - **All visuals**
    - **Relative dates**
    - **Days**
    - **Last N days**
    - select **Use parameters**, and accept to change the scope of the filter
    - select the parameter **DaysToDisplay**
    - click **Apply**:
![Images/quicksight_add_filter3.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_add_filter3.png)

23. Create a filter for **product_operating_system**:
    - **All visuals**
    - Type: Custom filter
    - equals
    - Use parameters, change the scope of this filter: yes
    - Parameter: OperatingSystem
![Images/quicksight_os_filter.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_os_filter.png)

24. Create a filter for **product_location**:
    - **All visuals**
    - Type: Custom filter
    - equals
    - Use parameters, change the scope of this filter: yes
    - Parameter: Region
![Images/quicksight_os_filter.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_location_filter.png)

24. Create a filter for **product_tenancy**:
    - **All visuals**
    - Type: Custom filter
    - equals
    - Use parameters, change the scope of this filter: yes
    - Parameter: Tenancy
![Images/quicksight_tenancy_filter.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_tenancy_filter.png)

25. Click on **Visualize**, click **Add**, select **Add calculated field**:
![Images/quicksight_add_calc_field1.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_add_calc_field1.png)

26. Field name **HoursDisplayed**, add the formula below and click **Create**:

        distinct_count({line_item_usage_start_date})
![Images/quicksight_add_calc_field2.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_add_calc_field2.png)   

27. Create a calculated field **HoursRun**, formula:

        HoursDisplayed / (${DaysToDisplay} * 24)

28. Create a calculated field **PayOffMonth**, formula:

        ifelse(((((sum(spprice) / HoursDisplayed) * 730 * 12) / ((sum(odprice) / (${DaysToDisplay} * 24)) * 730))) < 12,((((sum(spprice) / HoursDisplayed) * 730 * 12) / ((sum(odprice) / (${DaysToDisplay} * 24)) * 730))),12)

29. Create a calculated field **SavingsPlanReco**, formula:

        ifelse(PayOffMonth < 12,percentile(spprice,10),0.00)

30. Create a calculated field **StartSPPrice**, formula:

        lag(min(spprice),[{line_item_usage_start_date} ASC],${DaysToDisplay} - 2,[{product_instance_type}])

31. Create a calculated field **Trend**, formula:

        (min(spprice) - {StartSPPrice}) / min(spprice)

32. Create a calculated field **First3QtrAvg**, formula:

        windowAvg(avg(spprice),[{line_item_usage_start_date} ASC],${DaysToDisplay},${DaysToDisplay} / 4,[{product_instance_type}])

33. Create a calculated field **LastQtrAvg**, formula:

        windowAvg(avg(spprice),[{line_item_usage_start_date} ASC],${DaysToDisplay} / 4,1,[{product_instance_type}])

34. Create a calculated field **TrendAvg**, formula:

        (LastQtrAvg- First3QtrAvg) / First3QtrAvg

35. Add a Visual, click **Add**, select **Add visual**:
![Images/quicksight_add_visual1.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_add_visual1.png)

36. Select a **Table** visualization, Group by **product_instance_type**, Add the **values**:
    - SavingsPlanReco
    - PayOffMonth
    - discountrate, aggregate: average
    - HoursRun, show as percent
    - Label it **Recommendations**
![Images/quicksight_add_visual2.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_add_visual2.png)

37. Add a **Pivot Table** visual, Rows: **product_instance_type** and **line_item_usage_start_date aggreate: day**, Add the **values**:
    - instancecount aggregate: average
    - Trend
    - TrendAvg (show as percent)
    - Label it **Trends**,
![Images/quicksight_add_visual3.png](/Cost/200_Pricing_Model_Analysis/Images/quicksight_add_visual3.png)

38. Add a **filter** to **this visual only**:
    - Filter on: StartSPPrice
    - Type: Custom filter
    - Operation: Greater than
    - Value: -1
    - Nulls: Exclude nulls

40. Decrease the width of the date column as much as possible, its not needed
