---
title: "Create visualizations"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---
We will now start to visualize our costs and usage, and create a dashboard.

### Cost by account and product
The first visualization of the dashboard will do is a visualization of costs by linkedaccountID, and product. This will highlight top spend by account and product.

1. Select **line_item_unblendedcost** from the Fields list, and it will show Sum of Line_item_unblended_cost:
![Images/AWSQuicksight19.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight19.png)

2. Select **line_item_usage_account_id**, which will add it to the graph:
![Images/AWSQuicksight20.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight20.png)

3. Expand the field wells by clicking on the **two arrows** in the top right. Drag **line_item_product_code** into the **Group/Color** field:
![Images/AWSQuicksight21.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight21.png)

4. Select the **dropdown** next to the title, and chose **Format visual**:
![Images/AWSQuicksight22.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight22.png)

5. Click on the **down arrows** under **format visual**, change:
- **Y-Axis label**: Linked Account ID
- **X-Axis label**: Cost
- Double click the **title** to set it:
- Title: Cost by Account and Product
![Images/AWSQuicksight23.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight23.png)

6. Modify the graph so that all elements are visible, with the **lower corner** and **vertical bars**: (you may need to increase the size of the graph)
![Images/AWSQuicksight24.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight24.png)

7. Sort the accounts by cost, click the **dropdown under the X-Axis** (Cost label), and select **Sort by descending**:
![Images/AWSQuicksight25.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight25.png)

8. The visualization is complete and the layout should look similar to:
![Images/AWSQuicksight26.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight26.png)

9. Click on the highest usage bar, in this example it is **AWSGlue**, and select **Exclude AWSGlue**:
![Images/AWSQuicksight27.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight27.png)

10. You will notice that AWSGlue (or the service you selected) is no longer showing, and on the left it has automatically **created and applied a filter**:
![Images/AWSQuicksight28.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight28.png)


### Elasticity
The next visualization on the dashboard we will create is a visualization that shows usage for every hour, by purchase type (On Demand, Spot, Reserved Instance). In the CUR file there is no single field which shows the purchase type for EC2 Instances – so we’ll make one with a calculated field.

1. Click **Add** in the top left corner, then select **Add calculated field**:
![Images/AWSQuicksight29.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight29.png)

2. Copy and paste this formula into the **Formula** box:
```
ifelse(split({line_item_usage_type},':',1) = 'SpotUsage','Spot',ifelse(right(split({product_usagetype},':',1), 8) = 'BoxUsage',{pricing_term},'other'))
```
**Description**:
- Ifelse(<if>, <then>, <else>) If statement evaluated and returns <then> if true, otherwise <else>
- Right(<expression>, <limit>) Returns the right most characters from a string
- Split(<expression>, <string>, <position>) Returns the substring when <expression> is split by <string>, position is the index of the array starting at 1

**Formula Logic**:
If the first part of ‘lineitem/usagetype’ is ‘SpotUsage’ then PurchaseOption = ‘Spot’, otherwise check part of ‘product/usagetype’ is ‘BoxUsage’, if it is then PurchaseOption = ‘pricing/term’, otherwise PurchaseOption = ‘other’.

3. Enter a **Calculated field name** of **PurchaseOption**, and click **Create**:
![Images/AWSQuicksight30.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight30.png)

The new field will appear in the list of fields in the data source

4. Click **Add** then select **Add visual** from the top left:
![Images/AWSQuicksight31.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight31.png)

5. Click the field **line_item_usage_amount** to add it to the visualization:
![Images/AWSQuicksight32.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight32.png)

6. Click **line_item_usage_start_date** to add it to the visualization x-axis:
![Images/AWSQuicksight33.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight33.png)

7. Change the aggregation of time to **hourly**, expand the field wells wih the **arrows at the top right**, click the **down arrow* next to **line_item_usage_start_date**, click the arrow next to **Aggregate: Day**, and click **Hour**:
![Images/AWSQuicksight34.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight34.png)

8. Click and drag **PurchaseOption** to the **Color** field:
![Images/AWSQuicksight35.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight35.png)

9. Now we will filter out **other**, click **Filter** on the left, and click **Create One...**:
![Images/AWSQuicksight36.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight36.png)

10. Select **PurchaseOption**:
![Images/AWSQuicksight37.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight37.png)

11. Click on the filter name **PurchaseOption** to edit it:
![Images/AWSQuicksight38.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight38.png)

12. Change the filter type to **Custom filter list**, enter **other** and click the **+**, change the **Current list** to **Exclude**:
![Images/AWSQuicksight39.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight39.png)

13. Click **Apply**:
![Images/AWSQuicksight40.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight40.png)

