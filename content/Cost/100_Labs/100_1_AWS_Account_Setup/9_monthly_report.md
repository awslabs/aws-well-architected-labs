---
title: "Configure Monthly Reports (Optional)"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 9
pre: "<b>9. </b>"
---

It is possible to enable a CSV version of your summary cost and usage information called "Monthly Report. This is typically used by customers looking to analyze their costs in a spreadsheet format with ease of use. This is part of a legacy feature called "Detailed Billing Reports," but is used across many organizations for bill validations. Once setup, it will take up to 24 hours to create a file for your most recent bill. 

###  Configure Monthly Reports

1. Go to the billing dashboard:
![Images/AWSAcct4.png](/Cost/100_1_AWS_Account_Setup/Images/AWSMR0.png?classes=lab_picture_small)

2. Click on **Billing Preferences** from the left menu:
![Images/AWSMR1.png](/Cost/100_1_AWS_Account_Setup/Images/AWSMR1.png?classes=lab_picture_small)

3. Click **Detailed Billing Reports [Legacy]** and check the box to turn on this feature. Click **Configure S3 Bucket** to configure a bucket to store these reports. 
![Images/AWSMR2.png](/Cost/100_1_AWS_Account_Setup/Images/AWSMR2.png?classes=lab_picture_small)

4. Enter a unique bucket name, ensure the region is correct, and click **Next**. 
![Images/AWSMR3.png](/Cost/100_1_AWS_Account_Setup/Images/AWSMR3.png?classes=lab_picture_small)

5. Read and verify the policy, this will allow AWS to deliver billing reports to the bucket. Click on **I have confirmed that this policy is correct**, then click **Save**:
![Images/AWSMR4.png](/Cost/100_1_AWS_Account_Setup/Images/AWSMR4.png?classes=lab_picture_small)

6. Check off both Monthly Report and Cost Allocation Report and click **Save Preferences** to complete turning on Monthly Reporting. 
![Images/AWSMR5.png](/Cost/100_1_AWS_Account_Setup/Images/AWSMR5.png?classes=lab_picture_small)


For more details on the monthly report please take a look here: https://docs.aws.amazon.com/cur/latest/userguide/monthly-report.html. 

{{< prev_next_button link_prev_url="../2_cost_usage_detail/" link_next_url="../4_tear_down/" />}}