---
title: "References & useful resources"
menutitle: "Resources"
date: 2020-04-24T11:16:09-04:00
chapter: false
pre: "<b>5. </b>"
weight: 5
---

* [What Is AWS Backup?](https://docs.aws.amazon.com/aws-backup/latest/devguide/whatisbackup.html?ref=wellarchitected) - For backing up AWS resources _other_ than S3
* [AWS re:Invent 2018: Architecture Patterns for Multi-Region Active-Active Applications (ARC209-R2)](https://youtu.be/2e29I3dA8o4?ref=wellarchitected)
* [AWS re:Invent 2019: Backup-and-restore and disaster-recovery solutions with AWS (STG208)](https://youtu.be/7gNXfo5HZN8?ref=wellarchitected)
* [S3: Cross-Region Replication](http://docs.aws.amazon.com/AmazonS3/latest/dev/crr.html?ref=wellarchitected)
* [Amazon S3 Replication Time Control for predictable replication time, backed by an SLA](https://aws.amazon.com/about-aws/whats-new/2019/11/amazon-s3-replication-time-control-for-predictable-replication-time-backed-by-sla?ref=wellarchitected)
* [Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) (see the Reliability pillar)
* [Well-Architected best practices for reliability](https://wa.aws.amazon.com/wat.pillar.reliability.en.html)
* [Our Friend Rufus](https://www.amazon.com/gp/help/customer/display.html?nodeId=3711811)

### Additional information on multi-region strategies for disaster recovery (DR)

#### Recovery Time Objective (RTO) and Recovery Point Objective (RPO)

These terms are most often associated with Disaster Recovery (DR), which are a set of objectives and strategies to recover workload availability in the case of a disaster

* **Recovery time objective (RTO)** is the overall length of time that a workload’s components can be in the recovery phase, and therefore not available, before negatively impacting the organization’s mission or mission/business processes.
* **Recovery point objective (RPO**) is the overall length of time that a workload’s data can be unavailable, before negatively impacting the organization’s mission or mission/business processes.

#### Use defined recovery strategies to meet defined recovery objectives {#multi_region_strategy}

If necessary, when architecting a multi-region strategy for your workload, you should choose one of the following strategies. They are listed in increasing order of complexity, and decreasing order of RTO and RPO. _DR Region_ refers to an AWS Region other than the one used for your workload (or any AWS Region if your workload is on premises).

![MultiRegionStrategies](/Reliability/200_Bidirectional_Replication_for_S3/Images/MultiRegionStrategies.png)

* **Backup and restore** (RPO in hours, RTO in 24 hours or less): Back up your data and applications into the DR Region. Restore this data when necessary to recover from a disaster.
* **Pilot light** (RPO in minutes, RTO in hours): Maintain a minimal version of an environment always running the most critical core elements of your system in the DR Region. When the time comes for recovery, you can rapidly provision a full-scale production environment around the critical core.
* **Warm standby** (RPO in seconds, RTO in minutes):  Maintain a scaled-down version of a fully functional environment always running in the DR Region. Business-critical systems are fully duplicated and are always on, but with a scaled down fleet. When the time comes for recovery, the system is scaled up quickly to handle the production load.
* **Multi-region active-active** (RPO is none or possibly seconds, RTO in seconds): Your workload is deployed to, and actively serving traffic from, multiple AWS Regions. This strategy requires you to synchronize users and data across the Regions that you are using. When the time comes for recovery, use services like Amazon Route 53 or AWS Global Accelerator to route your user traffic to where your workload is healthy.

The bi-directional cross-region replication that you created in this lab is helpful for **Pilot light**, **Warm standby**, and **Multi-region active-active** strategies.
