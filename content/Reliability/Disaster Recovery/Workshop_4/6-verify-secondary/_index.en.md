+++
title = "Verify Failover"
date =  2021-05-11T11:43:28-04:00
weight = 6
+++

Your Amazon S3 bucket that hosts the Hot-Primary website is now inaccessible.  When CloudFront attempts to route the user’s request to the primary region, it will receive an HTTP 403 status error (Forbidden) just like we did.  The CloudFront Distribution will automatically handle this scenario by failing over to the Hot-Secondary region.

If you go back and refresh your browser (using the CloudFront Distribution’s Domain Name from before), you should now see **The Unicorn Shop - us-west-1** website. The user’s session should still be active, and their cart still contains the products previously added.

{{< img vf-1.png >}}

{{% notice note %}}
If you do not see us-west-1, this might be due to caching.  Please try doing a hard-page refresh (using CTRL+F5).
{{% /notice  %}}

{{< prev_next_button link_prev_url="../5-failover/5.2-ec2/" link_next_url="../7-cleanup/" />}}

