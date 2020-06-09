---
title: "Create Application Load Balancer with WAF integration"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>3. </b>"
weight: 3
---

Using the AWS Management Console, we will create an Application Load Balancer, link it to the AWS WAF
ACL we previously created and test.

### 3.1 Create Application Load Balancer

1. Open the Amazon EC2 console at https://console.aws.amazon.com/ec2/.
2. From the console dashboard, choose Load Balancers from the Load Balancing section.
3. Click Create Load Balancer.

![alb-create-load-balancer-1](/Security/200_Basic_EC2_with_WAF_Protection/Images/alb-create-load-balancer-1.png)

4. Click Create under the Application Load Balancer section.

![alb-create-load-balancer-2](/Security/200_Basic_EC2_with_WAF_Protection/Images/alb-create-load-balancer-2.png)

5. Enter Name for Application Load Balancer such as `lab-alb`. Select all availability zones in your region then click Next. You will need to click Next again to accept your load balancer is using insecure listener.

![alb-create-load-balancer-3](/Security/200_Basic_EC2_with_WAF_Protection/Images/alb-create-load-balancer-3.png)

6. Click Create a new security group and enter name and description such as `lab-alb` and accept default of open to internet.

![alb-create-load-balancer-4](/Security/200_Basic_EC2_with_WAF_Protection/Images/alb-create-load-balancer-4.png)

7. Accept defaults and enter Name such as `lab-alb` and click Next.

![alb-create-load-balancer-5](/Security/200_Basic_EC2_with_WAF_Protection/Images/alb-create-load-balancer-5.png)

8. From the list of instances click the check box and then Add to registered button. Then click Next.

![alb-create-load-balancer-6](/Security/200_Basic_EC2_with_WAF_Protection/Images/alb-create-load-balancer-6.png)

9. Review the details and click Create.

![alb-create-load-balancer-7](/Security/200_Basic_EC2_with_WAF_Protection/Images/alb-create-load-balancer-7.png)

10. A successful message should appear, click Close.
11. Take not of the DNS name under the Description tab, you will need this for testing.

### 3.2 Configure Application Load Balancer with WAF

1. Open the AWS WAF console at https://console.aws.amazon.com/waf/.
2. In the navigation pane, choose Web ACLs.

![waf-alb-1](/Security/200_Basic_EC2_with_WAF_Protection/Images/waf-alb-1.png)

3. Choose the web ACL that you want to associate with the Application Load Balancer.
4. On the Rules tab, under AWS resources using this web ACL, choose Add association.

![waf-alb-2](/Security/200_Basic_EC2_with_WAF_Protection/Images/waf-alb-2.png)

5. When prompted, use the Resource list to choose the Application Load Balancer that you want to associate this web ACL  such as `lab-alb` and click Add.

![waf-alb-3](/Security/200_Basic_EC2_with_WAF_Protection/Images/waf-alb-3.png)

6. The Application Load Balancer should now appear under resources using.

![waf-alb-4](/Security/200_Basic_EC2_with_WAF_Protection/Images/waf-alb-4.png)

7. You can now test access by entering the DNS name of your load balancer in a web browser.
