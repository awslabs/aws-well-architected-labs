+++
title = "Simulate Failure"
date =  2021-05-11T11:43:28-04:00
weight = 10
+++

Now that we’ve seen how traffic is routing through our application, we’re going to simulate a failure by blocking public access for one of the S3 website bucket endpoints. To set up an S3 bucket to host a static website like our unicorn shop frontend application, we need to enable public access on the bucket. You would have already set this up as part of the pre-requisites for this lab (or this may have been done for you), and validated the configuration when you tested the S3 website endpoints.

We’re going to disable public access on the S3 bucket hosting our unicorn shop application frontend to simulate a failure. This means that the website will no longer be available, which in turn, should cause our Route 53 health check to fail, which should then cause the readiness check to fail. Let’s get started!

1. Navigate to the Amazon S3 console, and select the bucket with the name starting with **“hot-primary-uibucket-”**. Select the **Permissions** tab, and on the **“Block Public Access (bucket settings)”** section, click **Edit**. Block all public access and click **Save changes**:

{{< img step-1.png >}}

2. Then, return to the Route 53 Application Recovery Controller, select the **View by cell** tab, and check the readiness check for our East cell, and note that the S3 website readiness check shows **“Not ready”** as the Route 53 health check has failed.

You may have to click refresh and wait for the health checks to update. Route 53 aggregates data from multiple health checkers in multiple region to determine if an endpoint is healthy or not. Each health check requires a number of consecutive health checks to succeed (based on the threshold value you configured), to ensure that transient network events don’t affect the determination:

{{< img step-2a.png >}}

Return to the Readiness check page and note that the **“Not ready”** state has propagated up to the recovery group. From the top level, you can monitor the readiness for your recovery groups. If any cell is not ready, the recovery group is likewise not ready too:

{{< img step-2b.png >}}

You can explore the cells to see which resource and readiness check has failed. This allows you to identify which cells are ready and able to accept traffic, and which cells need to have traffic directed away from them: 

{{< img step-2c.png >}}

3. Now that we’ve detected a failure, we need to update the routing controls to direct traffic away from our **East** cell that’s not ready to receive traffic, and towards our **West** cell that remains ready.

Navigate to your **DefaultControlPanel** in your Route 53 Application Recovery Controller cluster, select the **CellEast** routing control, and click **Change routing control states**. In the next dialog, turn the **CellEast** routing control state to **Off**, confirm the change, and click **Change traffic routing**:

{{< img step-3a.png >}}

This should result in a failure:

{{< img step-3b.png >}}

Reading the red error banner at the top of the page, you will see that the **AtLeastOneEndpoint** safety rule has prevented this update, as otherwise we’d fail open, as neither the **Maintenance** nor the **CellWest** routing controls are active, and able to accept traffic in this configuration. 

Instead, we’ll turn on the **CellWest** routing control at the same time. Select both the **CellWest** and **CellEast** routing controls, and click **Change routing control states** again. Set **CellWest** to **On** and **CellEast** to **Off**, confirm, and click **Change traffic routing**: 

{{< img step-3c.png >}}

This time you’ll see it succeeds, as the requested update satisfies the assertion from our **AtLeastOneEndpoint** safety rule. We are now routing traffic away from our **East** cell to our **West** cell, which remains healthy and ready to accept traffic.

4. Return to your **N. Virginia (us-east-1)** EC2 instance Session Manager browser tab, and let’s confirm that it’s working as expected. Using **curl**, we’ll again download the first 600 bytes from the **shop.unicorns.magic** URL:

```
curl -r 0-600 http://shop.unicorns.magic
```

You should see the same result as last time, but this time the unicorn shop application content is being served from our secondary **N. California (us-west-1)** endpoint:

