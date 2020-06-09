---
title: "Teardown"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>7. </b>"
weight: 7
---
1. Delete IAM role **Lambda_Auto_CUR_Delivery_Role** and policy **Lambda_Auto_CUR_Delivery_Access**
2. Delete Lambda function **Auto_CUR_Delivery**
3. Delete CloudWatch event **5_min_auto_cur_delivery**
4. Delete SES configuration
5. Delete S3 bucket for CUR query results storing