14. Select the **empty** line, and right click and select **exclude**:
![Images/AWSQuicksight41.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight41.png)

15. Update the title to **Usage Elasticity**, and you now have your elasticity graph, showing hourly usage by purchase option:
![Images/AWSQuicksight42.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight42.png)

{{% notice note %}}
In the top left it states SHOWING TOP 200, and on the x-axis it has changed the range from Nov 10th to Nov 18th (most recent data points)
{{% /notice %}}

Line charts show up to 2500 data points on the X axis when no color field is selected. When color is populated, line charts show up to 200 data points on the X axis and up to 25 data points for color.
To work within this limitation, you can to add a filter to see each purchase option (OnDemand, Reserved, Spot) and remove the color field, we will do that next.

16. We will now add instance type to the visualization, to be able to further drill down on usage. We will use another calculated field to get the instance type. Click on **Add**, and click **Add calculated field**:
![Images/AWSQuicksight43.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight43.png)

17. Copy and paste the following formula:
```
split({line_item_usage_type},':',2)
```

18. Name the field **InstanceType**, click **Create**:
![Images/AWSQuicksight44.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight44.png)

19. Drag **InstanceType** across to the **Color** field, the **bottom of the box** so it says Add drill-down layer:
![Images/AWSQuicksight45.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight45.png)

20. Select **InstanceType** and it will display the **hourly usage by instance type** (which is all usage regardless of purchase option):
![Images/AWSQuicksight46.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight46.png)

21. Now select **PurchaseOption**:
![Images/AWSQuicksight47.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight47.png)

22. Now we’ll focus only **on ondemand**. Click on the **blue line** & select **Focus only on OnDemand**:
![Images/AWSQuicksight48.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight48.png)

23. You can see it automatically **added a filter on the left**, now click **InstanceType**:
![Images/AWSQuicksight49.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight49.png)

24. It will now only show **hourly usage of OnDemand instances**:
![Images/AWSQuicksight50.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight50.png)

25. You can enable/disable the filter to quickly cycle through the different options, by clicking on the **checkbox next to the filter**:
![Images/AWSQuicksight51.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight51.png)

- This is also useful to work within the limitations of the number of data points on visuals. Remove the color field & enable/disable the filters to switch between data.
- Hourly usage of on demand instances is useful when making Reserved Instance purchase decisions and verifying usage to confirm if a purchase should be made.


### Cost by line item description
The previous visual showed instance usage, however instances vary in cost and your organization may have significant spend in other services and other components of EC2. So now we’ll create a visualization that looks at daily costs by line_item_line_item_descrption, this will help to identify exactly where your costs are by within each service, across all services on a daily basis.


1. Click **Add** and select **Add visual**:
![Images/AWSQuicksight52.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight52.png)

2. Click on **line_item_unblendedcost** to add it to the visualization:
![Images/AWSQuicksight53.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight53.png)

3. Click on **line_item_usage_start_date** to add it to the visualization, and you will have the **Sum of Line_item_unblended_cost** by **line_item_usage_start_date**:
![Images/AWSQuicksight54.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight54.png)

4. The data source for our workshop is 3 months of data, so we’ll narrow that down with a filter to make it faster. Click on **Filter** and click **Create one…**
![Images/AWSQuicksight55.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight55.png)

5. Select **bill_billing_period_start_date**:
![Images/AWSQuicksight56.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight56.png)

6. Click on the filter name, **bill_billing_period_start_date**:
![Images/AWSQuicksight57.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight57.png)

7. Select a **Relative dates** filter, by **Months** and select **This month**, then click **Apply**:
![Images/AWSQuicksight58.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight58.png)

8. Click **Visualize**:
![Images/AWSQuicksight59.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight59.png)

9. Drag **line_item_line_item_description** to the **Color field well**, to add it to the visualization:
![Images/AWSQuicksight60.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight60.png)

10. You may have a visualization similar to below, which doesn’t look very meaningful:
![Images/AWSQuicksight61.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight61.png)

11. Click on the **Vertical stacked bar** chart icon under **Visual Types**:
![Images/AWSQuicksight62.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight62.png)

12. You should get a graph similar to below which highlights cost more efficiently:
![Images/AWSQuicksight63.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight63.png)

Hover over the large usage and you can see the actual costs.
To use this graph, observe the top costs, then exclude them and continue to drill down on the highest cost visible.

### Dashboard Complete
Your dashboard is now complete, you should have a similar dashboard to below:
![Images/AWSQuicksight64.png](/Cost/200_5_Cost_Visualization/Images/AWSQuicksight64.png)
