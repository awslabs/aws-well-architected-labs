---
title: "Lab Prerequisites"
date: 2020-04-24T11:16:09-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

#### Prerequisite:
You must have configured a Cost and Usage Report in the [AWS Account Setup]({{< ref "/Cost/100_Labs/100_1_AWS_Account_Setup/3_cur" >}}) lab, it can take up to 24 hours for AWS to deliver the first report to your Amazon S3 bucket.

#### Verify CUR delivery

Verify the CUR files are being delivered and if they are in the correct format.

1. Log into the management/payer account AWS console via SSO.

2. Open the [S3 service page](https://s3.console.aws.amazon.com/) and select the bucket name that contains your Cost and Usage Report (CUR) files.
![Images/1.0-SelectBucket.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/1.0-SelectBucket.png?classes=lab_picture_small)

3. You should see a "aws-programmatic-access-test-object" which was put there to verify AWS can deliver reports and folder _(also known in S3 as a prefix)_ with the same name you selected as your CUR prefix. You selected this prefix when you setup your Cost and Usage Report. **Click** on the folder/prefix name to continue (here the prefix is **CUR**):
![Images/1.1-SelectPrefix.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/1.1-SelectPrefix.png?classes=lab_picture_small)

4. The next folder/prefix you see will have the same name you used for your Cost and Usage Report. **Select** the folder/prefix to access your CUR files (here it is **LabsCUR**):
![Images/1.2-SelectCURName.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/1.2-SelectCURName.png?classes=lab_picture_small)

5. You will now see the dated folders that contain the manifest files and the YML file we will use in the next step to setup a Glue Crawler. You will also see the folder that contains your cost and usage parquet files, here it is named **LabsCUR**. **Click** on the folder/prefix and then drill down into the current year and month:
![Images/1.3-ManifestFiles.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/1.3-ManifestFiles.png?classes=lab_picture_small)

6. You can see the delivered CUR file, verify that it is in the **parquet** format:
![Images/1.4-ParquetFile.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/1.4-ParquetFile.png?classes=lab_picture_small)

**You have successfully verified that you have access to the CUR files, and they are being delivered in the correct format.**

{{% notice note %}}
If you are doing this lab as part of a workshop, or do not have substantial or interesting usage in your existing CUR, select the **CUR Sample Data** link below to expand instructions to create an Amazon S3 bucket with sample CUR files.
{{% /notice %}}

{{%expand "CUR Sample Data" %}}

1. Follow the Amazon Simple Storage Service [documentation page](https://docs.aws.amazon.com/AmazonS3/latest/userguide/create-bucket-overview.html) to create an S3 bucket.
2. Select your new S3 bucket and click the **Create folder** button, enter `CUR` for your folder name, and click **Create folder**.
3. Click on your new `CUR` folder to enter it, and follow the same process to create further folders until you have a folder structure which resembles **(bucket name)/CUR/LabsCUR/LabsCUR/**.

![Images/1.5-CURDirectoryStructure.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/1.5-CURDirectoryStructure.png?classes=lab_picture_small)

4. Download the zip file below to your local hard drive, it contains the sample CUR data:

- [CUR Sample Data](/Cost/200_Automated_CUR_Updates_and_Ingestion/Code/CUR-Sample.zip)

5. Unzip the file. You should see a folder named "year=2018". You will now upload this folder and all of its contents into the last "LabsCUR" (lowest level) folder you created in Step 3.
6. From the lowest level "LabsCUR" folder select the **Upload** button then select the **Add folder** button and select the "year=2018" folder. Select **Upload** from the popup and then the **Upload** button again at the bottom of the page. Wait until the upload indicator says "Upload succeeded" and then select the **Close** button.
7. You should now see the "year=2018" folder in your "LabsCUR" folder.

![Images/1.6-CURUploaded.png](/Cost/200_Automated_CUR_Updates_and_Ingestion/Images/1.6-CURUploaded.png?classes=lab_picture_small)

**You have now successfully uploaded the necessary files for the workshop**

{{% /expand%}}

{{< prev_next_button link_prev_url="../" link_next_url="../2_setup_athena/" />}}
