+++
title = "S3 Access"
date =  2021-05-11T11:43:28-04:00
weight = 1
+++

### Allow Amazon S3 Public Acess

Our application employs AWS Simple Storage Service (S3) Static website hosting. To make the application available to Internet users, we must disable the AWS account policy that blocks public access.

1.1 Click [S3](https://us-east-1.console.aws.amazon.com/s3/home?region=us-east-1#/) to navigate to the dashboard.

1.2 Click **Block Public Access settings for this account**.

{{< img pr-1.png >}}

1.3 If you see that "Block all public access" is "On," then click on the "Edit" button to get to the next screen.

{{< img pr-2.png >}}

1.4 Uncheck "Block all public access," including any child selections. Click the "Save Changes" button. You will be required to confirm the changes.

{{< img pr-3.png >}}

1.5 Enter `confirm` and click the **Confirm** button.

{{< img pr-4.png >}}

{{< img pr-5.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../primary-region/" />}}
