---
title: "Customize query strings and create scheduled CloudWatch event"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>6. </b>"
weight: 6
---
1. In you local path where **AutoCURDelivery.zip** is located. Unzip and re-open **config.yml** in a text editor.

2. Find **Body_Text**, insert a description of new query **MTD_Inter_AZ_DT**.
    ```
    MTD_Inter_AZ_DT -  Month to date inter-AZ data transfer split by resource ID
    ```
    ![Images/body_text.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/body_text.png)

3. Find the section **Query_String_List**, add following new query string at the bottom of file (note the indent should be same as other query strings), save **config.yml**.

          - MTD_Inter_AZ_DT: SELECT
                year
                ,month(line_item_usage_start_date) month
                ,line_item_product_code as Product_Name  
                ,line_item_resource_id as Resource_Id  
                ,line_item_usage_type as Usage_Type
                ,sum(line_item_usage_amount) as "Inter_AZ_Data_Transfer(GB)"
                ,sum(line_item_unblended_cost) as "Cost($)"
                FROM
                CUR_DB
                WHERE
                "line_item_usage_type" like '%Bytes%'
                AND "line_item_usage_type" like '%Regional%'
                AND year='CUR_YEAR' AND month='CUR_MONTH'
                GROUP BY
                1,2,3,4,5
                ORDER BY
                sum("line_item_unblended_cost") desc

The paramemters CUR_DB, CUR_MONTH, CUR_YEAR are replaced when function is running

4. Add **config.yml** back into **AutoCURDelivery.zip**, and upload zip file to S3.

5. Goto Lambda console, update function code path to above S3 path where new zip file is located, click **Save**.

6. Perform another **Test** of the function.

7. Check the cost & utilization report in the mail your recipient receives, there should be one more tab added in the excel file for month to date inter-az data transfer cost.

We will now create a scheduled Cloudwatch event to trigger Lambda function periodically

8. Go to the **Cloudwatch dashboard**, under **Events** click **Rules**

9. Click  **Create rule**.

10. In **Event Source**, choose **Schedule**, use default **fixed rate of 5 minutes**.

11. In **Targets** click **Add Target** and choose **Lambda function** in the drop-down box.

12. Choose the function **Auto_CUR_Delivery**, click **Configure details**
![Images/create_rule.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/create_rule.png)

13. Configure a name **5_min_auto_cur_delivery**, click **Create rule**.
![Images/rule_name.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/rule_name.png)

14. Wait for 5 minutes, your recipients should receive a cost & utilization report mail, and continually receive report mail every other 5 minutes.

15. To stop event triggering, choose the rule **5_min_auto_cur_delivery**, click **Actions** and select **Disable**.
![Images/disable_rule.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/disable_rule.png)

Now you have completed this lab to query CUR with customized query strings from Athena and send it via SES periodically. To explore more, you can define your own query strings in **config.yml** and configure CloudWatch event rule to the rate as required.  
