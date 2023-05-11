---
title: "Amazon S3 Intelligent-Tiering Overview"
date: 2023-04-03T26:16:08-04:00
chapter: false
weight: 1
pre: "<b>1. </b>"
---

The Amazon S3 Intelligent-Tiering storage class is designed to optimize storage costs by automatically moving data to the most cost-effective access tier/storage class when access patterns change. S3 Intelligent-Tiering is the ideal storage class for data with unknown, changing, or unpredictable access patterns, independent of object size or retention period. You can use S3 Intelligent-Tiering as the default storage class for virtually any workload, especially data lakes, data analytics, new applications, and user-generated content.

For a small monthly object monitoring and automation charge, S3 Intelligent-Tiering moves objects that have not been accessed for 30 consecutive days to the Infrequent Access tier for savings of 40%; and after 90 days of no access, they’re moved to the Archive Instant Access tier with savings of 68%. If the objects are accessed later, S3 Intelligent-Tiering moves the objects back to the Frequent Access tier. 

![Images/S3IntelligentTiering01.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-01.png)

To save more on data that doesn’t require immediate retrieval, you can activate the optional asynchronous Archive Access and Deep Archive Access tiers. When turned on, objects not accessed for 90 days are moved directly to the Archive Access Tier (bypassing the automatic Archive Instant Access tier) for savings of 71%, and the Archive Deep Archive Access tier after 180 days with up to 95% in storage cost savings. If the objects are accessed later, S3 Intelligent-Tiering moves the objects back to the Frequent Access tier. If the object you are retrieving is stored in the optional Archive Access or Deep Archive tiers, before you can retrieve the object you must first restore a copy using RestoreObject.

![Images/S3IntelligentTiering02.png](/Cost/200_S3_Intelligent_Tiering/Images/S3-IntelligentTiering-02.png)

There are no retrieval charges in S3 Intelligent-Tiering. Objects smaller than 128 KB are not eligible for auto tiering. These smaller objects may be stored in S3 Intelligent-Tiering, but they’ll always be charged at the Frequent Access tier rates and don’t incur the monitoring and automation charge. Monitoring and Automation for all Storage objects > 128 KB per month are charged at $0.0025 per 1,000 objects. There are no retrieval charges in S3 Intelligent-Tiering.

{{< prev_next_button link_prev_url="../" link_next_url="../2_upload_new_object/" />}}