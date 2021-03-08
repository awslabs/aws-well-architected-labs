---
title: "Create Journey"
date: 2021-03-01T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

### Create the Journey
We will now run the Lambda function and create the Well-Architected Cost Journeys. We will manually run the function

1. Go to the **Lambda** service page, select the **Cost_W-A_Journey** function

2. Scroll down to the **Code source**, click **Deploy**, click **Test**

3. Set the event name to **CreateJourney**, click **Create**

4. Click **Test**, 
![Images/lambda_test.png](/Cost/200_cost_journey/Images/lambda_test.png)

5. You will see a null response and there should be some log messages in the lambda console
![Images/lambda_response.png](/Cost/200_cost_journey/Images/lambda_response.png)

6. Go to the **s3 console** and select the bucket you configured, you will see a **W-A Workload Journeys.html** file which contains the index of all the workload journeys. The **WorkloadReports/** folder contains each workload journey.
![Images/s3_journeys.png](/Cost/200_cost_journey/Images/s3_journeys.png)

7. Open up the files in a web browser and view the image:
![Images/journey.png](/Cost/200_cost_journey/Images/journey.png)

{{% notice tip %}}
You have successfully created your Well-Architected Cost Journeys.
You can configure the S3 bucket to serve web pages to easily distribute the journeys across your organization.
{{% /notice %}}



{{< prev_next_button link_prev_url="../1_pricing_sources/" link_next_url="../3_tear_down/" />}}
