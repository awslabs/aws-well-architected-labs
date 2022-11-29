+++
title = "Configure Reverse Proxy"
date =  2021-05-11T11:43:28-04:00
weight = 4
+++

For our lab, we’re going to set up a simulated endpoint for our application. As the Unishop front-end is currently served from S3, we’re going to set up a reverse proxy on the EC2 instances in our primary and secondary regions, and configure an internet-facing ALB to serve the content. 

Each of our regions represents a cell, and the ALB is the entry point of our application in each, which we’ll use in later steps when we configure Route 53.

### Primary Region

1.1 Click [EC2 Instances](https://us-east-1.console.aws.amazon.com/ec2/home?region=us-east-1#Instances:instanceState=running) to navigate to the Amazon EC2 dashboard in the **N. Virginia (us-east-1)** region.

Select the instance named **“hot-primary”**, and click the **“Connect”** button at the top of the screen.

{{< img primary-step-1.png >}}

1.2 Connect to the instance using the Session Manager tab.

{{< img primary-step-2.png >}}

1.3 Once the Systems Manager Session Manager tab opens, paste the following into the console to install nginx:

```
sudo amazon-linux-extras install nginx1 -y

sudo systemctl enable nginx
```

Once the installation completes, we’ll edit the config file to include a directive to set up a reverse proxy to the Amazon S3 website endpoint. 

Paste the following into the console to edit the nginx config file at ```/etc/nginx/nginx.conf``` using **vim** (or your favourite editor):

```
sudo vim /etc/nginx/nginx.conf
```

We’ll need to set the nginx server to listen on TCP port 8080 rather than the default HTTP port 80, as the unicorn shop back-end application is running on port 80 already. Find the first server section, it looks like this:

```
 server {
        listen       80;
        listen       [::]:80;
```

Then, update (by hitting “i” to enter insert mode in **vim**) the nginx server to listen on 8080 on both lines like so:

```
 server {
        listen       8080;
        listen       [::]:8080;
```

1.4 Next, we’ll set up the reverse proxy directive. Immediately under the port configuration, insert a `proxy_pass` directive, using the primary region S3 website endpoint. Replace **YOUR_ PRIMARY_ S3_ WEBSITE_HERE** with the URL you obtained from the primary region CloudFormation stack outputs, and remember to include the final semi-colon:

```
    server {
        listen       8080;
        listen       [::]:8080;
        location / {
                proxy_pass http://YOUR_PRIMARY_S3_WEBSITE_HERE;
        }
```

Now, save and exit the editor (ESC then “:wq” to save and exit **vim**).

Next, we’ll start nginx and make it re-load the config file to check for any errors. Back in the console terminal command line, paste in:

```
sudo nginx -s reload
sudo systemctl start nginx
```

Verify that the nginx reverse proxy is up and running with **curl**:

```
curl localhost:8080
```

You should see the Unishop front-end application HTML returned to you from the S3 website endpoint in the primary region, **N. Virginia (us-east-1)**. 

### Secondary Region

Next, we’ll repeat the process for the secondary region.

2.1 Click [EC2 Instances](https://us-west-1.console.aws.amazon.com/ec2/home?region=us-west-1#Instances:instanceState=running) to navigate to the Amazon EC2 dashboard in the **N. California (us-west-1)** region.

Select the instance named **"hot-secondary”**, and click the **“Connect”** button at the top of the screen.

{{< img secondary-step-1.png >}}

2.2 Connect to the instance as per step 1.2 above.

2.3 Install and configure nginx as per step 1.3 above.

2.4 Next, we’ll set up the reverse proxy directive, but this time, to point at the secondary region. Immediately under the port configuration, insert a `proxy_pass` directive, using the secondary region S3 website endpoint. Replace **YOUR_ SECONDARY_ S3_ WEBSITE_HERE** with the URL you obtained from the secondary region CloudFormation stack outputs, and remember to include the final semi-colon:

```
    server {
        listen       8080;
        listen       [::]:8080;
        location / {
                proxy_pass http://YOUR_SECONDARY_S3_WEBSITE_HERE;
        }
```

Now, save and exit the editor (ESC then “:wq” to save and exit **vim**).

Next, we’ll start nginx and make it re-load the config file to check for any errors. Back in the console terminal command line, paste in:

```
sudo nginx -s reload
sudo systemctl start nginx
```

Verify that the nginx reverse proxy is up and running with **curl**:

```
curl localhost:8080
```

You should see the Unishop front-end application HTML returned to you from the S3 website endpoint in the secondary region, **N. California (us-west-1)**. 




{{< prev_next_button link_prev_url="../3-verify-websites/" link_next_url="../5-alb/" />}}

