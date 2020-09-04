---
title: "Generate Logs"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 5
pre: "<b>5. </b>"
---

In order to populate the logs you are collecting, you need to interact with the deployed website. The Apache web server service being used to host your website generates access logs. In the following steps, you will visit the website to generate these access logs.

1. Go to the [CloudFormation console](https://console.aws.amazon.com/cloudformation/).
2. Select the stack you deployed for this lab, called `security-cw-lab`.
3. Click on **Outputs**, then click on **WebsiteURL**.
4. Refresh the page a few time to generate some activity on your website.
5. Repeat steps 1-4, but add `/example` to the end of the website url. This will generate a 404 error, which is expected.

Generating these access logs will allow you to explore the ways in which you can inspect and view these logs, as shown in the following sections of this lab.

{{< prev_next_button link_prev_url="../4_start_cw_agent/" link_next_url="../6_view_cw_logs/" />}}
