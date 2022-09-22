---
title: "Prerequisites: QuickSight"
date: 2020-07-26T11:16:08-04:00
chapter: false
weight: 
pre: "<b>1b. </b>"
---


### Enable QuickSight 
QuickSight is the AWS Business Intelligence tool that will allow you to not only view the Standard AWS provided insights into all of your accounts, but will also allow to produce new versions of the Dashboards we provide or create something entirely customized to you. If you are already a regular QuickSight user you can skip these steps and move on to the next step. If not, complete the steps below.

{{%expand "Click here - to setup QuickSight" %}}
#### Enable QuickSight:

1. Log into your AWS Account and search for **QuickSight** in the list of Services

1. You will be asked to **sign up** before you will be able to use it

    ![QuickSight Sign up Workflow Image](https://wellarchitectedlabs.com/Cost/200_Cloud_Intelligence/Images/QS-signup.png?classes=lab_picture_small)

1. After pressing the **Sign up** button you will be presented with 2 options, please ensure you select the **Enterprise Edition** during this step

1. Select **continue** and you will need to fill in a series of options in order to finish creating your account. 

    + Ensure you select the region that is most appropriate based on where your S3 Bucket is located containing your Cost & Usage Report file.

        ![Select Region and Amazon S3 Discovery](/Cost/200_Cloud_Intelligence/Images/QS-s3.png?classes=lab_picture_small)
    
    + Enable the Amazon S3 option and select the bucket where your **Cost & Usage Report** is stored, as well as your **Athena** query bucket

        ![Image of s3 buckets that are linked to the QuickSight account. Enable bucket and give Athena Write permission to it.](/Cost/200_Cloud_Intelligence/Images/QS-bucket.png?classes=lab_picture_small)

1. Click **Finish** and wait for the congratulations screen to display

1. Click **Go to Amazon QuickSight**

![](/Cost/200_Cloud_Intelligence/Images/Congrats-QS.png?classes=lab_picture_small)
{{% /expand%}}



{{< prev_next_button link_prev_url="../1a_cur_setup" link_next_url="../2_deploy_dashboards" />}}
