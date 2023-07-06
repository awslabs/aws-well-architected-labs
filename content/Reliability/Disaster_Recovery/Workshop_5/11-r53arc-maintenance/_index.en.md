+++
title = "Maintenance Mode"
date =  2021-05-11T11:43:28-04:00
weight = 11
+++

For the final part of this lab, we’re going to demonstrate the Maintenance routing in action. 

1. Click [R53 ARC Clusters](https://us-west-2.console.aws.amazon.com/route53recovery/home#/recovery-control/clusters) to navigate to the Route 53 Application Recovery Controller Clusters page.

Select your cluster and navigate to the **DefaultControlPanel**. Select the **Maintenance** and **Application** routing controls and click **Change routing control states**. Remember that we need to update both together, or enable the **Maintenance** control before disabling the **Application** routing control because of our safety rules. Update the traffic routing, setting **Application** to **Off** and **Maintenance** to **On**, confirm the changes and click **Change traffic routing**:

{{< img step-1.png >}}

This should succeed as we are complying with both of our safety rule assertions. **"AtLeastOneEndpoint”** is satisfied as both the **Maintenance** and **CellWest** routing controls are **On**, and **"MaintenanceORApplication"** is satisfied as the **Maintenance** routing control is **On** while the **Application** routing control is now **Off**.

2. Return to your **N. Virginia (us-east-1)** EC2 Session Manager console browser tab. Using **curl**, try to download the **shop.unicorns.magic** URL:

```
curl -v -H "Host: www.example.com" http://shop.unicorns.magic
```

This will return something like this:

```
sh-4.2$ curl -v -H "Host: www.example.com" http://shop.unicorns.magic
*   Trying 93.184.216.34:80...
* Connected to shop.unicorns.magic (93.184.216.34) port 80 (#0)
> GET / HTTP/1.1
> Host: www.example.com
> User-Agent: curl/7.79.1
> Accept: */*

...

<!doctype html>
<html>
<head>
    <title>Example Domain</title>

...

<body>
<div>
    <h1>Example Domain</h1>
    <p>This domain is for use in illustrative examples in documents. You may use this
    domain in literature without prior coordination or asking for permission.</p>
    <p><a href="https://www.iana.org/domains/example">More information...</a></p>
</div>
</body>
</html>
```

Because we used **www.example.com** as a maintenance page for convenience, we needed to provide the **”Host: “** HTTP header so that the HTTP server for **www.example.com** could serve the page, otherwise it would return an HTTP 404 error.

{{% notice note %}}

This illustrates an important consideration. Your maintenance page should be as robust as possible. If, as in this case, it is served from an HTTP endpoint that requires the HTTP **“Host: ”** header to be provided, this may not work as expected. Bear in mind that S3 static website endpoints also require the bucket name to match the URL prefix. Learn more by reviewing the [documentation for S3 Virtual Hosting here](https://docs.aws.amazon.com/AmazonS3/latest/userguide/VirtualHosting.html).

Construction of your catch-all, or maintenance page is beyond the scope of this lab. But bear in mind the considerations outlined above as you build the right strategy for your application.

{{% /notice %}}


Next, confirm you see the same result in your **N. California (us-west-1)** EC2 Session Manager browser tab console. Finally, we’ll confirm that the routing controls are working as expected using **dig**:

```
dig shop.unicorns.magic
```

This will return something like this:

```
sh-4.2$ dig shop.unicorns.magic

; <<>> DiG 9.11.4-P2-RedHat-9.11.4-26.P2.amzn2.5.2 <<>> shop.unicorns.magic
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 15423
;; flags: qr rd ra; QUERY: 1, ANSWER: 2, AUTHORITY: 0, ADDITIONAL: 1

;; OPT PSEUDOSECTION:
; EDNS: version: 0, flags:; udp: 4096
;; QUESTION SECTION:
;shop.unicorns.magic.           IN      A

;; ANSWER SECTION:
shop.unicorns.magic.    60      IN      CNAME   www.example.com.
www.example.com.        300     IN      A       93.184.216.34

;; Query time: 1 msec
;; SERVER: 10.0.0.2#53(10.0.0.2)
;; WHEN: Tue Nov 01 08:59:37 UTC 2022
;; MSG SIZE  rcvd: 93
```

Note that the **“ANSWER SECTION”** shows the resolution of **shop.unicorns.magic** to **www.example.com**, which in turn agrees with the IP address we saw our curl query connect to, in this case 93.184.216.34.

Congratulations! You have now completed this lab.

Please proceed to complete the cleanup steps for this lab.


{{< prev_next_button link_prev_url="../10-r53-failures/" link_next_url="../12-cleanup/" />}}

