---
title: "Tear down"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 2
pre: "<b>2. </b>"
---

The following instructions will remove the certificate you have created.

1. Sign into the AWS Management Console and open the ACM console at [https://console.aws.amazon.com/acm/home](https://console.aws.amazon.com/acm/home). Select the region where you created the certificate.
2. Click the check box for the domain name of the certificate to delete. Click **Actions** then **Delete**.
3. Verify this is the certificate to delete and click **Delete**.
    **Note:** You cannot delete an ACM Certificate that is being used by another AWS service. To delete a certificate that is in use, you must first remove the certificate association.

## References & useful resources

* [AWS Certificate Manager](https://docs.aws.amazon.com/en_pv/acm/latest/userguide/acm-overview.html)
* [Create an HTTPS Listener for Your Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html)
