---
title: "Download your Monthly Report CSV"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 3
pre: "<b>3. </b>"
---

It is possible to download a **Monthly Report** of your estimated AWS charges from the Bills page of the Billing and Cost Management console of your Management Account. This is typically used by customers looking to analyze their costs in a spreadsheet format with ease of use. This is part of a legacy feature called "Detailed Billing Reports", but is used across many organizations for bill validations. If this is already enabled in your account you will be able to immediately download your monthly usage file and view it. If not, please reference the [AWS Billing Billing and Cost Management User Guide](https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/invoice.html) for steps to enable your Monthly Report. 

1. Go to the billing dashboard:
![Images/AWSBillDetail0.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSBillDetail0.png?classes=lab_picture_small)

2. Click on **Bills** from the left menu:
![Images/AWSBillDetail1.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill0.png?classes=lab_picture_small)

3. Select the **Date** you require from the drop down menu, by clicking on the menu item:
![Images/AWSBillDetail2.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill1.png?classes=lab_picture_small)

4. Click on **Download CSV**:
![Images/AWSDownloadBill0.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill2.png?classes=lab_picture_small)

5. It will download a CSV Monthly Report version of the bill you can use in a spreadsheet application. It is recommended to use this for monthly validations and NOT use this data source for cost analysis or chargeback, instead you should use the Cost and Usage Report, which is covered in [200_4_Cost_and_Usage_Analysis]({{< ref "/Cost/200_Labs/200_4_Cost_and_Usage_Analysis" >}}).
![Images/AWSDownloadBill1.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill3.png?classes=lab_picture_small)

6. If you get the following error, please pick the most recent month and try again. If you continue to receive this error please follow the steps in [AWS Account Setup Lab Guide](https://wellarchitectedlabs.com/cost/100_labs/100_1_aws_account_setup/) and wait 24 hours before attempting to download the most recent month's bill. 
![Images/AWSDownloadBill1.png](/Cost/100_4_Cost_and_Usage_Analysis/Images/AWSDownloadBill4.png?classes=lab_picture_small)


{{< prev_next_button link_prev_url="../2_cost_usage_detail/" link_next_url="../4_teardown/" />}}