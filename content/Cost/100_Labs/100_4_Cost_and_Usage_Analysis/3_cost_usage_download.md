---
title: "Download your monthly cost and usage file"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

It is possible to download a CSV version of your summary cost and usage information. This can be accessed by a spreadsheet application for ease of use. This is part of a legacy feature called "Detailed Billing Reports." If this is already enabled in your account you will be able to immediately download your monthly usage file and view it. If not, it will take up to 24 hours to create a file for your most recent bill. 

1. Go to the billing dashboard:
![Images/AWSBillDetail0.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSBillDetail0.png)

2. Click on **Billing Preferences** from the left menu:
![Images/AWSBillDetail1.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill0.png)

3. Click **Detailed Billing Reports [Legacy]** and check the box to turn on this feature. Click **Configure S3 Bucket** to configure a bucket to store these reports. 
![Images/AWSBillDetail1.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill1.png)

4. Enter a unique bucket name, ensure the region is correct, and click **Next**. 
![Images/AWSBillDetail1.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill2.png)
5. Read and verify the policy, this will allow AWS to deliver billing reports to the bucket. Click on **I have confirmed that this policy is correct**, then click **Save**:
![Images/AWSBillDetail1.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill3.png)
6. Click **Save Preferences** to complete turning on Detailed Billing Reports. 
![Images/AWSBillDetail1.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill4.png)

7. Click on **Bills** from the left menu:
![Images/AWSBillDetail1.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill5.png)

8. Select the **Date** you require from the drop down menu, by clicking on the menu item:
![Images/AWSBillDetail2.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill6.png)

9. Click on **Download CSV**:
![Images/AWSDownloadBill0.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill7.png)

10. It will download a CSV version of the bill you can use in a spreadsheet application. It is recommended to NOT use this data source for calculations and analysis, instead you should use the Cost and Usage Report, which is covered in [200_4_Cost_and_Usage_Analysis]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}}).
![Images/AWSDownloadBill1.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill8.png)

11. If you get the following error, please wait 24 hours before attempting the download the most recent month's bill. 
![Images/AWSDownloadBill1.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill9.png)


For more details on the DBR report and a comparison to the Cost and Usage Report, please check here: https://docs.aws.amazon.com/cur/latest/userguide/detailed-billing.html. 

{{< prev_next_button link_prev_url="../2_cost_usage_detail/" link_next_url="../4_tear_down/" />}}