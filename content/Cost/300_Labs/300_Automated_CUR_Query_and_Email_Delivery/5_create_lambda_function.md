---
title: "Create a Lambda function"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

We will now create a Lambda function which will run the code and produce the reports.  **NOTE**: this Lambda function must be created in the same region as S3 bucket for CUR query results created earlier.

1. Go to the **Lambda console**, click **Create function**.

2. Select **Author from scratch**, configure the following parameters:
    - **Function name**: Auto_CUR_Delivery
    - **Runtime**: Python 3.7
    - **Execution role**: Use an existing role
    - **Existing role**: Lambda_Auto_CUR_Delivery_Role
    - click **Create function**.
![Images/create_function.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/create_function.png)

3. In the top right-hand corner of Lambda configuration page, click **Select a test event** drop-down box and choose **Configure test events**.                                          
![Images/configure_test_events.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/configure_test_events.png)

4. Use the default event template Hello world, because this function does not need any input event parameters, set a event name **AutoCURDeliveryTest**, and click **Create**.
![Images/event_template.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/event_template.png)

5. In **Function code** section, configure the following:
    - **Code entry type**: Upload a file from Amazon S3
    - **Amazon S3 link URL**: https://s3.amazonaws.com/bucket name/AutoCURDelivery.zip
    - **Handler**: auto_cur_delivery.lambda_handler
![Images/function_code.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/function_code.png)

6. Scroll down to **Basic settings** section, set Memory to 512 MB, and timeout to 5 min.
![Images/basic_settings.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/basic_settings.png)

7. Keep other configurations as default, scroll to the very top and click **Save**. Click the **Actions** drop-down box and choose **Publish new version**.
![Images/pub_new_version.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/pub_new_version.png)

8. Set the **Version description** to v1, and click **Publish**.
![Images/pub_v1.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/pub_v1.png)

9. We have finished the configuration and we will now test it.  Make sure **AutoCURDeliveryTest** event is selected, click **Test**.
![Images/test_function.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/test_function.png)

10. It takes a few seconds to execute Lambda function, and you'll see all logs after execution.
![Images/execution_log.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/execution_log.png)

11. Check your e-mail recipients, they should receive a mail for cost & utilization report with an excel file attached, similarly as below:
![Images/cur_mail.png](/Cost/300_Automated_CUR_Query_and_Email_Delivery/Images/cur_mail.png)

12. By default, the cost & utilization report contains:
    - Cost_By_Service - Cost in the recent three months split by service (e.g. current month is Jul, the recent three months are Jul, Jun and May, same as below)
    - Data_Cost_By_Service - Data cost in the recent three months split by service
    - MoM_Inter_AZ_DT(with graph) - Month over months inter-AZ data transfer usage and change in the recent three months
    - MTD_S3_By_Bucket - Month to date S3 cost and usage type split by bucket name
    - MTD_ELB_By_Name - Month to date ELB cost split by ELB name and region
    - MTD_CF_By_Distribution - Month to date Cloudfront cost and usage split by distribution id


Now you have completed this auto CUR delivery solution with default CUR query. In the next step we will add an additional query, and a CloudWatch scheduled event to trigger Lambda function as required. 