```
sh-4.2$ curl -r 0-600 http://shop.unicorns.magic
<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>The Unicorn Shop</title>

    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
    <link href="https://fonts.googleapis.com/css?family=Sacramento&display=swap" rel="stylesheet">
    <link href="css/freelancer.css" rel="stylesheet">
    <link href="fontawesome-free/css/all.css" rel="stylesheet">


</head>
```

Confirm that the DNS records have been updated using **dig**:

```
dig shop.unicorns.magic
```

And you should see something like this:

```
sh-4.2$ dig shop.unicorns.magic

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.amzn2.5.2 <<>> shop.unicorns.magic
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 40437
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;shop.unicorns.magic.           IN      A

;; ANSWER SECTION:
shop.unicorns.magic.    60      IN      CNAME   application.unicorns.magic.
application.unicorns.magic. 60  IN      A       52.8.67.124
application.unicorns.magic. 60  IN      A       52.9.58.138

;; Query time: 2 msec
;; SERVER: 10.0.0.2#53(10.0.0.2)
;; WHEN: Tue Nov 01 08:11:46 UTC 2022
;; MSG SIZE  rcvd: 106
```

Note that the **application.unicorns.magic** IP addresses have changed. Let’s confirm that they belong to our ALB in **N. California (us-west-1)**. Return to your Route 53 browser tab, select the **Hosted zones** page from the left navigation pane, and go to the **unicorns.magic** private hosted zone. 

Copy the DNS name of the secondary **applications.unicorns.magic** record to your clipboard, which should begin with **”dualstack.hotsecondaryalb-“**. 

Now confirm that this does indeed resolve to the same IP addresses that you saw in your DNS query for **site.unicorns.magic”**. Return to your **N. Virginia (us-east-1)** EC2 instance, and perform a lookup on this DNS name, replacing the address with your secondary ALB DNS name:

```
dig dualstack.secondaryalb-YOUR_ALB_HERE
```

You should see something like this:

```
sh-4.2$ dig shop.unicorns.magic

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.amzn2.5.2 <<>> shop.unicorns.magic
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 40437
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;shop.unicorns.magic.           IN      A

;; ANSWER SECTION:
shop.unicorns.magic.    60      IN      CNAME   application.unicorns.magic.
application.unicorns.magic. 60  IN      A       52.8.67.124
application.unicorns.magic. 60  IN      A       52.9.58.138

;; Query time: 2 msec
;; SERVER: 10.0.0.2#53(10.0.0.2)
;; WHEN: Tue Nov 01 08:11:46 UTC 2022
;; MSG SIZE  rcvd: 106

sh-4.2$ dig dualstack.hotsecondaryalb-1243938485.us-west-1.elb.amazonaws.com.

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.amzn2.5.2 <<>> dualstack.hotsecondaryalb-1243938485.us-west-1.elb.amazonaws.com.
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 43573
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;dualstack.hotsecondaryalb-1243938485.us-west-1.elb.amazonaws.com. IN A

;; ANSWER SECTION:
dualstack.hotsecondaryalb-1243938485.us-west-1.elb.amazonaws.com. 60 IN A 52.8.67.124
dualstack.hotsecondaryalb-1243938485.us-west-1.elb.amazonaws.com. 60 IN A 52.9.58.138

;; Query time: 5 msec
;; SERVER: 10.0.0.2#53(10.0.0.2)
;; WHEN: Tue Nov 01 08:20:00 UTC 2022
;; MSG SIZE  rcvd: 125

sh-4.2$
```

Note that again, the IP addresses match for the secondary ALB in **N. California (us-west-1)** and **application.unicorns.magic**, in this case 52.8.67.124 and 52.9.58.138. We have successfully failed over to our secondary region as expected.

Finally, navigate to the Amazon S3 console, and select the bucket with the name starting with **“hot-primary-uibucket-”**. Select the Permissions tab, and restore all public access and click Save changes. Then you’re ready to proceed to the next section.

{{< prev_next_button link_prev_url="../9-r53-using/" link_next_url="../11-r53arc-maintenance/" />}}

