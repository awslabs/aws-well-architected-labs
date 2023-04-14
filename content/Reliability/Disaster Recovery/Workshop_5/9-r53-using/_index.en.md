+++
title = "Controlling Traffic"
date =  2021-05-11T11:43:28-04:00
weight = 9
+++

We’ve set up the Route 53 private hosted zones for our unicorn shop single page application. Now we need to activate the routing controls to start routing traffic to the Application Load Balancers that will simulate our application cell’s endpoints.

1. Click [Route 53 ARC clusters](https://us-west-2.console.aws.amazon.com/route53recovery/home#/recovery-control/clusters) to navigate back to routing control clusters page.

And then select your cluster and **DefaultControlPanel** to get started. Select the **CellEast** and **Application routing controls**, and click **Change routing control states**. 

{{< img step-0a.png >}}


Turn them both to **on** in the following dialog, confirm the routing change, and click **Change traffic routing**:

{{< img step-1a.png >}}

The routing controls now should look like this:

{{< img step-1b.png >}}

2. With the **Application** routing control on, the Route 53 private hosted zone CNAME record that routes traffic for the **shop.unicorns.magic** subdomain to the **application.unicorns.magic** domain will be activated. In turn, the **CellEast** routing control activates the Alias A record pointing from **application.unicorns.magic** to the Application Load Balancer in our primary region, **N. Virginia (us-east-1)**, will be activated. This means that any traffic hitting the “front-door” should result in the unicorn shop front-end application being served.

Let’s test this out. Open a new browser tab, and click [Running EC2 instances in **N. California (us-west-1)**](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#Instances:instanceState=running) to navigate to the EC2 instances in **N. California (us-west-1)**.  

Select the **hot-secondary** instance, and click **Connect**, and start a **Session Manager** connection to your instance.

Open another browser tab, and click [Running EC2 instances in **N. Virginia (us-east-1)**](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:instanceState=running) to navigate to your EC2 instance in **N. Virginia (us-east-1)**. 

Start a **Session Manager** connection to your **hot-primary** instance in the same way.

You will now have two consoles, one to the EC2 instance in your **East** cell and one in your **West** cell. Take note of which is which. You can easily tell by the URL in the Session Manager browser session, the first part of the URL is the region.

In your **N. Virginia (us-east-1)** EC2 instance, check that you can resolve and be served the unicorn shop application by using **curl** to download the first 600 bytes of the page from the **shop.unicorns.magic** URL:

```
curl -r 0-600 http://shop.unicorns.magic
```

You should see this result:

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

Next, switch to your **N. California (us-west-1)** EC2 instance tab and repeat the steps, and you should obtain the same result. 

At this stage, it looks like whether we’re in **N. Virginia (us-east-1)** or **N. California (us-west-1)**, we are able to download the same content. In our browser, if you recall from Module 4, we can see the region the site is served from at the top of the page:

{{< img step-2a.png >}}

However, using **curl**, we can’t see this, as this region text is updated by code running in the browser, and the unicorn shop frontend application content is the same in each region. So how can we be sure?

Let’s instead look at the result of the Route 53 private hosted zone DNS queries using **dig**. In your **N. Virginia (us-east-1)** EC2 console, paste in the following to make a DNS query for the **shop.unicorns.magic** URL:

```
dig shop.unicorns.magic
```

This will return something like this:

```
sh-4.2$ dig shop.unicorns.magic

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.amzn2.5.2 <<>> shop.unicorns.magic
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 50978
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;shop.unicorns.magic.           IN      A

;; ANSWER SECTION:
shop.unicorns.magic.    60      IN      CNAME   application.unicorns.magic.
application.unicorns.magic. 60  IN      A       54.205.37.6
application.unicorns.magic. 60  IN      A       3.209.182.71

;; Query time: 2 msec
;; SERVER: 10.0.0.2#53(10.0.0.2)
;; WHEN: Tue Nov 01 07:17:47 UTC 2022
;; MSG SIZE  rcvd: 106

sh-4.2$
```

Take a look at the **“ANSWER SECTION”**. You can see that the query has obtained the CNAME record for **application.unicorns.magic**, which again resolves to the two A-records for our Application Load Balancer in **us-east-1*.

If you repeat the process in your **N. California (us-west-1)** EC2 console, you should see the same results. 

Next, we’ll confirm that the **application.unicorns.magic** record from Route 53 does actually point to our primary ALB. Switch back to the Route 53 console tab in your browser. Take note of the **“Value/Route traffic to”** entry in the **Primary** record for **application.unicorns.magic**, starting with **“dualstack.primaryalb-”**, and copy this address to your clipboard:

{{< img step-2b.png >}}

Return to your **N. Virginia (us-east-1)** EC2 instance, and perform a lookup on this DNS name, replacing the address with your primary ALB DNS name:

```
dig dualstack.primaryalb-YOUR_ALB_HERE
```

You should see something like this:

```
sh-4.2$ dig shop.unicorns.magic

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.amzn2.5.2 <<>> shop.unicorns.magic
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 47852
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;shop.unicorns.magic.           IN      A

;; ANSWER SECTION:
shop.unicorns.magic.    60      IN      CNAME   application.unicorns.magic.
application.unicorns.magic. 60  IN      A       3.209.182.71
application.unicorns.magic. 60  IN      A       54.205.37.6

;; Query time: 3 msec
;; SERVER: 10.0.0.2#53(10.0.0.2)
;; WHEN: Tue Nov 01 07:30:11 UTC 2022
;; MSG SIZE  rcvd: 106

sh-4.2$ dig dualstack.primaryalb-1570981327.us-east-1.elb.amazonaws.com.

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.amzn2.5.2 <<>> dualstack.primaryalb-1570981327.us-east-1.elb.amazonaws.com.
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 58526
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;dualstack.primaryalb-1570981327.us-east-1.elb.amazonaws.com. IN        A

;; ANSWER SECTION:
dualstack.primaryalb-1570981327.us-east-1.elb.amazonaws.com. 60 IN A 3.209.182.71
dualstack.primaryalb-1570981327.us-east-1.elb.amazonaws.com. 60 IN A 54.205.37.6

;; Query time: 2 msec
;; SERVER: 10.0.0.2#53(10.0.0.2)
;; WHEN: Tue Nov 01 07:30:16 UTC 2022
;; MSG SIZE  rcvd: 120

sh-4.2$ 
```

Note that the IP addresses returned for the **N. Virginia (us-east-1)** ALB match those in the original query for **application.unicorns.magic**, in the case above, 3.209.182.71 and 54.205.37.6.

Repeat the process in your **N. California (us-west-1)** EC2 instance, and confirm that you get the same result. This demonstrates that both regions are receiving the unicorn shop frontend application content from the primary endpoint in **N. Virginia (us-east-1)**.

{{< prev_next_button link_prev_url="../8-r53-zone/" link_next_url="../10-r53-failures/" />}}

