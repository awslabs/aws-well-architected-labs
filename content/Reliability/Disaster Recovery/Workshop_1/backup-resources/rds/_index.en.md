+++
title = "RDS"
date =  2021-05-11T20:33:54-04:00
weight = 1
+++

### Backup the RDS database 

1.1 Click [AWS Backup](https://us-east-1.console.aws.amazon.com/backup/home?region=us-east-1#/) to navigate to the dashboard in the **N. Vriginia (us-east-1)** region.

1.2 Click the **Protected resources** link, then click the **Create an on-demand backup** button.

{{< img BK-22.png >}}

1.3 Select **RDS** as the **Resource type**, then select **unishopappv1dbbackupandrestore** as the **Database name**. Click the **Create on-demand backup** button.

{{< img BK-23.png >}}

{{< prev_next_button link_prev_url="../" link_next_url="../ec2/" />}}
