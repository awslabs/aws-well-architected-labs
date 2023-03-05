---
title: "Create an Amazon S3 bucket and upload your dataset"
date: 2023-01-24T09:16:09-04:00
chapter: false
weight: 3
pre: "<b>Step 1: </b>"
---

Before starting you will create: 
- an Amazon S3 bucket to store the resources used and created in the lab
- an IAM role to give AWS Glue permissions to access our bucket. 

#### 1. Create an Amazon S3 bucket and upload your dataset

**1.1.** Open Amazon S3 console. You can use the search bar or click on the **Services** link in the upper left-hand corner of the screen to bring up the services menu. Under the "Storage" heading select **S3** or open the Amazon S3 console [here](https://console.aws.amazon.com/s3).

**1.2.** Click the **Create Bucket** button. You will be taken to the *"Create bucket"* page to begin setting up your bucket.

- Enter a name in the *"Bucket name"* field. The bucket name you choose must be __unique__ across all existing bucket names in Amazon S3. One way can make your bucket name unique is by prefixing your bucket name with your initials and your organization's name. e.g. `[your initials]-[your org]-module1-lab`

- In the **Region** drop-down list select the same region where you want to deploy the lab. Make sure [AWS Glue](https://aws.amazon.com/es/glue/) is available in the region by checking [AWS Regional Services List](https://aws.amazon.com/about-aws/global-infrastructure/regional-product-services/)). This module `eu-central-1 (Frankfurt)`.

- The next section is **"Block Public Access settings for this bucket"**. You will be working with a private bucket so leave *__Block all public access__* checked.

- You can leave the rest of the settings as default and click on the **Create bucket**. button.
  ![Bucket Details](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/2_BucketDetails.jpg)

**1.3.** You will now be back on the page showing all your S3 buckets, click on the name of the bucket you just created. 
![Bucket List](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/3_BucketList.jpg)

You should now be on your bucket's overview page. Your bucket should show "Objects (0)" as you don't have any object yet. 
- Click on **Create folder** to create a folder for your dataset.
![Create Folder](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/4_CreateFolder.png)

- Give a name to your folder, such as `csv` and click **Create folder**:
![Create Folder 2](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/4_NameFolder.png)


**1.4.** Let's upload the dataset to the folder. In your new bucket's overview page, click on the folder you just created and then *Upload* under the "Objects" tab.
![Upload dataset](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/4_Upload.png)

Then click on the **Add Files** button to select your files for upload. Upload the dataset file SaaS-Sales.cvs from your device. After you have selected the file, click on the "Upload" dialogue.
![Add Files](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/5_AddFiles.png)

**1.5.** When the upload is complete you should see "Upload succeeded". Click on *Close* to return to the bucket overview page.

**1.6.** In your new bucket overview page, you already have information about the object uploaded. You can see:
* The type of object: **.csv**
* The Size in MB: **1.6MB**
* The storage class: **Amazon S3 Standard**
![Object Details](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/6_2_ObjectProperties.png)

**1.7.** Select the dataset and copy its S3 URI, you will use it later (ex: `s3://[YOUR_BUCKET_NAME]/csv/SaaS-Sales.csv`)
![Object URI](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/6_1_ObjectURI.png)


**Click on *Next Step* to continue to the next module.**

{{< prev_next_button link_prev_url="../" link_next_url="../2_create_role" />}}
