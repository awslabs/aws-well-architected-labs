---
title: "Test Workload"
date: 2020-04-28T10:02:27-06:00
weight: 30
---

## Test the Workload

In this section we'll make sure that the workload is running properly, and that data is replicating to the backup region.  We use a python script to simulate a stream of incoming tweets.

Open a Session Manager connection to the EC2 instance sample producer in the primary region.  You can find the instance ID and the Global Accelerator endpoint in the CloudFormation output.

Run:

    sudo su - ec2-user
    python3 tweetmaker.py --endpoint <Global Accelerator endpoint>

After a few minutes you should be able to preview the table in Athena and see some output.  The Glue database is called `backuprestoredb` and the raw tweets are in a table called `rawdata`.  

To produce the nightly compacted files, run the Glue job called `CompactNightly`.  Then you can preview the table `compacteddata`.  

To verify data replication, you can look for files in the bucket in the backup region.