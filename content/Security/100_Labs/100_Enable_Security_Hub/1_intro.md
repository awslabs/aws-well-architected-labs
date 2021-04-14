---
title: "Enable AWS Security Hub"
date: 2020-09-16T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

## Table of Contents

1. [Getting Started](#getting_Started)

## 1. Getting Started {#getting_Started}

The AWS console provides a graphical user interface to search and work with the AWS services.
We will use the AWS console to enable AWS Security Hub.

### 1.1 Enable AWS Config

AWS Security Hub requires [AWS Config](https://aws.amazon.com/config/) to run within your account. 

If you have not enabled **AWS Config**, we'll need to enable that now. If it's already enabled in your account, you can skip to the next step. Navigate to the AWS Config [console](https://console.aws.amazon.com/config/) and select **1-click setup** and then select **Confirm**.

![enable-aws-config](/Security/100_Enable_Security_Hub/Images/enable-aws-config.png)

Once successful, you'll see this **Welcome to AWS Config** page.
![aws-config-success](/Security/100_Enable_Security_Hub/Images/aws-config-success.png)

### 1.2 AWS Security Hub

Once you have logged into your AWS account and enabled AWS Config, we need to enable Security Hub. Navigate to the AWS Security Hub [console](https://console.aws.amazon.com/securityhub/).

Alternatively, you can just search for *Security Hub* and select the service.
![search-for-security-hub](/Security/100_Enable_Security_Hub/Images/search-for-security-hub.png)


### 1.3 Enable AWS Security Hub

In the *AWS Security Hub* service console you can click on the **Go to Security Hub** orange button to navigate to AWS Security Hub in your account.

![go-to-security-hub](/Security/100_Enable_Security_Hub/Images/go-to-security-hub.png)

Additional information is provided regarding **Security standards** and **AWS Integrations**. You can read more [here](https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-internal-providers.html). Now select **Enable Security Hub**.

![enable-security-hub](/Security/100_Enable_Security_Hub/Images/enable-security-hub.png)

### 1.4 Explore AWS Security Hub

> **NOTE:** Because **Security Hub** is a Regional service, the checks performed for this control only apply to the current Region for the account. It must be enabled separately for each region. 

With AWS Security Hub now enabled in your account, you can explore the security insights AWS Security Hub offers.
![explore-aws-security-hub](/Security/100_Enable_Security_Hub/Images/explore-aws-security-hub.png)

Once you enable, it may take up to two hours or more to see results from the security checks. You might see this banner below.
![after-security-hub-enable](/Security/100_Enable_Security_Hub/Images/after-security-hub-enable.png)

If you forgot to enable AWS Config, you might see this banner.
![aws-config-error](/Security/100_Enable_Security_Hub/Images/aws-config-error.png)