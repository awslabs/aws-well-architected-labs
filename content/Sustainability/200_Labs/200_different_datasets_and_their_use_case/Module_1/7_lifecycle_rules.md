---
title: "Automate data deletion"
date: 2023-01-24T09:16:09-04:00
chapter: false
weight: 7
pre: "<b>Step 7: </b>"
---

One of the best practices when talking about data patterns in the Sustainability Pillar of the Well Architected Framework is to [Use lifecycle policies to delete unnecessary data](https://docs.aws.amazon.com/wellarchitected/latest/sustainability-pillar/sus_sus_data_a4.html).

Managing the lifecycle of all your data and automatically enforce deletion timelines allows you minimize the total storage requirements of your workload. This means:

- Define lifecycle policies for all your data
- Set automated lifecycle policies to enforce lifecycle rules
- Delete unused data

Let's discuss your needs to store this data. As stated at the introduction, this dataset was only used for a month. Whatsmore, now you have a Parquet dataset you are going to query for building your reports, your CSV dataset is not longer needed. Finally, this is data that, if lost, is possible to recover, as it comes from the data department. Thus:

- If after format conversion, you are not using the CSV dataset, you can delete it
- After a month you are not using your Parquet dataset, you can also delete it after a determined time
- A backup is not needed


To manage your objects so that they are stored cost effectively and resource effectively throughout their lifecycle, you can configure their [Amazon S3 Lifecycle](https://docs.aws.amazon.com/AmazonS3/latest/userguide/object-lifecycle-mgmt.html). An S3 Lifecycle configuration is a set of rules that define actions that Amazon S3 applies to a group of objects.

You can define different rules for different types of data in a same bucket. Let's define a lifecycle rule to automate deletion of the CSV file after, for example, 7 days.

**Exercise**

**7.1.** Go to Amazon S3, click on the bucket you have been using for this lab and choose the *Management tab*:
![Create LCR](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/12_1_lifecycle_rule.png)

- Click on **Create lifecycle rule**

- Enter a *Lifecycle rule name*: `delete_CSV`

- Keep selected the option *Limit the scope of this rule using one or more filters*, as we want this rule to apply only to some data in the bucket

- In *Filter type*, *Prefix*, add: `/csv` (or the prefix of the folder where you have your CSV dataset)

- In *Lifecycle rule actions*, select **Expire current versions of objects**

- In *Expire current versions of objects*, write `7`under **Days after object creation**.

- Clicl on **Create rule**

![Create LCR 1](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/12_2_create_lcr.png)
![Create LCR 2](/Sustainability/200_different_datasets_and_their_use_case/Module_1/Images/12_3_create_lcr.png)

Congrats! You have created a rule to delete your unused CSV file.

**Click on *Next Step* to continue to the next module.**

{{< prev_next_button link_prev_url="../6_optional" link_next_url="../8_conclusion" />}}