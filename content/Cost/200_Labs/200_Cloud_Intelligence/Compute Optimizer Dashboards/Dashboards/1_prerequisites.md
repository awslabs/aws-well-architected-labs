---
title: "Prerequisites"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

### 1/4 Enable AWS Compute Optimizer

To get right sizing recommendations you need to [Enroll all accounts to Compute Optmizer](https://docs.aws.amazon.com/compute-optimizer/latest/ug/getting-started.html#account-opt-in). You can use free version that provides recommendations based on 14 days of look-back period.


### 2/4 Install Compute Optimizer Data Collection

Before installing Dashboard please install Compute Optimizer module of **[Optimization Data Collection lab](https://wellarchitectedlabs.com/cost/300_labs/300_optimization_data_collection/)** - this provides an automated way to collect Compute Optimizer recommendations for all accounts in your AWS Organizations and AWS Regions.

### 3/4 Prepare Athena
If this is the first time you will be using Athena you will need to complete a few setup steps before you are able to create the views needed. If you are already a regular Athena user you can skip these steps and move on to the [Enable Quicksight](#enable-quicksight) section below.

To get Athena warmed up:

1. From the services list, choose **S3**

1. Create a new S3 bucket for Athena queries to be logged to. Keep to the same region as the S3 bucket created for your Compute Optimizer data created via Data Collection Lab.

1. From the services list, choose **Athena**

1. Select **Get Started** to enable Athena and start the basic configuration
    ![Image of Athena Query Editor](/Cost/200_Cloud_Intelligence/Images/Athena-GetStarted.png?classes=lab_picture_small)

1. At the top of this screen select **Before you run your first query, you need to set up a query result location in Amazon S3.**

    ![Image of Athena Query Editor](/Cost/200_Cloud_Intelligence/Images/Athena-S3.png?classes=lab_picture_small)

1. Validate your Athena primary workgroup has an output location by  
    - Open a new tab or window and navigate to the **Athena** console
    - Select **Workgroup: primary**
![Images/cf_dash_athena_2.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_2.png?classes=lab_picture_small)
    - Confirm your **Query result location** is configured with an S3 bucket path. 
        - If not configured, continue to setting up by clicking **Edit workgroup**
![Images/cf_dash_athena_4.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_4.png?classes=lab_picture_small)
    - Add the **S3 bucket path** you have selected for your Query result location and click save
![Images/cf_dash_athena_5.png](/Cost/200_Cloud_Intelligence/Images/cf_dash_athena_5.png?classes=lab_picture_small)


### 4/4 Enable QuickSight 
QuickSight is the AWS Business Intelligence tool that will allow you to not only view the Standard AWS provided insights into all of your accounts, but will also allow to produce new versions of the Dashboards we provide or create something entirely customized to you. If you are already a regular QuickSight user you can skip these steps.


1. Log into your AWS Account and search for **QuickSight** in the list of Services

1. You will be asked to **sign up** before you will be able to use it

    ![QuickSight Sign up Workflow Image](/Cost/200_Cloud_Intelligence/Images/QS-signup.png?classes=lab_picture_small)

1. After pressing the **Sign up** button you will be presented with 2 options, please ensure you select the **Enterprise Edition** during this step

1. Select **continue** and you will need to fill in a series of options in order to finish creating your account. 

    + Ensure you select the region that is most appropriate based on where your S3 Bucket is located containing your CO report files.

        ![Select Region and Amazon S3 Discovery](/Cost/200_Cloud_Intelligence/Images/QS-s3.png?classes=lab_picture_small)
    
    + Enable the Amazon S3 option and select the bucket where your Compute Optimizer data created via Data Collection Lab are located

        ![Image of s3 buckets that are linked to the QuickSight account. Enable bucket and give Athena Write permission to it.](/Cost/200_Cloud_Intelligence/Images/QS-s3-bucket-cod.png?classes=lab_picture_small)

1. Click **Finish** & wait for the congratulations screen to display

1. Click **Go to Amazon QuickSight**

    ![Image](/Cost/200_Cloud_Intelligence/Images/QS-Congrats.png?classes=lab_picture_small)

1. Check you have **Amazon QuickSight Enterprise Edition**

    ![Image](/Cost/200_Cloud_Intelligence/Images/QS-enterprise.png?classes=lab_picture_small)


{{< prev_next_button link_prev_url="../../" link_next_url="../2_deployment/" />}}
