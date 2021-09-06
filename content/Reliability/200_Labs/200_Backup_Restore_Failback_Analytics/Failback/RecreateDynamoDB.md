---
title: "Recreate DynamoDB"
date: 2020-04-28T10:02:27-06:00
weight: 10
---

## Recreate DynamoDB

When failing back to the primary region, we need to get the latest data from the DynamoDB table in the backup region into the table in the primary region.  We'll do this by restoring the table from the backup region.  Note that using [DynamoDB Global Tables](https://aws.amazon.com/dynamodb/global-tables/) is a more convenient way to handle multi-region scenarios with DynamoDB, but in this example we'll use the less convenient but more cost effective approach of relying on backups.

First, navigate the DynamoDB console in the primary region and delete the `processed_tweets` table. 

![Delete table](/Reliability/200_Backup_Restore_Failback_Analytics/Images/restorepitr1.png)

Now, in the backup region, go to the `processed_tweets` table.  Select the `Backups` tab and, under the PITR section, choose `Restore`.

![Restore table](/Reliability/200_Backup_Restore_Failback_Analytics/Images/restorepitr2.png)

Provide the table name (`processed_tweets`), select cross region restore, and pick the primary region.

![Restore table](/Reliability/200_Backup_Restore_Failback_Analytics/Images/restorepitr3.png)

Once the table is active, you can perform a scan query and check that the item counts are in sync with the backup region.

{{< prev_next_button link_prev_url="../" link_next_url="../traffic" />}}